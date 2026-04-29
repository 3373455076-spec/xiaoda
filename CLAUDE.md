# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

Run all commands from the repository root.

### Package manager
- `pnpm install` — install dependencies. The repo enforces `pnpm`; do not use npm or yarn.

### Frontend + backend development
- `pnpm dev` — start the H5 frontend and Nest backend together.
- `pnpm dev:web` — run the H5 frontend in watch mode on port 5000.
- `pnpm dev:weapp` — run the WeChat Mini Program build in watch mode.
- `pnpm dev:tt` — run the Toutiao app build in watch mode.
- `pnpm dev:server` — start the Nest backend in watch mode.
- `pnpm kill:all` — kill leftover concurrent dev processes.

### Build / validation
- `pnpm validate` — run the required root checks (`eslint` + `tsc`).
- `pnpm lint` — lint frontend source.
- `pnpm lint:fix` — auto-fix frontend lint issues.
- `pnpm tsc` — run TypeScript checks without emitting.
- `pnpm build` — full build: lint, typecheck, H5, WeChat, Toutiao, and server.
- `pnpm build:web` — build H5 output to `dist-web`.
- `pnpm build:weapp` — build WeChat Mini Program output to `dist`.
- `pnpm build:tt` — build Toutiao app output to `dist-tt`.
- `pnpm build:server` — build the Nest backend.
- `pnpm build:pack` — build only the WeChat and Toutiao outputs.
- `pnpm preview:weapp` — generate a WeChat preview build.
- `pnpm preview:tt` — generate a Toutiao preview build.
- `pnpm new` — scaffold a new Taro page/component.

### Backend-only commands
- `pnpm --filter server dev` — backend watch mode.
- `pnpm --filter server build` — backend production build.
- `pnpm --filter server start` — backend start.
- `pnpm --filter server start:debug` — backend debug watch mode.
- `pnpm --filter server start:prod` — run built backend from `server/dist/main`.

### Cloud function tests
Cloud functions are separate Node projects under `cloudfunctions/`.

- `pnpm --dir cloudfunctions/taskService test` — run taskService tests.
- `pnpm --dir cloudfunctions/taskService test:watch` — watch taskService tests.
- `pnpm --dir cloudfunctions/taskService test:cov` — coverage for taskService.
- `pnpm --dir cloudfunctions/taskService test -- <pattern>` — run a single taskService test by Jest pattern.
- `pnpm --dir cloudfunctions/userService test` — run userService tests.
- `pnpm --dir cloudfunctions/userService test:watch` — watch userService tests.
- `pnpm --dir cloudfunctions/userService test:cov` — coverage for userService.
- `pnpm --dir cloudfunctions/userService test -- <pattern>` — run a single userService test by Jest pattern.

## Architecture overview

This is a Taro 4 + React mini-program app with a NestJS backend and two legacy-style cloud function folders. The repo is organized around three runtime surfaces:

1. `src/` — the client app shared across H5, WeChat Mini Program, and Toutiao Mini App.
2. `server/` — the active NestJS API used by the frontend during development and web usage.
3. `cloudfunctions/` — `taskService` and `userService`, exposed through the backend as compatibility-style service endpoints.

### Frontend app structure
- `src/app.tsx` wraps the app in `LucideTaroProvider`, global `Preset`, and the shared toast system.
- `src/app.config.ts` is the routing source of truth: it declares all pages and the tab bar.
- `src/pages/` holds feature pages; navigation is mostly direct `Taro.navigateTo` / `navigateBack` calls between pages.
- `src/components/ui/` is the project’s preferred component layer (Taro-adapted shadcn-style components). Reuse these before falling back to raw `@tarojs/components`.
- `src/presets/` contains cross-cutting app behavior for H5, including navbar/error-boundary style runtime wrappers.
- `src/network.ts` is the only approved request wrapper for normal client HTTP traffic.

### Request and API flow
- Frontend code should call `Network.request`, `Network.uploadFile`, and `Network.downloadFile` from `src/network.ts`; do not call `Taro.request` / `uploadFile` / `downloadFile` directly.
- `config/index.ts` injects `PROJECT_DOMAIN` into the client build. Relative client requests are prefixed with that domain.
- In H5 dev, Taro also proxies `/api` to `PROJECT_DOMAIN` via the Vite dev server on port 5000.
- The Nest app sets a global `/api` prefix in `server/src/main.ts`, so controller decorators must not include `api` in their route paths.
- `server/src/app.controller.ts` exposes health/auth endpoints and a `/cloud/:name` proxy that dispatches to `taskService` and `userService` through `AppService`.

### Backend data model
- The backend is currently a thin Nest application: `AppModule` wires only `AppController` and `AppService`.
- Most business logic lives in the large `server/src/app.service.ts` service rather than feature modules.
- Persistence is initialized in `server/src/db/client.ts` using a Postgres `pg` pool.
- `initDatabase()` creates tables and indexes on startup and seeds initial circle data if the database is empty.
- `server/src/db/schema.ts` contains the Drizzle schema definitions, but database bootstrapping is still done with raw SQL in `client.ts`.
- `server/src/main.ts` also enables CORS, sets large JSON/body limits, and installs `HttpStatusInterceptor` so successful POST requests return 200 instead of Nest’s default 201.

### Build/config model
- `config/index.ts` is the central Taro config. It selects output roots by target (`dist`, `dist-web`, `dist-tt`), injects `PROJECT_DOMAIN`, configures H5 dev proxying, and enables `weapp-tailwindcss` for non-H5 builds.
- `.env.local` drives frontend build-time values; `server/.env` drives backend runtime values such as `DATABASE_URL`.
- The backend will fail fast if `DATABASE_URL` is missing.

## Project-specific rules worth preserving

### From existing repo instructions
- Use `pnpm` only.
- Prefer `@/components/ui/*` for common UI primitives; do not hand-roll standard buttons, inputs, dialogs, cards, tabs, toasts, etc. with `View/Text` unless the component truly does not exist yet.
- Prefer Tailwind utility classes over inline styles or large page-specific CSS. Avoid hardcoded `px` arbitrary values where Tailwind presets work.
- Use `lucide-react-taro`, never `lucide-react`.
- For icons, set visual appearance with component props like `size`, `color`, and `strokeWidth`; `className` only affects the outer Taro `Image` wrapper.
- Static media should live in object storage URLs rather than being bundled into the app. The main exception is local tab bar PNG assets required by WeChat Mini Program.
- Do not modify `src/network.ts` unless the change is truly global request behavior; normal feature work should consume it, not replace it.
- Because the backend applies `app.setGlobalPrefix('api')`, routes should be declared like `@Controller('users')`, not `@Controller('api/users')`.

## Notes for future Claude instances
- There is no top-level monorepo test command. Root validation is `pnpm validate`; cloud-function tests run inside each cloud function directory.
- The root `README.md` is partly template-like and over-describes generated patterns. Prefer the actual code when README guidance conflicts with observed implementation.
- The active backend architecture is flatter than a typical Nest app: expect controller/service files plus DB helpers, not per-feature Nest modules.
