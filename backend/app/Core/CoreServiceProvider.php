<?php

namespace App\Core;

use App\Core\Contracts\AiImageProvider;
use App\Core\Contracts\AiTextProvider;
use App\Core\Contracts\NotificationChannel;
use App\Core\Contracts\OtpProvider;
use App\Core\Contracts\PaymentGateway;
use App\Core\Contracts\PushProvider;
use App\Core\Contracts\SmsProvider;
use App\Core\Contracts\StorageService;
use App\Core\Contracts\UsageMeter;
use App\Core\Contracts\WhatsAppProvider;
use App\Core\Identity\Models\CustomerAccount;
use App\Core\Identity\Models\PersonalAccessToken;
use App\Core\Identity\Models\PlatformAdmin;
use App\Core\Identity\Models\User;
use App\Core\Media\DiskStorageService;
use App\Core\Media\Media;
use App\Core\Providers\DatabaseUsageMeter;
use App\Core\Providers\Fakes\FakeAiImageProvider;
use App\Core\Providers\Fakes\FakeAiTextProvider;
use App\Core\Providers\Fakes\FakePaymentGateway;
use App\Core\Providers\Fakes\FakeWhatsAppProvider;
use App\Core\Providers\Fakes\LogNotificationChannel;
use App\Core\Providers\Fakes\LogOtpProvider;
use App\Core\Providers\Fakes\LogPushProvider;
use App\Core\Providers\Fakes\LogSmsProvider;
use App\Core\Tenancy\CurrentSalon;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Models\SalonMembership;
use App\Core\Tenancy\Tenancy;
use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\Relation;
use Illuminate\Http\Request;
use Illuminate\Queue\Events\JobExceptionOccurred;
use Illuminate\Queue\Events\JobProcessed;
use Illuminate\Queue\Events\JobProcessing;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Queue;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\ServiceProvider;
use Laravel\Sanctum\Sanctum;

final class CoreServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        $this->app->scoped(CurrentSalon::class);

        // Provider contracts → dev/test implementations. Real adapters replace these per phase.
        $this->app->singleton(OtpProvider::class, LogOtpProvider::class);
        $this->app->singleton(SmsProvider::class, LogSmsProvider::class);
        $this->app->singleton(PushProvider::class, LogPushProvider::class);
        $this->app->singleton(NotificationChannel::class, LogNotificationChannel::class);
        $this->app->singleton(PaymentGateway::class, FakePaymentGateway::class);
        $this->app->singleton(WhatsAppProvider::class, FakeWhatsAppProvider::class);
        $this->app->singleton(AiImageProvider::class, FakeAiImageProvider::class);
        $this->app->singleton(AiTextProvider::class, FakeAiTextProvider::class);
        $this->app->singleton(UsageMeter::class, DatabaseUsageMeter::class);
        $this->app->singleton(StorageService::class, DiskStorageService::class);
    }

    public function boot(): void
    {
        Model::shouldBeStrict(! $this->app->isProduction());

        Relation::enforceMorphMap([
            'user' => User::class,
            'customer_account' => CustomerAccount::class,
            'platform_admin' => PlatformAdmin::class,
            'salon' => Salon::class,
            'branch' => Branch::class,
            'salon_membership' => SalonMembership::class,
            'media' => Media::class,
        ]);

        Sanctum::usePersonalAccessTokenModel(PersonalAccessToken::class);

        // Models live in App\Core and App\Modules; factories stay flat in database/factories.
        Factory::guessFactoryNamesUsing(fn (string $model) => 'Database\\Factories\\'.class_basename($model).'Factory');

        $this->configureRateLimits();
        $this->configureQueueTenancy();
    }

    private function configureRateLimits(): void
    {
        RateLimiter::for('api', fn (Request $request) => [
            Limit::perMinute(120)->by('user:'.($request->user()?->getMorphClass() ?? 'guest').':'.($request->user()?->getAuthIdentifier() ?? $request->ip())),
            Limit::perMinute(600)->by('salon:'.(Tenancy::id() ?? 'none')),
        ]);
        RateLimiter::for('login', fn (Request $request) => Limit::perMinute(10)->by('login:'.$request->ip()));
        RateLimiter::for('otp', fn (Request $request) => Limit::perMinute(10)->by('otp:'.$request->ip()));
        RateLimiter::for('refresh', fn (Request $request) => Limit::perMinute(30)->by('refresh:'.$request->ip()));
    }

    /**
     * Queued jobs carry the dispatching salon and restore it before the job is unserialized,
     * so SerializesModels can load tenant models. A job without a salon fails closed (ADR-001).
     */
    private function configureQueueTenancy(): void
    {
        Queue::createPayloadUsing(fn () => ['salon_id' => Tenancy::id()]);

        // A stack keeps the outer tenant intact when jobs run synchronously inside a request.
        $stack = [];

        Event::listen(JobProcessing::class, function (JobProcessing $event) use (&$stack): void {
            $stack[] = [Tenancy::current(), Tenancy::membership()];
            $salonId = $event->job->payload()['salon_id'] ?? null;
            $salon = $salonId === null ? null : Tenancy::bypass(fn () => Salon::query()->find($salonId));
            $salon === null ? Tenancy::clear() : Tenancy::set($salon);
        });

        $restore = function () use (&$stack): void {
            [$salon, $membership] = array_pop($stack) ?? [null, null];
            $salon === null ? Tenancy::clear() : Tenancy::set($salon, $membership);
        };
        Event::listen(JobProcessed::class, $restore);
        Event::listen(JobExceptionOccurred::class, $restore);
    }
}
