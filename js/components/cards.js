import { STATUS } from "../data/mock.js";
import { categoryLabel, escapeHtml, heartIcon, statusBadge, swatch } from "../ui.js";
import { navigate } from "../router.js";
import { toggleFavorite } from "../state.js";
import { resolveLookItems } from "../data/mock.js";

export function clothingCard(item, index = 0) {
  return `
    <button class="clothing-card" type="button" data-clothing-id="${item.id}" style="animation-delay:${index * 0.04}s">
      <div class="clothing-card-media">${swatch(item.colors, item.color)}</div>
      <div class="clothing-card-body">
        <div class="clothing-card-name">${escapeHtml(item.name)}</div>
        <div class="clothing-card-meta">${categoryLabel(item.category)} · ${escapeHtml(item.color)}</div>
        ${statusBadge(item.status)}
      </div>
    </button>
  `;
}

export function bindClothingCards(root) {
  root.querySelectorAll("[data-clothing-id]").forEach((btn) => {
    btn.addEventListener("click", () => navigate(`/vetement/${btn.dataset.clothingId}`));
  });
}

export function lookCard(look, { compact = false, full = false } = {}) {
  const items = resolveLookItems(look).slice(0, 4);
  const pieces = items
    .map((item) => `<div class="piece">${swatch(item.colors)}</div>`)
    .join("");

  const cls = ["look-card", compact && "compact", full && "full"].filter(Boolean).join(" ");

  return `
    <article class="${cls}" data-look-id="${look.id}">
      <button type="button" class="look-card-stack" data-open-look="${look.id}" aria-label="Voir ${escapeHtml(look.name)}">
        ${pieces}
      </button>
      <div class="look-card-body">
        <div class="look-card-top">
          <div>
            <div class="look-card-name">${escapeHtml(look.name)}</div>
            <div class="look-card-meta">${escapeHtml(look.style)} · ${escapeHtml(look.occasion)}</div>
            <div class="look-score">${look.score}% de compatibilité</div>
          </div>
          <button class="fav-btn ${look.favorite ? "is-on" : ""}" type="button" data-fav="${look.id}" aria-label="Favori">
            ${heartIcon(look.favorite)}
          </button>
        </div>
      </div>
    </article>
  `;
}

export function bindLookCards(root, onFavChange) {
  root.querySelectorAll("[data-open-look]").forEach((btn) => {
    btn.addEventListener("click", () => navigate(`/look/${btn.dataset.openLook}`));
  });
  root.querySelectorAll("[data-fav]").forEach((btn) => {
    btn.addEventListener("click", (e) => {
      e.stopPropagation();
      const id = btn.dataset.fav;
      toggleFavorite(id);
      btn.classList.add("pop");
      onFavChange?.();
    });
  });
}

export function statusOptions(current) {
  return Object.values(STATUS)
    .map(
      (s) => `
      <button class="status-option ${current === s.id ? "is-active" : ""}" type="button" data-status="${s.id}">
        <span class="status-badge ${s.className}"><span class="status-dot"></span>${s.label}</span>
      </button>`
    )
    .join("");
}
