import { STATUS } from "./data/mock.js";

export function el(html) {
  const t = document.createElement("template");
  t.innerHTML = html.trim();
  return t.content.firstElementChild;
}

export function swatch(colors, label = "") {
  const [c1, c2] = colors || ["#ccc", "#999"];
  const lbl = label
    ? `<span class="swatch-label">${escapeHtml(label)}</span>`
    : "";
  return `<div class="swatch" style="--c1:${c1}; background: linear-gradient(155deg, ${c1} 0%, ${c2 || c1} 100%);">${lbl}</div>`;
}

export function statusBadge(statusId) {
  const s = STATUS[statusId] || STATUS.available;
  return `<span class="status-badge ${s.className}"><span class="status-dot"></span>${s.label}</span>`;
}

export function heartIcon(on) {
  return on
    ? `<svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" stroke="currentColor" stroke-width="1.5" d="M12 21s-7-4.35-9.5-8.5C.5 9 2.5 5.5 6.2 5.5c2 0 3.3 1.1 3.8 2.1.5-1 1.8-2.1 3.8-2.1 3.7 0 5.7 3.5 3.7 7C19 16.65 12 21 12 21z"/></svg>`
    : `<svg viewBox="0 0 24 24" aria-hidden="true"><path fill="none" stroke="currentColor" stroke-width="1.7" d="M12.1 20.3C5.4 15.2 2.5 11.5 2.5 8.2 2.5 5.4 4.7 3.5 7.3 3.5c1.7 0 3.2.9 4 2.2.8-1.3 2.3-2.2 4-2.2 2.6 0 4.8 1.9 4.8 4.7 0 3.3-2.9 7-8 12.1z"/></svg>`;
}

export const icons = {
  home: `<svg viewBox="0 0 24 24"><path d="M4 10.5 12 4l8 6.5V20a1 1 0 0 1-1 1h-5v-6H10v6H5a1 1 0 0 1-1-1v-9.5z"/></svg>`,
  hanger: `<svg viewBox="0 0 24 24"><path d="M12 7a2 2 0 1 0-2-2"/><path d="M12 7v3"/><path d="M3.5 18.5 12 12l8.5 6.5H3.5z"/></svg>`,
  spark: `<svg viewBox="0 0 24 24"><path d="M12 3v3M12 18v3M3 12h3M18 12h3"/><path d="M6.5 6.5 8.5 8.5M15.5 15.5l2 2M17.5 6.5 15.5 8.5M8.5 15.5l-2 2"/><circle cx="12" cy="12" r="2.5"/></svg>`,
  image: `<svg viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="9" cy="10" r="1.5"/><path d="m21 16-5-5-4 4-2-2-5 5"/></svg>`,
  user: `<svg viewBox="0 0 24 24"><circle cx="12" cy="8" r="3.5"/><path d="M5 19.5c1.8-3.2 4.2-4.5 7-4.5s5.2 1.3 7 4.5"/></svg>`,
};

export function escapeHtml(str) {
  return String(str)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;");
}

export function categoryLabel(id) {
  const map = {
    hauts: "Hauts",
    bas: "Bas",
    vestes: "Vestes",
    chaussures: "Chaussures",
    accessoires: "Accessoires",
  };
  return map[id] || id;
}
