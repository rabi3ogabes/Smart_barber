<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/*
| Phase 3 — Catalog: categories, services, add-ons, bundles, branch and barber overrides
| (erd.md §4). Prices are BIGINT minor units in the salon's currency (ADR-003).
*/
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('service_categories', function (Blueprint $table) {
            $table->id();
            $table->char('public_id', 26)->unique();
            $table->foreignId('salon_id')->constrained();
            $table->json('name');
            $table->string('icon', 60)->nullable();
            $table->unsignedSmallInteger('sort_order')->default(0);
            $table->boolean('is_active')->default(true);
            $table->timestamps();
            $table->softDeletes();
            $table->index(['salon_id', 'sort_order']);
        });

        Schema::create('services', function (Blueprint $table) {
            $table->id();
            $table->char('public_id', 26)->unique();
            $table->foreignId('salon_id')->constrained();
            $table->foreignId('category_id')->constrained('service_categories');
            $table->json('name');
            $table->json('description')->nullable();
            $table->unsignedBigInteger('image_media_id')->nullable();
            $table->bigInteger('base_price');
            $table->unsignedSmallInteger('duration_minutes');
            $table->unsignedSmallInteger('buffer_minutes')->default(0);
            $table->string('tax_class', 16)->default('standard');
            $table->boolean('is_active')->default(true);
            $table->boolean('is_bookable_online')->default(true);
            $table->unsignedSmallInteger('sort_order')->default(0);
            $table->timestamps();
            $table->softDeletes();
            $table->index(['salon_id', 'category_id', 'is_active']);
        });

        Schema::create('service_addons', function (Blueprint $table) {
            $table->id();
            $table->char('public_id', 26)->unique();
            $table->foreignId('salon_id')->constrained();
            $table->json('name');
            $table->bigInteger('price');
            $table->unsignedSmallInteger('extra_minutes')->default(0);
            $table->string('tax_class', 16)->default('standard');
            $table->boolean('is_active')->default(true);
            $table->timestamps();
            $table->softDeletes();
        });

        Schema::create('service_addon_service', function (Blueprint $table) {
            $table->id();
            $table->foreignId('salon_id')->constrained();
            $table->foreignId('service_addon_id')->constrained()->cascadeOnDelete();
            $table->foreignId('service_id')->constrained()->cascadeOnDelete();
            $table->timestamps();
            $table->unique(['service_addon_id', 'service_id']);
        });

        Schema::create('service_bundles', function (Blueprint $table) {
            $table->id();
            $table->char('public_id', 26)->unique();
            $table->foreignId('salon_id')->constrained();
            $table->json('name');
            $table->json('description')->nullable();
            $table->bigInteger('price');
            $table->string('tax_class', 16)->default('standard');
            $table->boolean('is_active')->default(true);
            $table->unsignedSmallInteger('sort_order')->default(0);
            $table->timestamps();
            $table->softDeletes();
        });

        Schema::create('service_bundle_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('salon_id')->constrained();
            $table->foreignId('bundle_id')->constrained('service_bundles')->cascadeOnDelete();
            $table->foreignId('service_id')->constrained();
            $table->unsignedSmallInteger('sort_order')->default(0);
            $table->timestamps();
            $table->unique(['bundle_id', 'service_id']);
        });

        Schema::create('branch_service', function (Blueprint $table) {
            $table->id();
            $table->foreignId('salon_id')->constrained();
            $table->foreignId('branch_id')->constrained()->cascadeOnDelete();
            $table->foreignId('service_id')->constrained()->cascadeOnDelete();
            $table->boolean('is_available')->default(true);
            $table->bigInteger('price_override')->nullable();
            $table->timestamps();
            $table->unique(['branch_id', 'service_id']);
        });

        Schema::create('barber_service', function (Blueprint $table) {
            $table->id();
            $table->foreignId('salon_id')->constrained();
            $table->foreignId('barber_id')->constrained()->cascadeOnDelete();
            $table->foreignId('service_id')->constrained()->cascadeOnDelete();
            $table->bigInteger('price_override')->nullable();
            $table->unsignedSmallInteger('duration_override')->nullable();
            $table->unsignedInteger('commission_rate_bp')->nullable(); // placeholder, read by Phase 13
            $table->timestamps();
            $table->unique(['barber_id', 'service_id']);
        });
    }

    public function down(): void
    {
        foreach (['barber_service', 'branch_service', 'service_bundle_items', 'service_bundles', 'service_addon_service', 'service_addons', 'services', 'service_categories'] as $table) {
            Schema::dropIfExists($table);
        }
    }
};
