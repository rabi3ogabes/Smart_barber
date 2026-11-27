# Smart Barber — backend

Laravel 13 app: the mobile API (`/api/v1`), the salon dashboard (Inertia + Vue 3 + TypeScript + Tailwind) on `{slug}.{APP_DOMAIN}`, and the Super Admin console on `admin.{APP_DOMAIN}`.
Read the root `CLAUDE.md` and `docs/architecture/` first.

## Run locally

Requirements: PHP 8.3+, Composer, Node 22+, and MySQL 8 + Redis (via `docker compose up -d` from the repo root, or installed locally).

```bash
cp .env.example .env
composer install
php artisan key:generate
npm install
php artisan migrate:fresh --seed
npm run build            # or `npm run dev` for hot reload
php artisan serve        # http://salon-a.localhost:8000
```

Optional workers: `php artisan horizon` (queues), `php artisan reverb:start` (WebSockets), `php artisan schedule:work`.

Browsers resolve `*.localhost` to your machine, so no hosts-file changes are needed:

| URL | Who | Login (password `Password123!`) |
|---|---|---|
| http://salon-a.localhost:8000 | Salon A dashboard | `owner.a@…` (2FA setup forced), `manager.a@…`, `barber.a@…` — domain `smartbarber.test` |
| http://salon-b.localhost:8000 | Salon B dashboard | `owner.b@…`, `manager.b@…`, `barber.b@…` |
| http://admin.localhost:8000 | Super Admin console | `admin@smartbarber.test` (2FA setup forced) |
| http://salon-a.localhost:8000/dev/components | Component gallery (AR/EN, light/dark) | any salon member |
| http://localhost:8000/docs/api | API docs (after `php artisan scribe:generate`; not served in production) | — |

Customer OTP codes are written to `storage/logs/laravel.log` by the dev OTP driver.

## Quality gates (run before declaring a phase done)

```bash
vendor/bin/pint --test
vendor/bin/phpstan analyse --memory-limit=1G
php vendor/bin/pest
npm run lint             # ESLint + RTL logical-direction check + AR/EN key parity
npm run build            # vue-tsc type-check + Vite build
```

Tests run against MySQL database `smartbarber_test` (see `phpunit.xml`); the booking engine relies on MySQL row locks.

## Where things live

- `app/Core/` — tenancy, identity/auth, money, API envelope, idempotency, audit, settings, features, media, provider contracts + fakes.
- `app/Modules/{Name}/` — business modules, added phase by phase (`docs/architecture/modules.md`).
- `../design/tokens.json` — design tokens; `npm run tokens` generates `resources/css/tokens.css`.
- `lang/{ar,en}.json` — UI strings shared by Laravel and Vue; `lang/{ar,en}/errors.php` — API error messages.
