import { getState, setStyleMe, generateLookFromPrefs } from "../state.js";
import { escapeHtml } from "../ui.js";
import { navigate } from "../router.js";

const OCCASIONS = ["Quotidien", "Travail", "Sortie", "Soirée", "Sport", "Rendez-vous"];
const STYLES = ["Casual", "Élégant", "Minimal", "Streetwear", "Surprise"];

export function renderStyleMe(root) {
  const { styleMe, weather } = getState();

  root.innerHTML = `
    <div class="page">
      <button class="back-btn" type="button" id="back">← Retour</button>
      <p class="page-kicker">Styliste</p>
      <h1 class="page-title">Que veux-tu porter aujourd'hui&nbsp;?</h1>

      <div class="choice-block" style="margin-top:24px">
        <h3>Occasion</h3>
        <div class="choice-grid">
          ${OCCASIONS.map(
            (o) =>
              `<button class="chip chip-select ${styleMe.occasion === o ? "is-active" : ""}" type="button" data-occ="${o}">${o}</button>`
          ).join("")}
        </div>
      </div>

      <div class="choice-block">
        <h3>Style</h3>
        <div class="choice-grid">
          ${STYLES.map(
            (s) =>
              `<button class="chip chip-select ${styleMe.style === s ? "is-active" : ""}" type="button" data-style="${s}">${s}</button>`
          ).join("")}
        </div>
      </div>

      <div class="choice-block">
        <h3>Météo</h3>
        <div class="weather-pill">${weather.temp}°C · ${escapeHtml(weather.label)}</div>
        <p class="muted" style="margin-top:8px;font-size:.85rem">Les vêtements indisponibles ou au lavage seront ignorés.</p>
      </div>

      <button class="btn btn-primary" type="button" id="generate">✨ Générer ma tenue</button>
      <div id="gen-area"></div>
    </div>
  `;

  root.querySelector("#back").onclick = () => history.back();

  root.querySelectorAll("[data-occ]").forEach((btn) => {
    btn.onclick = () => {
      setStyleMe({ occasion: btn.dataset.occ });
      renderStyleMe(root);
    };
  });

  root.querySelectorAll("[data-style]").forEach((btn) => {
    btn.onclick = () => {
      setStyleMe({ style: btn.dataset.style });
      renderStyleMe(root);
    };
  });

  root.querySelector("#generate").onclick = () => {
    const area = root.querySelector("#gen-area");
    const btn = root.querySelector("#generate");
    btn.disabled = true;
    area.innerHTML = `
      <div class="generating">
        <div class="generating-ring"></div>
        <div class="generating-title">Composition en cours…</div>
        <div class="shimmer-bar" style="width:60%"></div>
        <p class="muted">On croise ton dressing, ton style et la météo.</p>
      </div>
    `;

    setTimeout(() => {
      const look = generateLookFromPrefs();
      navigate(`/look/${look.id}`);
    }, 1400);
  };
}
