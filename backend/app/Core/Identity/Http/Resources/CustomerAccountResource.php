<?php

namespace App\Core\Identity\Http\Resources;

use App\Core\Identity\Models\CustomerAccount;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @mixin CustomerAccount
 */
final class CustomerAccountResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->public_id,
            'phone' => $this->phone,
            'name' => $this->name,
            'email' => $this->email,
            'locale' => $this->locale,
            'profile_complete' => $this->name !== null && $this->name !== '',
        ];
    }
}
