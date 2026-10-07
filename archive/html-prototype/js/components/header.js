import { navigate } from "../router.js";

export function renderHeader(root, { titleAction = null, showBrand = true } = {}) {
  const action = titleAction
    ? `<button class="header-action" type="button" data-action="${titleAction.action}" aria-label="${titleAction.label}">${titleAction.icon}</button>`
    : `<span style="width:42px"></span>`;

  root.innerHTML = `
    <div class="brand">
      ${showBrand ? `<div class="brand-name">Philia</div><div class="brand-tag">Dressing</div>` : ""}
    </div>
    <button class="menu-trigger" type="button" id="menu-trigger" aria-expanded="false" aria-controls="dropdown-menu">
      Menu
      <span class="menu-trigger-chevron" aria-hidden="true"></span>
    </button>
    ${action}
  `;

  root.querySelector("#menu-trigger")?.addEventListener("click", () => {
    window.dispatchEvent(new CustomEvent("philia:toggle-menu"));
  });

  root.querySelector("[data-action]")?.addEventListener("click", (e) => {
    const actionName = e.currentTarget.dataset.action;
    if (actionName === "style-me") navigate("/habille-moi");
    if (actionName === "add") navigate("/ajouter");
  });
}

export function setMenuTriggerOpen(open) {
  const btn = document.getElementById("menu-trigger");
  if (!btn) return;
  btn.classList.toggle("is-open", open);
  btn.setAttribute("aria-expanded", open ? "true" : "false");
}
