<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        User::updateOrCreate(
            ['email' => 'admin@saydone.app'],
            ['name' => 'SayDone Admin', 'password' => Hash::make('password'), 'role' => 'admin']
        );

        User::updateOrCreate(
            ['email' => 'user@example.com'],
            ['name' => 'Demo User', 'password' => Hash::make('password'), 'role' => 'user']
        );
    }
}
