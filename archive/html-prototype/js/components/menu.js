import { navItems } from "../data/mock.js";
import { icons } from "../ui.js";
import { navigate } from "../router.js";
import { getState, setMenuOpen } from "../state.js";
import { setMenuTriggerOpen } from "./header.js";

let bound = false;

export function renderMenu(root) {
  root.innerHTML = `
    <div class="menu-top">
      <div class="menu-brand">Philia<span>Personal stylist</span></div>
      <button class="menu-close" type="button" id="menu-close" aria-label="Fermer le menu">✕</button>
    </div>
    <nav class="menu-nav" aria-label="Navigation principale">
      ${navItems
        .map(
          (item) => `
        <button class="menu-item" type="button" data-path="${item.path}">
          <span class="menu-item-icon">${icons[item.icon]}</span>
          <span class="menu-item-text">
            <span class="menu-item-label">${item.label}</span>
            <span class="menu-item-desc">${item.desc}</span>
          </span>
          <span class="menu-item-mark" aria-hidden="true"></span>
        </button>`
        )
        .join("")}
    </nav>
    <div class="menu-footer">Prototype visuel · données fictives</div>
  `;

  root.querySelector("#menu-close").addEventListener("click", () => closeMenu());
  root.querySelectorAll(".menu-item").forEach((btn) => {
    btn.addEventListener("click", () => {
      const path = btn.dataset.path;
      closeMenu();
      setTimeout(() => navigate(path), 180);
    });
  });
}

export function syncMenuActive() {
  const { currentPath } = getState();
  const root = document.getElementById("dropdown-menu");
  root.querySelectorAll(".menu-item").forEach((btn) => {
    const path = btn.dataset.path;
    const active =
      path === "/"
        ? currentPath === "/"
        : currentPath === path || currentPath.startsWith(path + "/");
    btn.classList.toggle("is-active", active);
  });
}

export function openMenu() {
  setMenuOpen(true);
  applyMenuDom(true);
}

export function closeMenu() {
  setMenuOpen(false);
  applyMenuDom(false);
}

export function toggleMenu() {
  getState().menuOpen ? closeMenu() : openMenu();
}

function applyMenuDom(open) {
  const menu = document.getElementById("dropdown-menu");
  const backdrop = document.getElementById("menu-backdrop");
  const shell = document.getElementById("app-shell");

  menu.classList.toggle("is-open", open);
  menu.setAttribute("aria-hidden", open ? "false" : "true");
  backdrop.hidden = false;
  requestAnimationFrame(() => {
    backdrop.classList.toggle("is-visible", open);
  });
  if (!open) {
    setTimeout(() => {
      if (!getState().menuOpen) backdrop.hidden = true;
    }, 400);
  }
  shell.classList.toggle("is-dimmed", open);
  setMenuTriggerOpen(open);
  if (open) syncMenuActive();
}

export function bindMenuChrome() {
  if (bound) return;
  bound = true;
  document.getElementById("menu-backdrop").addEventListener("click", closeMenu);
  window.addEventListener("philia:toggle-menu", toggleMenu);
  window.addEventListener("keydown", (e) => {
    if (e.key === "Escape" && getState().menuOpen) closeMenu();
  });
}
