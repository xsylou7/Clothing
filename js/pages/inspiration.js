import { getState } from "../state.js";
import { escapeHtml, swatch } from "../ui.js";

export function renderInspiration(root) {
  const { inspirations } = getState();

  root.innerHTML = `
    <div class="page">
      <p class="page-kicker">Moodboard</p>
      <h1 class="page-title">Inspiration</h1>

      <div class="inspire-cta anim-rise" style="margin-top:20px">
        <p class="page-kicker" style="color:rgba(244,245,247,.5)">Bientôt</p>
        <h2>Une tenue que tu aimes&nbsp;?</h2>
        <p>Ajoute une photo — VESTIA analysera le look et proposera de le recréer avec ton dressing.</p>
        <button class="btn btn-secondary" type="button" id="add-inspire" style="background:#f4f5f7;color:#101114;border:none">+ Ajouter une inspiration</button>
      </div>

      <section class="section">
        <div class="section-head">
          <h3 class="section-title">Tes inspirations</h3>
        </div>
        <div class="inspire-grid">
          ${inspirations
            .map(
              (insp, i) => `
            <button class="inspire-card" type="button" style="flex:none;animation: rise-in .5s var(--ease) both; animation-delay:${i * 0.05}s">
              ${swatch(insp.colors)}
              <span class="inspire-card-caption">${escapeHtml(insp.title)}</span>
            </button>`
            )
            .join("")}
        </div>
      </section>

      <div class="recreate-banner">
        <h3>Recréer avec mon dressing</h3>
        <p>Prototype : cette fonctionnalité simulera bientôt une correspondance pièce par pièce.</p>
        <button class="btn btn-secondary" type="button" id="recreate">Essayer (démo)</button>
      </div>
    </div>
  `;

  root.querySelector("#add-inspire").onclick = () => {
    alert("Prototype : l'ajout d'inspiration photo arrivera plus tard.");
  };
  root.querySelector("#recreate").onclick = () => {
    alert("Prototype : VESTIA proposera des équivalents depuis ton dressing.");
  };
}
