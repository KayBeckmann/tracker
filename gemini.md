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
- **Tasks/Appointments:** With pop-up notifications and reminder functionality. Includes:
    - Calendar overview with visual highlighting for days with appointments.
    - List view of all appointments, sortable by due date, priority, or category.
    - Functionality to create and edit appointments with fields: title, due date, creation date, priority (-1: low, 0: medium, 1: high), description, and category.
    - Category management via a dedicated tab, with automatic creation of new categories upon appointment creation if they don't exist.
- **Notes:** Support for tags, filtering, search, and Markdown formatting. Includes:
    - Note structure: description (Markdown), first line as title, creation/last modification dates, multiple tags.
    - Initial notes for each module describing functionalities and Markdown introduction.
    - Overview list of all notes, filterable by input field (search) or multiple tag selection.
    - Ability to mark notes as templates (e.g., for Bullet Journal).
    - Calendar filtering: display notes created or modified within a specified date range or on a specific day.
    - Bidirectional linking between appointments and notes.
    - **Note-to-note linking:** Wiki-style links using `[[Note Title]]` syntax. Links are clickable in preview mode and navigate to the referenced note.
    - Image insertion from device, synchronized with backend for paid subscriptions.
    - **Default view setting:** User can choose whether notes and journal entries open in Editor or Preview mode by default (configurable in Settings).
- **Habits:** Tracking daily counts/time spent and comparison with past performance.
- **Household Book:** Financial tracking and management.
- **Settings:** User preferences and application configuration, including:
    - Theme selection (System, Light, Dark) and color scheme customization.
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
