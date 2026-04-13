// ── Typewriter ────────────────────────────────────────────────────────
(function(){
  const el = document.getElementById('typewriter-text');
  if (!el) return;
  const phrases = ['Penetration Tester', 'HTB Enthusiast', 'Red Team Operator', 'Security Researcher', 'Bug Hunter'];
  let pi = 0, ci = 0, deleting = false;
  function tick() {
    const word = phrases[pi];
    if (!deleting) {
      el.textContent = word.slice(0, ++ci);
      if (ci === word.length) { deleting = true; setTimeout(tick, 1800); return; }
    } else {
      el.textContent = word.slice(0, --ci);
      if (ci === 0) { deleting = false; pi = (pi + 1) % phrases.length; }
    }
    setTimeout(tick, deleting ? 50 : 80);
  }
  tick();
})();

// ── Counter Animation ─────────────────────────────────────────────────
(function(){
  const counters = document.querySelectorAll('.stat-number');
  const observer = new IntersectionObserver(entries => {
    entries.forEach(e => {
      if (!e.isIntersecting) return;
      const el = e.target;
      const target = parseInt(el.dataset.target);
      let current = 0;
      const step = Math.ceil(target / 30);
      const t = setInterval(() => {
        current = Math.min(current + step, target);
        el.textContent = current;
        if (current >= target) clearInterval(t);
      }, 40);
      observer.unobserve(el);
    });
  }, { threshold: 0.5 });
  counters.forEach(c => observer.observe(c));
})();

// ── Tool card reactive glow on hover ─────────────────────────────────
(function(){
  document.querySelectorAll('.tool-card').forEach(card => {
    card.addEventListener('mousemove', e => {
      const r = card.getBoundingClientRect();
      const x = e.clientX - r.left;
      const y = e.clientY - r.top;
      card.style.setProperty('--mx', x + 'px');
      card.style.setProperty('--my', y + 'px');
    });
  });
})();
