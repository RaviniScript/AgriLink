# Quick Steps for Smooth UI Merge

## ✅ What I've Done (Preparation)
1. Added `welcome` route to `app_routes.dart` (line 3)
2. Added TODO comments in `onboarding_view.dart` showing where navigation will change
3. Created detailed `MERGE_INSTRUCTIONS.md` with step-by-step guide
4. Verified no compilation errors

## 🔄 Current Navigation (Temporary)
```
Splash → Onboarding → homeSelector (temporary) → Buyer/Farmer/Delivery Home
```

## 🎯 Target Navigation (After Your Teammate Merges)
```
Splash → Welcome (NEW) → Onboarding or Login → Login/Signup → Role Selection → Home
```

## 📝 For Your Teammate

### Files to Create/Update:
1. **NEW**: `lib/views/common/welcome_view.dart`
2. **UPDATE**: `lib/views/auth/login_view.dart` (new UI design)
3. **UPDATE**: `lib/views/auth/register_view.dart` (add if missing)
4. **REPLACE**: `lib/views/common/home_selector_view.dart` (with designed role selection)
5. **UPDATE**: `lib/views/common/splash_view.dart` (navigate to welcome instead of onboarding)
6. **UPDATE**: `lib/views/common/onboarding_view.dart` (navigate to login instead of homeSelector)
7. **UPDATE**: `lib/routes/route_generator.dart` (add welcome case)

### Quick Git Commands for Teammate:
```bash
# Get latest code
git pull origin main

# Create feature branch
git checkout -b feature/auth-welcome-ui

# After making changes, commit
git add lib/views/common/welcome_view.dart
git add lib/views/auth/login_view.dart
git add lib/views/auth/register_view.dart
git add lib/views/common/home_selector_view.dart
git add lib/views/common/splash_view.dart
git add lib/views/common/onboarding_view.dart
git add lib/routes/route_generator.dart
git add assets/*  # if new assets

git commit -m "feat: Add welcome screen and update auth UI"
git push origin feature/auth-welcome-ui
```

### After They Push, You Do:
```bash
# Review their branch
git fetch origin
git checkout feature/auth-welcome-ui
flutter pub get
flutter run -d RF8M727CZLP  # Test it

# If good, merge
git checkout main
git merge feature/auth-welcome-ui
git push origin main
```

## ⚠️ Important: What NOT to Touch
Your teammate should avoid modifying:
- `lib/views/buyer/*` (complete buyer module)
- `lib/services/*` (all backend)
- `lib/models/*` (data models)
- `lib/widgets/buyer_bottom_nav.dart`
- `pubspec.yaml` (unless coordinated)

## 📱 Testing Checklist After Merge
- [ ] Run `flutter pub get`
- [ ] App launches without errors
- [ ] Splash → Welcome → Onboarding → Login flow works
- [ ] Login navigates to role selection
- [ ] Role selection navigates to buyer home
- [ ] Existing buyer features work (cart, orders, profile, reviews, favorites)
- [ ] No compilation errors: `flutter analyze`
- [ ] Build succeeds: `flutter build apk --debug`

---

**Status**: Your code is ready for merge! No conflicts expected if teammate follows the instructions. The `welcome` route is already added, and temporary navigation is clearly marked with TODO comments.
