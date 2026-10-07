import { getState } from "../state.js";
import { resolveLookItems } from "../data/mock.js";
import { swatch, escapeHtml } from "../ui.js";
import { lookCard, bindLookCards } from "../components/cards.js";
import { navigate } from "../router.js";

export function renderHome(root) {
  const { profile, weather, looks } = getState();
  const lookOfDay = looks.find((l) => l.id === "l01") || looks[0];
  const pieces = resolveLookItems(lookOfDay);
  const favorites = looks.filter((l) => l.favorite).slice(0, 4);

  root.innerHTML = `
    <div class="page home-hero">
      <p class="page-kicker">Aujourd'hui</p>
      <h1 class="home-hello">Bonjour <em>${escapeHtml(profile.firstName)}</em></h1>
      <div class="weather-pill">${weather.temp}°C · ${escapeHtml(weather.label)}</div>

      <section class="outfit-hero anim-rise">
        <div class="outfit-hero-visual">
          ${pieces
            .slice(0, 4)
            .map((p) => `<div class="piece">${swatch(p.colors, p.category)}</div>`)
            .join("")}
        </div>
        <div class="outfit-hero-body">
          <p class="page-kicker">Ton look du jour</p>
          <h2>${escapeHtml(lookOfDay.name)}</h2>
          <p class="look-card-meta" style="margin-top:6px">${escapeHtml(lookOfDay.style)}</p>
          <div class="score-ring" style="margin-top:10px">${lookOfDay.score}% de compatibilité</div>
          <div class="outfit-hero-actions">
            <button class="btn btn-primary" type="button" id="cta-style">Habille-moi</button>
            <button class="btn btn-ghost" type="button" id="cta-look">Voir la tenue</button>
          </div>
        </div>
      </section>

      <section class="section">
        <div class="section-head">
          <h3 class="section-title">Pour aujourd'hui</h3>
        </div>
        <div class="occasion-grid">
          ${occasionTile("Journée normale", "Quotidien", "look")}
          ${occasionTile("Sortie", "Sortie", "moon")}
          ${occasionTile("Travail", "Travail", "brief")}
          ${occasionTile("Soirée", "Soirée", "spark")}
        </div>
      </section>

      <section class="section">
        <div class="section-head">
          <h3 class="section-title">Tes favoris</h3>
          <button class="section-link" type="button" id="to-looks">Voir tout</button>
        </div>
        <div class="look-scroll" id="home-favs">
          ${favorites.map((l) => lookCard(l, { compact: true })).join("")}
        </div>
      </section>

      <section class="section">
        <div class="section-head">
          <h3 class="section-title">Dressing</h3>
          <button class="section-link" type="button" id="to-dressing">Ouvrir</button>
        </div>
        <div class="clothing-grid" id="home-clothes">
          ${getState()
            .clothes.slice(0, 4)
            .map((c, i) => `
              <button class="clothing-card" type="button" data-c="${c.id}" style="animation-delay:${i * 0.05}s">
                <div class="clothing-card-media">${swatch(c.colors)}</div>
                <div class="clothing-card-body">
                  <div class="clothing-card-name">${escapeHtml(c.name)}</div>
                  <div class="clothing-card-meta">${escapeHtml(c.color)}</div>
                </div>
              </button>`)
            .join("")}
        </div>
      </section>
    </div>
  `;

  root.querySelector("#cta-style").onclick = () => navigate("/habille-moi");
  root.querySelector("#cta-look").onclick = () => navigate(`/look/${lookOfDay.id}`);
  root.querySelector("#to-looks").onclick = () => navigate("/looks");
  root.querySelector("#to-dressing").onclick = () => navigate("/dressing");

  root.querySelectorAll("[data-occasion]").forEach((btn) => {
    btn.onclick = () => navigate("/habille-moi");
  });

  root.querySelectorAll("[data-c]").forEach((btn) => {
    btn.onclick = () => navigate(`/vetement/${btn.dataset.c}`);
  });

  bindLookCards(root.querySelector("#home-favs"), () => renderHome(root));
}

function occasionTile(label, occasion, kind) {
  const icons = {
    look: "◎",
    moon: "◐",
    brief: "▢",
    spark: "✧",
  };
  return `
    <button class="occasion-tile" type="button" data-occasion="${occasion}">
      <span class="occasion-icon">${icons[kind]}</span>
      <span>
        <span class="label">${label}</span>
        <span class="hint" style="display:block;margin-top:4px">Suggérer une tenue</span>
      </span>
    </button>
  `;
}
