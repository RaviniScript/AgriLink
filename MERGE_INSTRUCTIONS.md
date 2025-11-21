# UI Merge Instructions

## Files Your Teammate Will Push

### 1. New Welcome Screen (separate from Splash)
- [ ] `lib/views/common/welcome_view.dart` - **NEW** Welcome screen (after splash)
- [ ] Update navigation: Splash → Welcome → Onboarding → Login

### 2. Updated Authentication Screens
- [ ] `lib/views/auth/login_view.dart` - Replace with new designed UI
- [ ] `lib/views/auth/register_view.dart` - Add or update signup screen

### 3. Role Selection Screen
- [ ] `lib/views/common/home_selector_view.dart` - **REPLACE** temporary version
- [ ] Or create `lib/views/auth/role_selection_view.dart` if using different name

## Current Navigation Flow (Temporary)
```
Splash (3s) 
  → Onboarding 
    → Home Selector (line 40 in onboarding_view.dart)
      → Buyer/Farmer/Delivery Home
```

## Target Navigation Flow (After Merge)
```
Splash (3s)
  → Welcome (NEW)
    → Onboarding or Login (button choice)
      → Login/Signup
        → Role Selection
          → Buyer/Farmer/Delivery Home
```

## Routes to Add/Update

### Add to `app_routes.dart`:
```dart
static const String welcome = '/welcome';
static const String register = '/register';  // if missing
```

### Update in `route_generator.dart`:
```dart
case AppRoutes.welcome:
  return MaterialPageRoute(builder: (_) => const WelcomeView());
case AppRoutes.register:
  return MaterialPageRoute(builder: (_) => const RegisterView());
```

### Update `splash_view.dart` navigation:
Change line ~20 from:
```dart
Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
```
To:
```dart
Navigator.of(context).pushReplacementNamed(AppRoutes.welcome);
```

### Update `onboarding_view.dart` navigation:
Change line 40 from:
```dart
Navigator.of(context).pushReplacementNamed(AppRoutes.homeSelector);
```
To:
```dart
Navigator.of(context).pushReplacementNamed(AppRoutes.login);
```

## Files Teammate Should NOT Touch
- `lib/views/buyer/*` - Complete buyer module
- `lib/services/*` - All backend services
- `lib/models/*` - Data models
- `lib/widgets/buyer_bottom_nav.dart`
- `pubspec.yaml` (unless adding new packages - coordinate first)

## Files Teammate CAN Modify
- `lib/views/common/welcome_view.dart` (NEW)
- `lib/views/common/splash_view.dart` (update navigation)
- `lib/views/common/onboarding_view.dart` (update navigation)
- `lib/views/common/home_selector_view.dart` (replace completely)
- `lib/views/auth/login_view.dart` (replace UI)
- `lib/views/auth/register_view.dart` (add or replace)
- `lib/routes/app_routes.dart` (add welcome route)
- `lib/routes/route_generator.dart` (add welcome case)
- `assets/*` (add new images/icons as needed)

## Git Workflow for Teammate

```bash
# 1. Get latest code
git pull origin main

# 2. Create feature branch
git checkout -b feature/auth-welcome-ui

# 3. Add/replace screens
# - Add welcome_view.dart
# - Update login_view.dart
# - Add/update register_view.dart  
# - Replace home_selector_view.dart
# - Update routes as listed above

# 4. Stage ONLY changed files
git add lib/views/common/welcome_view.dart
git add lib/views/auth/login_view.dart
git add lib/views/auth/register_view.dart
git add lib/views/common/home_selector_view.dart
git add lib/views/common/splash_view.dart
git add lib/views/common/onboarding_view.dart
git add lib/routes/app_routes.dart
git add lib/routes/route_generator.dart
git add assets/*  # if new assets added

# 5. Commit
git commit -m "feat: Add welcome screen and update auth UI"

# 6. Push
git push origin feature/auth-welcome-ui

# 7. Create Pull Request on GitHub
```

## Your Steps After Teammate Pushes

```bash
# 1. Fetch changes
git fetch origin

# 2. Review branch (optional)
git checkout feature/auth-welcome-ui
flutter pub get
flutter run -d RF8M727CZLP

# 3. If looks good, merge
git checkout main
git merge feature/auth-welcome-ui

# 4. Push merged code
git push origin main
```

## Quick Integration Checklist
- [ ] Run `flutter pub get` after merge
- [ ] Test splash → welcome → onboarding → login flow
- [ ] Test login navigates to role selection
- [ ] Test role selection navigates to buyer home
- [ ] Test existing buyer features (cart, orders, profile) still work
- [ ] Check no compilation errors: `flutter analyze`
- [ ] Build runs successfully: `flutter build apk --debug`

## Conflict Resolution Tips
If conflicts occur in routes files:
1. Keep both route additions (yours + teammate's)
2. Ensure all route cases are in `route_generator.dart`
3. Import all new view files at the top

If conflicts in navigation files:
1. Use teammate's updated navigation paths
2. Keep the route names from updated `app_routes.dart`

