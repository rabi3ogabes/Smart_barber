<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

/*
| Memberships are addressed in dashboard URLs from Phase 2, so they need a public id (ADR: ULIDs only in URLs).
*/
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('salon_user', fn (Blueprint $t) => $t->char('public_id', 26)->nullable()->after('id'));
        DB::table('salon_user')->whereNull('public_id')->orderBy('id')->each(function (object $row): void {
            DB::table('salon_user')->where('id', $row->id)->update(['public_id' => (string) Str::ulid()]);
        });
        Schema::table('salon_user', function (Blueprint $t): void {
            $t->char('public_id', 26)->nullable(false)->change();
            $t->unique('public_id');
        });
    }

    public function down(): void
    {
        Schema::table('salon_user', fn (Blueprint $t) => $t->dropColumn('public_id'));
    }
};
