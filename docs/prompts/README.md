# How to use these prompts

Give Claude the master context once, then run one phase prompt per session. Never paste all phases at once.

أعطِ Claude السياق الرئيسي مرة واحدة، ثم نفّذ برومبت مرحلة واحدة في كل جلسة. لا تلصق كل المراحل دفعة واحدة.

1. Create one monorepo: `smart-barber/` with `backend/` (Laravel), `apps/customer/`, `apps/staff/` (Flutter) and `packages/` (shared Dart). — أنشئ مستودعاً واحداً للمشروع.
2. Save section 2 as `CLAUDE.md` in the repo root. Claude Code reads it every session. — احفظ القسم 2 باسم `CLAUDE.md`.
3. Save sections 3, 4 and 5 as `docs/architecture/laravel.md`, `flutter.md` and `design-system.md`. — ملفات المعمارية مرجع ثابت.
4. Start with Phase 0 (plan only, no code). Review its plan before Phase 1. — ابدأ بالمرحلة 0 (خطة فقط).
5. After each phase, Claude must return the Phase Report (section 10). Commit, tag `phase-N`, then open a fresh session for the next phase. — بعد كل مرحلة: تقرير، ثم commit، ثم جلسة جديدة.
6. If a phase is too big for one session, use the "Continue" prompt in section 10, never "start over". — إذا انقطع العمل، استخدم برومبت المتابعة.

Prompts are in English on purpose: coding agents follow English instructions more precisely. Arabic lines explain each step for you and your team. — البرومبتات بالإنجليزية عمداً لدقة التنفيذ، والشرح بالعربية.
