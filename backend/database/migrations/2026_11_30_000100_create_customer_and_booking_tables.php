<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/*
| Phase 4 — minimal Customer module and the Booking engine (erd.md §5, §6; ADR-004).
| All datetimes are UTC. Money is BIGINT minor units with a currency (ADR-003).
*/
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('customers', function (Blueprint $table) {
            $table->id();
            $table->char('public_id', 26)->unique();
            $table->foreignId('salon_id')->constrained();
            $table->foreignId('customer_account_id')->nullable()->constrained();
            $table->string('name', 120);
            $table->string('phone', 20);
            $table->string('email', 190)->nullable();
            $table->date('birthday')->nullable();
            $table->char('locale', 2)->default('ar');
            $table->foreignId('preferred_barber_id')->nullable()->constrained('barbers');
            $table->foreignId('preferred_branch_id')->nullable()->constrained('branches');
            $table->text('internal_notes')->nullable();
            $table->json('tags')->nullable();
            $table->string('source', 16)->default('dashboard');
            $table->timestamp('first_visit_at')->nullable();
            $table->timestamp('last_visit_at')->nullable();
            $table->unsignedInteger('visits_count')->default(0);
            $table->bigInteger('total_spent_amount')->default(0);
            $table->unsignedSmallInteger('no_show_count')->default(0);
            $table->timestamps();
            $table->softDeletes();
            $table->unique(['salon_id', 'phone']);
            $table->index(['salon_id', 'last_visit_at']);
            $table->index('customer_account_id');
        });

        // Append-only ledger of what a customer owes the salon (no-show fees now; POS settles it in Phase 6).
        Schema::create('customer_dues', function (Blueprint $table) {
            $table->id();
            $table->char('public_id', 26)->unique();
            $table->foreignId('salon_id')->constrained();
            $table->foreignId('customer_id')->constrained();
            $table->unsignedBigInteger('booking_id')->nullable();
            $table->string('type', 24); // no_show_fee, waiver, settlement
            $table->bigInteger('amount'); // signed minor units: + owed, − waived/settled
            $table->char('currency', 3);
            $table->foreignId('reverses_id')->nullable()->constrained('customer_dues');
            $table->string('reason', 255)->nullable();
            $table->string('actor_type', 32)->nullable();
            $table->unsignedBigInteger('actor_id')->nullable();
            $table->timestamp('created_at')->useCurrent();
            $table->index(['salon_id', 'customer_id']);
        });

        Schema::create('bookings', function (Blueprint $table) {
            $table->id();
            $table->char('public_id', 26)->unique();
            $table->foreignId('salon_id')->constrained();
            $table->foreignId('branch_id')->constrained();
            $table->foreignId('customer_id')->constrained();
            $table->foreignId('barber_id')->constrained();
            $table->dateTime('starts_at');
            $table->dateTime('ends_at');
            $table->dateTime('blocked_until');
            $table->string('status', 16);
            $table->string('source', 16);
            $table->text('customer_notes')->nullable();
            $table->text('internal_notes')->nullable();
            $table->string('cancel_reason', 255)->nullable();
            $table->string('cancelled_by_type', 32)->nullable();
            $table->unsignedBigInteger('cancelled_by_id')->nullable();
            $table->dateTime('cancelled_at')->nullable();
            $table->bigInteger('subtotal_amount');
            $table->bigInteger('discount_amount')->default(0);
            $table->bigInteger('tax_amount')->default(0);
            $table->bigInteger('total_amount');
            $table->char('currency', 3);
            $table->json('quote_snapshot');
            $table->unsignedTinyInteger('reschedule_count')->default(0);
            $table->string('created_by_type', 32)->nullable();
            $table->unsignedBigInteger('created_by_id')->nullable();
            $table->timestamps();
            $table->index(['barber_id', 'starts_at', 'blocked_until']);
            $table->index(['salon_id', 'branch_id', 'starts_at']);
            $table->index(['salon_id', 'customer_id', 'starts_at']);
            $table->index(['salon_id', 'status', 'starts_at']);
        });

        Schema::create('booking_services', function (Blueprint $table) {
            $table->id();
            $table->foreignId('salon_id')->constrained();
            $table->foreignId('booking_id')->constrained()->cascadeOnDelete();
            $table->string('type', 16); // service, addon, bundle
            $table->unsignedBigInteger('service_id')->nullable();
            $table->unsignedBigInteger('addon_id')->nullable();
            $table->unsignedBigInteger('bundle_id')->nullable();
            $table->json('name');
            $table->bigInteger('price');
            $table->bigInteger('discount_amount')->default(0);
            $table->bigInteger('tax_amount')->default(0);
            $table->bigInteger('total_amount');
            $table->unsignedSmallInteger('duration_minutes');
            $table->unsignedSmallInteger('sort_order')->default(0);
            $table->timestamps();
        });

        Schema::create('booking_status_history', function (Blueprint $table) {
            $table->id();
            $table->foreignId('salon_id')->constrained();
            $table->foreignId('booking_id')->constrained()->cascadeOnDelete();
            $table->string('from_status', 16)->nullable();
            $table->string('to_status', 16);
            $table->string('actor_type', 32)->nullable();
            $table->unsignedBigInteger('actor_id')->nullable();
            $table->string('reason', 255)->nullable();
            $table->json('meta')->nullable();
            $table->timestamp('created_at')->useCurrent();
            $table->index(['booking_id', 'created_at']);
        });

        Schema::table('customer_dues', function (Blueprint $table) {
            $table->foreign('booking_id')->references('id')->on('bookings');
        });
    }

    public function down(): void
    {
        Schema::table('customer_dues', fn (Blueprint $t) => $t->dropForeign(['booking_id']));
        foreach (['booking_status_history', 'booking_services', 'bookings', 'customer_dues', 'customers'] as $table) {
            Schema::dropIfExists($table);
        }
    }
};
