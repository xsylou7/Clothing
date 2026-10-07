import { setPath } from "./state.js";
import { renderHeader } from "./components/header.js";
import { syncMenuActive } from "./components/menu.js";
import { renderHome } from "./pages/home.js";
import { renderDressing } from "./pages/dressing.js";
import { renderLooks } from "./pages/looks.js";
import { renderInspiration } from "./pages/inspiration.js";
import { renderProfile } from "./pages/profile.js";
import { renderStyleMe } from "./pages/style-me.js";
import { renderLookDetail } from "./pages/look-detail.js";
import { renderClothingDetail } from "./pages/clothing-detail.js";
import { renderAddClothing } from "./pages/add-clothing.js";

const routes = [
  { match: /^\/$/, name: "home", render: renderHome, header: { titleAction: { action: "style-me", label: "Habille-moi", icon: "✦" } } },
  { match: /^\/dressing$/, name: "dressing", render: renderDressing, header: { titleAction: { action: "add", label: "Ajouter", icon: "+" } } },
  { match: /^\/looks$/, name: "looks", render: renderLooks },
  { match: /^\/inspiration$/, name: "inspiration", render: renderInspiration },
  { match: /^\/profile$/, name: "profile", render: renderProfile },
  { match: /^\/habille-moi$/, name: "style-me", render: renderStyleMe },
  { match: /^\/look\/([^/]+)$/, name: "look-detail", render: renderLookDetail },
  { match: /^\/vetement\/([^/]+)$/, name: "clothing-detail", render: renderClothingDetail },
  { match: /^\/ajouter$/, name: "add", render: renderAddClothing },
];

export function navigate(path, { replace = false } = {}) {
  if (replace) history.replaceState({}, "", `#${path}`);
  else history.pushState({}, "", `#${path}`);
  renderRoute();
}

export function currentPath() {
  const hash = location.hash.replace(/^#/, "") || "/";
  return hash.startsWith("/") ? hash : `/${hash}`;
}

export function renderRoute() {
  const path = currentPath();
  setPath(path);
  const main = document.getElementById("app-main");
  const header = document.getElementById("app-header");

  const route = routes.find((r) => r.match.test(path));
  const params = route ? path.match(route.match) : null;

  renderHeader(header, route?.header || {});
  main.innerHTML = "";

  if (!route) {
    main.innerHTML = `<div class="page"><p class="page-kicker">404</p><h1 class="page-title">Page introuvable</h1><button class="btn btn-primary" style="margin-top:20px" id="go-home">Retour</button></div>`;
    main.querySelector("#go-home").onclick = () => navigate("/");
    return;
  }

  route.render(main, params);
  syncMenuActive();
  window.scrollTo({ top: 0, behavior: "instant" in window ? "instant" : "auto" });
}

export function startRouter() {
  window.addEventListener("hashchange", renderRoute);
  if (!location.hash) location.hash = "#/";
  renderRoute();
}
