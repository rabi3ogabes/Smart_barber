<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('audit_logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('salon_id')->nullable()->constrained();
            $table->string('actor_type')->nullable();
            $table->unsignedBigInteger('actor_id')->nullable();
            $table->unsignedBigInteger('impersonator_id')->nullable();
            $table->string('event', 100);
            $table->string('auditable_type')->nullable();
            $table->unsignedBigInteger('auditable_id')->nullable();
            $table->json('old_values')->nullable();
            $table->json('new_values')->nullable();
            $table->string('ip', 45)->nullable();
            $table->string('user_agent', 255)->nullable();
            $table->string('device', 100)->nullable();
            $table->timestamp('created_at')->useCurrent();
            $table->index(['salon_id', 'created_at']);
            $table->index(['auditable_type', 'auditable_id']);
        });

        Schema::create('settings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('salon_id')->constrained();
            $table->string('settable_type');
            $table->unsignedBigInteger('settable_id');
            $table->string('key', 100);
            $table->json('value')->nullable();
            $table->timestamps();
            $table->unique(['settable_type', 'settable_id', 'key']);
        });

        Schema::create('salon_features', function (Blueprint $table) {
            $table->id();
            $table->foreignId('salon_id')->constrained();
            $table->string('feature_key', 64);
            $table->boolean('enabled')->default(true);
            $table->string('source', 32)->default('manual');
            $table->json('limits')->nullable();
            $table->timestamp('expires_at')->nullable();
            $table->timestamps();
            $table->unique(['salon_id', 'feature_key']);
        });

        Schema::create('idempotency_keys', function (Blueprint $table) {
            $table->id();
            $table->string('key', 100);
            $table->string('actor_type');
            $table->unsignedBigInteger('actor_id');
            $table->unsignedBigInteger('salon_id')->nullable();
            $table->string('method', 8);
            $table->string('route', 190);
            $table->char('request_hash', 64);
            $table->string('status', 16);
            $table->unsignedSmallInteger('response_status')->nullable();
            $table->mediumText('response_body')->nullable();
            $table->timestamp('expires_at')->index();
            $table->timestamps();
            $table->unique(['actor_type', 'actor_id', 'key']);
        });

        Schema::create('devices', function (Blueprint $table) {
            $table->id();
            $table->string('owner_type');
            $table->unsignedBigInteger('owner_id');
            $table->foreignId('salon_id')->nullable()->constrained();
            $table->string('app', 16);
            $table->string('platform', 16);
            $table->string('fcm_token', 255)->unique();
            $table->char('locale', 2)->default('ar');
            $table->string('app_version', 20)->nullable();
            $table->timestamp('last_seen_at')->nullable();
            $table->timestamps();
            $table->index(['owner_type', 'owner_id']);
        });

        Schema::create('media', function (Blueprint $table) {
            $table->id();
            $table->foreignId('salon_id')->constrained();
            $table->string('owner_type')->nullable();
            $table->unsignedBigInteger('owner_id')->nullable();
            $table->string('collection', 50);
            $table->string('disk', 30);
            $table->string('path', 255);
            $table->string('mime', 100);
            $table->unsignedInteger('size_bytes');
            $table->unsignedInteger('width')->nullable();
            $table->unsignedInteger('height')->nullable();
            $table->json('variants')->nullable();
            $table->string('visibility', 16)->default('private');
            $table->boolean('contains_pii')->default(false);
            $table->timestamp('delete_after')->nullable();
            $table->timestamps();
            $table->softDeletes();
            $table->index(['owner_type', 'owner_id', 'collection']);
        });

        Schema::create('usage_records', function (Blueprint $table) {
            $table->id();
            $table->foreignId('salon_id')->constrained();
            $table->string('meter', 32);
            $table->integer('quantity');
            $table->string('source_type')->nullable();
            $table->unsignedBigInteger('source_id')->nullable();
            $table->timestamp('occurred_at');
            $table->timestamp('created_at')->useCurrent();
            $table->index(['salon_id', 'meter', 'occurred_at']);
        });
    }

    public function down(): void
    {
        foreach (['usage_records', 'media', 'devices', 'idempotency_keys', 'salon_features', 'settings', 'audit_logs'] as $table) {
            Schema::dropIfExists($table);
        }
    }
};
