<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Phase 5: booking reviews ("Rate your visit", spec-review item 6), account-level media for the
 * customer avatar (ADR-009) and notification preferences on the customer account.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('booking_reviews', function (Blueprint $table) {
            $table->id();
            $table->char('public_id', 26)->unique();
            $table->foreignId('salon_id')->constrained();
            $table->foreignId('booking_id')->unique()->constrained();
            $table->foreignId('branch_id')->constrained();
            $table->foreignId('customer_id')->constrained();
            $table->foreignId('barber_id')->nullable()->constrained();
            $table->unsignedTinyInteger('rating');
            $table->text('comment')->nullable();
            // published: counts toward the barber rating; hidden: removed by a moderator.
            $table->string('status', 16)->default('published');
            $table->string('moderation_note', 255)->nullable();
            $table->foreignId('moderated_by_id')->nullable()->constrained('users');
            $table->timestamp('moderated_at')->nullable();
            $table->timestamps();
            $table->index(['salon_id', 'status', 'created_at']);
            $table->index(['barber_id', 'status']);
        });

        // Files that belong to a global customer account, not to a salon (ADR-009).
        Schema::create('account_media', function (Blueprint $table) {
            $table->id();
            $table->foreignId('customer_account_id')->constrained();
            $table->string('collection', 50);
            $table->string('disk', 30);
            $table->string('path', 255);
            $table->string('mime', 100);
            $table->unsignedInteger('size_bytes');
            $table->unsignedInteger('width')->nullable();
            $table->unsignedInteger('height')->nullable();
            $table->json('variants')->nullable();
            $table->timestamps();
            $table->index(['customer_account_id', 'collection']);
        });

        Schema::table('customer_accounts', function (Blueprint $table) {
            $table->json('notification_preferences')->nullable()->after('locale');
        });
    }

    public function down(): void
    {
        Schema::table('customer_accounts', fn (Blueprint $table) => $table->dropColumn('notification_preferences'));
        Schema::dropIfExists('account_media');
        Schema::dropIfExists('booking_reviews');
    }
};
