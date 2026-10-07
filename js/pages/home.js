import { getState } from "../state.js";
import { resolveLookItems } from "../data/mock.js";
import { escapeHtml, swatch } from "../ui.js";
import { lookCard, bindLookCards } from "../components/cards.js";
import { navigate } from "../router.js";

export function renderHome(root) {
  const { profile, weather, looks, inspirations, clothes } = getState();
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
          ${occasionTile("Journée normale", "Quotidien", "◎")}
          ${occasionTile("Sortie", "Sortie", "◐")}
          ${occasionTile("Travail", "Travail", "▢")}
          ${occasionTile("Soirée", "Soirée", "✧")}
        </div>
      </section>

      <section class="section">
        <div class="section-head">
          <h3 class="section-title">Tes dernières inspirations</h3>
          <button class="section-link" type="button" id="to-inspire">Voir tout</button>
        </div>
        <div class="inspire-scroll">
          ${inspirations
            .map(
              (insp, i) => `
            <button class="inspire-card" type="button" data-inspire="${insp.id}" style="animation-delay:${i * 0.05}s">
              ${swatch(insp.colors)}
              <span class="inspire-card-caption">${escapeHtml(insp.title)}</span>
            </button>`
            )
            .join("")}
        </div>
      </section>

      <section class="section">
        <div class="section-head">
          <h3 class="section-title">Tes favoris</h3>
          <button class="section-link" type="button" id="to-looks">Voir tout</button>
        </div>
        <div class="looks-list" id="home-favs">
          ${favorites.slice(0, 2).map((l) => lookCard(l, { full: true })).join("")}
        </div>
      </section>

      <section class="section">
        <div class="section-head">
          <h3 class="section-title">Dressing</h3>
          <button class="section-link" type="button" id="to-dressing">Ouvrir</button>
        </div>
        <div class="clothing-grid">
          ${clothes
            .slice(0, 4)
            .map(
              (c, i) => `
              <button class="clothing-card" type="button" data-c="${c.id}" style="animation-delay:${i * 0.05}s">
                <div class="clothing-card-media">${swatch(c.colors)}</div>
                <div class="clothing-card-body">
                  <div class="clothing-card-name">${escapeHtml(c.name)}</div>
                  <div class="clothing-card-meta">${escapeHtml(c.color)}</div>
                </div>
              </button>`
            )
            .join("")}
        </div>
      </section>
    </div>
  `;

  root.querySelector("#cta-style").onclick = () => navigate("/habille-moi");
  root.querySelector("#cta-look").onclick = () => navigate(`/look/${lookOfDay.id}`);
  root.querySelector("#to-looks").onclick = () => navigate("/looks");
  root.querySelector("#to-dressing").onclick = () => navigate("/dressing");
  root.querySelector("#to-inspire").onclick = () => navigate("/inspiration");

  root.querySelectorAll("[data-occasion]").forEach((btn) => {
    btn.onclick = () => navigate("/habille-moi");
  });

  root.querySelectorAll("[data-c]").forEach((btn) => {
    btn.onclick = () => navigate(`/vetement/${btn.dataset.c}`);
  });

  root.querySelectorAll("[data-inspire]").forEach((btn) => {
    btn.onclick = () => navigate("/inspiration");
  });

  bindLookCards(root.querySelector("#home-favs"), () => renderHome(root));
}

function occasionTile(label, occasion, icon) {
  return `
    <button class="occasion-tile" type="button" data-occasion="${occasion}">
      <span class="occasion-icon">${icon}</span>
      <span>
        <span class="label">${label}</span>
        <span class="hint" style="display:block;margin-top:4px">Suggérer une tenue</span>
      </span>
    </button>
  `;
}
