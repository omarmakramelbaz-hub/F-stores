# Fasakhansta Vendor

Flutter vendor application for managing store orders, products, wallet transfers,
delivery requests, account settings, and chat. It supports Arabic and English.

## Toolchain and local setup

CI uses Flutter **3.47.0** (Dart **3.13**). Use that version for reproducible checks;
`pubspec.lock` records the dependencies resolved with it.

```sh
flutter pub get
flutter run
```

Use the appropriate Android or iOS development toolchain and the project's
platform configuration when running on a device. API endpoints are defined in
`lib/helpers/networking/urls.dart`.

## Code layout

| Path | Responsibility |
| --- | --- |
| `lib/main.dart` | Application entry point and localization setup |
| `lib/init_services.dart` | Firebase, Hive, notifications, and platform startup |
| `lib/app.dart` | App providers, theme, and navigation |
| `lib/helpers/` | API transport, persistence, events, routing, and shared utilities |
| `lib/view/layout/vendor/` | Feature screens, controllers, models, and widgets |
| `lib/view/global/chat/` | Shared chat flows |
| `lib/view/custom_widgets/` | Reusable interface widgets |
| `assets/langs/` | Arabic and English translations |
| `test/` | Automated regression tests |
| `android/`, `ios/` | Native application projects |

Feature controllers currently manage state and call the shared API helper.
Keep related changes within their feature and separate reusable data-handling
logic from widget lifecycle code.

## Validation

```sh
flutter analyze
flutter test
```

The regression suite covers wallet destination confirmation, malformed API error
responses, network transport detection, and event listener registration and
removal. GitHub Actions runs the suite for pull requests and manual dispatches.

## Maintenance guidelines

- Use `snake_case` Dart filenames and the existing feature layout.
- Dispose widget controllers and unregister the same callback that was registered.
- Keep transport failures readable and avoid logging authentication or user data.
- Add behavioral regression coverage when changing order, payment, or event flows.

The October 2026 review focused on shared network handling, event lifecycle,
startup configuration, and static analysis. It did not include Android/iOS release
builds, live payment tests, or a complete device-based review of every screen.
