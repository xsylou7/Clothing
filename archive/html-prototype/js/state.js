import { clothes as initialClothes, looks as initialLooks, inspirations, profile, weather } from "./data/mock.js";

const listeners = new Set();

const state = {
  clothes: structuredClone(initialClothes),
  looks: structuredClone(initialLooks),
  inspirations: structuredClone(inspirations),
  profile: structuredClone(profile),
  weather: structuredClone(weather),
  menuOpen: false,
  currentPath: "/",
  dressingFilter: "all",
  styleMe: {
    occasion: "Quotidien",
    style: "Casual",
  },
  lastGeneratedLookId: "l01",
  analyzing: false,
};

export function getState() {
  return state;
}

export function subscribe(fn) {
  listeners.add(fn);
  return () => listeners.delete(fn);
}

function emit() {
  listeners.forEach((fn) => fn(state));
}

export function setMenuOpen(open) {
  state.menuOpen = open;
  emit();
}

export function setPath(path) {
  state.currentPath = path;
  emit();
}

export function setDressingFilter(filter) {
  state.dressingFilter = filter;
  emit();
}

export function toggleFavorite(lookId) {
  const look = state.looks.find((l) => l.id === lookId);
  if (!look) return;
  look.favorite = !look.favorite;
  emit();
}

export function setClothingStatus(id, status) {
  const item = state.clothes.find((c) => c.id === id);
  if (!item) return;
  item.status = status;
  emit();
}

export function updateClothing(id, patch) {
  const item = state.clothes.find((c) => c.id === id);
  if (!item) return;
  Object.assign(item, patch);
  emit();
}

export function addClothing(item) {
  state.clothes.unshift(item);
  emit();
}

export function setStyleMe(partial) {
  Object.assign(state.styleMe, partial);
  emit();
}

export function setLastGeneratedLookId(id) {
  state.lastGeneratedLookId = id;
  emit();
}

export function setAnalyzing(v) {
  state.analyzing = v;
  emit();
}

export function getAvailableClothes() {
  return state.clothes.filter((c) => c.status === "available");
}

export function generateLookFromPrefs() {
  const available = new Set(getAvailableClothes().map((c) => c.id));
  const { occasion, style } = state.styleMe;

  const scored = state.looks
    .map((look) => {
      const allAvailable = look.items.every((id) => available.has(id));
      let score = look.score;
      if (look.occasion === occasion) score += 8;
      if (look.style === style || style === "Surprise") score += 6;
      if (!allAvailable) score -= 40;
      return { look, score, allAvailable };
    })
    .filter((x) => x.allAvailable)
    .sort((a, b) => b.score - a.score);

  const pick = scored[0]?.look || state.looks.find((l) => l.id === "l01");
  state.lastGeneratedLookId = pick.id;
  emit();
  return pick;
}

export function stats() {
  return {
    clothes: state.clothes.length,
    looks: state.looks.length,
    favorites: state.looks.filter((l) => l.favorite).length,
  };
}
