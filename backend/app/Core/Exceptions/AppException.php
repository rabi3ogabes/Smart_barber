<?php

namespace App\Core\Exceptions;

use RuntimeException;

/**
 * A business error with a machine-readable code. Rendered by the API envelope.
 */
class AppException extends RuntimeException
{
    /**
     * @param  array<string, mixed>  $errors
     * @param  array<string, mixed>  $data  Extra payload returned in `data` (e.g. retry_after)
     */
    public function __construct(
        public readonly ErrorCode $errorCode,
        ?string $message = null,
        public readonly array $errors = [],
        public readonly array $data = [],
    ) {
        parent::__construct($message ?? $errorCode->message());
    }

    /**
     * @param  array<string, mixed>  $data
     */
    public static function of(ErrorCode $code, array $data = []): self
    {
        return new self($code, data: $data);
    }

    public function status(): int
    {
        return $this->errorCode->status();
    }
}
