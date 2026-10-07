import { startRouter } from "./router.js";
import { renderMenu, bindMenuChrome } from "./components/menu.js";

function boot() {
  renderMenu(document.getElementById("dropdown-menu"));
  bindMenuChrome();
  startRouter();
}

boot();
