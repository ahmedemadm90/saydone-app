<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class SayDoneApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_register_and_create_tasks(): void
    {
        $response = $this->postJson('/api/v1/auth/register', [
            'name' => 'Ahmed',
            'email' => 'ahmed@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $response->assertCreated()->assertJsonStructure(['token', 'user']);
        $token = $response->json('token');

        $this->withHeader('Authorization', 'Bearer ' . $token)
            ->postJson('/api/v1/tasks', ['title' => 'Buy milk'])
            ->assertCreated()
            ->assertJsonPath('title', 'Buy milk');
    }

    public function test_free_user_is_limited_to_five_tasks_daily(): void
    {
        $user = User::factory()->create(['role' => 'user', 'daily_tasks_count' => 5, 'last_task_at' => now()]);

        $this->actingAs($user)
            ->postJson('/api/v1/tasks', ['title' => 'Task 6'])
            ->assertForbidden()
            ->assertJsonPath('message', 'Daily task limit reached. Upgrade for unlimited access.');
    }

    public function test_admin_has_no_daily_limit(): void
    {
        $admin = User::factory()->create(['role' => 'admin', 'daily_tasks_count' => 10, 'last_task_at' => now()]);

        $this->actingAs($admin)
            ->postJson('/api/v1/tasks', ['title' => 'Admin Task'])
            ->assertCreated();
    }
}
