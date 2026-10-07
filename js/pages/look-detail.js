import { getState, toggleFavorite } from "../state.js";
import { resolveLookItems } from "../data/mock.js";
import { categoryLabel, escapeHtml, statusBadge, swatch } from "../ui.js";
import { navigate } from "../router.js";

export function renderLookDetail(root, params) {
  const id = params[1];
  const look = getState().looks.find((l) => l.id === id);
  if (!look) {
    root.innerHTML = `<div class="page"><p>Look introuvable.</p></div>`;
    return;
  }

  const items = resolveLookItems(look);
  let selected = null;

  function paint() {
    root.innerHTML = `
      <div class="page">
        <button class="back-btn" type="button" id="back">← Retour</button>
        <p class="page-kicker">${escapeHtml(look.occasion)}</p>
        <h1 class="page-title">${escapeHtml(look.name)}</h1>
        <p class="muted" style="margin-top:6px">${escapeHtml(look.style)}</p>
        <div class="score-ring" style="margin-top:12px">${look.score}% compatible avec ton style</div>

        <div class="outfit-pieces" id="pieces">
          ${items
            .map(
              (item, i) => `
              ${i > 0 ? `<div class="plus-sep">+</div>` : ""}
              <button class="outfit-piece ${selected === item.id ? "is-selected" : ""}" type="button" data-piece="${item.id}">
                <div class="outfit-piece-thumb">${swatch(item.colors)}</div>
                <div>
                  <div class="outfit-piece-name">${escapeHtml(item.name)}</div>
                  <div class="outfit-piece-meta">${categoryLabel(item.category)} · ${escapeHtml(item.color)}</div>
                  <div style="margin-top:6px">${statusBadge(item.status)}</div>
                </div>
                <span class="muted">›</span>
              </button>`
            )
            .join("")}
        </div>

        <div class="btn-row">
          <button class="btn btn-primary" type="button" id="fav">${look.favorite ? "♥ Dans les favoris" : "♡ Ajouter aux favoris"}</button>
          <button class="btn btn-secondary" type="button" id="edit">Modifier la tenue</button>
          <button class="btn btn-ghost" type="button" id="regen">✦ Générer une autre tenue</button>
        </div>
      </div>
    `;

    root.querySelector("#back").onclick = () => history.back();
    root.querySelector("#fav").onclick = () => {
      toggleFavorite(look.id);
      paint();
    };
    root.querySelector("#edit").onclick = () => {
      alert("Prototype : tu pourras remplacer chaque pièce individuellement.");
    };
    root.querySelector("#regen").onclick = () => navigate("/habille-moi");
    root.querySelectorAll("[data-piece]").forEach((btn) => {
      btn.onclick = () => {
        selected = btn.dataset.piece;
        paint();
        setTimeout(() => navigate(`/vetement/${selected}`), 180);
      };
    });
  }

  paint();
}
