# Phase 9 — AI Hair Studio and recommendations / استوديو الشعر بالذكاء الاصطناعي

الهدف: العميل يجرّب القصة على صورته ثم يحجزها مباشرة.

```
Implement PHASE 9 only. Gate with salon_features 'ai_studio'.

Backend:
- AiImageProvider interface (generateHairstyle(originalImage, params): job) with a Fake
  provider and one real adapter selected by config; AiTextProvider for recommendations.
  Provider keys live only on the server.
- ai_studio_sessions (customer, original image path — never modified, status), 
  ai_generations (session, params: hairstyle, beard, length, fade, colour; result path,
  provider, cost units, latency, status, error), saved styles.
- Flow: upload (validate type/size/face present if provider supports it, strip EXIF,
  resize) → queued GenerateHairstyleJob on 'ai' queue → broadcast/poll result.
- Usage limits per customer per day and per salon per month (from plan), usage ledger
  for billing in Phase 14; graceful message when limit reached.
- Recommendation endpoint: inputs = customer preferences (maintenance level, length,
  style vibe), optional photo analysis, history; output = top pick + 1–2 alternatives with
  short reasons, always labelled "Suggested based on your preferences and the photo
  provided" (ar/en). Map suggestions to the salon's haircut_styles and services.
- Privacy: customer can delete sessions and photos; auto-delete originals after N days
  (setting).

Customer app (AI Studio tab):
- Upload or take photo with guidance overlay → style pickers (chips/carousel) →
  generating state with progress → Before/After comparison slider (drag handle, RTL-aware)
  → actions: Try another, Save, Book this style (prefills booking with mapped service +
  barber specialised in it), Share (watermarked image).
- "Which style suits me?" short questionnaire → recommendation cards → Try / Book.
Tests: limits, job failure + retry, original untouched, deletion, feature gating.
```
