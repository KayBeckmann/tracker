window.TRACKER_TRANSLATIONS = {
  en: {
    common: {
      brand: "Tracker",
      nav: {
        vision: "Vision",
        modules: "Modules",
        sync: "Sync Modes",
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
          "The modular productivity suite for personal planning, knowledge capture, and secure synchronisation across every device.",
        ctaPrimary: "Explore the modules",
        ctaSecondary: "Open the wiki"
      },
      vision: {
        heading: "Why Tracker?",
        body:
          "Tracker combines tasks, notes, journaling, habits, budgets, and time tracking in an offline-first workspace. A paid membership unlocks end-to-end encrypted sync between your devices.",
        cards: {
          offline: {
            title: "Offline first",
            body: "Work entirely locally without creating an account—ideal for privacy and travelling."
          },
          encrypted: {
            title: "Encrypted cloud",
            body: "Membership unlocks zero-knowledge sync across devices with conflict management on the roadmap."
          },
          modular: {
            title: "Modular & adaptable",
            body: "Enable only the modules you need, adjust colours, and personalise their order."
          }
        }
      },
      modules: {
        heading: "Modules at a glance",
        dashboard: {
          title: "Dashboard",
          body: "Personal cockpit with highlights from every module.",
          list:
            "<li>At-a-glance status cards across modules (available)</li><li>Quick access to recent notes, tasks, and entries (available)</li><li>Configurable widgets and layout (roadmap)</li>"
        },
        tasks: {
          title: "Tasks & Appointments",
          body: "Plan tasks, deadlines, reminders, and calendar events together.",
          list:
            "<li>Task lists plus calendar overview with highlighted days (available)</li><li>Sort by due date, priority, and category (available)</li><li>Time tracking directly from tasks (in development)</li>"
        },
        notes: {
          title: "Notes",
          body: "Flexible Markdown knowledge base with drawing support.",
          list:
            "<li>Live preview editor with tagging and full-text search (available)</li><li>Freehand sketches and shapes for visual notes (available)</li><li>Templates, multi-tag filters, and backlinks (roadmap)</li>"
        },
        journal: {
          title: "Journal & Mood Tracker",
          body: "Daily reflection with planned mood tracking and highlights.",
          list:
            "<li>Day and week timelines with mood indicators (in design)</li><li>Link entries to notes and tasks (roadmap)</li><li>Encrypted sync once memberships launch (planned)</li>"
        },
        habits: {
          title: "Habits",
          body: "Build routines with streaks, counters, and insights.",
          list:
            "<li>Track daily or weekly goals with flexible units (available)</li><li>Historical comparison views and streak analytics (available)</li><li>Shared templates and suggestions (roadmap)</li>"
        },
        ledger: {
          title: "Household Ledger",
          body: "Stay on top of expenses, budgets, and reports.",
          list:
            "<li>Income and expense tracking with categories (available)</li><li>Budget versus actual overviews and filters (available)</li><li>Charts and backend sync integration (in progress)</li>"
        },
        timeTracking: {
          title: "Time Tracking",
          body: "Measure focus sessions and tie them to tasks.",
          list:
            "<li>Manual entry and timers for sessions (available)</li><li>Day and tag based summaries (available)</li><li>Deeper task integration and exports (roadmap)</li>"
        },
        settings: {
          title: "Settings",
          body: "Control language, theming, modules, and sync.",
          list:
            "<li>Backend login for email, Google, and Apple ID (available)</li><li>Language and theme preferences (in development)</li><li>Module visibility and sync controls (roadmap)</li>"
        }
      },
      sync: {
        heading: "Local first or encrypted cloud",
        body:
          "Choose the mode that fits your privacy needs. Tracker works fully offline, while memberships unlock zero-knowledge sync.",
        local: {
          title: "Local only",
          list:
            "<li>All data stays on your device by default</li><li>No account required for the full feature set</li><li>Ideal for sensitive or offline workflows</li>"
        },
        cloud: {
          title: "Encrypted sync",
          list:
            "<li>End-to-end encryption with per-device keys</li><li>Access your workspace on mobile, desktop, and web</li><li>Membership planned at €2/month or €20/year</li>"
        }
      },
      availability: {
        heading: "Availability & downloads",
        web: {
          title: "Web app",
          body: "Launch the progressive web app directly in your browser.",
          link: "Open now"
        },
        playStore: {
          title: "Google Play Store",
          body: "Play Store listing is in preparation—follow the roadmap for the launch date.",
          link: "Preview listing"
        },
        windows: {
          title: "Windows download",
          body: "Placeholder build while automated packaging is finalised.",
          link: "Prepare download"
        },
        linux: {
          title: "Linux download",
          body: "Placeholder build while automated packaging is finalised.",
          link: "Prepare download"
        }
      },
      roadmap: {
        heading: "Roadmap & current status",
        body: "We iterate in focused phases to deliver the full Tracker experience.",
        phase1: {
          title: "Phase 1 — Foundation (completed)",
          list:
            "<li>Flutter app and backend scaffolding — completed</li><li>Local database integration & authentication — completed</li><li>Initial multilingual support (DE/EN/SV) — completed</li>"
        },
        phase2: {
          title: "Phase 2 — Module polish (in progress)",
          list:
            "<li>Deepen tasks, calendar, and notification flows</li><li>Rich note features including templates and backlinks</li><li>Journal flows with mood tracking</li><li>Habits, ledger insights, and dashboard widgets</li>"
        },
        phase3: {
          title: "Phase 3 — Synchronisation (upcoming)",
          list:
            "<li>End-to-end encryption and revision history</li><li>Conflict resolution workflows</li><li>Membership payments via PayPal and Bitcoin</li>"
        },
        phase4: {
          title: "Phase 4 — Launch & platforms (upcoming)",
          list:
            "<li>Cross-platform refinements (Android, iOS, Web, Desktop)</li><li>CI/CD automation and expanded testing</li><li>Product site, documentation, and onboarding</li>"
        }
      },
      footer: {
        title: "Tracker",
        body: "Productivity reimagined—local-first, secure, adaptable.",
        linksTitle: "Links",
        contactTitle: "Contact",
        contactEmail: "kontakt@tracker-app.dev",
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
          }
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
              "<li>Landing screen after signing in or launching the local app.</li><li>Shows welcome message, system alerts, and cross-module metrics.</li><li>Quick actions trigger backend calls and surface stored responses.</li><li>Clearing the response list removes locally cached handshake data.</li>"
          },
          data: {
            heading: "Data model",
            list:
              "<li>Uses Drift table <code>greeting_entries</code> to persist server responses.</li><li>Reads Hive boxes for language, theme, and module preferences.</li><li>No dedicated sync entities yet; aggregated KPIs are on the roadmap.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Greeting entries remain strictly local for debugging purposes.</li><li>Membership tier will surface cross-module metrics from synced data.</li><li>Widget layout preferences will sync once Phase 3 launches.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Inject live metrics from tasks, habits, ledger, and journal.</li><li>Offer configurable widgets, sizing, and drag-and-drop layout.</li><li>Support multiple dashboards for personal and work contexts.</li>"
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
              "<li>Plan tasks, appointments, and reminders in a unified workspace.</li><li>Calendar view highlights busy days and upcoming deadlines.</li><li>Lists support sorting by due date, priority, and category.</li><li>Categories are created automatically when referenced in new entries.</li><li>Start time tracking sessions straight from a task (in development).</li>"
          },
          data: {
            heading: "Data model (planned)",
            list:
              "<li>Core tables: <code>tasks</code>, <code>appointments</code>, <code>categories</code>, <code>reminders</code>.</li><li>Relations: <code>tasks</code> ↔ <code>time_entries</code> (1:n), tasks ↔ notes (n:m planned).</li><li>Categories stored as reference entities with colour and icon metadata.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Fully usable offline with Drift/Hive persistence.</li><li>Membership sync will encrypt tasks, appointments, reminders, and categories.</li><li>Conflict handling: last write wins with revision history on the roadmap.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Complete appointment detail editing (title, due date, priority, category).</li><li>Add dedicated category management and colour selection.</li><li>Integrate deeper time tracking flows with running timers.</li><li>Improve notifications, recurring patterns, and smart suggestions.</li>"
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
              "<li>Capture focus sessions manually or with the built-in timer.</li><li>Attach sessions to tasks for end-to-end reporting.</li><li>Tag entries, add notes, and review the day timeline.</li><li>Pause and resume timers without losing recorded duration.</li>"
          },
          data: {
            heading: "Data model",
            list:
              "<li>Core table <code>time_entries</code> stores duration, start, stop, and optional task reference.</li><li>Bridge table <code>time_entry_tags</code> links entries with multiple tags.</li><li>Aggregations for day and week summaries are computed on the fly.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Offline first with all data persisted locally.</li><li>Membership sync will replicate time entries and tags across devices.</li><li>Conflict handling merges overlapping sessions by keeping precise timestamps.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Start and stop timers directly from task cards.</li><li>Enable multi-select edits and bulk tag operations.</li><li>Export reports (CSV/JSON) for invoicing and analysis.</li><li>Visualise trends with charts and session heatmaps.</li>"
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
              "<li>Write Markdown notes with live preview and split view.</li><li>The first line becomes the title; creation and update times are tracked automatically.</li><li>Tag notes, filter by tag, and search across full text and metadata.</li><li>Switch to freehand mode for sketches, diagrams, and quick wireframes.</li>"
          },
          data: {
            heading: "Data model",
            list:
              "<li>Tables: <code>notes</code>, <code>note_tags</code>, and join table <code>note_tag_links</code>.</li><li>Metadata columns store created/updated timestamps and last editor.</li><li>Drawings are kept as embedded vectors with optional PNG fallback.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Notes live locally by default for privacy and offline access.</li><li>Membership sync will encrypt note bodies, drawings, and attachments.</li><li>Conflict resolution keeps both versions with a merge assistant planned.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Seed onboarding notes that explain core workflows.</li><li>Multi-tag filtering, saved searches, and notebook groupings.</li><li>Note templates plus cross-linking with tasks and journal entries.</li><li>Image insertion with local storage and optional sync support.</li>"
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
              "<li>Capture daily reflections, highlights, and challenges.</li><li>Record mood scores with optional tags for triggers and wins.</li><li>Link entries to notes, tasks, and habit streaks for context.</li><li>Timeline views for day, week, and month help spot trends.</li>"
          },
          data: {
            heading: "Data model (in design)",
            list:
              "<li>Tables: <code>journal_entries</code>, <code>journal_moods</code>, and join tables for linked entities.</li><li>Mood scores will use a 1–5 scale with optional emoji mapping.</li><li>Entries store free-form text, attachments, and weather context (planned).</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Entries remain local until encrypted sync launches.</li><li>Membership sync will encrypt text, attachments, and mood metrics end to end.</li><li>Version history ensures reflections are never lost during merges.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Ship the first journal interface with daily prompts.</li><li>Add mood visualisations including streaks and trends.</li><li>Surface correlations between mood, habits, and time tracking.</li><li>Implement private export to PDF and Markdown.</li>"
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
              "<li>Define routines with daily, weekly, or custom cadences.</li><li>Track completions with counters, timers, or boolean check-ins.</li><li>Visualise streaks and compare current versus target performance.</li><li>Annotate streak breaks with notes for future reflection.</li>"
          },
          data: {
            heading: "Data model",
            list:
              "<li>Tables: <code>habit_definitions</code>, <code>habit_entries</code>, and <code>habit_targets</code>.</li><li>Entries store date, value, optional duration, and note.</li><li>Aggregated streak metrics are derived and cached for dashboards.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Habit data is available offline with automatic Drift persistence.</li><li>Membership sync will merge entries by timestamp while preserving streaks.</li><li>Conflicts keep the higher completion value and log the merge.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Shared habit templates and recommendations.</li><li>Calendar heatmaps for quick monthly overview.</li><li>Automation hooks to trigger habits from tasks or time tracking.</li><li>Export streak summaries for accountability partners.</li>"
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
              "<li>Track incomes and expenses with categories and payment methods.</li><li>Set budgets per category and review progress throughout the month.</li><li>Filter by time range, tags, and accounts for targeted analysis.</li><li>Export data for tax preparation or personal finance reviews (planned).</li>"
          },
          data: {
            heading: "Data model",
            list:
              "<li>Tables: <code>ledger_entries</code>, <code>ledger_categories</code>, <code>ledger_budgets</code>, <code>ledger_accounts</code>.</li><li>Entries include amount, currency, type, category, account, and optional receipt metadata.</li><li>Monthly rollups cache totals for faster dashboard views.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Local-first ledger keeps all financial data on device by default.</li><li>Encrypted sync will be opt-in for memberships with per-device keys.</li><li>Conflicts resolve by amount and timestamp while preserving history.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Interactive charts for category trends and cashflow.</li><li>Recurring transactions and rule-based categorisation.</li><li>Receipt capture via photos with OCR (research).</li><li>Shared budgets for household collaboration.</li>"
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
              "<li>Manage account login via email/password, Google, or Apple ID.</li><li>Configure module visibility and default dashboards (planned).</li><li>Select app language and theme once the UI switches ship.</li><li>Review storage usage and trigger local backups (roadmap).</li>"
          },
          data: {
            heading: "Data model",
            list:
              "<li>Preferences stored in Hive boxes for fast, offline access.</li><li>Account credentials handled via secure auth APIs in the backend.</li><li>Upcoming <code>user_preferences</code> table will unify sync state.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Language and theme apply locally until multi-device sync launches.</li><li>Membership sync will propagate module visibility, dashboards, and shortcuts.</li><li>Security-sensitive settings (2FA, keys) stay server-side only.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Launch full language/theme switcher UI in-app.</li><li>Expose subscription status, billing history, and upgrade flows.</li><li>Add import/export for preferences and module layouts.</li><li>Integrate advanced privacy options (biometric lock, quick wipe).</li>"
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
        sync: "Sync-Modi",
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
          "Die modulare Produktivitäts-Suite für persönliche Planung, Wissenssammlung und sichere Synchronisierung auf allen Geräten.",
        ctaPrimary: "Module entdecken",
        ctaSecondary: "Wiki öffnen"
      },
      vision: {
        heading: "Warum Tracker?",
        body:
          "Tracker vereint Aufgaben, Notizen, Journal, Gewohnheiten, Finanzen und Zeiterfassung in einem Offline-First-Arbeitsbereich. Mit einer Mitgliedschaft schaltest du eine Ende-zu-Ende-verschlüsselte Synchronisation zwischen deinen Geräten frei.",
        cards: {
          offline: {
            title: "Offline zuerst",
            body: "Arbeite vollständig lokal ohne Account - ideal für Privatsphäre und unterwegs."
          },
          encrypted: {
            title: "Verschlüsselte Cloud",
            body: "Mitgliedschaften aktivieren Zero-Knowledge-Sync zwischen deinen Geräten; Konfliktmanagement steht auf der Roadmap."
          },
          modular: {
            title: "Modular & anpassbar",
            body: "Aktiviere nur die Module, die du brauchst, passe Farben an und bestimme die Reihenfolge."
          }
        }
      },
      modules: {
        heading: "Die Module im Überblick",
        dashboard: {
          title: "Dashboard",
          body: "Persönliches Cockpit mit Highlights aller Module.",
          list:
            "<li>Status-Karten aller Module auf einen Blick (verfügbar)</li><li>Schnellzugriff auf aktuelle Notizen, Aufgaben und Einträge (verfügbar)</li><li>Konfigurierbare Widgets und Layout (Roadmap)</li>"
        },
        tasks: {
          title: "Aufgaben & Termine",
          body: "Plane Aufgaben, Deadlines, Erinnerungen und Kalenderereignisse gemeinsam.",
          list:
            "<li>Aufgabenlisten plus Kalenderansicht mit hervorgehobenen Tagen (verfügbar)</li><li>Sortierung nach Fälligkeit, Priorität und Kategorie (verfügbar)</li><li>Zeiterfassung direkt aus Aufgaben starten (in Entwicklung)</li>"
        },
        notes: {
          title: "Notizen",
          body: "Flexibler Markdown-Wissensspeicher mit Zeichenunterstützung.",
          list:
            "<li>Markdown-Editor mit Live-Vorschau, Tags und Volltextsuche (verfügbar)</li><li>Freihand-Zeichnungen und Formen für visuelle Notizen (verfügbar)</li><li>Vorlagen, Multi-Tag-Filter und Backlinks (Roadmap)</li>"
        },
        journal: {
          title: "Journal & Mood Tracker",
          body: "Tägliche Reflexion mit geplantem Mood-Tracking und Highlights.",
          list:
            "<li>Tages- und Wochenansichten mit Stimmungsindikatoren (in Konzeption)</li><li>Verknüpfungen zu Notizen und Aufgaben (Roadmap)</li><li>Verschlüsselte Synchronisation zum Membership-Start (geplant)</li>"
        },
        habits: {
          title: "Habits",
          body: "Baue Routinen mit Serien, Zählern und Insights auf.",
          list:
            "<li>Tägliche oder wöchentliche Ziele mit flexiblen Einheiten verfolgen (verfügbar)</li><li>Historische Vergleiche und Serien-Analysen (verfügbar)</li><li>Geteilte Vorlagen und Empfehlungen (Roadmap)</li>"
        },
        ledger: {
          title: "Haushaltsbuch",
          body: "Behalte Ausgaben, Budgets und Reports im Blick.",
          list:
            "<li>Einnahmen und Ausgaben mit Kategorien erfassen (verfügbar)</li><li>Budget-vs.-Ist-Übersichten und Filter (verfügbar)</li><li>Diagramme und Backend-Sync-Integration (in Arbeit)</li>"
        },
        timeTracking: {
          title: "Zeiterfassung",
          body: "Erfasse Fokus-Sessions und verknüpfe sie mit Aufgaben.",
          list:
            "<li>Manuelle Eingabe und Timer für Sessions (verfügbar)</li><li>Tages- und Tag-basierte Auswertungen (verfügbar)</li><li>Intensivere Task-Integration und Exporte (Roadmap)</li>"
        },
        settings: {
          title: "Einstellungen",
          body: "Steuere Sprache, Theme, Module und Synchronisation.",
          list:
            "<li>Backend-Login für E-Mail, Google und Apple ID (verfügbar)</li><li>Sprach- und Theme-Voreinstellungen (in Entwicklung)</li><li>Modulsichtbarkeit und Sync-Steuerung (Roadmap)</li>"
        }
      },
      sync: {
        heading: "Lokal zuerst oder verschlüsselte Cloud",
        body:
          "Wähle den Modus, der zu deinem Datenschutz passt. Tracker funktioniert komplett offline; mit Mitgliedschaft kommt Zero-Knowledge-Sync.",
        local: {
          title: "Nur lokal",
          list:
            "<li>Alle Daten bleiben standardmäßig auf deinem Gerät</li><li>Kein Account nötig für den vollen Funktionsumfang</li><li>Ideal für sensible oder Offline-Workflows</li>"
        },
        cloud: {
          title: "Verschlüsselte Synchronisation",
          list:
            "<li>Ende-zu-Ende-Verschlüsselung mit Geräteschlüsseln</li><li>Zugriff auf Web, Desktop und Mobile</li><li>Mitgliedschaft geplant für 2 € pro Monat oder 20 € pro Jahr</li>"
        }
      },
      availability: {
        heading: "Verfügbarkeit & Downloads",
        web: {
          title: "Web-App",
          body: "Starte die Progressive Web App direkt im Browser.",
          link: "Jetzt öffnen"
        },
        playStore: {
          title: "Google Play Store",
          body: "Play-Store-Eintrag in Vorbereitung - folge der Roadmap für den Starttermin.",
          link: "Listing ansehen"
        },
        windows: {
          title: "Windows-Download",
          body: "Platzhalter-Build, während Packaging automatisiert wird.",
          link: "Download vorbereiten"
        },
        linux: {
          title: "Linux-Download",
          body: "Platzhalter-Build, während Packaging automatisiert wird.",
          link: "Download vorbereiten"
        }
      },
      roadmap: {
        heading: "Roadmap & aktueller Status",
        body: "Wir entwickeln in fokussierten Phasen, um das komplette Tracker-Erlebnis zu liefern.",
        phase1: {
          title: "Phase 1 - Fundament (abgeschlossen)",
          list:
            "<li>Flutter-App und Backend-Grundlage - abgeschlossen</li><li>Lokale Datenbank & Authentifizierung - abgeschlossen</li><li>Initiale Mehrsprachigkeit (DE/EN/SV) - abgeschlossen</li>"
        },
        phase2: {
          title: "Phase 2 - Module verfeinern (in Arbeit)",
          list:
            "<li>Aufgaben, Kalender und Benachrichtigungen vertiefen</li><li>Notiz-Features wie Vorlagen und Backlinks erweitern</li><li>Journal-Flows mit Mood-Tracking</li><li>Insights für Habits, Haushaltsbuch und Dashboard</li>"
        },
        phase3: {
          title: "Phase 3 - Synchronisation (anstehend)",
          list:
            "<li>Ende-zu-Ende-Verschlüsselung und Versionsverlauf</li><li>Workflows zur Konfliktauflösung</li><li>Mitgliedschaftszahlungen via PayPal und Bitcoin</li>"
        },
        phase4: {
          title: "Phase 4 - Launch & Plattformen (anstehend)",
          list:
            "<li>Plattform-Optimierung (Android, iOS, Web, Desktop)</li><li>CI/CD-Automatisierung und erweiterte Tests</li><li>Produktseite, Dokumentation und Onboarding</li>"
        }
      },
      footer: {
        title: "Tracker",
        body: "Produktivität neu gedacht - lokal, sicher, flexibel.",
        linksTitle: "Links",
        contactTitle: "Kontakt",
        contactEmail: "kontakt@tracker-app.dev",
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
          }
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
              "<li>Startansicht nach Login oder lokalem Start.</li><li>Zeigt Begrüßung, Systemhinweise und modulübergreifende Kennzahlen.</li><li>Schnellaktionen stoßen Backend-Aufrufe an und zeigen gespeicherte Antworten.</li><li>Das Leeren entfernt lokal gespeicherte Handshake-Daten.</li>"
          },
          data: {
            heading: "Datenmodell",
            list:
              "<li>Nutzt die Drift-Tabelle <code>greeting_entries</code> für Serverantworten.</li><li>Liest Hive-Boxes für Sprache, Theme und Modulpräferenzen.</li><li>Noch keine eigenen Sync-Entitäten; aggregierte KPIs sind geplant.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Begrüßungsdaten bleiben lokal für Debugging-Zwecke.</li><li>Mitgliedschaften zeigen künftig Kennzahlen aus synchronisierten Daten.</li><li>Widget-Layouts werden ab Phase 3 synchronisiert.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Echte Kennzahlen aus Tasks, Habits, Ledger und Journal einbinden.</li><li>Konfigurierbare Widgets, Größen und Drag-and-Drop-Layouts.</li><li>Mehrere Dashboards für verschiedene Kontexte unterstützen.</li>"
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
              "<li>Plane Aufgaben, Termine und Erinnerungen in einem Workspace.</li><li>Kalenderansicht hebt volle Tage und Fälligkeiten hervor.</li><li>Listen lassen sich nach Fälligkeit, Priorität und Kategorie sortieren.</li><li>Kategorien entstehen automatisch beim Anlegen neuer Einträge.</li><li>Zeiterfassung direkt aus Aufgaben starten (in Entwicklung).</li>"
          },
          data: {
            heading: "Datenmodell (geplant)",
            list:
              "<li>Kern-Tabellen: <code>tasks</code>, <code>appointments</code>, <code>categories</code>, <code>reminders</code>.</li><li>Relationen: <code>tasks</code> ↔ <code>time_entries</code> (1:n), Aufgaben ↔ Notizen (n:m geplant).</li><li>Kategorien als Referenzobjekte mit Farbe und Icon.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Offline vollständig nutzbar mit Drift/Hive-Speicherung.</li><li>Mitgliedschaften verschlüsseln Aufgaben, Termine, Erinnerungen und Kategorien.</li><li>Konflikte: Last-Write-Wins, Versionshistorie ist geplant.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Bearbeitungsdialog für Termine (Titel, Datum, Priorität, Kategorie) finalisieren.</li><li>Eigene Oberfläche für Kategoriemanagement und Farbauswahl.</li><li>Tiefergehende Zeiterfassungs-Workflows mit Timern.</li><li>Benachrichtigungen, Wiederholungen und smarte Vorschläge verbessern.</li>"
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
              "<li>Sessions manuell oder mit dem integrierten Timer erfassen.</li><li>Sessions Aufgaben zuordnen, um Ende-zu-Ende-Auswertungen zu erhalten.</li><li>Einträge taggen, Notizen ergänzen und Tagesverlauf prüfen.</li><li>Timer pausieren und fortsetzen, ohne Dauer zu verlieren.</li>"
          },
          data: {
            heading: "Datenmodell",
            list:
              "<li>Tabelle <code>time_entries</code> speichert Dauer, Start, Ende und optionale Task-Referenz.</li><li>Zwischentabelle <code>time_entry_tags</code> verknüpft mehrere Tags.</li><li>Tages- und Wochenaggregate werden on-the-fly berechnet.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Offline-first mit lokaler Persistenz.</li><li>Mitgliedschaften synchronisieren Entries und Tags geräteübergreifend.</li><li>Konfliktlösung führt überlappende Sessions anhand genauer Zeitstempel zusammen.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Timer direkt aus Task-Karten starten und stoppen.</li><li>Mehrfachbearbeitung und Tag-Bulk-Operationen ermöglichen.</li><li>Reports als CSV/JSON für Abrechnung und Analyse exportieren.</li><li>Trends mit Diagrammen und Heatmaps visualisieren.</li>"
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
              "<li>Markdown-Notizen mit Live-Vorschau und Split-View schreiben.</li><li>Die erste Zeile wird zum Titel; Erstell- und Änderungszeiten werden automatisch gepflegt.</li><li>Notizen taggen, nach Tags filtern und per Volltext suchen.</li><li>In den Freihandmodus wechseln für Skizzen, Diagramme und Wireframes.</li>"
          },
          data: {
            heading: "Datenmodell",
            list:
              "<li>Tabellen: <code>notes</code>, <code>note_tags</code> und Join-Tabelle <code>note_tag_links</code>.</li><li>Metadaten enthalten Zeitstempel und letzten Bearbeiter.</li><li>Zeichnungen werden als Vektoren mit optionaler PNG-Kopie gespeichert.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Notizen bleiben standardmäßig lokal für Privatsphäre und Offline-Nutzung.</li><li>Mitgliedschaften verschlüsseln Notiztexte, Zeichnungen und Anhänge.</li><li>Konfliktlösung hält beide Versionen bereit; ein Merge-Assistent ist geplant.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Onboarding-Notizen, die Kern-Workflows erklären.</li><li>Multi-Tag-Filter, gespeicherte Suchen und Notebook-Gruppierungen.</li><li>Vorlagen sowie Cross-Linking mit Aufgaben und Journal.</li><li>Bild-Einbettung mit lokaler Ablage und optionaler Sync-Unterstützung.</li>"
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
              "<li>Tägliche Reflexionen, Highlights und Herausforderungen erfassen.</li><li>Stimmungsscores mit Tags für Auslöser und Erfolge speichern.</li><li>Einträge mit Notizen, Aufgaben und Habit-Serien verknüpfen.</li><li>Tages-, Wochen- und Monatsverläufe helfen Trends zu erkennen.</li>"
          },
          data: {
            heading: "Datenmodell (in Planung)",
            list:
              "<li>Tabellen: <code>journal_entries</code>, <code>journal_moods</code> plus Join-Tabellen für Verknüpfungen.</li><li>Stimmungsskala 1-5 mit optionaler Emoji-Zuordnung.</li><li>Einträge speichern Freitext, Anhänge und geplanten Wetterkontext.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Einträge bleiben lokal, bis die verschlüsselte Sync startet.</li><li>Mitgliedschaften verschlüsseln Text, Anhänge und Stimmungsdaten Ende-zu-Ende.</li><li>Versionshistorie stellt sicher, dass Reflexionen beim Mergen erhalten bleiben.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Erste Journal-Oberfläche mit täglichen Prompts ausliefern.</li><li>Mood-Visualisierungen mit Serien und Trends ergänzen.</li><li>Korrelationen zwischen Stimmung, Habits und Zeiterfassung anzeigen.</li><li>Privaten Export nach PDF und Markdown ermöglichen.</li>"
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
              "<li>Routinen mit täglichen, wöchentlichen oder freien Intervallen definieren.</li><li>Erfolge mit Zählern, Timern oder einfachen Check-ins erfassen.</li><li>Serien visualisieren und Soll-Ist-Vergleiche anzeigen.</li><li>Unterbrechungen mit Notizen kommentieren, um später daraus zu lernen.</li>"
          },
          data: {
            heading: "Datenmodell",
            list:
              "<li>Tabellen: <code>habit_definitions</code>, <code>habit_entries</code> und <code>habit_targets</code>.</li><li>Einträge speichern Datum, Wert, optionale Dauer und Notiz.</li><li>Serienkennzahlen werden berechnet und fürs Dashboard zwischengespeichert.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Habits funktionieren offline mit automatischer Drift-Persistenz.</li><li>Mitgliedschaften mergen Einträge über Zeitstempel und erhalten Serien.</li><li>Konflikte behalten den höheren Erfüllungswert und protokollieren die Zusammenführung.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Geteilte Habit-Vorlagen und Empfehlungen.</li><li>Kalender-Heatmaps für den Monatsüberblick.</li><li>Automatisierungen, die Habits durch Tasks oder Zeiterfassung anstoßen.</li><li>Serien-Exporte für Accountability-Partner.</li>"
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
              "<li>Einnahmen und Ausgaben mit Kategorien und Zahlungsarten erfassen.</li><li>Budgets pro Kategorie setzen und den Fortschritt während des Monats tracken.</li><li>Nach Zeitraum, Tags und Konten filtern für gezielte Auswertungen.</li><li>Daten für Steuer oder Finanzreview exportieren (geplant).</li>"
          },
          data: {
            heading: "Datenmodell",
            list:
              "<li>Tabellen: <code>ledger_entries</code>, <code>ledger_categories</code>, <code>ledger_budgets</code>, <code>ledger_accounts</code>.</li><li>Einträge enthalten Betrag, Währung, Typ, Kategorie, Konto und optional Belegdaten.</li><li>Monatliche Rollups cachen Summen für schnellere Dashboards.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Lokales Haushaltsbuch hält Finanzdaten standardmäßig auf dem Gerät.</li><li>Verschlüsselte Sync ist optional für Mitgliedschaften mit Geräteschlüsseln.</li><li>Konflikte lösen sich über Betrag und Zeitstempel, Historie bleibt erhalten.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Interaktive Diagramme für Kategorien und Cashflow.</li><li>Wiederkehrende Buchungen und regelbasierte Kategorisierung.</li><li>Belegerfassung per Foto mit OCR (Recherche).</li><li>Geteilte Budgets für Haushaltsorganisation.</li>"
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
              "<li>Account-Login via E-Mail/Passwort, Google oder Apple ID verwalten.</li><li>Modulsichtbarkeit und Standard-Dashboards konfigurieren (geplant).</li><li>App-Sprache und Theme einstellen, sobald die UI-Schalter live sind.</li><li>Speicherverbrauch prüfen und lokale Backups anstoßen (Roadmap).</li>"
          },
          data: {
            heading: "Datenmodell",
            list:
              "<li>Präferenzen werden in Hive-Boxes für schnellen Offline-Zugriff gespeichert.</li><li>Account-Credentials laufen über sichere Backend-Auth-APIs.</li><li>Die kommende Tabelle <code>user_preferences</code> vereinheitlicht den Sync-Status.</li>"
          },
          sync: {
            heading: "Synchronisation",
            list:
              "<li>Sprache und Theme gelten lokal, bis der Multi-Device-Sync startet.</li><li>Mitgliedschaften synchronisieren Modulsichtbarkeit, Dashboards und Shortcuts.</li><li>Sicherheitskritische Einstellungen (2FA, Keys) bleiben ausschließlich serverseitig.</li>"
          },
          roadmap: {
            heading: "Roadmap",
            list:
              "<li>Vollständigen Sprach-/Theme-Switch in der App veröffentlichen.</li><li>Abostatus, Rechnungsverlauf und Upgrade-Flows darstellen.</li><li>Import/Export für Präferenzen und Modul-Layouts ergänzen.</li><li>Erweiterte Privatsphäre-Optionen (Biometrie, Schnell-Löschen) integrieren.</li>"
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
        sync: "Synklägen",
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
          "Den modulära produktivitetssviten för planering, kunskapsfångst och säker synkronisering på alla enheter.",
        ctaPrimary: "Utforska modulerna",
        ctaSecondary: "Öppna wikin"
      },
      vision: {
        heading: "Varför Tracker?",
        body:
          "Tracker förenar uppgifter, anteckningar, journal, vanor, ekonomi och tidrapportering i ett offline-först-arbetsflöde. Ett medlemskap låser upp änd-till-ände-krypterad synk mellan dina enheter.",
        cards: {
          offline: {
            title: "Offline först",
            body: "Arbeta helt lokalt utan konto – perfekt för integritet och resor."
          },
          encrypted: {
            title: "Krypterat moln",
            body: "Medlemskap aktiverar zero-knowledge-synk mellan enheter; konfliktlösning finns på färdplanen."
          },
          modular: {
            title: "Modulärt & anpassningsbart",
            body: "Aktivera bara de moduler du behöver, justera färgerna och bestäm ordningen."
          }
        }
      },
      modules: {
        heading: "Moduler i överblick",
        dashboard: {
          title: "Dashboard",
          body: "Personligt cockpit med höjdpunkter från alla moduler.",
          list:
            "<li>Statuskort från alla moduler på ett ögonblick (tillgängligt)</li><li>Snabbåtkomst till senaste anteckningar, uppgifter och poster (tillgängligt)</li><li>Konfigurerbara widgets och layout (färdplan)</li>"
        },
        tasks: {
          title: "Uppgifter & möten",
          body: "Planera uppgifter, deadlines, påminnelser och kalenderhändelser tillsammans.",
          list:
            "<li>Uppgiftslistor och kalendervy med markerade dagar (tillgängligt)</li><li>Sortering efter förfallodatum, prioritet och kategori (tillgängligt)</li><li>Tidtagning direkt från uppgifter (under utveckling)</li>"
        },
        notes: {
          title: "Anteckningar",
          body: "Flexibel Markdown-bas med stöd för ritningar.",
          list:
            "<li>Editor med liveförhandsvisning, taggar och fulltextsökning (tillgängligt)</li><li>Frihandsritningar och former för visuella anteckningar (tillgängligt)</li><li>Mallar, multi-tag-filter och bakåtlänkar (färdplan)</li>"
        },
        journal: {
          title: "Journal & humör",
          body: "Daglig reflektion med planerad humörspårning och höjdpunkter.",
          list:
            "<li>Dags- och veckovy med humörindikatorer (under design)</li><li>Länka poster till anteckningar och uppgifter (färdplan)</li><li>Krypterad synk när medlemskap lanseras (planerat)</li>"
        },
        habits: {
          title: "Vanor",
          body: "Bygg rutiner med serier, räknare och insikter.",
          list:
            "<li>Följ dagliga eller veckovisa mål med flexibla enheter (tillgängligt)</li><li>Historiska jämförelser och serieanalys (tillgängligt)</li><li>Delade mallar och rekommendationer (färdplan)</li>"
        },
        ledger: {
          title: "Hushållsbok",
          body: "Håll koll på utgifter, budgetar och rapporter.",
          list:
            "<li>Registrera inkomster och utgifter med kategorier (tillgängligt)</li><li>Budget vs. utfall med filter (tillgängligt)</li><li>Diagram och backend-synk (pågår)</li>"
        },
        timeTracking: {
          title: "Tidrapportering",
          body: "Mät fokustillfällen och koppla dem till uppgifter.",
          list:
            "<li>Manuell registrering och timers för pass (tillgängligt)</li><li>Dags- och taggbaserade sammanställningar (tillgängligt)</li><li>Djupare uppgiftsintegration och exporter (färdplan)</li>"
        },
        settings: {
          title: "Inställningar",
          body: "Styr språk, tema, moduler och synk.",
          list:
            "<li>Backend-inloggning för e-post, Google och Apple ID (tillgängligt)</li><li>Språk- och temapreferenser (under utveckling)</li><li>Synlighet för moduler och synkstyrning (färdplan)</li>"
        }
      },
      sync: {
        heading: "Lokal först eller krypterat moln",
        body:
          "Välj läget som passar din integritet. Tracker fungerar fullt ut offline medan medlemskap ger zero-knowledge-synk.",
        local: {
          title: "Endast lokalt",
          list:
            "<li>All data stannar på din enhet som standard</li><li>Inget konto krävs för hela funktionsuppsättningen</li><li>Perfekt för känsliga eller offline-flöden</li>"
        },
        cloud: {
          title: "Krypterad synk",
          list:
            "<li>Änd-till-ände-kryptering med enhetsspecifika nycklar</li><li>Åtkomst via mobil, desktop och webb</li><li>Medlemskap planeras till 2 €/månad eller 20 €/år</li>"
        }
      },
      availability: {
        heading: "Tillgänglighet & nedladdningar",
        web: {
          title: "Webbapp",
          body: "Starta den progressiva webbappen direkt i webbläsaren.",
          link: "Öppna nu"
        },
        playStore: {
          title: "Google Play Store",
          body: "Play Store-listningen förbereds – följ färdplanen för lanseringsdatum.",
          link: "Förhandsgranska"
        },
        windows: {
          title: "Windows-nedladdning",
          body: "Platshållarbuild medan paketering automatiseras.",
          link: "Förbered nedladdning"
        },
        linux: {
          title: "Linux-nedladdning",
          body: "Platshållarbuild medan paketering automatiseras.",
          link: "Förbered nedladdning"
        }
      },
      roadmap: {
        heading: "Färdplan & nuläge",
        body: "Vi levererar Tracker i fokuserade faser för att nå helheten.",
        phase1: {
          title: "Fas 1 - Grund (klar)",
          list:
            "<li>Flutter-app och backend-grund - klart</li><li>Lokal databas & autentisering - klart</li><li>Initial flerspråkighet (DE/EN/SV) - klart</li>"
        },
        phase2: {
          title: "Fas 2 - Förfina moduler (pågår)",
          list:
            "<li>Fördjupa uppgifter, kalender och notiser</li><li>Utöka anteckningsfunktioner med mallar och bakåtlänkar</li><li>Journalflöden med humörspårning</li><li>Insikter för vanor, hushållsbok och dashboard</li>"
        },
        phase3: {
          title: "Fas 3 - Synkronisering (kommer)",
          list:
            "<li>Änd-till-ände-kryptering och versionshistorik</li><li>Arbetsflöden för konfliktlösning</li><li>Medlemsbetalningar via PayPal och Bitcoin</li>"
        },
        phase4: {
          title: "Fas 4 - Lansering & plattformar (kommer)",
          list:
            "<li>Plattformsoptimering (Android, iOS, webb, desktop)</li><li>CI/CD-automation och utökad testning</li><li>Produktsajt, dokumentation och onboarding</li>"
        }
      },
      footer: {
        title: "Tracker",
        body: "Produktivitet på nytt sätt – lokal, säker, flexibel.",
        linksTitle: "Länkar",
        contactTitle: "Kontakt",
        contactEmail: "kontakt@tracker-app.dev",
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
          }
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
              "<li>Hantera kontoinloggning via e-post/lösenord, Google eller Apple ID.</li><li>Konfigurera modulernas synlighet och standarddashboards (planerat).</li><li>Välj appens språk och tema när reglagen lanseras.</li><li>Granska lagringsanvändning och initiera lokala säkerhetskopior (färdplan).</li>"
          },
          data: {
            heading: "Datamodell",
            list:
              "<li>Preferenser lagras i Hive-boxar för snabb offline-åtkomst.</li><li>Kontouppgifter hanteras via säkra backend-API:er.</li><li>Den kommande tabellen <code>user_preferences</code> samlar synkstatus.</li>"
          },
          sync: {
            heading: "Synkronisering",
            list:
              "<li>Språk och tema gäller lokalt tills synk över flera enheter finns.</li><li>Medlemskap synkar modulernas synlighet, dashboards och genvägar.</li><li>Säkerhetskritiska inställningar (2FA, nycklar) ligger endast server-side.</li>"
          },
          roadmap: {
            heading: "Färdplan",
            list:
              "<li>Lansera fullständigt språk- och temabyte i appen.</li><li>Visa abonnemangsstatus, fakturahistorik och uppgraderingsflöden.</li><li>Lägg till import/export av preferenser och modulayout.</li><li>Integrera avancerade sekretessalternativ (biometriskt lås, snabb rensning).</li>"
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
