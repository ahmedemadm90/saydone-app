# SayDone — Voice-to-Task AI Assistant

SayDone is a real-world SaaS application that converts voice notes into organized, actionable tasks. It supports Arabic (Modern Standard and Slang) and English, uses a Laravel backend for identity and usage metering, and features a Material 3 Flutter mobile client with a native recording experience.

## Product surface

| Feature | Implementation |
|---|---|
| AI Processing | Converts voice recordings into structured tasks with titles and descriptions |
| Language Support | Understands English, Arabic Fusha, and Arabic Egyptian/Gulf dialects |
| SaaS Metering | Free tier limited to 5 tasks/day; Admin accounts have unlimited access |
| Onboarding | Interactive mobile introduction with local state persistence |
| Identity | Secure registration, login, and session management via Laravel Sanctum |
| Mobile Experience | Native audio recording, real-time usage tracking, and task status toggling |

## Run the backend

```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate --seed
php artisan serve --host=0.0.0.0 --port=8000
```

Seeded credentials:

| User | Email | Password | Role |
|---|---|---|---|
| Admin | `admin@saydone.app` | `password` | Unlimited |
| Free User | `user@example.com` | `password` | 5 tasks/day |

## Run the Flutter mobile app

```bash
cd frontend
flutter pub get
flutter test
flutter analyze
flutter run
```

The app is configured for an Android emulator (`10.0.2.2`). Update `frontend/lib/services/saydone_api.dart` for physical devices or remote production environments.

The flow starts with a 3-page onboarding sequence, followed by an authentication gateway. Once logged in, users can record voice notes (or simulate recognition) to generate tasks.

## AI Pipeline

SayDone uses a multi-stage pipeline for voice processing:
1. **Native Record**: Captures high-quality audio on the device.
2. **Whisper/STT**: Transcribes audio with dialect-aware models.
3. **LLM Extraction**: Parses transcription to extract intent, priority, and structured fields.
4. **Laravel Persistence**: Validates daily usage limits and stores the task.

## API Surface

| Method | Endpoint | Purpose |
|---|---|---|
| `POST` | `/api/v1/auth/register` | Create a new user account |
| `POST` | `/api/v1/auth/login` | Issue an API token |
| `GET` | `/api/v1/auth/me` | Fetch current user profile and usage |
| `GET` | `/api/v1/tasks` | List paginated user tasks |
| `POST` | `/api/v1/tasks` | Store a new task (enforces 5/day limit) |
| `PATCH` | `/api/v1/tasks/{id}` | Toggle task status or update fields |
| `DELETE` | `/api/v1/tasks/{id}` | Permanently remove a task |

## Repository layout

```text
backend/
├── app/Http/Controllers/        Auth and usage-limited Task APIs
├── app/Models/                  User (with usage logic) and Task models
├── database/migrations/         SaaS schema and task persistence
└── tests/Feature/               Daily limit and identity tests
frontend/
├── lib/models/                  App domain models
├── lib/providers/               State management and local persistence
├── lib/services/                REST API client
├── lib/views/                   Onboarding, Home, and Voice UI
└── assets/                      Product illustrations
```

## Author

Ahmed Emad — Backend, Mobile, and Automation Developer.
