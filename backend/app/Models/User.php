<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = ['name', 'email', 'password', 'role', 'daily_tasks_count', 'last_task_at'];
    protected $hidden = ['password', 'remember_token'];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'last_task_at' => 'date',
            'daily_tasks_count' => 'integer',
        ];
    }

    public function tasks()
    {
        return $this->hasMany(Task::class);
    }

    public function isAdmin(): bool
    {
        return $this->role === 'admin';
    }

    public function canCreateTask(): bool
    {
        if ($this->isAdmin()) return true;
        
        $today = now()->toDateString();
        if ($this->last_task_at?->toDateString() !== $today) {
            return true;
        }
        
        return $this->daily_tasks_count < 5;
    }
}
