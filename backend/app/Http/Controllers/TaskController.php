<?php

namespace App\Http\Controllers;

use App\Models\Task;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class TaskController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $tasks = $request->user()->tasks()
            ->when($request->string('status')->trim()->value(), fn ($query, $status) => $query->where('status', $status))
            ->latest()
            ->paginate(min($request->integer('per_page', 20), 100));

        return response()->json($tasks);
    }

    public function store(Request $request): JsonResponse
    {
        $user = $request->user();
        if (!$user->canCreateTask()) {
            return response()->json(['message' => 'Daily task limit reached. Upgrade for unlimited access.'], 403);
        }

        $data = $request->validate([
            'title' => ['required', 'string', 'max:255'],
            'description' => ['nullable', 'string'],
            'priority' => ['nullable', 'in:low,medium,high'],
            'voice_url' => ['nullable', 'string'],
            'transcription' => ['nullable', 'string'],
        ]);

        $task = DB::transaction(function () use ($user, $data) {
            $task = $user->tasks()->create($data);
            
            $today = now()->toDateString();
            if ($user->last_task_at?->toDateString() !== $today) {
                $user->update(['daily_tasks_count' => 1, 'last_task_at' => now()]);
            } else {
                $user->increment('daily_tasks_count');
            }
            
            return $task;
        });

        return response()->json($task, 201);
    }

    public function update(Request $request, Task $task): JsonResponse
    {
        abort_unless($task->user_id === $request->user()->id, 403);
        $data = $request->validate([
            'title' => ['sometimes', 'string', 'max:255'],
            'description' => ['nullable', 'string'],
            'status' => ['sometimes', 'in:pending,completed'],
            'priority' => ['sometimes', 'in:low,medium,high'],
        ]);

        if (isset($data['status']) && $data['status'] === 'completed' && $task->status !== 'completed') {
            $data['completed_at'] = now();
        }

        $task->update($data);
        return response()->json($task);
    }

    public function destroy(Request $request, Task $task): JsonResponse
    {
        abort_unless($task->user_id === $request->user()->id, 403);
        $task->delete();
        return response()->json(['message' => 'Task deleted.']);
    }
}
