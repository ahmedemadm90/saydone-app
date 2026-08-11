<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('role')->default('user')->after('password');
            $table->unsignedInteger('daily_tasks_count')->default(0)->after('role');
            $table->timestamp('last_task_at')->nullable()->after('daily_tasks_count');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['role', 'daily_tasks_count', 'last_task_at']);
        });
    }
};
