<?php

namespace App\Core\Http;

use App\Core\Exceptions\AppException;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Domain errors (AppException) raised by dashboard requests. Forbidden and not-found codes
 * become the usual error page; every other code goes back to the form with field errors
 * (or a "general" error) and a translated toast. Never a raw exception (CLAUDE.md rule 11).
 */
final class WebAppExceptionRenderer
{
    public function __invoke(AppException $e, Request $request): ?Response
    {
        if ($request->is('api/*')) {
            return null;
        }
        // Dashboard JSON endpoints (calendar drag & drop, comboboxes) get the API envelope, so the
        // page can read the code (e.g. 409 BOOKING_SLOT_TAKEN with alternatives) and revert.
        if ($request->expectsJson() && ! $request->header('X-Inertia')) {
            return ApiResponse::error($e->errorCode, $e->getMessage(), $e->errors, $e->data);
        }

        $status = $e->status();
        if (in_array($status, [403, 404], true)) {
            return (new WebExceptionRenderer)(new \Illuminate\Http\Response('', $status), $e, $request);
        }

        $errors = [];
        foreach ($e->errors as $field => $messages) {
            $errors[$field] = is_array($messages) ? (string) ($messages[0] ?? $e->getMessage()) : (string) $messages;
        }

        return back()
            ->withInput($request->except(['password', 'password_confirmation']))
            ->withErrors($errors !== [] ? $errors : ['general' => $e->getMessage()])
            ->with('error', $e->getMessage());
    }
}
