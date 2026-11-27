<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/*
| Phase 2 — Staff module: invitations, barber profiles, schedules, time off (erd.md §3).
*/
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('staff_invitations', function (Blueprint $table) {
            $table->id();
            $table->char('public_id', 26)->unique();
            $table->foreignId('salon_id')->constrained();
            $table->string('email', 190)->nullable();
            $table->string('phone', 20)->nullable();
            $table->string('name', 120)->nullable();
            $table->json('role_names');
            $table->json('branch_ids');
            $table->char('token_hash', 64)->unique();
            $table->foreignId('invited_by')->constrained('users');
            $table->timestamp('expires_at');
            $table->timestamp('accepted_at')->nullable();
            $table->foreignId('accepted_user_id')->nullable()->constrained('users');
            $table->timestamp('revoked_at')->nullable();
            $table->timestamps();
            $table->index(['salon_id', 'accepted_at']);
        });

        Schema::create('barbers', function (Blueprint $table) {
            $table->id();
            $table->char('public_id', 26)->unique();
            $table->foreignId('salon_id')->constrained();
            $table->foreignId('user_id')->constrained();
            $table->foreignId('salon_user_id')->constrained('salon_user');
            $table->json('display_name');
            $table->json('bio')->nullable();
            $table->unsignedBigInteger('photo_media_id')->nullable();
            $table->json('specialties')->nullable();
            $table->unsignedTinyInteger('years_experience')->nullable();
            $table->unsignedSmallInteger('sort_order')->default(0);
            $table->boolean('is_bookable')->default(true);
            $table->decimal('rating_avg', 3, 2)->nullable();
            $table->unsignedInteger('rating_count')->default(0);
            $table->timestamps();
            $table->softDeletes();
            $table->unique(['salon_id', 'user_id']);
        });

        Schema::create('barber_branches', function (Blueprint $table) {
            $table->id();
            $table->foreignId('salon_id')->constrained();
            $table->foreignId('barber_id')->constrained()->cascadeOnDelete();
            $table->foreignId('branch_id')->constrained()->cascadeOnDelete();
            $table->timestamps();
            $table->unique(['barber_id', 'branch_id']);
        });

        foreach (['barber_working_hours', 'barber_breaks'] as $name) {
            Schema::create($name, function (Blueprint $table) use ($name) {
                $table->id();
                $table->foreignId('salon_id')->constrained();
                $table->foreignId('barber_id')->constrained()->cascadeOnDelete();
                $table->foreignId('branch_id')->constrained()->cascadeOnDelete();
                $table->unsignedTinyInteger('weekday');
                $table->time('starts_at');
                $table->time('ends_at');
                if ($name === 'barber_breaks') {
                    $table->string('label', 60)->nullable();
                }
                $table->timestamps();
                $table->index(['barber_id', 'branch_id', 'weekday']);
            });
        }

        Schema::create('barber_schedule_overrides', function (Blueprint $table) {
            $table->id();
            $table->char('public_id', 26)->unique();
            $table->foreignId('salon_id')->constrained();
            $table->foreignId('barber_id')->constrained()->cascadeOnDelete();
            $table->foreignId('branch_id')->constrained()->cascadeOnDelete();
            $table->date('date');
            $table->string('type', 32); // day_off | custom_hours
            $table->time('starts_at')->nullable();
            $table->time('ends_at')->nullable();
            $table->string('reason', 190)->nullable();
            $table->timestamps();
            $table->unique(['barber_id', 'branch_id', 'date']);
        });

        Schema::create('time_off_requests', function (Blueprint $table) {
            $table->id();
            $table->char('public_id', 26)->unique();
            $table->foreignId('salon_id')->constrained();
            $table->foreignId('barber_id')->constrained()->cascadeOnDelete();
            $table->dateTime('starts_at');
            $table->dateTime('ends_at');
            $table->string('type', 32);
            $table->string('status', 32)->default('pending');
            $table->text('reason')->nullable();
            $table->foreignId('decided_by')->nullable()->constrained('users');
            $table->timestamp('decided_at')->nullable();
            $table->string('decision_note', 255)->nullable();
            $table->timestamps();
            $table->index(['barber_id', 'status', 'starts_at']);
            $table->index(['salon_id', 'status', 'starts_at']);
        });
    }

    public function down(): void
    {
        foreach (['time_off_requests', 'barber_schedule_overrides', 'barber_breaks', 'barber_working_hours', 'barber_branches', 'barbers', 'staff_invitations'] as $t) {
            Schema::dropIfExists($t);
        }
    }
};
