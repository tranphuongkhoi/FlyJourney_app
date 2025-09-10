# Guidance for Codex Agent

This repository contains a Flutter application organized into feature-based modules.

## Structure

```
lib/
  src/
    core/          # shared constants, config, theme, widgets
    features/
      auth/
        data/
        domain/
        presentation/
      booking/
      connection/
      home/
      notifications/
      search/
      splash/
```

## Development Workflow

- Place reusable utilities in `lib/src/core`.
- Feature code lives under `lib/src/features/<feature>`.
- Separate layers: `data` for services, `domain` for models and logic, `presentation` for UI.

### Before committing

1. Format code if necessary.
2. Run static analysis and tests:
   - `dart analyze`
   - `dart test`
   - `flutter analyze` *(when Flutter SDK is available)*
3. Update relevant documentation.

Use descriptive commit messages and keep the workspace clean.
