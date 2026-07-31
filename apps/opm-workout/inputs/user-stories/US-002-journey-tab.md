# US-002: Open the Journey screen from the bottom navigation

## Story
As a user, from the home screen I can tap "Journey" in the bottom navigation
and land on the Journey screen, where I can see my workout overview (weekly
summary and total average).

## Acceptance criteria
- [ ] Starting on the home screen, tapping the "Journey" bottom-nav tab
      navigates to the Journey screen
- [ ] Journey screen shows the "Journey" title
- [ ] Workout summary card is visible ("Workout")
- [ ] Total Average metric is visible ("Total Average")

## Notes for generation
- Fresh launch, cleared state; start on Home, then tap Journey.
- Grounded in apps/opm-workout/hierarchy/home.json (home nav) and
  apps/opm-workout/hierarchy/journey.json (destination), dumped 2026-07-30,
  iPhone 16 Pro / iOS 18.6 simulator.
- Flutter app: on the Journey screen the entire workout card is ONE
  accessibility label — "Workout\nTotal Average: 00:00\nM\nT\nW\nT\nF\nS\nS".
  Assert substrings of it with a DOTALL regex; the inner texts are not
  separately targetable.
