# US-001: Launch app and reach home screen

## Story
As a user, when I launch OPM Workout, I land on the home screen and can see
today's workout entry point.

## Acceptance criteria
- [ ] App launches to the home screen without a crash
- [ ] Home screen shows the app branding ("One Punch")
- [ ] Difficulty selector is visible ("Beginner" / "Amateur" / "Pro")
- [ ] The workout program day list is visible ("DAY 1", "DAY 2", ...)
- [ ] Bottom navigation is visible ("Home" / "Journey" / "Settings")

## Notes for generation
- Fresh launch, cleared state.
- Element names above are grounded in apps/opm-workout/hierarchy/home.json
  (dumped 2026-07-30, iPhone 16 Pro / iOS 18.6 simulator).
- Flutter app: match on accessibility labels; labels carry suffixes
  (e.g. "Beginner\nTab 1 of 3", "DAY 2\n0%") so assert the leading substring.
