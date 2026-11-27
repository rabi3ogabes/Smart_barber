<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('salons', function (Blueprint $table) {
            $table->id();
            $table->char('public_id', 26)->unique();
            $table->string('slug', 63)->unique();
            $table->json('name');
            $table->char('currency', 3)->default('QAR');
            $table->string('timezone', 64)->default('Asia/Qatar');
            $table->char('default_locale', 2)->default('ar');
            $table->char('country', 2)->default('QA');
            $table->string('status', 32)->default('active')->index();
            $table->string('custom_domain', 190)->nullable()->unique();
            $table->unsignedBigInteger('logo_media_id')->nullable();
            $table->timestamps();
            $table->softDeletes();
        });

        Schema::create('branches', function (Blueprint $table) {
            $table->id();
            $table->char('public_id', 26)->unique();
            $table->foreignId('salon_id')->constrained();
            $table->json('name');
            $table->string('timezone', 64)->default('Asia/Qatar');
            $table->boolean('is_active')->default(true);
            $table->unsignedSmallInteger('sort_order')->default(0);
            $table->timestamps();
            $table->softDeletes();
            $table->index(['salon_id', 'is_active']);
        });

        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->char('public_id', 26)->unique();
            $table->string('name', 120);
            $table->string('email', 190)->nullable()->unique();
            $table->string('phone', 20)->nullable()->unique();
            $table->string('password');
            $table->char('locale', 2)->default('ar');
            $table->unsignedBigInteger('avatar_media_id')->nullable();
            $table->text('two_factor_secret')->nullable();
            $table->text('two_factor_recovery_codes')->nullable();
            $table->timestamp('two_factor_confirmed_at')->nullable();
            $table->timestamp('last_login_at')->nullable();
            $table->rememberToken();
            $table->timestamps();
            $table->softDeletes();
        });

        Schema::create('password_reset_tokens', function (Blueprint $table) {
            $table->string('email')->primary();
            $table->string('token');
            $table->timestamp('created_at')->nullable();
        });

        Schema::create('sessions', function (Blueprint $table) {
            $table->string('id')->primary();
            $table->foreignId('user_id')->nullable()->index();
            $table->string('ip_address', 45)->nullable();
            $table->text('user_agent')->nullable();
            $table->longText('payload');
            $table->integer('last_activity')->index();
        });

        Schema::create('platform_admins', function (Blueprint $table) {
            $table->id();
            $table->string('name', 120);
            $table->string('email', 190)->unique();
            $table->string('password');
            $table->text('two_factor_secret')->nullable();
            $table->text('two_factor_recovery_codes')->nullable();
            $table->timestamp('two_factor_confirmed_at')->nullable();
            $table->timestamp('last_login_at')->nullable();
            $table->rememberToken();
            $table->timestamps();
        });

        Schema::create('customer_accounts', function (Blueprint $table) {
            $table->id();
            $table->char('public_id', 26)->unique();
            $table->string('phone', 20)->unique();
            $table->string('name', 120)->nullable();
            $table->string('email', 190)->nullable();
            $table->char('locale', 2)->default('ar');
            $table->unsignedBigInteger('avatar_media_id')->nullable();
            $table->timestamp('phone_verified_at')->nullable();
            $table->timestamp('deletion_requested_at')->nullable();
            $table->timestamp('anonymised_at')->nullable();
            $table->timestamps();
            $table->softDeletes();
        });

        Schema::create('otp_codes', function (Blueprint $table) {
            $table->id();
            $table->string('phone', 20);
            $table->string('purpose', 32);
            $table->char('code_hash', 64);
            $table->unsignedTinyInteger('attempts')->default(0);
            $table->timestamp('expires_at');
            $table->timestamp('consumed_at')->nullable();
            $table->string('ip', 45)->nullable();
            $table->timestamps();
            $table->index(['phone', 'purpose', 'created_at']);
        });

        Schema::create('salon_user', function (Blueprint $table) {
            $table->id();
            $table->foreignId('salon_id')->constrained();
            $table->foreignId('user_id')->constrained();
            $table->string('status', 32)->default('active');
            $table->foreignId('invited_by')->nullable()->constrained('users');
            $table->timestamp('invited_at')->nullable();
            $table->timestamp('joined_at')->nullable();
            $table->timestamp('deactivated_at')->nullable();
            $table->timestamps();
            $table->unique(['salon_id', 'user_id']);
            $table->index(['user_id', 'status']);
        });

        Schema::create('salon_user_branches', function (Blueprint $table) {
            $table->id();
            $table->foreignId('salon_id')->constrained();
            $table->foreignId('salon_user_id')->constrained('salon_user')->cascadeOnDelete();
            $table->foreignId('branch_id')->constrained();
            $table->timestamps();
            $table->unique(['salon_user_id', 'branch_id']);
        });
    }

    public function down(): void
    {
        foreach (['salon_user_branches', 'salon_user', 'otp_codes', 'customer_accounts', 'platform_admins', 'sessions', 'password_reset_tokens', 'users', 'branches', 'salons'] as $table) {
            Schema::dropIfExists($table);
        }
    }
};
