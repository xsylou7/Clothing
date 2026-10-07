import { startRouter } from "./router.js";
import { renderMenu, bindMenuChrome } from "./components/menu.js";

renderMenu(document.getElementById("dropdown-menu"));
bindMenuChrome();
startRouter();
