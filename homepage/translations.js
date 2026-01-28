window.TRACKER_TRANSLATIONS = {
  en: {
    common: {
      brand: "Tracker",
      nav: {
        vision: "Vision",
        modules: "Modules",
        gallery: "Gallery",
        sync: "Sync Modes",
        architecture: "Architecture",
        availability: "Downloads",
        roadmap: "Roadmap",
        wiki: "Wiki",
        imprint: "Imprint",
        privacy: "Privacy"
      }
    },
    homepage: {
      meta: {
        title: "Tracker — Personal Productivity Suite"
      },
      hero: {
        title: "Tracker",
        subtitle:
          "The local-first productivity suite for planning, knowledge capture, journaling, and encrypted synchronisation across mobile, desktop, and web.",
        ctaPrimary: "Explore what’s new",
        ctaSecondary: "Open the wiki"
      },
      vision: {
        heading: "Why Tracker?",
        body:
          "Tracker fuses tasks, notes, journaling, habits, finances, and time tracking into a local-first cockpit. Work entirely offline with Drift-powered storage, or opt into free encrypted sync across all your devices.",
        cards: {
          offline: {
            title: "Local first",
            body: "Every module runs on-device with no mandatory account, perfect for privacy-conscious workflows and travelling."
          },
          encrypted: {
            title: "Encrypted cloud",
            body: "Free zero-knowledge sync with background conflict detection and server-side retention policies."
          },
          modular: {
            title: "Modular & adaptable",
            body: "Enable only the modules you need, automate hand-offs between them, and fine-tune colours plus layout."
          }
        }
      },
      modules: {
        heading: "Modules at a glance",
        dashboard: {
          title: "Dashboard",
          body: "Personal cockpit with highlights from every module.",
          list:
            "<li>Live status cards for habits, ledger balances, and timers (available)</li><li>Quick actions to start tracking, capture notes, or jump to focus views (available)</li><li>Custom widget grid with pinned filters (beta)</li>"
        },
        tasks: {
          title: "Tasks & Appointments",
          body: "Plan tasks, deadlines, reminders, and calendar events together.",
          list:
            "<li>Calendar-integrated board with colour-coded priorities (available)</li><li>Rich detail panel with tags, reminders, and linked notes (available)</li><li>Start/stop focus timers directly on a task (available)</li>"
        },
        notes: {
          title: "Notes",
          body: "Flexible Markdown knowledge base with drawing support.",
          list:
            "<li>Markdown editor with tag search, backlinks, and inline attachments (available)</li><li>Freehand sketches and canvas mode for visual thinking (available)</li><li>Reusable templates and multi-tag filters (beta)</li>"
        },
        journal: {
          title: "Journal & Mood Tracker",
          body: "Daily reflection with planned mood tracking and highlights.",
          list:
            "<li>Secure daily log with optional app-lock and biometric unlock (available)</li><li>Mood timeline with custom trackers and prompts (beta)</li><li>Link entries to notes and tasks for full context (in development)</li>"
        },
        habits: {
          title: "Habits",
          body: "Build routines with streaks, counters, and insights.",
          list:
            "<li>Track boolean, numeric, or duration goals with streak protection (available)</li><li>Trend charts and interval comparisons for each habit (available)</li><li>Template gallery and shared routines (roadmap)</li>"
        },
        ledger: {
          title: "Household Ledger",
          body: "Stay on top of expenses, budgets, and reports.",
          list:
            "<li>Multi-account ledger with recurring transactions (available)</li><li>Budgets, category filters, and reconciliation tools (available)</li><li>Analytics with rolling forecasts and sync exports (beta)</li>"
        },
        timeTracking: {
          title: "Time Tracking",
          body: "Measure focus sessions and tie them to tasks.",
          list:
            "<li>One-tap timers with automatic rounding and tagging (available)</li><li>Daily/weekly summaries plus billable vs. non-billable views (available)</li><li>CSV exports and task automation hooks (roadmap)</li>"
        },
        settings: {
          title: "Settings",
          body: "Control language, theming, modules, and sync.",
          list:
            "<li>Login via email/password or Google Sign-In with membership status (available)</li><li>Dynamic language, theme, and accent colour switching (available)</li><li>Module ordering, backups, and sync troubleshooting tools (beta)</li>"
        }
      },
      gallery: {
        heading: "Peek inside the workspace",
        body:
          "Each module runs locally, renders instantly, and syncs only when you decide to connect. These mock-ups show the layout of the current Android and desktop builds.",
        dashboardPlaceholder: "Dashboard preview",
        dashboard: "Dashboard with live habit streaks, current tasks, and ledger balance in one glance.",
        tasksPlaceholder: "Tasks preview",
        tasks: "Calendar-backed task board with inline timers and notification scheduling.",
        ledgerPlaceholder: "Ledger preview",
        ledger: "Ledger analytics summarising budgets, recurring payments, and account transfers."
      },
      sync: {
        heading: "Local first or encrypted cloud",
        body:
          "Choose the mode that fits your privacy needs. Tracker works fully offline, or sync for free with end-to-end encryption.",
        local: {
          title: "Local only",
          list:
            "<li>All data lives in an on-device Drift/Hive database</li><li>No account required—the full feature set is available offline</li><li>Export encrypted backups or keep everything air-gapped</li>"
        },
        cloud: {
          title: "Encrypted sync",
          list:
            "<li>End-to-end encryption (PBKDF2 + AES-256-GCM) with per-device keys</li><li>Access your workspace on Android, iOS (beta), desktop, and web</li><li>Completely free — no subscription required</li>"
        }
      },
      security: {
        heading: "Data security & retention",
        body:
          "Tracker never keeps synced content indefinitely. You stay in full control of your data at all times.",
        manual: {
          title: "Immediate deletion",
          body:
            "Delete synced copies from the server at any time from the app settings. Local notes and tasks remain on your devices."
        },
        local: {
          title: "Delete all local data",
          body:
            "Use the red button in settings to permanently delete all local data from your device. A confirmation dialog prevents accidental deletion."
        }
      },
      architecture: {
        heading: "Architecture & security insights",
        body:
          "Tracker follows a local-first architecture: Drift keeps an encrypted SQLite database on every device, while the server only stores ciphertext. Sync endpoints speak REST/JSON over TLS 1.3, and authentication relies on short-lived JWTs.",
        storage: {
          title: "On-device vault",
          list:
            "<li>Drift + SQLite for structured data, Hive for secrets and preferences</li><li>Automatic nightly snapshots with rolling retention (beta)</li><li>Module-level export/import for compliance and recovery</li>"
        },
        security: {
          title: "Encryption pipeline",
          list:
            "<li>PBKDF2-HMAC-SHA256 with 150k iterations derives 256-bit keys</li><li>AES-256-GCM envelopes notes, tasks, habits, ledger, and journal payloads</li><li>Per-device salts, lockout guards, and key rotation after membership changes</li>"
        },
        protocols: {
          title: "Protocols & APIs",
          list:
            "<li>FastAPI backend with optimistic locking and revision counters</li><li>Incremental sync APIs with server-side conflict detection</li><li>Google OAuth, access tokens, and upcoming Argon2id password hashing</li>"
        }
      },
      availability: {
        heading: "Availability & downloads",
        web: {
          title: "Web app",
          body: "Installable progressive web app with offline cache and biometric unlock on supported devices.",
          link: "Open now"
        },
        playStore: {
          title: "Google Play Store",
          body: "Sideload APK builds ship with every release; Play Store listing is currently in review.",
          link: "Listing preview"
        },
        windows: {
          title: "Windows download",
          body: "Placeholder build while automated packaging is finalised.",
          link: "Installer coming soon"
        },
        linux: {
          title: "Linux download",
          body: "Placeholder build while automated packaging is finalised.",
          link: "AppImage coming soon"
        }
      },
      roadmap: {
        heading: "Roadmap & current status",
        body: "We iterate in focused phases: stabilise the local-first core, then layer on encrypted sync, automation, and integrations.",
        phase1: {
          title: "Phase 1 — Local-first foundation (completed)",
          list:
            "<li>Drift/Hive storage, migrations, and backup subsystem</li><li>Modular UI with dashboard, tasks, notes, habits, ledger, journal, and time tracking</li><li>Localization (EN/DE/SV) with runtime language switching</li>"
        },
        phase2: {
          title: "Phase 2 — Module polish & automation (in progress)",
          list:
            "<li>Task timers, notification scheduler, and calendar blockers</li><li>Notes backlinks, templates, attachments, and drawing sync</li><li>Habit analytics, ledger forecasting, and dashboard widgets</li><li>Journal mood trackers and encrypted attachments</li>"
        },
        phase3: {
          title: "Phase 3 — Encrypted sync & memberships (beta)",
          list:
            "<li>PBKDF2/AES-256-GCM sync with per-collection versioning</li><li>Conflict assistant with revision history</li><li>Membership billing via PayPal/Google Pay and retention tooling</li>"
        },
        phase4: {
          title: "Phase 4 — Integrations & launch (upcoming)",
          list:
            "<li>Cross-platform refinements (Android, iOS, Web, Linux, Windows)</li><li>CI/CD, automated QA, and compliance exports</li><li>Public launch with onboarding, help centre, and API documentation</li>"
        }
      },
      support: {
        heading: "Support the project",
        body: "Tracker is free and ad-free. If you enjoy the app and want to support its development, consider making a small donation.",
        btc: {
          title: "Bitcoin",
          body: "Send BTC directly to the following address:"
        },
        coffee: {
          title: "Buy me a coffee",
          body: "Support the project with a one-time donation via Buy Me a Coffee.",
          link: "Buy me a coffee"
        }
      },
      footer: {
        title: "Tracker",
        body: "Productivity reimagined—local-first, secure, adaptable.",
        linksTitle: "Links",
        contactTitle: "Contact",
        contactEmail: "contact@kay-beckmann.com",
        legal: "© 2025 Tracker. All rights reserved."
      }
    },
    wiki: {
      common: {
        overview: "Wiki overview",
        footer: "© 2025 Tracker. All rights reserved."
      },
      index: {
        meta: {
          title: "Tracker Wiki — Overview"
        },
        title: "Tracker Wiki",
        intro:
          "Detailed guidance for every module: daily workflows, data structures, and synchronisation notes.",
        cards: {
          dashboard: {
            title: "Dashboard",
            body: "Overview, metrics, and quick actions."
          },
          tasks: {
            title: "Tasks & Appointments",
            body: "Planning, calendars, categories, and reminders."
          },
          timeTracking: {
            title: "Time Tracking",
            body: "Sessions, task links, and analytics."
          },
          notes: {
            title: "Notes",
            body: "Markdown, drawings, tags, and search."
          },
          journal: {
            title: "Journal & Mood",
            body: "Daily reflection and mood tracking roadmap."
          },
          habits: {
            title: "Habits",
            body: "Track routines, streaks, and progress."
          },
          ledger: {
            title: "Household Ledger",
            body: "Finances, budgets, and reports."
          },
          settings: {
            title: "Settings",
            body: "Language, theme, modules, and sync."
          },
          support: {
            title: "Support",
            body: "Donate to support the project."
          },
          userGuide: {
            title: "User Guide",
            body: "Getting started and daily workflows."
          },
          technical: {
            title: "Technical Documentation",
            body: "Architecture, APIs, and development."
          }
        },
        security: {
          title: "Data security & retention",
          body:
            "Your data stays under your control. Sync is free and encrypted, and you can delete everything at any time.",
          list:
            "<li>Delete synced data from the server via app settings.</li><li>Delete all local data using the red button in settings.</li><li>Local data on your devices is unaffected by server operations.</li>"
        }
      },
      dashboard: {
        meta: {
          title: "Tracker Wiki — Dashboard"
        },
        title: "Dashboard",
        sections: {
          usage: {
            heading: "Usage",
            list:
              "<li>Landing screen after launch showing membership state, pending syncs, and local-first guidance.</li><li>Displays live metrics such as habit streaks, ledger balance, and currently running timers.</li><li>Quick actions start timers, capture notes, or jump to focus views without leaving the dashboard.</li><li>Widgets adapt to enabled modules and highlight sync status or conflicts.</li>"
          },
          data: {
            heading: "Data model",
            list:
              "<li>Uses Drift table <code>greeting_entries</code> to persist environment messages and onboarding tips.</li><li>Reads Hive boxes for membership status, theme, language, and enabled modules.</li><li>Widget configuration (beta) lives in <code>dashboard_layouts</code> alongside pinned filters.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Dashboard metrics are computed locally; memberships surface encrypted aggregates fetched from the backend.</li><li>Sync badges read from the local queue and remote revision counters (no plaintext leaves the device).</li><li>Widget layouts will sync once the encrypted preference store ships with Phase 3.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Expose custom dashboards and saved filter sets for different contexts.</li><li>Sync widget layouts and preferences across devices with conflict resolution.</li><li>Trigger automations (e.g., remind when a habit streak is at risk) directly from the dashboard.</li>"
          }
        }
      },
      tasks: {
        meta: {
          title: "Tracker Wiki — Tasks & Appointments"
        },
        title: "Tasks & Appointments",
        sections: {
          usage: {
            heading: "Usage",
            list:
              "<li>Plan and prioritise tasks with board, calendar, and smart list filters.</li><li>Attach tags, reminders, linked notes, and ledger references to keep context together.</li><li>Start and stop focus timers directly from any task card.</li><li>Use recurring reminders and mobile notifications to stay on schedule.</li><li>Add tasks instantly via the command palette (Cmd/Ctrl + K).</li>"
          },
          data: {
            heading: "Data model",
            list:
              "<li>Drift table <code>task_entries</code> stores title, status, priority, due date, tags, and remote sync metadata.</li><li>Optional foreign keys link tasks to <code>note_entries</code> and <code>time_entries</code>.</li><li>Reminder schedules are persisted in <code>task_reminders</code> (queue cached in Hive for background delivery).</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Local-first: tasks remain usable offline, with sync metadata tracking pending changes.</li><li>Membership sync encrypts each task payload with PBKDF2-derived AES-256-GCM keys.</li><li>Conflicts reconcile via optimistic locking; revision history allows manual review (beta).</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Recurring task templates with rule-based scheduling.</li><li>Dependencies and checklists within a task card.</li><li>Natural-language quick capture (\"Tomorrow 9am call Alice\").</li><li>Webhook and automation hooks for external integrations.</li>"
          }
        }
      },
      time: {
        meta: {
          title: "Tracker Wiki — Time Tracking"
        },
        title: "Time Tracking",
        sections: {
          usage: {
            heading: "Usage",
            list:
              "<li>Capture focus sessions via one-tap timer or manual entry with rounding rules.</li><li>Link sessions to tasks for billable tracking and progress charts.</li><li>Add notes, classify entries by kind (work, break, learning), and review timeline summaries.</li><li>Lock completed entries to prevent accidental edits after invoicing.</li>"
          },
          data: {
            heading: "Data model",
            list:
              "<li>Drift table <code>time_entries</code> captures start/end timestamps, duration, note, kind, and optional <code>task_id</code>.</li><li>Rounding preferences and timer state live in Hive for instant resume across restarts.</li><li>Summaries are computed through SQL views that aggregate per day, week, and tag.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Offline-first with all time entries cached locally and flagged for sync when membership is active.</li><li>Encrypted sync serialises each entry with AES-256-GCM and optimistic version counters.</li><li>Conflict handling keeps both versions and highlights overlap for manual resolution.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Advanced analytics: charts, heatmaps, and utilisation dashboards.</li><li>Bulk editing tools for multi-select adjustments.</li><li>CSV/JSON exports with template presets for invoicing.</li><li>Automation hooks (auto-start timer when entering focus mode).</li>"
          }
        }
      },
      notes: {
        meta: {
          title: "Tracker Wiki — Notes"
        },
        title: "Notes",
        sections: {
          usage: {
            heading: "Usage",
            list:
              "<li>Write Markdown notes with side-by-side live preview and syntax helpers.</li><li>The first line becomes the title; created and updated timestamps track automatically.</li><li>Tag and search notes, filter by tag or text, and archive when no longer needed.</li><li>Switch to canvas mode for sketches, diagrams, and handwritten annotations.</li>"
          },
          linking: {
            heading: "Linking notes",
            list:
              "<li>Use <code>[[Note Title]]</code> wiki-style syntax to link between notes.</li><li>Links become clickable in preview mode and navigate to the referenced note.</li><li>A notification appears if the linked note does not exist.</li><li>Links also work in journal entries to connect daily reflections with notes.</li>"
          },
          data: {
            heading: "Data model",
            list:
              "<li>Drift table <code>note_entries</code> stores title, content, tags, kind (markdown/drawing), and remote sync metadata.</li><li>Drawings are persisted as JSON vector payloads with optional rendered previews.</li><li>Archive and deletion flags support soft delete before permanent removal.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Notes remain local by default; membership sync envelopes the content using AES-256-GCM.</li><li>Each note carries a version counter to detect conflicts across devices.</li><li>Merge assistant (beta) highlights divergent edits and keeps both copies.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Seed onboarding notes explaining workflows and shortcuts.</li><li>Multi-tag filtering, saved searches, and notebook groupings.</li><li>Template gallery and cross-linking to tasks, journal, and habits.</li><li>Image attachments with optional encrypted sync support.</li>"
          }
        }
      },
      journal: {
        meta: {
          title: "Tracker Wiki — Journal & Mood"
        },
        title: "Journal & Mood Tracker",
        sections: {
          usage: {
            heading: "Usage concept",
            list:
              "<li>Write one entry per day and category using personal or work templates.</li><li>Track mood and custom metrics via journal trackers with timeline visualisations.</li><li>Switch between editor and history tabs to review highlights quickly.</li><li>Protect the journal with optional lock code or biometric unlock.</li>"
          },
          data: {
            heading: "Data model",
            list:
              "<li>Drift tables: <code>journal_entries</code> (markdown content, category, sync metadata) and <code>journal_entry_links</code> (relationships to notes/tasks).</li><li>Trackers live in <code>journal_trackers</code> with daily values in <code>journal_tracker_values</code>.</li><li>Template configuration and lock state are cached in Hive for offline availability.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Entries remain local by default; memberships encrypt text, trackers, and metadata with AES-256-GCM.</li><li>Key rotation ensures old devices cannot read new entries after membership changes.</li><li>Conflict handling preserves both revisions and highlights differences for manual choice.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Attach images, audio, and files to entries with encrypted storage.</li><li>AI-assisted prompts and summaries (opt-in).</li><li>Advanced analytics: streaks, triggers, and correlation with habits/time tracking.</li><li>Shared templates and team reflection modes.</li>"
          }
        }
      },
      habits: {
        meta: {
          title: "Tracker Wiki — Habits"
        },
        title: "Habits",
        sections: {
          usage: {
            heading: "Usage",
            list:
              "<li>Define routines with daily, weekly, or multi-interval cadences.</li><li>Select measurement type: boolean, counter, or duration per habit.</li><li>Visualise streaks, rolling averages, and best series.</li><li>Annotate streak breaks with notes for future reflection.</li>"
          },
          data: {
            heading: "Data model",
            list:
              "<li>Drift tables: <code>habit_definitions</code> (meta, cadence, measurement) and <code>habit_logs</code> (date, value, note, sync metadata).</li><li>Rolling aggregates for streaks and trends are computed via SQL views.</li><li>Remote IDs and version counters support encrypted sync.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Habits work offline; pending logs are queued until membership sync runs.</li><li>Encrypted sync serialises each log with AES-256-GCM and merges by timestamp.</li><li>Conflicts retain the higher completion value and record both revisions.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Habit templates and sharing.</li><li>Calendar heatmaps and anomaly alerts.</li><li>Automation hooks that trigger habits from tasks or time tracking.</li><li>Export streak summaries for accountability partners.</li>"
          }
        }
      },
      ledger: {
        meta: {
          title: "Tracker Wiki — Household Ledger"
        },
        title: "Household Ledger",
        sections: {
          usage: {
            heading: "Usage",
            list:
              "<li>Track income, expenses, transfers, and recurring payments per account.</li><li>Assign categories, tags, and payment methods for granular reporting.</li><li>Set budgets with live progress and overspend alerts.</li><li>Filter by time range, account, or tag and export to CSV (beta).</li>"
          },
          data: {
            heading: "Data model",
            list:
              "<li>Drift tables: <code>ledger_accounts</code>, <code>ledger_categories</code>, <code>ledger_transactions</code>, <code>ledger_budgets</code>, and <code>ledger_recurring_transactions</code>.</li><li>Transactions include amount, currency, kind (income/expense/transfer), category, source/destination account, and optional memo.</li><li>Monthly roll-ups and net-worth snapshots are cached for dashboard performance.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Local-first ledger keeps all financial data on device by default.</li><li>Membership sync encrypts each transaction with AES-256-GCM; recurring templates sync separately.</li><li>Conflicts preserve both revisions and mark transactions for manual review.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Interactive charts for category trends, cashflow, and net worth.</li><li>Rule-based categorisation with automatic reconciliations.</li><li>Receipt capture via photos with OCR (research).</li><li>Shared budgets and household collaboration.</li>"
          }
        }
      },
      settings: {
        meta: {
          title: "Tracker Wiki — Settings"
        },
        title: "Settings",
        sections: {
          usage: {
            heading: "Usage",
            list:
              "<li>Manage authentication via email/password or Google Sign-In.</li><li>Enable or disable modules, reorder navigation, and change accent colour.</li><li>Switch language or theme instantly; preferences persist offline.</li><li>Trigger encrypted backups and review storage usage (beta).</li>"
          },
          notesJournal: {
            heading: "Notes & Journal",
            list:
              "<li>Choose the default view (Editor or Preview) when opening notes and journal entries.</li><li>Editor mode opens notes ready for typing; Preview mode shows rendered Markdown.</li><li>The setting applies to both the Notes module and the Journal module.</li><li>This preference syncs across devices when using membership sync.</li>"
          },
          data: {
            heading: "Data model",
            list:
              "<li>Preferences stored in Hive boxes with optional encrypted export.</li><li>Server retains hashed credentials and Google OAuth linkage only.</li><li>Upcoming <code>user_preferences</code> collection will sync module settings and layouts.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Preferences remain local-first; sync encrypts selected settings with AES-256-GCM.</li><li>Module order and theme sync once the encrypted preference store is enabled.</li><li>Sensitive secrets (biometric keys, lock codes) never leave the device.</li>"
          },
          deleteData: {
            heading: "Delete all local data",
            list:
              "<li>A red danger button at the bottom of settings allows complete local data deletion.</li><li>Deletes all notes, tasks, time entries, journal entries, habits, and financial data.</li><li>A confirmation dialog prevents accidental deletion.</li><li>After deletion, the app restarts with a fresh database.</li><li>Synced copies on the server remain intact until manually deleted.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Import/export settings bundles across devices.</li><li>Advanced diagnostics for sync conflicts and encryption status.</li><li>Automated backup rotation with retention policies.</li>"
          }
        }
      },
      support: {
        meta: {
          title: "Tracker Wiki — Support the Project"
        },
        title: "Support the Project",
        intro:
          "Tracker is free and ad-free. If you enjoy the app and want to support its continued development, consider making a small donation.",
        sections: {
          bitcoin: {
            heading: "Bitcoin",
            body: "You can send Bitcoin directly to the following address:"
          },
          coffee: {
            heading: "Buy me a coffee",
            body: "Support the project with a one-time donation via Buy Me a Coffee:",
            link: "Buy me a coffee"
          },
          other: {
            heading: "Other ways to help",
            list:
              "<li>Share Tracker with friends and colleagues who might find it useful.</li><li>Report bugs and suggest features via the feedback channels.</li><li>Leave a positive review if the app is available on your platform's store.</li>"
          }
        }
      },
      userGuide: {
        meta: {
          title: "Tracker Wiki — User Guide"
        },
        title: "User Guide",
        intro: "This guide helps you get started with Tracker and make the most of its features.",
        sections: {
          gettingStarted: {
            heading: "Getting Started",
            list:
              "<li>Download Tracker for your platform or use the web app directly.</li><li>No account required — all features work offline immediately.</li><li>Enable only the modules you need in Settings.</li><li>Optionally sign in to sync your data across devices for free.</li>"
          },
          sync: {
            heading: "Free Cloud Sync",
            list:
              "<li>Sign in with email/password or Google to enable sync.</li><li>All data is encrypted end-to-end before leaving your device.</li><li>Sync is completely free — no subscription required.</li><li>Access your data from any device: mobile, desktop, or web.</li>"
          },
          dataControl: {
            heading: "Data Control",
            list:
              "<li>Your data belongs to you — delete it anytime from settings.</li><li>Use \"Delete synced data\" to remove server copies while keeping local data.</li><li>Use the red \"Delete all local data\" button to completely reset the app.</li><li>A confirmation dialog prevents accidental deletion.</li>"
          },
          modules: {
            heading: "Module Overview",
            list:
              "<li><strong>Dashboard:</strong> Your personal overview with quick actions and metrics.</li><li><strong>Tasks:</strong> Plan tasks with priorities, due dates, and reminders.</li><li><strong>Notes:</strong> Write Markdown notes or create freehand drawings.</li><li><strong>Journal:</strong> Daily reflection with optional mood tracking.</li><li><strong>Habits:</strong> Build routines and track streaks.</li><li><strong>Ledger:</strong> Manage finances with budgets and reports.</li><li><strong>Time Tracking:</strong> Log focus sessions and link them to tasks.</li>"
          },
          tips: {
            heading: "Tips & Tricks",
            list:
              "<li>Use the dashboard quick actions to capture ideas fast.</li><li>Link time entries to tasks for better productivity insights.</li><li>Enable the journal lock for privacy protection.</li><li>Export data regularly if you want local backups.</li>"
          }
        }
      },
      technical: {
        meta: {
          title: "Tracker Wiki — Technical Documentation"
        },
        title: "Technical Documentation",
        intro: "Detailed technical information about Tracker's architecture, data models, and implementation.",
        sections: {
          architecture: {
            heading: "Architecture Overview",
            list:
              "<li><strong>Frontend:</strong> Flutter app targeting Android, iOS, Web, Windows, and Linux.</li><li><strong>Local Storage:</strong> Drift (SQLite) for structured data, Hive for preferences and secrets.</li><li><strong>Backend:</strong> FastAPI server with PostgreSQL for sync and authentication.</li><li><strong>Encryption:</strong> PBKDF2-HMAC-SHA256 key derivation with AES-256-GCM encryption.</li>"
          },
          database: {
            heading: "Database Schema",
            list:
              "<li><code>greeting_entries</code> — Dashboard messages and onboarding tips.</li><li><code>note_entries</code> — Markdown and drawing notes with tags.</li><li><code>task_entries</code> — Tasks with priority, due date, and reminders.</li><li><code>time_entries</code> — Time tracking sessions with optional task links.</li><li><code>journal_entries</code> — Daily journal with categories.</li><li><code>journal_trackers</code> / <code>journal_tracker_values</code> — Custom mood/metric trackers.</li><li><code>habit_definitions</code> / <code>habit_logs</code> — Habit tracking with streaks.</li><li><code>ledger_*</code> — Accounts, transactions, budgets, categories, recurring templates.</li><li><code>sync_tombstones</code> — Tracks deleted items for sync.</li>"
          },
          encryption: {
            heading: "Encryption Pipeline",
            list:
              "<li>Master key derived from user password using PBKDF2-HMAC-SHA256 (150k iterations).</li><li>Each sync payload encrypted with AES-256-GCM using unique IVs.</li><li>Per-device salts ensure keys differ across devices.</li><li>Server stores only ciphertext — zero-knowledge architecture.</li><li>Key rotation supported after password changes.</li>"
          },
          sync: {
            heading: "Synchronisation Protocol",
            list:
              "<li>REST/JSON API over TLS 1.3 with short-lived JWT authentication.</li><li>Optimistic locking with version counters per entity.</li><li>Incremental sync using changelog endpoints.</li><li>Conflict detection with revision history (manual resolution).</li><li>Tombstone tracking for deletions across devices.</li>"
          },
          deleteData: {
            heading: "Data Deletion Implementation",
            list:
              "<li>Local deletion uses platform-specific implementations via conditional imports.</li><li><strong>iOS/Android:</strong> Closes database and deletes <code>tracker.sqlite</code> file.</li><li><strong>Web:</strong> Closes database and deletes IndexedDB <code>tracker_database</code>.</li><li>Hive preferences box cleared separately if full reset needed.</li><li>App calls <code>main()</code> to reinitialize after deletion.</li>"
          },
          api: {
            heading: "Backend API Endpoints",
            list:
              "<li><code>POST /api/auth/register</code> — Create account with email/password.</li><li><code>POST /api/auth/login</code> — Authenticate and receive JWT.</li><li><code>POST /api/auth/google</code> — OAuth login with Google.</li><li><code>GET/POST /api/sync/{collection}</code> — Fetch/push encrypted collection data.</li><li><code>POST /api/membership/delete_synced_data</code> — Delete all server-side data.</li>"
          },
          development: {
            heading: "Development Setup",
            list:
              "<li>Flutter SDK 3.8+ required for app development.</li><li>Run <code>flutter pub get</code> to install dependencies.</li><li>Generate Drift code: <code>dart run build_runner build</code>.</li><li>Backend requires Python 3.11+, FastAPI, and PostgreSQL.</li><li>Docker Compose available for full-stack local development.</li>"
          }
        }
      }
    },
    legal: {
      privacy: {
        meta: {
          title: "Tracker — Privacy Policy"
        },
        title: "Privacy Policy",
        updated: "Effective: update pending",
        sections: {
          controller: {
            heading: "1. Controller",
            body:
              "Kay Beckmann<br /><span>Address to be added</span><br />Email: <a href=\"mailto:kontakt@tracker-app.dev\">kontakt@tracker-app.dev</a>"
          },
          general: {
            heading: "2. General information",
            body:
              "Protecting your personal data matters to us. This statement explains which data we collect when you visit the website, use the web app, or subscribe to Tracker, how we process it, and the rights available to you."
          },
          website: {
            heading: "3. Providing the website",
            body1:
              "When you access our pages, the web server automatically stores information transmitted by your browser. This may include the IP address, browser type, date and time of the request, and the requested resource. Processing is based on our legitimate interest in a stable and secure service (Art. 6(1)(f) GDPR).",
            body2:
              "Server log files are deleted automatically as soon as they are no longer required for the purpose for which they were collected."
          },
          contact: {
            heading: "4. Contact",
            body1:
              "If you contact us by email, we process the data you provide in order to respond to your request. Processing is based on Art. 6(1)(b) GDPR when your request relates to contractual obligations, otherwise on our legitimate interest in answering enquiries (Art. 6(1)(f) GDPR).",
            body2:
              "We retain your information until the purpose of storage no longer applies or you ask us to delete it, provided no statutory retention obligations apply."
          },
          app: {
            heading: "5. Using the Tracker web app",
            body1:
              "The web app can be used locally without a user account. In that case all data is stored exclusively in your browser. Optional synchronisation features require an account; we process registration details, encrypted usage data, and technical metadata in that context.",
            list:
              "<li><strong>Purpose:</strong> Providing the app and synchronisation features</li><li><strong>Legal basis:</strong> Art. 6(1)(b) GDPR (contract fulfilment)</li><li><strong>Retention:</strong> Until membership is cancelled or statutory retention periods lapse</li>"
          },
          payments: {
            heading: "6. Payment processing",
            body:
              "Payments for Tracker memberships are handled by external payment providers. Once a provider is integrated, we will supply detailed information about the service used and the associated data processing here."
          },
          infrastructure: {
            heading: "7. Hosting and infrastructure",
            body:
              "Tracker services run inside containerised environments (Docker). Internal traffic between services is secured, and PostgreSQL is used for database operations. Regular backups are created and stored in encrypted form."
          },
          recipients: {
            heading: "8. Recipients",
            body:
              "We only share personal data with third parties when necessary to perform a contract, when legally required, or when you have given your consent. Data is not transferred to third countries unless explicitly stated."
          },
          rights: {
            heading: "9. Your rights",
            body:
              "Under applicable law you have the following rights:",
            list:
              "<li>Access to your stored data (Art. 15 GDPR)</li><li>Rectification of inaccurate data (Art. 16 GDPR)</li><li>Erasure of personal data (Art. 17 GDPR)</li><li>Restriction of processing (Art. 18 GDPR)</li><li>Data portability (Art. 20 GDPR)</li><li>Objection to certain processing (Art. 21 GDPR)</li><li>Withdrawal of consent granted (Art. 7(3) GDPR)</li>",
            body2:
              "You also have the right to lodge a complaint with the competent supervisory authority. In Germany this is generally the data protection authority of the federal state in which you reside."
          },
          security: {
            heading: "10. Security",
            body:
              "We implement technical and organisational measures to protect your data against manipulation, loss, or unauthorised access. Measures include access restrictions, encryption for synchronised data, and regular software updates."
          }
        }
      },
      imprint: {
        meta: {
          title: "Tracker — Legal Notice",
          label: "Information pursuant to § 5 TMG"
        },
        title: "Legal Notice",
        sections: {
          provider: {
            heading: "Service provider",
            body:
              "Kay Beckmann<br /><span>Address to be added</span>",
            contact:
              "Contact:<br />Email: <a href=\"mailto:kontakt@tracker-app.dev\">kontakt@tracker-app.dev</a><br />Phone: <span>optional</span>"
          },
          represented: {
            heading: "Authorised representative",
            body: "Kay Beckmann"
          },
          content: {
            heading: "Responsible for content (§ 55 Abs. 2 RStV)",
            body:
              "Kay Beckmann<br /><span>Address to be added</span>"
          },
          liabilityContent: {
            heading: "Liability for content",
            body1:
              "As a service provider we are responsible for our own content on these pages in accordance with § 7(1) TMG and general laws. Under §§ 8 to 10 TMG we are not obliged to monitor transmitted or stored third-party information or to investigate circumstances indicating unlawful activity. Obligations to remove or block the use of information under general laws remain unaffected.",
            body2:
              "Liability is only possible from the time we become aware of a specific infringement. Upon notification of corresponding violations we will remove such content immediately."
          },
          liabilityLinks: {
            heading: "Liability for links",
            body1:
              "Our offer contains links to external third-party websites whose content we cannot influence. Therefore we cannot assume any liability for such external content. The respective provider or operator of the pages is always responsible for the content of the linked pages. The linked pages were checked for possible legal violations at the time the link was created and no unlawful content was recognisable.",
            body2:
              "Permanent monitoring of the linked pages is not reasonable without concrete evidence of a violation. As soon as we become aware of legal infringements we will remove such links immediately."
          },
          copyright: {
            heading: "Copyright",
            body1:
              "The content and works created by the site operators are subject to German copyright law. Duplication, editing, distribution, and any form of utilisation outside the limits of copyright law require written consent from the respective author or creator. Downloads and copies of this site are permitted only for private, non-commercial use.",
            body2:
              "Insofar as content on this site was not created by the operator, the copyrights of third parties are respected and such content is labelled accordingly. Should you nevertheless become aware of a copyright infringement, please inform us. Upon notification of violations we will remove the content immediately."
          },
          dispute: {
            heading: "Alternative dispute resolution",
            body:
              "The European Commission provides a platform for online dispute resolution (OS): <a href=\"https://ec.europa.eu/consumers/odr/\" target=\"_blank\" rel=\"noopener\">https://ec.europa.eu/consumers/odr/</a>. We are neither obliged nor willing to participate in dispute resolution proceedings before a consumer arbitration board."
          }
        },
        nav: {
          home: "Back to homepage",
          privacy: "Privacy policy"
        }
      }
    }
  },
  de: {
    common: {
      brand: "Tracker",
      nav: {
        vision: "Vision",
        modules: "Module",
        gallery: "Galerie",
        sync: "Sync-Modi",
        architecture: "Architektur",
        availability: "Downloads",
        roadmap: "Roadmap",
        wiki: "Wiki",
        imprint: "Impressum",
        privacy: "Datenschutz"
      }
    },
    homepage: {
      meta: {
        title: "Tracker - Persönliche Produktivitätssuite"
      },
      hero: {
        title: "Tracker",
        subtitle:
          "Die local-first Produktivitäts-Suite für Planung, Wissensmanagement, Journal und verschlüsselte Synchronisation auf Mobilgeräten, Desktop und Web.",
        ctaPrimary: "Neuigkeiten entdecken",
        ctaSecondary: "Wiki öffnen"
      },
      vision: {
        heading: "Warum Tracker?",
        body:
          "Tracker vereint Aufgaben, Notizen, Tagebuch, Gewohnheiten, Finanzen und Zeiterfassung in einem local-first Cockpit. Alles läuft offline mit Drift-Storage, oder nutze kostenlos verschlüsselten Sync auf all deinen Geräten.",
        cards: {
          offline: {
            title: "Local first",
            body: "Alle Module laufen auf deinem Gerät ohne Pflicht-Account – perfekt für Privatsphäre und Reisen."
          },
          encrypted: {
            title: "Verschlüsselte Cloud",
            body: "Kostenloser Zero-Knowledge-Sync mit Hintergrund-Konflikterkennung und Aufbewahrungsrichtlinien."
          },
          modular: {
            title: "Modular & anpassbar",
            body: "Aktiviere nur benötigte Module, automatisiere Übergaben und passe Farben sowie Layout an."
          }
        }
      },
      modules: {
        heading: "Die Module im Überblick",
        dashboard: {
          title: "Dashboard",
          body: "Persönliches Cockpit mit Highlights aller Module.",
          list:
            "<li>Live-Status-Karten für Gewohnheiten, Kontostände und Timer (verfügbar)</li><li>Schnellaktionen zum Starten der Zeiterfassung, Notizen erfassen oder Fokusansichten öffnen (verfügbar)</li><li>Individuelles Widget-Raster mit angepinnten Filtern (Beta)</li>"
        },
        tasks: {
          title: "Aufgaben & Termine",
          body: "Plane Aufgaben, Deadlines, Erinnerungen und Kalenderereignisse gemeinsam.",
          list:
            "<li>Kalenderintegriertes Board mit farbcodierten Prioritäten (verfügbar)</li><li>Detailansicht mit Tags, Erinnerungen und verknüpften Notizen (verfügbar)</li><li>Start/Stopp-Fokustimer direkt an der Aufgabe (verfügbar)</li>"
        },
        notes: {
          title: "Notizen",
          body: "Flexibler Markdown-Wissensspeicher mit Zeichenunterstützung.",
          list:
            "<li>Markdown-Editor mit Tag-Suche, Backlinks und Inline-Anhängen (verfügbar)</li><li>Freihand-Zeichnungen und Canvas-Modus für visuelles Denken (verfügbar)</li><li>Wiederverwendbare Vorlagen und Multi-Tag-Filter (Beta)</li>"
        },
        journal: {
          title: "Journal & Mood Tracker",
          body: "Tägliche Reflexion mit optionalem App-Lock, Stimmungstrackern und Highlights.",
          list:
            "<li>Tages- und Wochenansichten mit Stimmungsverlauf und Prompts (Beta)</li><li>Optionaler App-Lock inkl. biometrischem Entsperren (verfügbar)</li><li>Verknüpfungen zu Notizen und Aufgaben für Kontext (in Entwicklung)</li>"
        },
        habits: {
          title: "Habits",
          body: "Baue Routinen mit Serien, Zählern und Insights auf.",
          list:
            "<li>Tägliche, wöchentliche oder mehrfache Ziele mit flexiblen Einheiten (verfügbar)</li><li>Trenddiagramme und Intervallvergleiche mit Streak-Schutz (verfügbar)</li><li>Vorlagen-Bibliothek und geteilte Routinen (Roadmap)</li>"
        },
        ledger: {
          title: "Haushaltsbuch",
          body: "Behalte Ausgaben, Budgets und Reports im Blick.",
          list:
            "<li>Mehrkonten-Haushaltsbuch mit wiederkehrenden Buchungen (verfügbar)</li><li>Budgets, Kategorienfilter und Abstimmungs-Tools (verfügbar)</li><li>Analysen mit rollierenden Forecasts und Sync-Exports (Beta)</li>"
        },
        timeTracking: {
          title: "Zeiterfassung",
          body: "Erfasse Fokus-Sessions und verknüpfe sie mit Aufgaben.",
          list:
            "<li>One-Tap-Timer mit automatischem Runden und Tagging (verfügbar)</li><li>Tages- und Wochenreports plus Auslastungsansichten (verfügbar)</li><li>CSV-Exporte und Automations-Hooks (Roadmap)</li>"
        },
        settings: {
          title: "Einstellungen",
          body: "Steuere Sprache, Theme, Module und Synchronisation.",
          list:
            "<li>Login per E-Mail/Passwort oder Google Sign-In inkl. Mitgliedschaftsstatus (verfügbar)</li><li>Sprach-, Theme- und Akzentfarbwechsel in Echtzeit (verfügbar)</li><li>Modulreihenfolge, Backups und Sync-Diagnose (Beta)</li>"
        }
      },
      gallery: {
        heading: "Ein Blick in die Arbeitsoberfläche",
        body:
          "Jedes Modul läuft lokal, reagiert sofort und synchronisiert nur auf Wunsch. Diese Mock-ups zeigen den aktuellen Stand der Android- und Desktop-Builds.",
        dashboardPlaceholder: "Dashboard-Vorschau",
        dashboard: "Dashboard mit Live-Streaks, aktuellen Aufgaben und Haushaltsbuch-Saldo auf einen Blick.",
        tasksPlaceholder: "Aufgaben-Vorschau",
        tasks: "Kalendergestütztes Aufgabenboard mit integrierten Timern und Benachrichtigungen.",
        ledgerPlaceholder: "Haushaltsbuch-Vorschau",
        ledger: "Haushaltsbuch-Analysen mit Budgets, wiederkehrenden Zahlungen und Transfers."
      },
      sync: {
        heading: "Lokal zuerst oder verschlüsselte Cloud",
        body:
          "Wähle den Modus, der zu deinem Datenschutz passt. Tracker funktioniert komplett offline, oder synchronisiere kostenlos mit Ende-zu-Ende-Verschlüsselung.",
        local: {
          title: "Nur lokal",
          list:
            "<li>Alle Daten leben in einer lokalen Drift-/Hive-Datenbank</li><li>Kein Account nötig – der komplette Funktionsumfang ist offline nutzbar</li><li>Exportiere verschlüsselte Backups oder arbeite komplett luftgetrennt</li>"
        },
        cloud: {
          title: "Verschlüsselte Synchronisation",
          list:
            "<li>Ende-zu-Ende-Verschlüsselung (PBKDF2 + AES-256-GCM) mit Geräteschlüsseln</li><li>Zugriff auf Android, iOS (Beta), Desktop und Web</li><li>Komplett kostenlos – kein Abo erforderlich</li>"
        }
      },
      security: {
        heading: "Datenschutz & Aufbewahrung",
        body:
          "Tracker speichert synchronisierte Inhalte nicht dauerhaft. Du behältst jederzeit die volle Kontrolle über deine Daten.",
        manual: {
          title: "Sofortiges Löschen",
          body:
            "Lösche synchronisierte Kopien jederzeit in den App-Einstellungen. Lokale Daten auf deinen Geräten bleiben erhalten."
        },
        local: {
          title: "Alle lokalen Daten löschen",
          body:
            "Nutze den roten Button in den Einstellungen, um alle lokalen Daten dauerhaft von deinem Gerät zu löschen. Ein Bestätigungsdialog verhindert versehentliches Löschen."
        }
      },
      architecture: {
        heading: "Architektur & Sicherheit",
        body:
          "Tracker folgt einem Local-First-Ansatz: Drift verwaltet eine verschlüsselte SQLite-Datenbank pro Gerät, der Server speichert ausschließlich Ciphertexte. Die Sync-Endpunkte sprechen REST/JSON über TLS 1.3; die Authentifizierung nutzt kurzlebige JWTs.",
        storage: {
          title: "On-Device-Tresor",
          list:
            "<li>Drift + SQLite für strukturierte Daten, Hive für Geheimnisse und Einstellungen</li><li>Automatische Nacht-Snapshots mit rollierender Aufbewahrung (Beta)</li><li>Modulweise Export/Import für Compliance und Wiederherstellung</li>"
        },
        security: {
          title: "Verschlüsselungskette",
          list:
            "<li>PBKDF2-HMAC-SHA256 mit 150k Iterationen erzeugt 256-Bit-Schlüssel</li><li>AES-256-GCM schützt Notizen, Aufgaben, Habits, Ledger und Journal beim Sync</li><li>Gerätespezifische Salze, Lockout-Guards und Key-Rotation nach Mitgliedschaftsänderungen</li>"
        },
        protocols: {
          title: "Protokolle & APIs",
          list:
            "<li>FastAPI-Backend mit optimistischer Sperrung und Versionszählern</li><li>Inkrementelle Sync-APIs mit serverseitiger Konflikterkennung</li><li>Google OAuth, Zugriffstoken und geplantes Argon2id für Passwörter</li>"
        }
      },
      availability: {
        heading: "Verfügbarkeit & Downloads",
        web: {
          title: "Web-App",
          body: "Installierbare Progressive Web App mit Offline-Cache und biometrischem Unlock (unterstützte Geräte).",
          link: "Jetzt öffnen"
        },
        playStore: {
          title: "Google Play Store",
          body: "Sideload-APK-Builds erscheinen zu jedem Release; Play-Store-Listing befindet sich im Review.",
          link: "Listing ansehen"
        },
        windows: {
          title: "Windows-Download",
          body: "Installer wird aktuell paketiert – öffentlicher Download folgt nach QA.",
          link: "Installer folgt"
        },
        linux: {
          title: "Linux-Download",
          body: "AppImage/Flatpak-Pakete in Arbeit – Veröffentlichung nach automatisierten Tests.",
          link: "AppImage folgt"
        }
      },
      roadmap: {
        heading: "Roadmap & aktueller Status",
        body: "Wir entwickeln in fokussierten Phasen: zuerst das local-first Fundament härten, dann verschlüsselten Sync, Automationen und Integrationen ergänzen.",
        phase1: {
          title: "Phase 1 - Local-First-Fundament (abgeschlossen)",
          list:
            "<li>Drift/Hive-Speicher, Migrationen und Backup-Subsystem</li><li>Modulares UI mit Dashboard, Aufgaben, Notizen, Habits, Haushaltsbuch, Journal und Zeiterfassung</li><li>Lokalisierung (DE/EN/SV) mit Laufzeit-Sprachumschaltung</li>"
        },
        phase2: {
          title: "Phase 2 - Module verfeinern & automatisieren (läuft)",
          list:
            "<li>Aufgaben-Timer, Benachrichtigungsscheduler und Kalender-Blocker</li><li>Notiz-Backlinks, Vorlagen, Anhänge und Zeichnungs-Sync</li><li>Habit-Analysen, Haushaltsbuch-Forecasts und Dashboard-Widgets</li><li>Journal-Moodtracker und verschlüsselte Anhänge</li>"
        },
        phase3: {
          title: "Phase 3 - Verschlüsselter Sync & Mitgliedschaften (Beta)",
          list:
            "<li>PBKDF2/AES-256-GCM-Sync mit Versionszählern</li><li>Konflikt-Assistent mit Versionshistorie</li><li>Mitgliedschaften via PayPal/Google Pay plus Aufbewahrungstools</li>"
        },
        phase4: {
          title: "Phase 4 - Integrationen & Launch (anstehend)",
          list:
            "<li>Plattform-Finishing (Android, iOS, Web, Linux, Windows)</li><li>CI/CD, automatisierte QA und Compliance-Exporte</li><li>Launch mit Onboarding, Help-Center und API-Dokumentation</li>"
        }
      },
      support: {
        heading: "Unterstütze das Projekt",
        body: "Tracker ist kostenlos und werbefrei. Wenn dir die App gefällt und du die Entwicklung unterstützen möchtest, freue ich mich über eine kleine Spende.",
        btc: {
          title: "Bitcoin",
          body: "Sende BTC direkt an folgende Adresse:"
        },
        coffee: {
          title: "Buy me a coffee",
          body: "Unterstütze das Projekt mit einer einmaligen Spende über Buy Me a Coffee.",
          link: "Buy me a coffee"
        }
      },
      footer: {
        title: "Tracker",
        body: "Produktivität neu gedacht - lokal, sicher, flexibel.",
        linksTitle: "Links",
        contactTitle: "Kontakt",
        contactEmail: "contact@kay-beckmann.com",
        legal: "© 2025 Tracker. Alle Rechte vorbehalten."
      }
    },
    wiki: {
      common: {
        overview: "Wiki-Übersicht",
        footer: "© 2025 Tracker. Alle Rechte vorbehalten."
      },
      index: {
        meta: {
          title: "Tracker Wiki - Übersicht"
        },
        title: "Tracker Wiki",
        intro:
          "Detaillierte Anleitungen für jedes Modul: tägliche Workflows, Datenstrukturen und Synchronisationshinweise.",
        cards: {
          dashboard: {
            title: "Dashboard",
            body: "Überblick, Kennzahlen und Schnellaktionen."
          },
          tasks: {
            title: "Aufgaben & Termine",
            body: "Planung, Kalender, Kategorien und Erinnerungen."
          },
          timeTracking: {
            title: "Zeiterfassung",
            body: "Sessions, Aufgaben-Verknüpfung und Analysen."
          },
          notes: {
            title: "Notizen",
            body: "Markdown, Zeichnungen, Tags und Suche."
          },
          journal: {
            title: "Journal & Stimmung",
            body: "Tägliche Reflexion und Mood-Tracking-Roadmap."
          },
          habits: {
            title: "Habits",
            body: "Routinen, Serien und Fortschritt verfolgen."
          },
          ledger: {
            title: "Haushaltsbuch",
            body: "Finanzen, Budgets und Berichte."
          },
          settings: {
            title: "Einstellungen",
            body: "Sprache, Theme, Module und Sync."
          },
          support: {
            title: "Unterstützung",
            body: "Spende, um das Projekt zu unterstützen."
          },
          userGuide: {
            title: "Benutzerhandbuch",
            body: "Erste Schritte und tägliche Workflows."
          },
          technical: {
            title: "Technische Dokumentation",
            body: "Architektur, APIs und Entwicklung."
          }
        },
        security: {
          title: "Datenschutz & Aufbewahrung",
          body:
            "Deine Daten bleiben unter deiner Kontrolle. Sync ist kostenlos und verschlüsselt, und du kannst alles jederzeit löschen.",
          list:
            "<li>Synchronisierte Daten über die Einstellungen vom Server löschen.</li><li>Alle lokalen Daten mit dem roten Button in den Einstellungen löschen.</li><li>Lokale Daten auf deinen Geräten bleiben von Server-Operationen unberührt.</li>"
        }
      },
      dashboard: {
        meta: {
          title: "Tracker Wiki - Dashboard"
        },
        title: "Dashboard",
        sections: {
          usage: {
            heading: "Bedienung",
            list:
              "<li>Startansicht mit Mitgliedschaftsstatus, offenen Syncs und Local-First-Hinweisen.</li><li>Zeigt Live-Kennzahlen wie Habit-Streaks, Haushaltsbuch-Saldo und laufende Timer.</li><li>Schnellaktionen starten Timer, erfassen Notizen oder öffnen Fokus-Ansichten.</li><li>Widgets passen sich aktivierten Modulen an und markieren Sync- oder Konfliktstatus.</li>"
          },
          data: {
            heading: "Datenmodell",
            list:
              "<li>Drift-Tabelle <code>greeting_entries</code> speichert Umgebungsnachrichten und Onboarding-Hinweise.</li><li>Hive-Boxen liefern Mitgliedschaft, Theme, Sprache und Modulstatus.</li><li>Widget-Konfiguration (Beta) liegt in <code>dashboard_layouts</code> mit angepinnten Filtern.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Kennzahlen werden lokal berechnet; Mitgliedschaften laden verschlüsselte Aggregationen.</li><li>Sync-Badges lesen den lokalen Queue und Remote-Versionszähler.</li><li>Widget-Layouts synchronisieren, sobald der verschlüsselte Präferenzspeicher aktiv ist.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Eigene Dashboards und gespeicherte Filter für verschiedene Kontexte.</li><li>Synchronisierte Widget-Layouts mit Konfliktauflösung.</li><li>Automationen wie Streak-Warnungen direkt vom Dashboard auslösen.</li>"
          }
        }
      },
      tasks: {
        meta: {
          title: "Tracker Wiki - Aufgaben & Termine"
        },
        title: "Aufgaben & Termine",
        sections: {
          usage: {
            heading: "Bedienung",
            list:
              "<li>Plane und priorisiere Aufgaben mit Board-, Listen- und Kalenderansichten.</li><li>Füge Tags, Erinnerungen, verknüpfte Notizen und Ledger-Referenzen hinzu.</li><li>Starte/Stopp Fokustimer direkt an jeder Aufgabe.</li><li>Nutze wiederkehrende Erinnerungen und mobile Benachrichtigungen.</li><li>Schnellerfassung über die Befehlspalette (Cmd/Ctrl + K).</li>"
          },
          data: {
            heading: "Datenmodell",
            list:
              "<li>Drift-Tabelle <code>task_entries</code> speichert Titel, Status, Priorität, Fälligkeit, Tags und Sync-Metadaten.</li><li>Optionale Fremdschlüssel verbinden Aufgaben mit <code>note_entries</code> und <code>time_entries</code>.</li><li>Reminder-Zeitpläne liegen in <code>task_reminders</code> (Queue in Hive für Hintergrundzustellung).</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Offline-first: Aufgaben bleiben nutzbar, Sync-Metadaten kennzeichnen offene Änderungen.</li><li>Mitgliedschaften verschlüsseln jede Aufgabe mit PBKDF2/AES-256-GCM.</li><li>Konflikte werden über optimistisches Locking erkannt; Versionshistorie erlaubt manuelle Prüfung (Beta).</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
            "<li>Wiederkehrende Aufgaben-Templates mit Regelwerk.</li><li>Abhängigkeiten und Checklisten innerhalb einer Aufgabe.</li><li>Sprach- und Kurzbefehle (&quot;Morgen 9 Uhr: Alice anrufen&quot;).</li><li>Webhook-/Automationshooks für externe Integrationen.</li>"
          }
        }
      },
      time: {
        meta: {
          title: "Tracker Wiki - Zeiterfassung"
        },
        title: "Zeiterfassung",
        sections: {
          usage: {
            heading: "Bedienung",
            list:
              "<li>Sessions mit One-Tap-Timer starten oder manuell mit Rundungsregeln erfassen.</li><li>Sitzungen Aufgaben zuordnen für abrechenbare Zeiten und Fortschrittsanalysen.</li><li>Notizen hinzufügen, Typen (Arbeit, Pause, Lernen) vergeben und die Timeline auswerten.</li><li>Abgeschlossene Einträge sperren, um versehentliche Änderungen zu vermeiden.</li>"
          },
          data: {
            heading: "Datenmodell",
            list:
              "<li>Drift-Tabelle <code>time_entries</code> enthält Start/Ende, Dauer, Notiz, Typ und optionales <code>task_id</code>.</li><li>Rundungspräferenzen und Timerstatus liegen in Hive für schnellen Resume.</li><li>Summaries entstehen über SQL-Views für Tages-, Wochen- und Tag-Auswertungen.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Offline-first; offene Einträge bleiben markiert, bis der Mitgliedschafts-Sync sie sendet.</li><li>Verschlüsselter Sync serialisiert jeden Eintrag mit AES-256-GCM und Versionszähler.</li><li>Konflikte behalten beide Versionen und heben Überschneidungen hervor.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Erweiterte Analysen: Charts, Heatmaps und Auslastungs-Boards.</li><li>Mehrfachbearbeitung und Tag-Bulk-Operationen.</li><li>CSV/JSON-Exporte mit Vorlagen für Abrechnung.</li><li>Automationen wie Auto-Start bei Fokusmodus.</li>"
          }
        }
      },
      notes: {
        meta: {
          title: "Tracker Wiki - Notizen"
        },
        title: "Notizen",
        sections: {
          usage: {
            heading: "Bedienung",
            list:
              "<li>Markdown-Notizen mit Live-Vorschau und Split-View verfassen.</li><li>Die erste Zeile wird zum Titel; Erstell- und Änderungszeiten werden automatisch gepflegt.</li><li>Notizen taggen, per Volltext suchen, archivieren oder duplizieren.</li><li>In den Canvas-Modus wechseln für Skizzen, Diagramme und handschriftliche Notizen.</li>"
          },
          linking: {
            heading: "Notizen verlinken",
            list:
              "<li>Mit <code>[[Notiz-Titel]]</code> Wiki-Syntax zwischen Notizen verlinken.</li><li>Links werden in der Vorschau klickbar und navigieren zur referenzierten Notiz.</li><li>Existiert die verlinkte Notiz nicht, erscheint eine Hinweismeldung.</li><li>Links funktionieren auch in Journal-Einträgen, um tägliche Reflexionen mit Notizen zu verbinden.</li>"
          },
          data: {
            heading: "Datenmodell",
            list:
              "<li>Drift-Tabelle <code>note_entries</code> speichert Titel, Inhalt, Tags, Typ (Markdown/Zeichnung) und Sync-Metadaten.</li><li>Zeichnungen liegen als JSON-Vektoren mit optionalen Vorschaubildern vor.</li><li>Archiv- und Lösch-Flags ermöglichen Soft-Delete vor endgültigem Entfernen.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Notizen bleiben standardmäßig lokal; Mitgliedschaften verschlüsseln Inhalte mit AES-256-GCM.</li><li>Versionszähler erkennen Konflikte zwischen Geräten.</li><li>Merge-Assistent (Beta) hebt Unterschiede hervor und behält beide Versionen.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Onboarding-Notizen zu Workflows und Shortcuts.</li><li>Multi-Tag-Filter, gespeicherte Suchen und Notebook-Gruppen.</li><li>Vorlagen und Cross-Linking mit Aufgaben, Journal und Habits.</li><li>Bild- und Dateianhänge mit optional verschlüsselter Synchronisation.</li>"
          }
        }
      },
      journal: {
        meta: {
          title: "Tracker Wiki - Journal & Stimmung"
        },
        title: "Journal & Mood Tracker",
        sections: {
          usage: {
            heading: "Nutzungskonzept",
            list:
              "<li>Pro Tag und Kategorie einen Eintrag über Vorlagen erfassen.</li><li>Stimmung und individuelle Tracker mit Zeitverlauf visualisieren.</li><li>Zwischen Editor und Verlauf wechseln, um Highlights schnell zu prüfen.</li><li>Journal per Code oder biometrisch sperren, falls gewünscht.</li>"
          },
          data: {
            heading: "Datenmodell",
            list:
              "<li>Drift-Tabellen: <code>journal_entries</code> (Markdown, Kategorie, Sync) und <code>journal_entry_links</code> (Bezüge zu Notizen/Aufgaben).</li><li>Tracker liegen in <code>journal_trackers</code>, Tageswerte in <code>journal_tracker_values</code>.</li><li>Vorlagen und Sperrstatus werden in Hive zwischengespeichert.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Einträge bleiben lokal; Mitgliedschaften verschlüsseln Texte, Tracker und Metadaten mit AES-256-GCM.</li><li>Schlüsselrotation stellt sicher, dass alte Geräte keine neuen Einträge lesen können.</li><li>Konflikte bewahren beide Versionen und markieren Unterschiede für manuelle Auswahl.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Anhänge (Bilder, Audio) mit verschlüsselter Ablage.</li><li>Optionale KI-Prompts und Zusammenfassungen.</li><li>Advanced Analytics: Streaks, Trigger, Korrelationen zu Habits/Zeiterfassung.</li><li>Geteilte Vorlagen und Team-Retros.</li>"
          }
        }
      },
      habits: {
        meta: {
          title: "Tracker Wiki - Habits"
        },
        title: "Habits",
        sections: {
          usage: {
            heading: "Bedienung",
            list:
              "<li>Routinen mit täglichen, wöchentlichen oder Mehrfach-Intervallen definieren.</li><li>Messart wählen: Boolean, Zähler oder Dauer pro Habit.</li><li>Serien, rollierende Durchschnitte und Bestleistungen visualisieren.</li><li>Unterbrechungen mit Notizen kommentieren, um später daraus zu lernen.</li>"
          },
          data: {
            heading: "Datenmodell",
            list:
              "<li>Drift-Tabellen: <code>habit_definitions</code> (Meta, Intervall, Messart) und <code>habit_logs</code> (Datum, Wert, Notiz, Sync-Metadaten).</li><li>Rollierende Auswertungen für Streaks und Trends entstehen über SQL-Views.</li><li>Remote-IDs und Versionszähler unterstützen den verschlüsselten Sync.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Habits arbeiten offline; offene Logs bleiben markiert, bis der Sync läuft.</li><li>Verschlüsselter Sync serialisiert jeden Log mit AES-256-GCM und führt nach Zeitstempeln zusammen.</li><li>Konflikte behalten den höheren Wert und protokollieren beide Versionen.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Habit-Vorlagen und Sharing.</li><li>Kalender-Heatmaps und Anomalie-Warnungen.</li><li>Automationen, die Habits durch Tasks oder Zeiterfassung auslösen.</li><li>Serien-Exporte für Accountability-Partner.</li>"
          }
        }
      },
      ledger: {
        meta: {
          title: "Tracker Wiki - Haushaltsbuch"
        },
        title: "Haushaltsbuch",
        sections: {
          usage: {
            heading: "Bedienung",
            list:
              "<li>Einnahmen, Ausgaben, Transfers und wiederkehrende Buchungen je Konto erfassen.</li><li>Kategorien, Tags und Zahlungsarten für detaillierte Auswertungen vergeben.</li><li>Budgets mit Live-Fortschritt und Overspend-Hinweisen überwachen.</li><li>Nach Zeitraum, Konto oder Tag filtern und als CSV exportieren (Beta).</li>"
          },
          data: {
            heading: "Datenmodell",
            list:
              "<li>Drift-Tabellen: <code>ledger_accounts</code>, <code>ledger_categories</code>, <code>ledger_transactions</code>, <code>ledger_budgets</code> und <code>ledger_recurring_transactions</code>.</li><li>Transaktionen enthalten Betrag, Währung, Art (Einnahme/Ausgabe/Transfer), Kategorie, Quell-/Zielkonto und optionales Memo.</li><li>Monatliche Rollups und Vermögens-Snapshots werden für Dashboards zwischengespeichert.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Finanzdaten bleiben standardmäßig lokal.</li><li>Mitgliedschaften verschlüsseln jede Buchung mit AES-256-GCM; wiederkehrende Vorlagen synchronisieren separat.</li><li>Konflikte bewahren beide Versionen und markieren sie zur manuellen Prüfung.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Interaktive Diagramme für Kategorien, Cashflow und Vermögensentwicklung.</li><li>Regelbasierte Kategorisierung mit automatischen Abstimmungen.</li><li>Belegerfassung per Foto mit OCR (Recherche).</li><li>Geteilte Budgets für Haushaltsorganisation.</li>"
          }
        }
      },
      settings: {
        meta: {
          title: "Tracker Wiki - Einstellungen"
        },
        title: "Einstellungen",
        sections: {
          usage: {
            heading: "Bedienung",
            list:
              "<li>Anmeldung über E-Mail/Passwort oder Google Sign-In verwalten.</li><li>Module aktivieren/deaktivieren, Navigation neu sortieren und Akzentfarbe anpassen.</li><li>Sprache und Theme sofort wechseln; Präferenzen bleiben offline verfügbar.</li><li>Verschlüsselte Backups anstoßen und Speicherverbrauch prüfen (Beta).</li>"
          },
          notesJournal: {
            heading: "Notizen & Journal",
            list:
              "<li>Standardansicht (Editor oder Vorschau) für Notizen und Journal-Einträge wählen.</li><li>Editor-Modus öffnet Notizen zum Tippen; Vorschau zeigt gerenderten Markdown.</li><li>Die Einstellung gilt für das Notizen- und das Journal-Modul.</li><li>Diese Präferenz synchronisiert über Geräte bei aktiver Mitgliedschaft.</li>"
          },
          data: {
            heading: "Datenmodell",
            list:
              "<li>Präferenzen liegen in Hive mit optionalem verschlüsseltem Export.</li><li>Server verwaltet nur gehashte Credentials und Google-OAuth-Verknüpfungen.</li><li>Die kommende Collection <code>user_preferences</code> synchronisiert Moduleinstellungen und Layouts.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Präferenzen bleiben local-first; Sync verschlüsselt ausgewählte Settings mit AES-256-GCM.</li><li>Modulreihenfolge und Theme synchronisieren, sobald der verschlüsselte Präferenzspeicher aktiv ist.</li><li>Sicherheitskritische Geheimnisse (Biometrie, Lock-Codes) verlassen das Gerät nicht.</li>"
          },
          deleteData: {
            heading: "Alle lokalen Daten löschen",
            list:
              "<li>Ein roter Button unten in den Einstellungen ermöglicht das vollständige Löschen aller lokalen Daten.</li><li>Löscht alle Notizen, Aufgaben, Zeiteinträge, Journal-Einträge, Gewohnheiten und Finanzdaten.</li><li>Ein Bestätigungsdialog verhindert versehentliches Löschen.</li><li>Nach dem Löschen startet die App mit einer leeren Datenbank neu.</li><li>Synchronisierte Kopien auf dem Server bleiben erhalten, bis sie manuell gelöscht werden.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Import/Export von Einstellungen zwischen Geräten.</li><li>Diagnose-Tools für Sync-Konflikte und Verschlüsselungsstatus.</li><li>Automatisierte Backup-Rotation mit Aufbewahrungsregeln.</li>"
          }
        }
      },
      support: {
        meta: {
          title: "Tracker Wiki - Projekt unterstützen"
        },
        title: "Projekt unterstützen",
        intro:
          "Tracker ist kostenlos und werbefrei. Wenn dir die App gefällt und du die Weiterentwicklung unterstützen möchtest, freue ich mich über eine kleine Spende.",
        sections: {
          bitcoin: {
            heading: "Bitcoin",
            body: "Du kannst Bitcoin direkt an folgende Adresse senden:"
          },
          coffee: {
            heading: "Buy me a coffee",
            body: "Unterstütze das Projekt mit einer einmaligen Spende über Buy Me a Coffee:",
            link: "Buy me a coffee"
          },
          other: {
            heading: "Andere Möglichkeiten zu helfen",
            list:
              "<li>Teile Tracker mit Freunden und Kollegen, die es nützlich finden könnten.</li><li>Melde Bugs und schlage Features über die Feedback-Kanäle vor.</li><li>Hinterlasse eine positive Bewertung, wenn die App in deinem Store verfügbar ist.</li>"
          }
        }
      },
      userGuide: {
        meta: {
          title: "Tracker Wiki - Benutzerhandbuch"
        },
        title: "Benutzerhandbuch",
        intro: "Dieses Handbuch hilft dir beim Einstieg in Tracker und zeigt, wie du die Funktionen optimal nutzt.",
        sections: {
          gettingStarted: {
            heading: "Erste Schritte",
            list:
              "<li>Lade Tracker für deine Plattform herunter oder nutze die Web-App direkt.</li><li>Kein Account nötig – alle Funktionen arbeiten sofort offline.</li><li>Aktiviere in den Einstellungen nur die Module, die du brauchst.</li><li>Optional: Melde dich an, um deine Daten kostenlos zwischen Geräten zu synchronisieren.</li>"
          },
          sync: {
            heading: "Kostenlose Cloud-Synchronisation",
            list:
              "<li>Melde dich mit E-Mail/Passwort oder Google an, um die Synchronisation zu aktivieren.</li><li>Alle Daten werden Ende-zu-Ende verschlüsselt, bevor sie dein Gerät verlassen.</li><li>Sync ist komplett kostenlos – kein Abo erforderlich.</li><li>Greife von jedem Gerät auf deine Daten zu: Smartphone, Desktop oder Web.</li>"
          },
          dataControl: {
            heading: "Datenkontrolle",
            list:
              "<li>Deine Daten gehören dir – lösche sie jederzeit über die Einstellungen.</li><li>Nutze \"Synchronisierte Daten löschen\", um Server-Kopien zu entfernen und lokale Daten zu behalten.</li><li>Nutze den roten Button \"Alle lokalen Daten löschen\", um die App komplett zurückzusetzen.</li><li>Ein Bestätigungsdialog verhindert versehentliches Löschen.</li>"
          },
          modules: {
            heading: "Modulübersicht",
            list:
              "<li><strong>Dashboard:</strong> Dein persönlicher Überblick mit Schnellaktionen und Kennzahlen.</li><li><strong>Aufgaben:</strong> Plane Aufgaben mit Prioritäten, Fälligkeiten und Erinnerungen.</li><li><strong>Notizen:</strong> Schreibe Markdown-Notizen oder erstelle Freihand-Zeichnungen.</li><li><strong>Journal:</strong> Tägliche Reflexion mit optionalem Mood-Tracking.</li><li><strong>Habits:</strong> Baue Routinen auf und verfolge Serien.</li><li><strong>Haushaltsbuch:</strong> Verwalte Finanzen mit Budgets und Berichten.</li><li><strong>Zeiterfassung:</strong> Protokolliere Fokus-Sessions und verknüpfe sie mit Aufgaben.</li>"
          },
          tips: {
            heading: "Tipps & Tricks",
            list:
              "<li>Nutze die Dashboard-Schnellaktionen, um Ideen schnell festzuhalten.</li><li>Verknüpfe Zeiteinträge mit Aufgaben für bessere Produktivitäts-Insights.</li><li>Aktiviere die Journal-Sperre für Privatsphäre.</li><li>Exportiere regelmäßig Daten, wenn du lokale Backups möchtest.</li>"
          }
        }
      },
      technical: {
        meta: {
          title: "Tracker Wiki - Technische Dokumentation"
        },
        title: "Technische Dokumentation",
        intro: "Detaillierte technische Informationen zu Trackers Architektur, Datenmodellen und Implementierung.",
        sections: {
          architecture: {
            heading: "Architekturübersicht",
            list:
              "<li><strong>Frontend:</strong> Flutter-App für Android, iOS, Web, Windows und Linux.</li><li><strong>Lokaler Speicher:</strong> Drift (SQLite) für strukturierte Daten, Hive für Einstellungen und Geheimnisse.</li><li><strong>Backend:</strong> FastAPI-Server mit PostgreSQL für Sync und Authentifizierung.</li><li><strong>Verschlüsselung:</strong> PBKDF2-HMAC-SHA256 Key-Derivation mit AES-256-GCM-Verschlüsselung.</li>"
          },
          database: {
            heading: "Datenbankschema",
            list:
              "<li><code>greeting_entries</code> – Dashboard-Nachrichten und Onboarding-Tipps.</li><li><code>note_entries</code> – Markdown- und Zeichnungs-Notizen mit Tags.</li><li><code>task_entries</code> – Aufgaben mit Priorität, Fälligkeit und Erinnerungen.</li><li><code>time_entries</code> – Zeiterfassungs-Sessions mit optionaler Aufgaben-Verknüpfung.</li><li><code>journal_entries</code> – Tägliches Journal mit Kategorien.</li><li><code>journal_trackers</code> / <code>journal_tracker_values</code> – Eigene Stimmungs-/Metrik-Tracker.</li><li><code>habit_definitions</code> / <code>habit_logs</code> – Habit-Tracking mit Serien.</li><li><code>ledger_*</code> – Konten, Buchungen, Budgets, Kategorien, wiederkehrende Vorlagen.</li><li><code>sync_tombstones</code> – Verfolgt gelöschte Einträge für Sync.</li>"
          },
          encryption: {
            heading: "Verschlüsselungs-Pipeline",
            list:
              "<li>Master-Key aus Benutzerpasswort mittels PBKDF2-HMAC-SHA256 (150k Iterationen) abgeleitet.</li><li>Jede Sync-Payload mit AES-256-GCM und eindeutigen IVs verschlüsselt.</li><li>Gerätespezifische Salze stellen unterschiedliche Schlüssel pro Gerät sicher.</li><li>Server speichert nur Ciphertext – Zero-Knowledge-Architektur.</li><li>Key-Rotation nach Passwortänderungen unterstützt.</li>"
          },
          sync: {
            heading: "Synchronisationsprotokoll",
            list:
              "<li>REST/JSON-API über TLS 1.3 mit kurzlebigen JWT zur Authentifizierung.</li><li>Optimistisches Locking mit Versionszählern pro Entität.</li><li>Inkrementeller Sync über Changelog-Endpoints.</li><li>Konflikterkennung mit Versionshistorie (manuelle Auflösung).</li><li>Tombstone-Tracking für Löschungen über Geräte hinweg.</li>"
          },
          deleteData: {
            heading: "Implementierung der Datenlöschung",
            list:
              "<li>Lokale Löschung nutzt plattformspezifische Implementierungen via Conditional Imports.</li><li><strong>iOS/Android:</strong> Schließt Datenbank und löscht <code>tracker.sqlite</code>-Datei.</li><li><strong>Web:</strong> Schließt Datenbank und löscht IndexedDB <code>tracker_database</code>.</li><li>Hive-Einstellungen werden separat geleert bei vollständigem Reset.</li><li>App ruft <code>main()</code> zur Neuinitialisierung nach Löschung auf.</li>"
          },
          api: {
            heading: "Backend-API-Endpunkte",
            list:
              "<li><code>POST /api/auth/register</code> – Account mit E-Mail/Passwort erstellen.</li><li><code>POST /api/auth/login</code> – Authentifizieren und JWT erhalten.</li><li><code>POST /api/auth/google</code> – OAuth-Login mit Google.</li><li><code>GET/POST /api/sync/{collection}</code> – Verschlüsselte Collection-Daten abrufen/senden.</li><li><code>POST /api/membership/delete_synced_data</code> – Alle serverseitigen Daten löschen.</li>"
          },
          development: {
            heading: "Entwicklungs-Setup",
            list:
              "<li>Flutter SDK 3.8+ für App-Entwicklung erforderlich.</li><li><code>flutter pub get</code> ausführen, um Abhängigkeiten zu installieren.</li><li>Drift-Code generieren: <code>dart run build_runner build</code>.</li><li>Backend benötigt Python 3.11+, FastAPI und PostgreSQL.</li><li>Docker Compose für lokale Full-Stack-Entwicklung verfügbar.</li>"
          }
        }
      }
    },
    legal: {
      privacy: {
        meta: {
          title: "Tracker - Datenschutzerklärung"
        },
        title: "Datenschutzerklärung",
        updated: "Stand: wird aktualisiert",
        sections: {
          controller: {
            heading: "1. Verantwortlicher",
            body:
              "Kay Beckmann<br /><span>Adresse folgt</span><br />E-Mail: <a href=\"mailto:kontakt@tracker-app.dev\">kontakt@tracker-app.dev</a>"
          },
          general: {
            heading: "2. Allgemeine Hinweise",
            body:
              "Der Schutz deiner personenbezogenen Daten ist uns wichtig. Diese Erklärung erläutert, welche Daten wir beim Besuch der Website, bei Nutzung der Web-App oder beim Tracker-Abo erheben, wie wir sie verarbeiten und welche Rechte dir zustehen."
          },
          website: {
            heading: "3. Bereitstellung der Website",
            body1:
              "Beim Aufruf unserer Seiten speichert der Webserver automatisch Informationen, die dein Browser übermittelt. Dazu gehören IP-Adresse, Browsertyp, Datum und Uhrzeit der Anfrage sowie die aufgerufene Ressource. Die Verarbeitung erfolgt auf Grundlage unseres berechtigten Interesses an einem stabilen und sicheren Betrieb (Art. 6 Abs. 1 lit. f DSGVO).",
            body2:
              "Server-Logfiles werden automatisch gelöscht, sobald sie für den ursprünglichen Zweck nicht mehr benötigt werden."
          },
          contact: {
            heading: "4. Kontakt",
            body1:
              "Wenn du uns per E-Mail kontaktierst, verarbeiten wir deine Angaben zur Bearbeitung der Anfrage. Rechtsgrundlage ist Art. 6 Abs. 1 lit. b DSGVO, sofern es um vertragliche Pflichten geht, ansonsten unser berechtigtes Interesse an der Beantwortung (Art. 6 Abs. 1 lit. f DSGVO).",
            body2:
              "Wir speichern deine Angaben, bis der Zweck entfällt oder du um Löschung bittest, sofern keine gesetzlichen Aufbewahrungspflichten entgegenstehen."
          },
          app: {
            heading: "5. Nutzung der Tracker Web-App",
            body1:
              "Die Web-App kann ohne Benutzerkonto lokal genutzt werden. Alle Daten verbleiben dann ausschließlich in deinem Browser. Für optionale Synchronisationsfunktionen ist ein Konto erforderlich; dabei verarbeiten wir Registrierungsdaten, verschlüsselte Nutzungsdaten und technische Metadaten.",
            list:
              "<li><strong>Zweck:</strong> Bereitstellung der App und Synchronisationsfunktionen</li><li><strong>Rechtsgrundlage:</strong> Art. 6 Abs. 1 lit. b DSGVO (Vertragserfüllung)</li><li><strong>Speicherdauer:</strong> Bis zur Kündigung der Mitgliedschaft bzw. Ablauf gesetzlicher Fristen</li>"
          },
          payments: {
            heading: "6. Zahlungsabwicklung",
            body:
              "Die Zahlungen für Tracker-Mitgliedschaften erfolgen über externe Zahlungsdienstleister. Sobald ein Anbieter integriert ist, informieren wir hier über den genutzten Dienst und die dortige Datenverarbeitung."
          },
          infrastructure: {
            heading: "7. Hosting und Infrastruktur",
            body:
              "Tracker-Dienste laufen in Container-Umgebungen (Docker). Der interne Datenverkehr ist abgesichert, als Datenbank kommt PostgreSQL zum Einsatz. Backups werden regelmäßig erstellt und verschlüsselt gespeichert."
          },
          recipients: {
            heading: "8. Empfänger",
            body:
              "Eine Weitergabe personenbezogener Daten erfolgt nur, wenn dies zur Vertragserfüllung notwendig ist, eine rechtliche Verpflichtung besteht oder du eingewilligt hast. Eine Übermittlung in Drittländer findet nur bei ausdrücklicher Angabe statt."
          },
          rights: {
            heading: "9. Deine Rechte",
            body:
              "Du hast nach geltendem Recht folgende Ansprüche:",
            list:
              "<li>Auskunft über gespeicherte Daten (Art. 15 DSGVO)</li><li>Berichtigung unrichtiger Daten (Art. 16 DSGVO)</li><li>Löschung personenbezogener Daten (Art. 17 DSGVO)</li><li>Einschränkung der Verarbeitung (Art. 18 DSGVO)</li><li>Datenübertragbarkeit (Art. 20 DSGVO)</li><li>Widerspruch gegen bestimmte Verarbeitungen (Art. 21 DSGVO)</li><li>Widerruf erteilter Einwilligungen (Art. 7 Abs. 3 DSGVO)</li>",
            body2:
              "Darüber hinaus steht dir ein Beschwerderecht bei der zuständigen Aufsichtsbehörde zu. In Deutschland ist dies in der Regel der Landesdatenschutzbeauftragte deines Bundeslandes."
          },
          security: {
            heading: "10. Sicherheit",
            body:
              "Wir treffen technische und organisatorische Maßnahmen, um deine Daten vor Manipulation, Verlust oder unbefugtem Zugriff zu schützen. Dazu zählen Zugriffsbeschränkungen, Verschlüsselung synchronisierter Daten und regelmäßige Software-Updates."
          }
        }
      },
      imprint: {
        meta: {
          title: "Tracker - Impressum",
          label: "Angaben gemäß § 5 TMG"
        },
        title: "Impressum",
        sections: {
          provider: {
            heading: "Diensteanbieter",
            body:
              "Kay Beckmann<br /><span>Adresse folgt</span>",
            contact:
              "Kontakt:<br />E-Mail: <a href=\"mailto:kontakt@tracker-app.dev\">kontakt@tracker-app.dev</a><br />Telefon: <span>optional</span>"
          },
          represented: {
            heading: "Vertretungsberechtigt",
            body: "Kay Beckmann"
          },
          content: {
            heading: "Verantwortlich für den Inhalt nach § 55 Abs. 2 RStV",
            body:
              "Kay Beckmann<br /><span>Adresse folgt</span>"
          },
          liabilityContent: {
            heading: "Haftung für Inhalte",
            body1:
              "Als Diensteanbieter sind wir gemäß § 7 Abs. 1 TMG für eigene Inhalte auf diesen Seiten nach den allgemeinen Gesetzen verantwortlich. Nach §§ 8 bis 10 TMG sind wir jedoch nicht verpflichtet, übermittelte oder gespeicherte fremde Informationen zu überwachen oder nach Umständen zu forschen, die auf eine rechtswidrige Tätigkeit hinweisen. Verpflichtungen zur Entfernung oder Sperrung der Nutzung von Informationen nach den allgemeinen Gesetzen bleiben unberührt.",
            body2:
              "Eine Haftung ist erst ab dem Zeitpunkt der Kenntnis einer konkreten Rechtsverletzung möglich. Bei Bekanntwerden entsprechender Rechtsverletzungen entfernen wir diese Inhalte umgehend."
          },
          liabilityLinks: {
            heading: "Haftung für Links",
            body1:
              "Unser Angebot enthält Links zu externen Websites Dritter, auf deren Inhalte wir keinen Einfluss haben. Daher können wir für diese fremden Inhalte auch keine Gewähr übernehmen. Für die Inhalte der verlinkten Seiten ist stets der jeweilige Anbieter oder Betreiber verantwortlich. Die verlinkten Seiten wurden zum Zeitpunkt der Verlinkung auf mögliche Rechtsverstöße überprüft; rechtswidrige Inhalte waren nicht erkennbar.",
            body2:
              "Eine permanente inhaltliche Kontrolle der verlinkten Seiten ist ohne konkrete Anhaltspunkte einer Rechtsverletzung nicht zumutbar. Bei Bekanntwerden von Rechtsverletzungen entfernen wir derartige Links umgehend."
          },
          copyright: {
            heading: "Urheberrecht",
            body1:
              "Die durch die Seitenbetreiber erstellten Inhalte und Werke unterliegen dem deutschen Urheberrecht. Die Vervielfältigung, Bearbeitung, Verbreitung und jede Art der Verwertung außerhalb der Grenzen des Urheberrechts bedürfen der schriftlichen Zustimmung des jeweiligen Autors. Downloads und Kopien dieser Seite sind nur für den privaten, nicht kommerziellen Gebrauch gestattet.",
            body2:
              "Soweit Inhalte nicht vom Betreiber erstellt wurden, werden die Urheberrechte Dritter beachtet und entsprechende Inhalte gekennzeichnet. Solltest du trotzdem eine Urheberrechtsverletzung bemerken, informiere uns bitte. Bei Bekanntwerden entfernen wir solche Inhalte umgehend."
          },
          dispute: {
            heading: "Alternative Streitbeilegung",
            body:
              "Die Europäische Kommission stellt eine Plattform zur Online-Streitbeilegung (OS) bereit: <a href=\"https://ec.europa.eu/consumers/odr/\" target=\"_blank\" rel=\"noopener\">https://ec.europa.eu/consumers/odr/</a>. Wir sind weder verpflichtet noch bereit, an Streitbeilegungsverfahren vor einer Verbraucherschlichtungsstelle teilzunehmen."
          }
        },
        nav: {
          home: "Zur Startseite",
          privacy: "Zur Datenschutzerklärung"
        }
      }
    }
  },
  sv: {
    common: {
      brand: "Tracker",
      nav: {
        vision: "Vision",
        modules: "Moduler",
        gallery: "Galleri",
        sync: "Synklägen",
        architecture: "Arkitektur",
        availability: "Nedladdningar",
        roadmap: "Färdplan",
        wiki: "Wiki",
        imprint: "Utgivarinformation",
        privacy: "Integritet"
      }
    },
    homepage: {
      meta: {
        title: "Tracker - Personlig produktivitetssvit"
      },
      hero: {
        title: "Tracker",
        subtitle:
          "Den local-first produktivitetssviten för planering, kunskapshantering, journal och krypterad synk på mobil, desktop och webb.",
        ctaPrimary: "Utforska nyheterna",
        ctaSecondary: "Öppna wikin"
      },
      vision: {
        heading: "Varför Tracker?",
        body:
          "Tracker förenar uppgifter, anteckningar, journal, vanor, ekonomi och tidrapportering i ett local-first cockpit. Allt körs offline med Drift-lagring, eller använd gratis krypterad synk på alla dina enheter.",
        cards: {
          offline: {
            title: "Local first",
            body: "Alla moduler körs på enheten utan krav på konto – perfekt för integritet och resor."
          },
          encrypted: {
            title: "Krypterat moln",
            body: "Gratis zero-knowledge-synk med bakgrundskonfliktdetektering och lagringspolicyer."
          },
          modular: {
            title: "Modulärt & anpassningsbart",
            body: "Aktivera bara modulerna du behöver, automatisera överlämningar och finjustera färger samt layout."
          }
        }
      },
      modules: {
        heading: "Moduler i överblick",
        dashboard: {
          title: "Dashboard",
          body: "Personligt cockpit med höjdpunkter från alla moduler.",
          list:
            "<li>Live-statuskort för vanor, saldon och timers (tillgängligt)</li><li>Snabbåtgärder för att starta en timer, skapa anteckningar eller öppna fokusflöden (tillgängligt)</li><li>Anpassat widget-rutnät med fastnålade filter (beta)</li>"
        },
        tasks: {
          title: "Uppgifter & möten",
          body: "Planera uppgifter, deadlines, påminnelser och kalenderhändelser tillsammans.",
          list:
            "<li>Kalenderintegrerad tavla med färgkodade prioriteter (tillgängligt)</li><li>Detaljpanel med taggar, påminnelser och länkade anteckningar (tillgängligt)</li><li>Starta/stoppa fokustimer direkt på uppgiften (tillgängligt)</li>"
        },
        notes: {
          title: "Anteckningar",
          body: "Flexibel Markdown-bas med stöd för ritningar.",
          list:
            "<li>Markdown-editor med taggsökning, bakåtlänkar och inline-bilagor (tillgängligt)</li><li>Frihandsritningar och canvas-läge för visuellt tänkande (tillgängligt)</li><li>Återanvändbara mallar och multi-tag-filter (beta)</li>"
        },
        journal: {
          title: "Journal & humör",
          body: "Daglig reflektion med app-lås, stämningsdiagram och highlights.",
          list:
            "<li>Dags- och veckovy med stämningskurva och promptar (beta)</li><li>Valbart app-lås med biometrisk upplåsning (tillgängligt)</li><li>Länka poster till anteckningar och uppgifter (under utveckling)</li>"
        },
        habits: {
          title: "Vanor",
          body: "Bygg rutiner med serier, räknare och insikter.",
          list:
            "<li>Följ booleska, numeriska eller tidsbaserade mål med streak-skydd (tillgängligt)</li><li>Trenddiagram och intervalljämförelser per vana (tillgängligt)</li><li>Mallbibliotek och delade rutiner (färdplan)</li>"
        },
        ledger: {
          title: "Hushållsbok",
          body: "Håll koll på utgifter, budgetar och rapporter.",
          list:
            "<li>Flera konton med återkommande transaktioner (tillgängligt)</li><li>Budgetar, kategorifilter och avstämning (tillgängligt)</li><li>Analyser med rullande prognoser och synkexporter (beta)</li>"
        },
        timeTracking: {
          title: "Tidrapportering",
          body: "Mät fokustillfällen och koppla dem till uppgifter.",
          list:
            "<li>Ett-trycks-timers med automatisk avrundning och taggar (tillgängligt)</li><li>Dags- och veckorapporter plus beläggningsvyer (tillgängligt)</li><li>CSV-exporter och automationskrokar (färdplan)</li>"
        },
        settings: {
          title: "Inställningar",
          body: "Styr språk, tema, moduler och synk.",
          list:
            "<li>Inloggning via e-post/lösenord eller Google Sign-In med medlemsstatus (tillgängligt)</li><li>Språk-, tema- och accentfärgsbyte i realtid (tillgängligt)</li><li>Modulordning, säkerhetskopior och synkdiagnostik (beta)</li>"
        }
      },
      gallery: {
        heading: "Titta in i arbetsytan",
        body:
          "Varje modul körs lokalt, reagerar direkt och synkroniserar bara när du väljer det. Dessa mockups visar läget i de aktuella Android- och desktop-buildarna.",
        dashboardPlaceholder: "Dashboard-förhandsvisning",
        dashboard: "Dashboard med live-streaks, aktuella uppgifter och hushållssaldo i samma vy.",
        tasksPlaceholder: "Uppgiftsförhandsvisning",
        tasks: "Kalenderstödd uppgiftstavla med inbyggda timers och aviseringar.",
        ledgerPlaceholder: "Hushållsboksförhandsvisning",
        ledger: "Hushållsboksanalys med budgetar, återkommande betalningar och överföringar."
      },
      sync: {
        heading: "Lokal först eller krypterat moln",
        body:
          "Välj läget som passar din integritet. Tracker fungerar fullt ut offline, eller synka gratis med änd-till-ände-kryptering.",
        local: {
          title: "Endast lokalt",
          list:
            "<li>All data lever i en lokal Drift/Hive-databas</li><li>Inget konto krävs – hela funktionsuppsättningen finns offline</li><li>Exportera krypterade säkerhetskopior eller arbeta helt luftgap</li>"
        },
        cloud: {
          title: "Krypterad synk",
          list:
            "<li>Änd-till-ände-kryptering (PBKDF2 + AES-256-GCM) med enhetsspecifika nycklar</li><li>Åtkomst via Android, iOS (beta), desktop och webb</li><li>Helt gratis – ingen prenumeration krävs</li>"
        }
      },
      security: {
        heading: "Datasäkerhet & retention",
        body:
          "Tracker sparar aldrig synkat innehåll permanent. Du har alltid full kontroll över dina data.",
        manual: {
          title: "Omedelbar radering",
          body:
            "Ta bort synkade kopior från servern när som helst via appens inställningar. Lokala data ligger kvar på dina enheter."
        },
        local: {
          title: "Radera all lokal data",
          body:
            "Använd den röda knappen i inställningarna för att permanent radera all lokal data från din enhet. En bekräftelsedialog förhindrar oavsiktlig radering."
        }
      },
      architecture: {
        heading: "Arkitektur & säkerhet",
        body:
          "Tracker följer en local-first-arkitektur: Drift hanterar en krypterad SQLite-databas per enhet medan servern bara lagrar chiffertext. Sync-endpoints använder REST/JSON över TLS 1.3 och autentisering sker med kortlivade JWT.",
        storage: {
          title: "Lokalt valv",
          list:
            "<li>Drift + SQLite för strukturerad data, Hive för hemligheter och preferenser</li><li>Automatiska nattsnapshots med rullande retention (beta)</li><li>Export/import per modul för efterlevnad och återställning</li>"
        },
        security: {
          title: "Krypteringskedja",
          list:
            "<li>PBKDF2-HMAC-SHA256 med 150k iterationer skapar 256-bitars nycklar</li><li>AES-256-GCM omsluter anteckningar, uppgifter, vanor, hushållsbok och journal vid synk</li><li>Enhetsspecifika salter, låsskydd och nyckelrotation efter medlemskapsändringar</li>"
        },
        protocols: {
          title: "Protokoll & API:er",
          list:
            "<li>FastAPI-backend med optimistisk låsning och versionsräknare</li><li>Inkrementella synk-API:er med serversidig konfliktupptäckt</li><li>Google OAuth, åtkomsttokens och planerad Argon2id för lösenord</li>"
        }
      },
      availability: {
        heading: "Tillgänglighet & nedladdningar",
        web: {
          title: "Webbapp",
          body: "Installerbar progressiv webbapp med offlinecache och biometrisk upplåsning där det stöds.",
          link: "Öppna nu"
        },
        playStore: {
          title: "Google Play Store",
          body: "Sideload-APK publiceras vid varje release; Play Store-listning är under granskning.",
          link: "Förhandsgranska"
        },
        windows: {
          title: "Windows-nedladdning",
          body: "Installeraren paketeras just nu – publik nedladdning kommer efter QA.",
          link: "Installerare kommer"
        },
        linux: {
          title: "Linux-nedladdning",
          body: "AppImage/Flatpak-paket är under arbete – släpps efter automatiserade tester.",
          link: "AppImage kommer"
        }
      },
      roadmap: {
        heading: "Färdplan & nuläge",
        body: "Vi itererar i fokuserade faser: först stärka local-first-kärnan, därefter krypterad synk, automation och integrationer.",
        phase1: {
          title: "Fas 1 – Local-first-grund (klar)",
          list:
            "<li>Drift/Hive-lagring, migrationer och backup-subsystem</li><li>Modulärt UI med dashboard, uppgifter, anteckningar, vanor, hushållsbok, journal och tid</li><li>Lokalisering (DE/EN/SV) med språkbyte i realtid</li>"
        },
        phase2: {
          title: "Fas 2 – Förfina moduler & automation (pågår)",
          list:
            "<li>Uppgiftstimers, aviseringar och kalenderblockering</li><li>Anteckningsbacklinks, mallar, bilagor och ritningssynk</li><li>Vananalyser, hushållsprognoser och dashboard-widgets</li><li>Journal-humörtracker och krypterade bilagor</li>"
        },
        phase3: {
          title: "Fas 3 – Krypterad synk & medlemskap (beta)",
          list:
            "<li>PBKDF2/AES-256-GCM-synk med versionsräknare</li><li>Konflikthanterare med versionshistorik</li><li>Medlemskap via PayPal/Google Pay och lagringshantering</li>"
        },
        phase4: {
          title: "Fas 4 – Integrationer & lansering (kommer)",
          list:
            "<li>Plattformsfinlir (Android, iOS, webb, Linux, Windows)</li><li>CI/CD, automatiserad QA och export för efterlevnad</li><li>Lansering med onboarding, hjälpcenter och API-dokumentation</li>"
        }
      },
      support: {
        heading: "Stöd projektet",
        body: "Tracker är gratis och reklamfri. Om du gillar appen och vill stödja utvecklingen uppskattar jag en liten donation.",
        btc: {
          title: "Bitcoin",
          body: "Skicka BTC direkt till följande adress:"
        },
        coffee: {
          title: "Buy me a coffee",
          body: "Stöd projektet med en engångsdonation via Buy Me a Coffee.",
          link: "Buy me a coffee"
        }
      },
      footer: {
        title: "Tracker",
        body: "Produktivitet på nytt sätt – lokal, säker, flexibel.",
        linksTitle: "Länkar",
        contactTitle: "Kontakt",
        contactEmail: "contact@kay-beckmann.com",
        legal: "© 2025 Tracker. Alla rättigheter förbehållna."
      }
    },
    wiki: {
      common: {
        overview: "Wikiöversikt",
        footer: "© 2025 Tracker. Alla rättigheter förbehållna."
      },
      index: {
        meta: {
          title: "Tracker Wiki - Översikt"
        },
        title: "Tracker Wiki",
        intro:
          "Detaljerad vägledning för varje modul: vardagliga arbetsflöden, datastrukturer och synk-kommentarer.",
        cards: {
          dashboard: {
            title: "Dashboard",
            body: "Översikt, nyckeltal och snabba åtgärder."
          },
          tasks: {
            title: "Uppgifter & möten",
            body: "Planering, kalender, kategorier och påminnelser."
          },
          timeTracking: {
            title: "Tidrapportering",
            body: "Pass, uppgiftslänkar och analys."
          },
          notes: {
            title: "Anteckningar",
            body: "Markdown, ritningar, taggar och sök."
          },
          journal: {
            title: "Journal & humör",
            body: "Daglig reflektion och humörspårning."
          },
          habits: {
            title: "Vanor",
            body: "Följ rutiner, serier och framsteg."
          },
          ledger: {
            title: "Hushållsbok",
            body: "Ekonomi, budgetar och rapporter."
          },
          settings: {
            title: "Inställningar",
            body: "Språk, tema, moduler och synk."
          },
          support: {
            title: "Stöd",
            body: "Donera för att stödja projektet."
          },
          userGuide: {
            title: "Användarguide",
            body: "Kom igång och dagliga arbetsflöden."
          },
          technical: {
            title: "Teknisk dokumentation",
            body: "Arkitektur, API:er och utveckling."
          }
        },
        security: {
          title: "Datasäkerhet & retention",
          body:
            "Dina data förblir under din kontroll. Synk är gratis och krypterad, och du kan radera allt när som helst.",
          list:
            "<li>Radera synkade data från servern via inställningarna.</li><li>Radera all lokal data med den röda knappen i inställningarna.</li><li>Lokala data på dina enheter påverkas inte av serveroperationer.</li>"
        }
      },
      dashboard: {
        meta: {
          title: "Tracker Wiki - Dashboard"
        },
        title: "Dashboard",
        sections: {
          usage: {
            heading: "Användning",
            list:
              "<li>Startvy efter inloggning eller lokal start.</li><li>Visar hälsning, systemaviseringar och modulövergripande nyckeltal.</li><li>Snabbåtgärder anropar backend och visar sparade svar.</li><li>Att rensa listan tar bort lokala handskakningsdata.</li>"
          },
          data: {
            heading: "Datamodell",
            list:
              "<li>Använder Drift-tabellen <code>greeting_entries</code> för serversvar.</li><li>Läser Hive-boxar för språk, tema och modulpreferenser.</li><li>Inga egna synk-entiteter ännu; aggregerade KPI:er planeras.</li>"
          },
          sync: {
            heading: "Synkronisering",
            list:
              "<li>Hälsningsposter stannar lokalt för felsökning.</li><li>Medlemskap kommer att visa nyckeltal från synkade data.</li><li>Widgetlayouter synkas när fas 3 lanseras.</li>"
          },
          roadmap: {
            heading: "Färdplan",
            list:
              "<li>Infoga live-data från uppgifter, vanor, hushållsbok och journal.</li><li>Erbjuda konfigurerbara widgets, storlekar och drag-and-drop.</li><li>Stöd för flera dashboards för olika sammanhang.</li>"
          }
        }
      },
      tasks: {
        meta: {
          title: "Tracker Wiki - Uppgifter & möten"
        },
        title: "Uppgifter & möten",
        sections: {
          usage: {
            heading: "Användning",
            list:
              "<li>Planera uppgifter, möten och påminnelser i en vy.</li><li>Kalendervy markerar intensiva dagar och deadlines.</li><li>Listor kan sorteras efter datum, prioritet och kategori.</li><li>Kategorier skapas automatiskt när nya poster anges.</li><li>Starta tidtagning direkt från en uppgift (under utveckling).</li>"
          },
          data: {
            heading: "Datamodell (planerad)",
            list:
              "<li>Kärntabeller: <code>tasks</code>, <code>appointments</code>, <code>categories</code>, <code>reminders</code>.</li><li>Relationer: <code>tasks</code> ↔ <code>time_entries</code> (1:n), uppgifter ↔ anteckningar (planerad n:m).</li><li>Kategorier lagras som referensobjekt med färg och ikon.</li>"
          },
          sync: {
            heading: "Synkronisering",
            list:
              "<li>Fungerar helt offline via Drift/Hive.</li><li>Medlemskap krypterar uppgifter, möten, påminnelser och kategorier.</li><li>Konflikter: senaste skrivning vinner, versionshistorik planeras.</li>"
          },
          roadmap: {
            heading: "Färdplan",
            list:
              "<li>Slutföra redigering av mötesdetaljer (titel, datum, prioritet, kategori).</li><li>Lägga till särskild vy för kategorihantering och färgval.</li><li>Djupare tidtagningsflöden med aktiva timers.</li><li>Förbättra aviseringar, upprepningar och smarta förslag.</li>"
          }
        }
      },
      time: {
        meta: {
          title: "Tracker Wiki - Tidrapportering"
        },
        title: "Tidrapportering",
        sections: {
          usage: {
            heading: "Användning",
            list:
              "<li>Registrera fokustillfällen manuellt eller med inbyggd timer.</li><li>Koppla pass till uppgifter för kompletta rapporter.</li><li>Tagga poster, lägg till anteckningar och granska dagslinjen.</li><li>Pausa och återuppta timers utan att förlora tid.</li>"
          },
          data: {
            heading: "Datamodell",
            list:
              "<li>Tabellen <code>time_entries</code> sparar längd, start, stopp och eventuell uppgiftsreferens.</li><li>Mellantabell <code>time_entry_tags</code> kopplar flera taggar.</li><li>Dags- och veckosammanställningar beräknas vid behov.</li>"
          },
          sync: {
            heading: "Synkronisering",
            list:
              "<li>Offline-först med lokal lagring.</li><li>Medlemskap synkar pass och taggar mellan enheter.</li><li>Konflikter sammanfogas med exakta tidsstämplar.</li>"
          },
          roadmap: {
            heading: "Färdplan",
            list:
              "<li>Starta/stoppa timers direkt från uppgiftskort.</li><li>Möjliggöra multiredigering och masshantering av taggar.</li><li>Exportera rapporter (CSV/JSON) för fakturering och analys.</li><li>Visualisera trender med diagram och värmekartor.</li>"
          }
        }
      },
      notes: {
        meta: {
          title: "Tracker Wiki - Anteckningar"
        },
        title: "Anteckningar",
        sections: {
          usage: {
            heading: "Användning",
            list:
              "<li>Skriv Markdown-anteckningar med liveförhandsvisning och delad vy.</li><li>Första raden blir titel; skapad- och ändringstid uppdateras automatiskt.</li><li>Tagga anteckningar, filtrera efter taggar och sök i text och metadata.</li><li>Byt till frihandsläge för skisser, diagram och wireframes.</li>"
          },
          linking: {
            heading: "Länka anteckningar",
            list:
              "<li>Använd <code>[[Anteckningstitel]]</code> wiki-syntax för att länka mellan anteckningar.</li><li>Länkar blir klickbara i förhandsvisningen och navigerar till refererad anteckning.</li><li>Ett meddelande visas om den länkade anteckningen inte finns.</li><li>Länkar fungerar även i journalposter för att koppla dagliga reflektioner med anteckningar.</li>"
          },
          data: {
            heading: "Datamodell",
            list:
              "<li>Tabeller: <code>notes</code>, <code>note_tags</code> och jointabellen <code>note_tag_links</code>.</li><li>Metadata lagrar tidsstämplar och senaste redigerare.</li><li>Ritningar sparas som vektorer med eventuell PNG-kopia.</li>"
          },
          sync: {
            heading: "Synkronisering",
            list:
              "<li>Anteckningar ligger lokalt som standard för integritet och offlineåtkomst.</li><li>Medlemskap krypterar text, ritningar och bilagor.</li><li>Konfliktlösning behåller båda versionerna; en sammanslagningsassistent planeras.</li>"
          },
          roadmap: {
            heading: "Färdplan",
            list:
              "<li>Onboarding-anteckningar som förklarar huvudflöden.</li><li>Flera taggfilter, sparade sökningar och anteckningsböcker.</li><li>Mallar samt korslänkning med uppgifter och journalposter.</li><li>Bildinfogning med lokal lagring och valfri synk.</li>"
          }
        }
      },
      journal: {
        meta: {
          title: "Tracker Wiki - Journal & humör"
        },
        title: "Journal & humörspårare",
        sections: {
          usage: {
            heading: "Koncept",
            list:
              "<li>Fånga dagliga reflektioner, höjdpunkter och utmaningar.</li><li>Registrera humörpoäng med taggar för triggers och framgångar.</li><li>Länka poster till anteckningar, uppgifter och vaneserier.</li><li>Dag-, vecko- och månadsöversikter hjälper dig att se trender.</li>"
          },
          data: {
            heading: "Datamodell (under design)",
            list:
              "<li>Tabeller: <code>journal_entries</code>, <code>journal_moods</code> samt join-tabeller för kopplingar.</li><li>Humörskala 1–5 med valfri emoji-karta.</li><li>Poster lagrar fri text, bilagor och planerat väderkontext.</li>"
          },
          sync: {
            heading: "Synkronisering",
            list:
              "<li>Poster stannar lokalt tills krypterad synk lanseras.</li><li>Medlemskap krypterar text, bilagor och humördata änd-till-ände.</li><li>Versionshistorik ser till att reflektioner inte går förlorade vid sammanslagning.</li>"
          },
          roadmap: {
            heading: "Färdplan",
            list:
              "<li>Lansera första journalgränssnittet med dagliga frågor.</li><li>Lägg till humörvisualiseringar med serier och trender.</li><li>Visa samband mellan humör, vanor och tidrapportering.</li><li>Möjliggör privat export till PDF och Markdown.</li>"
          }
        }
      },
      habits: {
        meta: {
          title: "Tracker Wiki - Vanor"
        },
        title: "Vanor",
        sections: {
          usage: {
            heading: "Användning",
            list:
              "<li>Definiera rutiner med dagliga, veckovisa eller egna intervaller.</li><li>Registrera uppfyllelse med räknare, timer eller enkel check-in.</li><li>Visualisera serier och jämför med mål.</li><li>Kommentera avbrott med anteckningar för senare lärdom.</li>"
          },
          data: {
            heading: "Datamodell",
            list:
              "<li>Tabeller: <code>habit_definitions</code>, <code>habit_entries</code> och <code>habit_targets</code>.</li><li>Poster sparar datum, värde, eventuell varaktighet och anteckning.</li><li>Seriestatistik beräknas och cachelagras för dashboards.</li>"
          },
          sync: {
            heading: "Synkronisering",
            list:
              "<li>Vanedata fungerar offline med automatisk Drift-lagring.</li><li>Medlemskap slår samman poster via tidsstämplar och bevarar serier.</li><li>Konflikter behåller det högre värdet och loggar sammanslagningen.</li>"
          },
          roadmap: {
            heading: "Färdplan",
            list:
              "<li>Delade vanemallar och rekommendationer.</li><li>Kalender-heatmaps för snabb månadsöverblick.</li><li>Automatiseringar som triggar vanor från uppgifter eller tidspass.</li><li>Export av serier för ansvarspartners.</li>"
          }
        }
      },
      ledger: {
        meta: {
          title: "Tracker Wiki - Hushållsbok"
        },
        title: "Hushållsbok",
        sections: {
          usage: {
            heading: "Användning",
            list:
              "<li>Registrera inkomster och utgifter med kategorier och betalningssätt.</li><li>Sätt budget per kategori och följ utvecklingen under månaden.</li><li>Filtrera på tidsperiod, taggar och konton för riktad analys.</li><li>Exportera data för skatt eller privatekonomisk översyn (planerat).</li>"
          },
          data: {
            heading: "Datamodell",
            list:
              "<li>Tabeller: <code>ledger_entries</code>, <code>ledger_categories</code>, <code>ledger_budgets</code>, <code>ledger_accounts</code>.</li><li>Poster innehåller belopp, valuta, typ, kategori, konto och eventuell kvittometadata.</li><li>Månadsvisa rollups cachelagrar summor för snabbare dashboards.</li>"
          },
          sync: {
            heading: "Synkronisering",
            list:
              "<li>Lokalt först: ekonomidata stannar på enheten som standard.</li><li>Krypterad synk är valfri för medlemmar med enhetsnycklar.</li><li>Konflikter löses via belopp och tidsstämpel och historik sparas.</li>"
          },
          roadmap: {
            heading: "Färdplan",
            list:
              "<li>Interaktiva diagram för kategoritrender och kassaflöde.</li><li>Återkommande transaktioner och regelbaserad kategorisering.</li><li>Kvittokoppling via foto med OCR (utreds).</li><li>Delade budgetar för hushållssamarbete.</li>"
          }
        }
      },
      settings: {
        meta: {
          title: "Tracker Wiki - Inställningar"
        },
        title: "Inställningar",
        sections: {
          usage: {
            heading: "Användning",
            list:
              "<li>Hantera kontoinloggning via e-post/lösenord eller Google.</li><li>Konfigurera modulernas synlighet och standarddashboards.</li><li>Välj appens språk och tema; preferenser gäller direkt.</li><li>Granska lagringsanvändning och initiera lokala säkerhetskopior (beta).</li>"
          },
          notesJournal: {
            heading: "Anteckningar & journal",
            list:
              "<li>Välj standardvy (Redigera eller Förhandsgranska) när du öppnar anteckningar och journalposter.</li><li>Redigeringsläge öppnar anteckningar redo att skriva; Förhandsvisning visar renderad Markdown.</li><li>Inställningen gäller både Antecknings- och Journalmodulen.</li><li>Denna preferens synkas mellan enheter vid aktivt medlemskap.</li>"
          },
          data: {
            heading: "Datamodell",
            list:
              "<li>Preferenser lagras i Hive-boxar för snabb offline-åtkomst.</li><li>Kontouppgifter hanteras via säkra backend-API:er.</li><li>Den kommande tabellen <code>user_preferences</code> samlar synkstatus.</li>"
          },
          sync: {
            heading: "Synkronisering",
            list:
              "<li>Preferenser är lokala först; synk krypterar valda inställningar med AES-256-GCM.</li><li>Modulordning och tema synkas när det krypterade preferenslagret aktiveras.</li><li>Säkerhetskritiska hemligheter (biometrinycklar, låskoder) lämnar aldrig enheten.</li>"
          },
          deleteData: {
            heading: "Radera all lokal data",
            list:
              "<li>En röd knapp längst ner i inställningarna gör det möjligt att helt radera all lokal data.</li><li>Raderar alla anteckningar, uppgifter, tidsposter, journalposter, vanor och ekonomidata.</li><li>En bekräftelsedialog förhindrar oavsiktlig radering.</li><li>Efter radering startar appen om med en tom databas.</li><li>Synkade kopior på servern finns kvar tills de raderas manuellt.</li>"
          },
          roadmap: {
            heading: "Färdplan",
            list:
              "<li>Import/export av inställningar mellan enheter.</li><li>Diagnosverktyg för synkkonflikter och krypteringsstatus.</li><li>Automatisk backup-rotation med lagringspolicyer.</li>"
          }
        }
      },
      support: {
        meta: {
          title: "Tracker Wiki - Stöd projektet"
        },
        title: "Stöd projektet",
        intro:
          "Tracker är gratis och reklamfri. Om du gillar appen och vill stödja den fortsatta utvecklingen uppskattar jag en liten donation.",
        sections: {
          bitcoin: {
            heading: "Bitcoin",
            body: "Du kan skicka Bitcoin direkt till följande adress:"
          },
          coffee: {
            heading: "Buy me a coffee",
            body: "Stöd projektet med en engångsdonation via Buy Me a Coffee:",
            link: "Buy me a coffee"
          },
          other: {
            heading: "Andra sätt att hjälpa",
            list:
              "<li>Dela Tracker med vänner och kollegor som kanske tycker det är användbart.</li><li>Rapportera buggar och föreslå funktioner via feedback-kanalerna.</li><li>Lämna en positiv recension om appen finns i din plattforms butik.</li>"
          }
        }
      },
      userGuide: {
        meta: {
          title: "Tracker Wiki - Användarguide"
        },
        title: "Användarguide",
        intro: "Denna guide hjälper dig att komma igång med Tracker och få ut det mesta av funktionerna.",
        sections: {
          gettingStarted: {
            heading: "Kom igång",
            list:
              "<li>Ladda ner Tracker för din plattform eller använd webbappen direkt.</li><li>Inget konto krävs – alla funktioner fungerar offline direkt.</li><li>Aktivera endast de moduler du behöver i Inställningar.</li><li>Logga valfritt in för att synka dina data mellan enheter gratis.</li>"
          },
          sync: {
            heading: "Gratis molnsynk",
            list:
              "<li>Logga in med e-post/lösenord eller Google för att aktivera synk.</li><li>All data krypteras änd-till-ände innan den lämnar din enhet.</li><li>Synk är helt gratis – ingen prenumeration krävs.</li><li>Kom åt dina data från vilken enhet som helst: mobil, desktop eller webb.</li>"
          },
          dataControl: {
            heading: "Datakontroll",
            list:
              "<li>Dina data tillhör dig – radera dem när som helst från inställningarna.</li><li>Använd \"Radera synkade data\" för att ta bort serverexemplar men behålla lokala data.</li><li>Använd den röda knappen \"Radera all lokal data\" för att helt återställa appen.</li><li>En bekräftelsedialog förhindrar oavsiktlig radering.</li>"
          },
          modules: {
            heading: "Modulöversikt",
            list:
              "<li><strong>Dashboard:</strong> Din personliga översikt med snabba åtgärder och nyckeltal.</li><li><strong>Uppgifter:</strong> Planera uppgifter med prioriteter, förfallodatum och påminnelser.</li><li><strong>Anteckningar:</strong> Skriv Markdown-anteckningar eller skapa frihandsritningar.</li><li><strong>Journal:</strong> Daglig reflektion med valfri humörspårning.</li><li><strong>Vanor:</strong> Bygg rutiner och följ serier.</li><li><strong>Hushållsbok:</strong> Hantera ekonomi med budgetar och rapporter.</li><li><strong>Tidrapportering:</strong> Logga fokuspass och länka dem till uppgifter.</li>"
          },
          tips: {
            heading: "Tips & tricks",
            list:
              "<li>Använd dashboardens snabba åtgärder för att fånga idéer snabbt.</li><li>Länka tidsposter till uppgifter för bättre produktivitetsinsikter.</li><li>Aktivera journallåset för integritetsskydd.</li><li>Exportera data regelbundet om du vill ha lokala säkerhetskopior.</li>"
          }
        }
      },
      technical: {
        meta: {
          title: "Tracker Wiki - Teknisk dokumentation"
        },
        title: "Teknisk dokumentation",
        intro: "Detaljerad teknisk information om Trackers arkitektur, datamodeller och implementation.",
        sections: {
          architecture: {
            heading: "Arkitekturöversikt",
            list:
              "<li><strong>Frontend:</strong> Flutter-app för Android, iOS, Webb, Windows och Linux.</li><li><strong>Lokal lagring:</strong> Drift (SQLite) för strukturerad data, Hive för inställningar och hemligheter.</li><li><strong>Backend:</strong> FastAPI-server med PostgreSQL för synk och autentisering.</li><li><strong>Kryptering:</strong> PBKDF2-HMAC-SHA256 nyckelderivering med AES-256-GCM-kryptering.</li>"
          },
          database: {
            heading: "Databasschema",
            list:
              "<li><code>greeting_entries</code> – Dashboard-meddelanden och introduktionstips.</li><li><code>note_entries</code> – Markdown- och ritningsanteckningar med taggar.</li><li><code>task_entries</code> – Uppgifter med prioritet, förfallodatum och påminnelser.</li><li><code>time_entries</code> – Tidrapporteringspass med valfri uppgiftslänk.</li><li><code>journal_entries</code> – Daglig journal med kategorier.</li><li><code>journal_trackers</code> / <code>journal_tracker_values</code> – Anpassade humör-/mätspårare.</li><li><code>habit_definitions</code> / <code>habit_logs</code> – Vanespårning med serier.</li><li><code>ledger_*</code> – Konton, transaktioner, budgetar, kategorier, återkommande mallar.</li><li><code>sync_tombstones</code> – Spårar raderade poster för synk.</li>"
          },
          encryption: {
            heading: "Krypteringspipeline",
            list:
              "<li>Huvudnyckel härleds från användarlösenord med PBKDF2-HMAC-SHA256 (150k iterationer).</li><li>Varje synknyttolast krypteras med AES-256-GCM och unika IV:er.</li><li>Enhetsspecifika salter säkerställer olika nycklar per enhet.</li><li>Servern lagrar endast chiffertext – zero-knowledge-arkitektur.</li><li>Nyckelrotation stöds efter lösenordsändringar.</li>"
          },
          sync: {
            heading: "Synkroniseringsprotokoll",
            list:
              "<li>REST/JSON API över TLS 1.3 med kortlivade JWT för autentisering.</li><li>Optimistisk låsning med versionsnummer per entitet.</li><li>Inkrementell synk via changelog-endpoints.</li><li>Konfliktdetektering med revisionshistorik (manuell upplösning).</li><li>Tombstone-spårning för raderingar över enheter.</li>"
          },
          deleteData: {
            heading: "Implementation av dataradering",
            list:
              "<li>Lokal radering använder plattformsspecifika implementationer via villkorliga importer.</li><li><strong>iOS/Android:</strong> Stänger databas och raderar <code>tracker.sqlite</code>-filen.</li><li><strong>Webb:</strong> Stänger databas och raderar IndexedDB <code>tracker_database</code>.</li><li>Hive-inställningar rensas separat vid fullständig återställning.</li><li>Appen anropar <code>main()</code> för återinitiering efter radering.</li>"
          },
          api: {
            heading: "Backend API-endpoints",
            list:
              "<li><code>POST /api/auth/register</code> – Skapa konto med e-post/lösenord.</li><li><code>POST /api/auth/login</code> – Autentisera och ta emot JWT.</li><li><code>POST /api/auth/google</code> – OAuth-inloggning med Google.</li><li><code>GET/POST /api/sync/{collection}</code> – Hämta/skicka krypterad kollektionsdata.</li><li><code>POST /api/membership/delete_synced_data</code> – Radera all serverdata.</li>"
          },
          development: {
            heading: "Utvecklingssetup",
            list:
              "<li>Flutter SDK 3.8+ krävs för apputveckling.</li><li>Kör <code>flutter pub get</code> för att installera beroenden.</li><li>Generera Drift-kod: <code>dart run build_runner build</code>.</li><li>Backend kräver Python 3.11+, FastAPI och PostgreSQL.</li><li>Docker Compose tillgängligt för lokal fullstack-utveckling.</li>"
          }
        }
      }
    },
    legal: {
      privacy: {
        meta: {
          title: "Tracker - Integritetspolicy"
        },
        title: "Integritetspolicy",
        updated: "Gäller från: uppdatering följer",
        sections: {
          controller: {
            heading: "1. Personuppgiftsansvarig",
            body:
              "Kay Beckmann<br /><span>Adress kommer</span><br />E-post: <a href=\"mailto:kontakt@tracker-app.dev\">kontakt@tracker-app.dev</a>"
          },
          general: {
            heading: "2. Allmänt",
            body:
              "Skyddet av dina personuppgifter är viktigt för oss. Policyn beskriver vilka data vi samlar in när du besöker webbplatsen, använder webappen eller blir medlem i Tracker, hur vi behandlar dem och vilka rättigheter du har."
          },
          website: {
            heading: "3. Tillhandahållande av webbplatsen",
            body1:
              "När du besöker våra sidor lagrar webbservern automatiskt information som din webbläsare skickar, till exempel IP-adress, webbläsartyp, datum, tid och begärd resurs. Behandlingen sker med stöd av vårt berättigade intresse av en stabil och säker tjänst (artikel 6.1 f GDPR).",
            body2:
              "Serverloggar raderas automatiskt när de inte längre behövs för syftet de samlades in för."
          },
          contact: {
            heading: "4. Kontakt",
            body1:
              "När du kontaktar oss via e-post behandlar vi uppgifterna för att svara på din förfrågan. Rättslig grund är artikel 6.1 b GDPR om ärendet rör avtal, annars vårt berättigade intresse av att besvara förfrågningar (artikel 6.1 f GDPR).",
            body2:
              "Vi sparar uppgifterna tills syftet upphör eller du begär radering, såvida inga lagstadgade skyldigheter kräver längre lagring."
          },
          app: {
            heading: "5. Användning av Tracker-webappen",
            body1:
              "Webappen kan användas lokalt utan konto. Då lagras alla data uteslutande i din webbläsare. För valfri synk behövs konto; vi behandlar då registreringsdata, krypterad användningsdata och teknisk metadata.",
            list:
              "<li><strong>Syfte:</strong> Tillhandahålla appen och synkfunktioner</li><li><strong>Rättslig grund:</strong> Artikel 6.1 b GDPR (avtalsuppfyllelse)</li><li><strong>Lagringstid:</strong> Tills medlemskapet avslutas eller lagstadgade frister löper ut</li>"
          },
          payments: {
            heading: "6. Betalningar",
            body:
              "Betalningar för Tracker-medlemskap hanteras av externa betaltjänstleverantörer. När en leverantör är integrerad informerar vi här om tjänsten och dess databehandling."
          },
          infrastructure: {
            heading: "7. Hosting och infrastruktur",
            body:
              "Tracker körs i containerbaserade miljöer (Docker). Intern trafik mellan tjänster är säkrad och PostgreSQL används som databas. Säkerhetskopior skapas regelbundet och lagras krypterat."
          },
          recipients: {
            heading: "8. Mottagare",
            body:
              "Personuppgifter lämnas endast vidare när det krävs för avtal, när lagen kräver det eller när du samtyckt. Överföring till tredjeland sker bara om det uttryckligen anges."
          },
          rights: {
            heading: "9. Dina rättigheter",
            body:
              "Du har enligt lag bland annat rätt till:",
            list:
              "<li>Tillgång till dina uppgifter (artikel 15 GDPR)</li><li>Rättelse av felaktiga uppgifter (artikel 16 GDPR)</li><li>Radering av personuppgifter (artikel 17 GDPR)</li><li>Begränsning av behandling (artikel 18 GDPR)</li><li>Dataportabilitet (artikel 20 GDPR)</li><li>Invändning mot viss behandling (artikel 21 GDPR)</li><li>Återkalla samtycke (artikel 7.3 GDPR)</li>",
            body2:
              "Du har dessutom rätt att lämna klagomål till ansvarig tillsynsmyndighet. I Sverige är det Integritetsskyddsmyndigheten (IMY)."
          },
          security: {
            heading: "10. Säkerhet",
            body:
              "Vi använder tekniska och organisatoriska åtgärder för att skydda dina data mot manipulation, förlust eller obehörig åtkomst. Det inkluderar åtkomstkontroller, kryptering av synkade data och regelbundna uppdateringar."
          }
        }
      },
      imprint: {
        meta: {
          title: "Tracker - Utgivarinformation",
          label: "Information enligt § 5 TMG"
        },
        title: "Utgivarinformation",
        sections: {
          provider: {
            heading: "Tjänsteleverantör",
            body:
              "Kay Beckmann<br /><span>Adress kommer</span>",
            contact:
              "Kontakt:<br />E-post: <a href=\"mailto:kontakt@tracker-app.dev\">kontakt@tracker-app.dev</a><br />Telefon: <span>valfritt</span>"
          },
          represented: {
            heading: "Behörig företrädare",
            body: "Kay Beckmann"
          },
          content: {
            heading: "Ansvarig för innehåll (§ 55 Abs. 2 RStV)",
            body:
              "Kay Beckmann<br /><span>Adress kommer</span>"
          },
          liabilityContent: {
            heading: "Ansvar för innehåll",
            body1:
              "Som tjänsteleverantör ansvarar vi för eget innehåll enligt § 7.1 TMG och allmän lag. Enligt §§ 8–10 TMG är vi inte skyldiga att övervaka överförd eller lagrad extern information eller att aktivt söka efter tecken på olaglig verksamhet. Skyldigheter att ta bort eller blockera innehåll enligt lag påverkas inte.",
            body2:
              "Ansvar uppstår först när vi får kännedom om konkreta överträdelser. Vid kännedom tar vi bort sådant innehåll omedelbart."
          },
          liabilityLinks: {
            heading: "Ansvar för länkar",
            body1:
              "Vårt erbjudande innehåller länkar till externa webbplatser vars innehåll vi inte kan påverka. Vi kan därför inte ta ansvar för dessa. Respektive operatör ansvarar alltid för innehållet. Länkarna kontrollerades vid länkningen och inga överträdelser noterades.",
            body2:
              "Kontinuerlig kontroll utan konkreta indikationer är orimlig. Om vi får vetskap om överträdelser tar vi bort länkarna omedelbart."
          },
          copyright: {
            heading: "Upphovsrätt",
            body1:
              "Innehåll som skapats av webbplatsoperatören omfattas av tysk upphovsrätt. Kopiering, bearbetning och spridning utanför lagens gränser kräver skriftligt tillstånd. Nedladdning och kopiering är endast tillåten för privat, icke-kommersiellt bruk.",
            body2:
              "Om innehåll inte skapats av operatören respekteras tredje parts rättigheter och markeras som sådana. Meddela oss om du upptäcker upphovsrättsbrott så tar vi bort materialet."
          },
          dispute: {
            heading: "Tvistlösning",
            body:
              "EU-kommissionen tillhandahåller en plattform för tvistlösning online (ODR): <a href=\"https://ec.europa.eu/consumers/odr/\" target=\"_blank\" rel=\"noopener\">https://ec.europa.eu/consumers/odr/</a>. Vi deltar varken frivilligt eller obligatoriskt i tvistlösningsförfaranden vid konsumentnämnd."
          }
        },
        nav: {
          home: "Till startsidan",
          privacy: "Integritetspolicy"
        }
      }
    }
  }
};
