<?php

namespace App\Core\Providers\Fakes;

use App\Core\Contracts\PaymentGateway;
use App\Core\Money\Money;
use Illuminate\Support\Str;

final class FakePaymentGateway implements PaymentGateway
{
    public function createCheckout(Money $amount, string $description, string $returnUrl, array $metadata = []): array
    {
        $reference = 'fake_'.Str::ulid();

        return ['reference' => $reference, 'redirect_url' => $returnUrl.'?reference='.$reference];
    }

    public function refund(string $reference, Money $amount): array
    {
        return ['reference' => 'fake_refund_'.Str::ulid(), 'status' => 'succeeded'];
    }

    public function verifyWebhook(string $payload, array $headers): bool
    {
        return ($headers['x-fake-signature'] ?? null) === hash_hmac('sha256', $payload, (string) config('app.key'));
    }
}
