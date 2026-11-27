<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/*
| Phase 2 — Salon module: profile, booking policy, branch details, opening hours, closures (erd.md §1–2).
*/
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('salons', function (Blueprint $table) {
            $table->string('legal_name', 190)->nullable()->after('name');
            $table->unsignedBigInteger('cover_media_id')->nullable()->after('logo_media_id');
            $table->string('tax_number', 50)->nullable();
            $table->unsignedInteger('tax_rate_bp')->default(0);
            $table->boolean('prices_include_tax')->default(true);
            $table->string('contact_phone', 20)->nullable();
            $table->string('contact_email', 190)->nullable();
            $table->json('social_links')->nullable();
            $table->unsignedSmallInteger('lead_time_minutes')->default(60);
            $table->unsignedSmallInteger('max_days_ahead')->default(30);
            $table->unsignedInteger('cancellation_window_minutes')->default(120);
            $table->bigInteger('no_show_fee_amount')->default(0);
        });

        Schema::table('branches', function (Blueprint $table) {
            $table->json('address')->nullable()->after('name');
            $table->decimal('lat', 10, 7)->nullable()->after('address');
            $table->decimal('lng', 10, 7)->nullable()->after('lat');
            $table->string('phone', 20)->nullable()->after('lng');
        });

        Schema::create('branch_opening_hours', function (Blueprint $table) {
            $table->id();
            $table->foreignId('salon_id')->constrained();
            $table->foreignId('branch_id')->constrained()->cascadeOnDelete();
            $table->unsignedTinyInteger('weekday'); // 0 = Sunday … 6 = Saturday
            $table->time('opens_at');
            $table->time('closes_at');
            $table->timestamps();
            $table->index(['branch_id', 'weekday']);
        });

        Schema::create('branch_closures', function (Blueprint $table) {
            $table->id();
            $table->char('public_id', 26)->unique();
            $table->foreignId('salon_id')->constrained();
            $table->foreignId('branch_id')->nullable()->constrained()->cascadeOnDelete(); // null = all branches
            $table->date('starts_on');
            $table->date('ends_on');
            $table->json('reason')->nullable();
            $table->timestamps();
            $table->index(['salon_id', 'starts_on']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('branch_closures');
        Schema::dropIfExists('branch_opening_hours');
        Schema::table('branches', fn (Blueprint $t) => $t->dropColumn(['address', 'lat', 'lng', 'phone']));
        Schema::table('salons', fn (Blueprint $t) => $t->dropColumn([
            'legal_name', 'cover_media_id', 'tax_number', 'tax_rate_bp', 'prices_include_tax', 'contact_phone', 'contact_email',
            'social_links', 'lead_time_minutes', 'max_days_ahead', 'cancellation_window_minutes', 'no_show_fee_amount',
        ]));
    }
};
