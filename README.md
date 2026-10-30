# Maison — DummyJSON Store (Flutter)

Flutter demo app against the public [DummyJSON](https://dummyjson.com) API.  
Built for Android and iOS with a **Paneri-style** architecture (Provider, feature modules, Dio, secure storage).

---

## Client requirements checklist

| Requirement | Implementation |
| --- | --- |
| Login screen · `POST /auth/login` | `features/auth/login/` — username/password form, validation, loading |
| Test user `emilys` / `emilyspass` | Prefills on the login screen; also documented below |
| Store token securely | JWT in **`FlutterSecureStorage`** (Android Keystore / iOS Keychain). Login flag + light user JSON in `SharedPreferences` |
| Product list · `GET /products` | `features/products/` after successful login |
| Loading / error / empty states | Loader, `ErrorView` + retry, `EmptyView` + retry |
| Pull-to-refresh | `RefreshIndicator` via `CustomSingleChildScroll` |
| Pagination | DummyJSON `limit` + `skip`; infinite scroll near list end |
| Product detail on tap | `GET /products/:id` → `features/products/product_details/` |
| Clean structure + state management | Provider + ChangeNotifier, repositories, `RouteService` (see below) |
| Short README of decisions | This file |

Extra (not required, but included): splash session restore via `GET /auth/me`, offline dialog (`connectivity_plus`), logout.

---

## Architecture decisions

### Why this shape?

The structure mirrors **Paneri mobile** so the same patterns are reused: feature folders, screen `builder` + provider, static repositories, Dio interceptors, and a barrel export file.

| Topic | Choice | Why |
| --- | --- | --- |
| State management | **Provider + `ChangeNotifier`** | Same as Paneri; simple, testable, no GetX |
| Navigation | Named routes via **`RouteService`** | Each screen: `routeName` + `builder` that wires its provider |
| Networking | **Dio** (`ApiService`) | Auth interceptor (Bearer), retry on connection failures, debug logger |
| Data layer | Models + static **repositories** | UI never talks to Dio directly; `repoRequest` centralizes success/error |
| Auth session | `AuthSession` + secure storage | Token never kept in plain prefs; splash restores or clears session |
| Pagination model | `PaginatedResponse` / `PaginationMeta` | Paneri-style API adapted to DummyJSON’s `skip`/`limit`/`total` |
| UI kit | Shared widgets under `core/widgets/` | Buttons, fields, loaders, empty/error, product card |
| Scaling | `flutter_screenutil` (393×852) | Same design-size approach as Paneri |
| Platform | Flutter — **Android & iOS** | `INTERNET` + secure storage options configured for both |

### DummyJSON specifics

- Login: `POST https://dummyjson.com/auth/login`  
  Body: `{ "username", "password", "expiresInMins": 60 }`  
  Reads `accessToken` (fallback `token`) and optional `refreshToken`.
- Products list: `GET /products?limit=&skip=`  
  Response: `{ products, total, skip, limit }`.
- Detail: `GET /products/:id`.
- DummyJSON is **not** Paneri’s `{ success, data }` envelope — `AppResponse` treats HTTP 2xx JSON as the payload.

### Flow

1. **Splash** — restore login flag + token; if logged in, validate with `/auth/me`; else go to login.  
2. **Login** — authenticate → save token securely → open collection.  
3. **Collection** — paginated products, refresh, empty/error.  
4. **Detail** — tap product → fetch and show full product (gallery, price, reviews).  
5. **Logout** — clear secure token + prefs → back to login.

---

## Project structure

```
lib/
├── main.dart                      # App bootstrap, PrefService, AuthSession.restore
├── store_app.dart                 # Barrel exports (like paneri_app.dart)
├── store_app_extra.dart           # dart: / Dio / intl exports
├── app/
│   ├── app_view.dart              # MaterialApp, providers, navigatorKey
│   ├── app_provider.dart
│   └── network_provider.dart      # Connectivity + no-internet dialog
├── core/
│   ├── constants/                 # ApiConstants, PrefKeys, AppConstants
│   ├── theme/                     # AppColors, AppStyles (Fraunces + Plus Jakarta)
│   ├── utils/                     # Extensions, ErrorHandler, logout helpers
│   └── widgets/                   # Shared UI
├── data/
│   ├── api/                       # Auth / Retry / Logger interceptors
│   ├── models/                    # User, Product, AppResponse, pagination…
│   └── repositories/              # AuthRepository, CatalogRepository
├── features/
│   ├── auth/                      # AuthSession, splash, login
│   ├── products/                  # Collection list + product_details/
│   └── unknown/
└── service/                       # ApiService, PrefService, SecureStorage, RouteService
```

---

## Run (Android & iOS)

```bash
flutter pub get
flutter run
```

Pick a device/simulator as needed:

```bash
flutter devices
flutter run -d <device_id>
```

### Test credentials

| Field | Value |
| --- | --- |
| Username | `emilys` |
| Password | `emilyspass` |

Fields are **prefilled** on the login screen for the demo.

---

## Tests & analysis

```bash
flutter test
flutter analyze
```

Coverage includes:

- Model parsing (auth, product, DummyJSON pagination)
- Shared widgets (button, empty state)
- Navigation safety around loader dismiss after stack replace

---

## Design note

UI is branded **Maison** (boutique retail): wine primary, parchment atmosphere, Fraunces for display type and Plus Jakarta Sans for UI. Structure and networking remain Paneri-aligned; DummyJSON is only the data backend.
