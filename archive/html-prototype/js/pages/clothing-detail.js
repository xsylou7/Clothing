import { getState, setClothingStatus, updateClothing } from "../state.js";
import { categoryLabel, escapeHtml, statusBadge, swatch } from "../ui.js";
import { statusOptions } from "../components/cards.js";
import { CATEGORIES } from "../data/mock.js";

export function renderClothingDetail(root, params) {
  const id = params[1];
  const item = getState().clothes.find((c) => c.id === id);
  if (!item) {
    root.innerHTML = `<div class="page"><p>Vêtement introuvable.</p></div>`;
    return;
  }

  let editing = false;

  function paint() {
    const cats = CATEGORIES.filter((c) => c.id !== "all");

    root.innerHTML = `
      <div class="page">
        <button class="back-btn" type="button" id="back">← Retour</button>
        <div class="detail-media">${swatch(item.colors, item.color)}</div>
        <h1 class="detail-title">${escapeHtml(item.name)}</h1>
        <div style="margin-bottom:16px">${statusBadge(item.status)}</div>

        ${
          editing
            ? `
          <form id="edit-form">
            <div class="field"><label>Nom</label><input name="name" value="${escapeHtml(item.name)}" /></div>
            <div class="field"><label>Catégorie</label>
              <select name="category">
                ${cats.map((c) => `<option value="${c.id}" ${item.category === c.id ? "selected" : ""}>${c.label}</option>`).join("")}
              </select>
            </div>
            <div class="field"><label>Couleur</label><input name="color" value="${escapeHtml(item.color)}" /></div>
            <div class="field"><label>Style</label><input name="style" value="${escapeHtml(item.style)}" /></div>
            <div class="field"><label>Saison</label><input name="seasons" value="${escapeHtml(item.seasons.join(" · "))}" /></div>
            <div class="field"><label>Marque</label><input name="brand" value="${escapeHtml(item.brand || "")}" /></div>
            <div class="field"><label>Taille</label><input name="size" value="${escapeHtml(item.size || "")}" /></div>
            <div class="field"><label>Notes</label><textarea name="notes">${escapeHtml(item.notes || "")}</textarea></div>
            <div class="btn-row two">
              <button class="btn btn-ghost" type="button" id="cancel">Annuler</button>
              <button class="btn btn-primary" type="submit">Enregistrer</button>
            </div>
          </form>`
            : `
          <div class="meta-grid">
            <div class="meta-cell"><div class="k">Catégorie</div><div class="v">${categoryLabel(item.category)}</div></div>
            <div class="meta-cell"><div class="k">Couleur</div><div class="v">${escapeHtml(item.color)}</div></div>
            <div class="meta-cell"><div class="k">Style</div><div class="v">${escapeHtml(item.style)}</div></div>
            <div class="meta-cell"><div class="k">Saison</div><div class="v">${escapeHtml(item.seasons.join(" · "))}</div></div>
            <div class="meta-cell"><div class="k">Marque</div><div class="v">${escapeHtml(item.brand || "—")}</div></div>
            <div class="meta-cell"><div class="k">Taille</div><div class="v">${escapeHtml(item.size || "—")}</div></div>
          </div>
          ${item.notes ? `<p class="muted" style="margin-bottom:16px">${escapeHtml(item.notes)}</p>` : ""}
          <button class="btn btn-secondary" type="button" id="edit">Modifier les infos</button>`
        }

        <section class="section">
          <div class="section-head"><h3 class="section-title">Modifier le statut</h3></div>
          <div class="status-picker" id="status-picker">
            ${statusOptions(item.status)}
          </div>
        </section>
      </div>
    `;

    root.querySelector("#back").onclick = () => history.back();

    root.querySelector("#edit")?.addEventListener("click", () => {
      editing = true;
      paint();
    });
    root.querySelector("#cancel")?.addEventListener("click", () => {
      editing = false;
      paint();
    });
    root.querySelector("#edit-form")?.addEventListener("submit", (e) => {
      e.preventDefault();
      const fd = new FormData(e.target);
      updateClothing(item.id, {
        name: fd.get("name"),
        category: fd.get("category"),
        color: fd.get("color"),
        style: fd.get("style"),
        seasons: String(fd.get("seasons"))
          .split("·")
          .map((s) => s.trim())
          .filter(Boolean),
        brand: fd.get("brand"),
        size: fd.get("size"),
        notes: fd.get("notes"),
      });
      editing = false;
      paint();
    });

    root.querySelectorAll("[data-status]").forEach((btn) => {
      btn.onclick = () => {
        setClothingStatus(item.id, btn.dataset.status);
        paint();
      };
    });
  }

  paint();
}
