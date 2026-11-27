<?php

namespace App\Modules\Staff\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

/**
 * Invitation e-mail, queued (rule 9). Bilingual: Arabic first, then English.
 */
final class StaffInvitationMail extends Notification implements ShouldQueue
{
    use Queueable;

    public function __construct(public readonly string $salonNameAr, public readonly string $salonNameEn, public readonly string $url)
    {
        $this->onQueue('notifications');
    }

    /**
     * @return list<string>
     */
    public function via(object $notifiable): array
    {
        return ['mail'];
    }

    public function toMail(object $notifiable): MailMessage
    {
        return (new MailMessage)
            ->subject(__('invitations.mail_subject', ['salon' => $this->salonNameEn], 'en').' · '.__('invitations.mail_subject', ['salon' => $this->salonNameAr], 'ar'))
            ->line(__('invitations.mail_body', ['salon' => $this->salonNameAr], 'ar'))
            ->line(__('invitations.mail_body', ['salon' => $this->salonNameEn], 'en'))
            ->action(__('invitations.mail_action', [], 'ar').' / '.__('invitations.mail_action', [], 'en'), $this->url)
            ->line(__('invitations.mail_expiry', [], 'ar'))
            ->line(__('invitations.mail_expiry', [], 'en'));
    }
}
