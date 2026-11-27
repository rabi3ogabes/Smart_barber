<?php

namespace App\Core\Contracts;

use App\Core\Money\Money;

/**
 * Online payment provider (implemented in Phase 6; adapter chosen with spec-review Q11).
 */
interface PaymentGateway
{
    /**
     * Start a hosted checkout. Returns ['reference' => string, 'redirect_url' => string].
     *
     * @param  array<string, string>  $metadata
     * @return array{reference: string, redirect_url: string}
     */
    public function createCheckout(Money $amount, string $description, string $returnUrl, array $metadata = []): array;

    /**
     * @return array{reference: string, status: string}
     */
    public function refund(string $reference, Money $amount): array;

    /**
     * @param  array<string, string>  $headers
     */
    public function verifyWebhook(string $payload, array $headers): bool;
}
