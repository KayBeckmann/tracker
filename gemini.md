# Gemini Collaboration File

This file is used to store information and context for collaboration with Gemini.

## Project Goals

This project aims to develop a cross-platform application using Flutter, targeting:
- Android
- iOS
- Windows
- Linux
- Web

The architecture will consist of:
- A frontend running in a Docker container.
- A backend running in a separate Docker container.

Database considerations:
- A SQL database for the backend.
- A SQL database for the frontend (likely for local data persistence, e.g., SQLite).

The application will include the following core features:
- **Dashboard:** Overview of key information.
- **Tasks/Appointments:** With pop-up notifications and reminder functionality.
- **Notes:** Support for tags, filtering, search, and Markdown formatting.
- **Habits:** Tracking daily counts/time spent and comparison with past performance.
- **Household Book:** Financial tracking and management.
- **Settings:** User preferences and application configuration, including:
    - Theme selection (System, Light, Dark).
    - Language selection (German, English, Swedish).
    - Backend login functionality.
    - Backend subscription management.

## Important Notes

- All application functions should be fully operational on the respective end device, implying robust offline capabilities and local data storage.
- The backend will primarily serve for synchronization of data across different user devices.
- User authentication and registration will support Apple ID, Google, and Email/Password options.
- Backend service usage will be monetized at €1 per month or €10 per year.
- Payment options will include PayPal and Bitcoin.
- The application will support multilingual functionality, initially including German, English, and Swedish.

## Memories

[Gemini can store memories here using the `save_memory` tool.]
