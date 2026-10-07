import { addClothing, setAnalyzing } from "../state.js";
import { escapeHtml, swatch } from "../ui.js";
import { navigate } from "../router.js";

export function renderAddClothing(root) {
  let step = "choose"; // choose | analyzing | review
  const draft = {
    name: "Jean bleu",
    category: "bas",
    color: "Bleu",
    style: "Casual",
    seasons: ["Printemps", "Été", "Automne"],
    brand: "",
    size: "32",
    status: "available",
    notes: "",
    colors: ["#2f4f7a", "#1e3558"],
  };

  function paint() {
    if (step === "choose") {
      root.innerHTML = `
        <div class="page">
          <button class="back-btn" type="button" id="back">← Retour</button>
          <p class="page-kicker">Nouveau</p>
          <h1 class="page-title">Ajouter un vêtement</h1>
          <p class="muted" style="margin-top:8px">Prends une photo ou choisis-en une — l'analyse est simulée pour le prototype.</p>
          <div class="add-options">
            <button class="add-option" type="button" data-src="camera">
              <span class="add-option-icon">◎</span>
              <span><strong>Prendre une photo</strong><span>Utiliser l'appareil</span></span>
            </button>
            <button class="add-option" type="button" data-src="gallery">
              <span class="add-option-icon">▢</span>
              <span><strong>Choisir une photo</strong><span>Depuis la galerie</span></span>
            </button>
          </div>
        </div>
      `;
      root.querySelector("#back").onclick = () => history.back();
      root.querySelectorAll("[data-src]").forEach((btn) => {
        btn.onclick = () => startAnalysis();
      });
      return;
    }

    if (step === "analyzing") {
      root.innerHTML = `
        <div class="page">
          <div class="generating" style="padding-top:80px">
            <div class="generating-ring"></div>
            <div class="generating-title">Analyse de ton vêtement…</div>
            <div class="shimmer-bar" style="width:70%"></div>
            <p class="muted">Détection de la catégorie, couleur et style.</p>
          </div>
        </div>
      `;
      return;
    }

    root.innerHTML = `
      <div class="page">
        <button class="back-btn" type="button" id="back">← Retour</button>
        <p class="page-kicker">Résultat</p>
        <h1 class="page-title">Nous pensons qu'il s'agit de&nbsp;:</h1>

        <div class="analysis-preview" style="margin-top:18px">
          ${swatch(draft.colors, draft.color)}
          <div class="analysis-body">
            <form id="save-form">
              <div class="field"><label>Nom</label><input name="name" value="${escapeHtml(draft.name)}" /></div>
              <div class="field"><label>Catégorie</label>
                <select name="category">
                  <option value="hauts">Hauts</option>
                  <option value="bas" selected>Bas</option>
                  <option value="vestes">Vestes</option>
                  <option value="chaussures">Chaussures</option>
                  <option value="accessoires">Accessoires</option>
                </select>
              </div>
              <div class="field"><label>Couleur</label><input name="color" value="${escapeHtml(draft.color)}" /></div>
              <div class="field"><label>Style</label><input name="style" value="${escapeHtml(draft.style)}" /></div>
              <button class="btn btn-primary" type="submit">Enregistrer dans le dressing</button>
            </form>
          </div>
        </div>
      </div>
    `;

    root.querySelector("#back").onclick = () => {
      step = "choose";
      paint();
    };
    root.querySelector("#save-form").onsubmit = (e) => {
      e.preventDefault();
      const fd = new FormData(e.target);
      const id = `c${String(Date.now()).slice(-4)}`;
      addClothing({
        id,
        name: fd.get("name"),
        category: fd.get("category"),
        color: fd.get("color"),
        style: fd.get("style"),
        seasons: draft.seasons,
        brand: "",
        size: "",
        status: "available",
        notes: "Ajouté via prototype",
        colors: draft.colors,
      });
      navigate(`/vetement/${id}`);
    };
  }

  function startAnalysis() {
    step = "analyzing";
    setAnalyzing(true);
    paint();
    setTimeout(() => {
      setAnalyzing(false);
      step = "review";
      paint();
    }, 1800);
  }

  paint();
}
