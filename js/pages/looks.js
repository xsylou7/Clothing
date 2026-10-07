import { getState } from "../state.js";
import { lookCard, bindLookCards } from "../components/cards.js";
import { navigate } from "../router.js";

export function renderLooks(root) {
  const { looks } = getState();

  root.innerHTML = `
    <div class="page">
      <p class="page-kicker">Tenues</p>
      <h1 class="page-title">Looks</h1>
      <p class="muted" style="margin-top:8px">${looks.length} tenues · ${looks.filter((l) => l.favorite).length} favoris</p>

      <div class="btn-row" style="margin-top:18px">
        <button class="btn btn-primary" type="button" id="gen">Habille-moi</button>
      </div>

      <div class="looks-list section" id="looks-list">
        ${looks.map((l) => lookCard(l, { full: true })).join("")}
      </div>
    </div>
  `;

  root.querySelector("#gen").onclick = () => navigate("/habille-moi");
  bindLookCards(root.querySelector("#looks-list"), () => renderLooks(root));
}
