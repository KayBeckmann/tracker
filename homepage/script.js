(function () {
    const root = document.documentElement;
    const toggle = document.getElementById('themeToggle');
    const navLinks = document.querySelectorAll('.main-nav a');
    const wikiTabs = document.querySelectorAll('.wiki-tab');
    const wikiPanels = document.querySelectorAll('.wiki-panel');
    const searchInput = document.getElementById('wikiSearch');
    const wikiItems = document.querySelectorAll('.wiki-list li');
    const footerYear = document.getElementById('year');

    const storedTheme = localStorage.getItem('tracker-theme');
    if (storedTheme === 'dark') {
        root.classList.add('dark');
    }

    if (footerYear) {
        footerYear.textContent = String(new Date().getFullYear());
    }

    if (toggle) {
        toggle.addEventListener('click', () => {
            const isDark = root.classList.toggle('dark');
            localStorage.setItem('tracker-theme', isDark ? 'dark' : 'light');
        });
    }

    const observer = new IntersectionObserver(
        entries => {
            entries.forEach(entry => {
                const id = entry.target.getAttribute('id');
                const navLink = document.querySelector(`.main-nav a[href="#${id}"]`);
                if (!navLink) {
                    return;
                }
                if (entry.isIntersecting) {
                    navLinks.forEach(link => link.classList.remove('active'));
                    navLink.classList.add('active');
                }
            });
        },
        {
            threshold: 0.4,
        }
    );

    document.querySelectorAll('section[id]').forEach(section => observer.observe(section));

    wikiTabs.forEach(tab => {
        tab.addEventListener('click', () => {
            const target = tab.getAttribute('data-target');
            if (!target) {
                return;
            }
            wikiTabs.forEach(t => {
                t.classList.toggle('active', t === tab);
                t.setAttribute('aria-selected', String(t === tab));
            });
            wikiPanels.forEach(panel => {
                const isActive = panel.id === target;
                panel.classList.toggle('active', isActive);
                panel.toggleAttribute('hidden', !isActive);
            });
        });
    });

    if (searchInput) {
        const filterWiki = () => {
            const query = searchInput.value.trim().toLowerCase();
            wikiItems.forEach(item => {
                const text = item.textContent || '';
                const tags = item.getAttribute('data-tags') || '';
                const match = text.toLowerCase().includes(query) || tags.toLowerCase().includes(query);
                item.style.display = match ? '' : 'none';
            });
        };
        searchInput.addEventListener('input', filterWiki);
    }
})();
