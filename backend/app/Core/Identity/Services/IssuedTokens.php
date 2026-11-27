<?php

namespace App\Core\Identity\Services;

final readonly class IssuedTokens
{
    public function __construct(
        public string $accessToken,
        public int $expiresIn,
        public string $refreshToken,
        public int $refreshExpiresIn,
    ) {}

    /**
     * @return array{token_type: string, access_token: string, expires_in: int, refresh_token: string, refresh_expires_in: int}
     */
    public function toArray(): array
    {
        return [
            'token_type' => 'Bearer',
            'access_token' => $this->accessToken,
            'expires_in' => $this->expiresIn,
            'refresh_token' => $this->refreshToken,
            'refresh_expires_in' => $this->refreshExpiresIn,
        ];
    }
}
