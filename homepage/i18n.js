(() => {
  const DEFAULT_LANG = "en";
  const SUPPORTED_LANGS = ["en", "de", "sv"];
  const STORAGE_KEY = "tracker-preferred-language";

  const translations =
    (typeof window !== "undefined" && window.TRACKER_TRANSLATIONS) || {};

  const getNestedTranslation = (lang, key) => {
    const segments = key.split(".");
    let value = translations[lang];

    for (const segment of segments) {
      if (!value || typeof value !== "object") {
        return undefined;
      }
      value = value[segment];
    }
    return typeof value === "string" ? value : undefined;
  };

  const resolveTranslation = (key, lang) => {
    if (!key) {
      return undefined;
    }
    const normalizedLang = SUPPORTED_LANGS.includes(lang) ? lang : DEFAULT_LANG;
    return (
      getNestedTranslation(normalizedLang, key) ??
      getNestedTranslation(DEFAULT_LANG, key) ??
      ""
    );
  };

  const applyTranslations = (lang) => {
    document.querySelectorAll("[data-i18n]").forEach((element) => {
      const key = element.getAttribute("data-i18n");
      const translation = resolveTranslation(key, lang);
      if (translation) {
        element.textContent = translation;
      }
    });

    document.querySelectorAll("[data-i18n-html]").forEach((element) => {
      const key = element.getAttribute("data-i18n-html");
      const translation = resolveTranslation(key, lang);
      if (translation) {
        element.innerHTML = translation;
      }
    });

    document.querySelectorAll("[data-i18n-placeholder]").forEach((element) => {
      const key = element.getAttribute("data-i18n-placeholder");
      const translation = resolveTranslation(key, lang);
      if (translation) {
        element.setAttribute("placeholder", translation);
      }
    });

    const htmlElement = document.documentElement;
    htmlElement.setAttribute(
      "lang",
      SUPPORTED_LANGS.includes(lang) ? lang : DEFAULT_LANG
    );
  };

  const updateActiveLanguage = (lang) => {
    document
      .querySelectorAll("[data-lang]")
      .forEach((button) => button.classList.remove("is-active-lang"));

    document
      .querySelectorAll(`[data-lang="${lang}"]`)
      .forEach((button) => button.classList.add("is-active-lang"));
  };

  const persistLanguage = (lang) => {
    try {
      localStorage.setItem(STORAGE_KEY, lang);
    } catch (error) {
      console.warn("Unable to persist language preference:", error);
    }
  };

  const getInitialLanguage = () => {
    const persisted = (() => {
      try {
        return localStorage.getItem(STORAGE_KEY);
      } catch {
        return null;
      }
    })();

    if (persisted && SUPPORTED_LANGS.includes(persisted)) {
      return persisted;
    }

    const browserLang = navigator.language?.slice(0, 2);
    if (browserLang && SUPPORTED_LANGS.includes(browserLang)) {
      return browserLang;
    }

    return DEFAULT_LANG;
  };

  const setLanguage = (lang) => {
    const normalizedLang = SUPPORTED_LANGS.includes(lang) ? lang : DEFAULT_LANG;
    applyTranslations(normalizedLang);
    updateActiveLanguage(normalizedLang);
    persistLanguage(normalizedLang);
  };

  const handleLanguageSwitch = (event) => {
    const { lang } = event.currentTarget.dataset;
    setLanguage(lang);
  };

  const wireLanguageSwitchers = () => {
    document
      .querySelectorAll("[data-lang]")
      .forEach((button) =>
        button.addEventListener("click", handleLanguageSwitch)
      );
  };

  document.addEventListener("DOMContentLoaded", () => {
    const initialLang = getInitialLanguage();
    applyTranslations(initialLang);
    updateActiveLanguage(initialLang);
    wireLanguageSwitchers();
  });

  window.trackerI18n = {
    setLanguage,
    get language() {
      return document.documentElement.getAttribute("lang") ?? DEFAULT_LANG;
    },
    get translations() {
      return translations;
    },
  };
})();
