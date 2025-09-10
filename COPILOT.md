# Copilot Guidance

This project uses Flutter with a modular, feature-first architecture. Copilot should generate code that fits within this structure.

## Project Overview

- Shared resources are under `lib/src/core`.
- Feature-specific code resides in `lib/src/features/<feature>` with `data`, `domain`, and `presentation` layers.
- Imports should be relative to the `lib/src` root.

## Coding Conventions

- Follow the official Dart style guide.
- Use explicit types and maintain null safety.
- Keep widgets small and focused.

## Testing

- Add or update tests in the `test/` directory when introducing new behavior.
- Ensure `dart analyze` and `dart test` run without errors before submission.

These notes help Copilot provide suggestions that align with the repository's patterns and expectations.
