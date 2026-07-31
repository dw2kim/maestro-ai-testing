# US-003: Open Day 1 workout and see the exercises

## Story
As a user, from the home screen I can tap the unlocked "DAY 1" entry and open
its workout screen, where I can see the day's exercises and a way to mark the
workout done.

## Acceptance criteria
- [ ] Tapping "DAY 1" on Home navigates to the Day 1 workout screen
- [ ] The workout screen shows the day title ("DAY 1")
- [ ] All four exercises are visible: Push Up, Running, Squat, Sit Up
- [ ] A "DONE" control is visible
- [ ] A back control is available

## Notes for generation
- Fresh launch, cleared state; start on Home, then tap "DAY 1" (the only
  unlocked day; Days 2-5 are locked).
- Grounded in apps/opm-workout/hierarchy/home.json (home Day 1 entry) and
  apps/opm-workout/hierarchy/day1-workout.json (destination), dumped
  2026-07-30, iPhone 16 Pro / iOS 18.6 simulator.
- Flutter app: each exercise card is one merged accessibility label
  ("Push Up\n0 / 30", ...), and the title carries an emoji ("DAY 1 💪").
  Match with DOTALL regex on the stable leading text.
