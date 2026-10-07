import { CATEGORIES } from "../data/mock.js";
import { getState, setDressingFilter } from "../state.js";
import { clothingCard, bindClothingCards } from "../components/cards.js";
import { navigate } from "../router.js";

export function renderDressing(root) {
  const { clothes, dressingFilter } = getState();
  const filtered =
    dressingFilter === "all"
      ? clothes
      : clothes.filter((c) => c.category === dressingFilter);

  root.innerHTML = `
    <div class="page">
      <p class="page-kicker">Garde-robe</p>
      <h1 class="page-title">Dressing</h1>
      <p class="muted" style="margin-top:8px">${clothes.length} pièces · ${clothes.filter((c) => c.status === "available").length} disponibles</p>

      <div class="filter-scroll" style="margin-top:18px">
        ${CATEGORIES.map(
          (cat) => `
          <button class="chip chip-select ${dressingFilter === cat.id ? "is-active" : ""}" type="button" data-filter="${cat.id}">
            ${cat.label}
          </button>`
        ).join("")}
      </div>

      <div class="clothing-grid" id="dressing-grid">
        ${filtered.map((item, i) => clothingCard(item, i)).join("")}
      </div>
    </div>
    <button class="fab" type="button" id="fab-add" aria-label="Ajouter un vêtement">+</button>
  `;

  root.querySelectorAll("[data-filter]").forEach((btn) => {
    btn.onclick = () => {
      setDressingFilter(btn.dataset.filter);
      renderDressing(root);
    };
  });

  bindClothingCards(root.querySelector("#dressing-grid"));
  root.querySelector("#fab-add").onclick = () => navigate("/ajouter");
}
