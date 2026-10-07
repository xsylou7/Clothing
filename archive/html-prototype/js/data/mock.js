/** Données fictives — séparées de l'UI pour remplacement futur */

export const STATUS = {
  available: { id: "available", label: "Disponible", className: "available" },
  laundry: { id: "laundry", label: "Au lavage", className: "laundry" },
  unavailable: { id: "unavailable", label: "Indisponible", className: "unavailable" },
};

export const CATEGORIES = [
  { id: "all", label: "Tout" },
  { id: "hauts", label: "Hauts" },
  { id: "bas", label: "Bas" },
  { id: "vestes", label: "Vestes" },
  { id: "chaussures", label: "Chaussures" },
  { id: "accessoires", label: "Accessoires" },
];

export const weather = {
  temp: 12,
  label: "Partiellement nuageux",
  icon: "cloud",
};

export const profile = {
  firstName: "Sylvain",
  lastName: "M.",
  initials: "S",
  mainStyle: "Casual élégant",
  secondaryStyles: ["Minimal", "Smart Casual", "Streetwear"],
  favoriteColors: ["Noir", "Blanc", "Bleu marine", "Beige"],
  styleTags: ["CASUAL", "MINIMAL", "SMART CASUAL", "STREETWEAR"],
  preferences: [
    { label: "Coupe préférée", value: "Regular / Relaxed" },
    { label: "Météo froide", value: "Toujours une couche" },
    { label: "Couleurs", value: "Tons neutres" },
    { label: "Occasions", value: "Quotidien & travail" },
  ],
};

/** Palette swatches par pièce (visuels locaux, sans dépendance réseau) */
export const clothes = [
  { id: "c01", name: "Jean bleu", category: "bas", color: "Bleu", style: "Casual", seasons: ["Printemps", "Été", "Automne"], brand: "Apc", size: "32", status: "available", notes: "Coupe droite", colors: ["#2f4f7a", "#1e3558"] },
  { id: "c02", name: "T-shirt blanc", category: "hauts", color: "Blanc", style: "Minimal", seasons: ["Printemps", "Été"], brand: "Uniqlo", size: "M", status: "laundry", notes: "", colors: ["#f2efe8", "#d9d4cb"] },
  { id: "c03", name: "Veste noire", category: "vestes", color: "Noir", style: "Smart Casual", seasons: ["Automne", "Hiver", "Printemps"], brand: "Zara", size: "M", status: "available", notes: "Légère", colors: ["#1a1a1a", "#2c2c2c"] },
  { id: "c04", name: "Chemise lin crème", category: "hauts", color: "Crème", style: "Élégant", seasons: ["Printemps", "Été"], brand: "COS", size: "M", status: "available", notes: "", colors: ["#e8dfd0", "#cfc3ae"] },
  { id: "c05", name: "Chino beige", category: "bas", color: "Beige", style: "Casual", seasons: ["Printemps", "Été", "Automne"], brand: "Gap", size: "32", status: "available", notes: "", colors: ["#c4ae8c", "#a8906e"] },
  { id: "c06", name: "Sweat gris", category: "hauts", color: "Gris", style: "Casual", seasons: ["Automne", "Hiver"], brand: "Nike", size: "L", status: "available", notes: "", colors: ["#8a8e91", "#6b7074"] },
  { id: "c07", name: "Blazer navy", category: "vestes", color: "Bleu marine", style: "Élégant", seasons: ["Automne", "Hiver", "Printemps"], brand: "Sandro", size: "M", status: "available", notes: "", colors: ["#1b2a44", "#243554"] },
  { id: "c08", name: "Baskets blanches", category: "chaussures", color: "Blanc", style: "Casual", seasons: ["Printemps", "Été", "Automne"], brand: "Common Projects", size: "43", status: "available", notes: "", colors: ["#f5f5f5", "#d8d8d8"] },
  { id: "c09", name: "Derbies cognac", category: "chaussures", color: "Cognac", style: "Élégant", seasons: ["Automne", "Hiver"], brand: "Paraboot", size: "43", status: "available", notes: "", colors: ["#8b4f2d", "#6e3c20"] },
  { id: "c10", name: "Hoodie noir", category: "hauts", color: "Noir", style: "Streetwear", seasons: ["Automne", "Hiver"], brand: "Carhartt", size: "L", status: "unavailable", notes: "À réparer", colors: ["#111111", "#222222"] },
  { id: "c11", name: "Cargo olive", category: "bas", color: "Olive", style: "Streetwear", seasons: ["Printemps", "Automne"], brand: "Alpha", size: "32", status: "available", notes: "", colors: ["#556046", "#3f4a34"] },
  { id: "c12", name: "Pull mérinos", category: "hauts", color: "Camel", style: "Minimal", seasons: ["Automne", "Hiver"], brand: "Uniqlo", size: "M", status: "available", notes: "", colors: ["#b08a5a", "#8f6c42"] },
  { id: "c13", name: "Parka kaki", category: "vestes", color: "Kaki", style: "Casual", seasons: ["Automne", "Hiver"], brand: "Aigle", size: "M", status: "available", notes: "", colors: ["#5c6340", "#454a30"] },
  { id: "c14", name: "Pantalon noir", category: "bas", color: "Noir", style: "Minimal", seasons: ["Toute saison"], brand: "COS", size: "32", status: "available", notes: "", colors: ["#171717", "#2a2a2a"] },
  { id: "c15", name: "Polo marine", category: "hauts", color: "Bleu marine", style: "Smart Casual", seasons: ["Printemps", "Été"], brand: "Lacoste", size: "M", status: "laundry", notes: "", colors: ["#1e3350", "#2a4468"] },
  { id: "c16", name: "Mocassins noirs", category: "chaussures", color: "Noir", style: "Élégant", seasons: ["Toute saison"], brand: "G.H. Bass", size: "43", status: "available", notes: "", colors: ["#101010", "#2b2b2b"] },
  { id: "c17", name: "Ceinture cuir", category: "accessoires", color: "Marron", style: "Élégant", seasons: ["Toute saison"], brand: "Anderson's", size: "95", status: "available", notes: "", colors: ["#5c3a22", "#3f2716"] },
  { id: "c18", name: "Bonnet laine", category: "accessoires", color: "Gris", style: "Casual", seasons: ["Hiver"], brand: "Arket", size: "Unique", status: "available", notes: "", colors: ["#6e7275", "#4f5457"] },
  { id: "c19", name: "Surchemise carreaux", category: "vestes", color: "Multicolore", style: "Casual", seasons: ["Automne", "Hiver"], brand: "Levi's", size: "M", status: "available", notes: "", colors: ["#6b4e3d", "#3d4a5c"] },
  { id: "c20", name: "Sneakers noires", category: "chaussures", color: "Noir", style: "Streetwear", seasons: ["Toute saison"], brand: "Adidas", size: "43", status: "available", notes: "", colors: ["#0f0f0f", "#333333"] },
];

export const looks = [
  { id: "l01", name: "Casual quotidien", style: "Casual", occasion: "Quotidien", score: 94, favorite: true, items: ["c03", "c02", "c01", "c08"] },
  { id: "l02", name: "Smart Casual", style: "Smart Casual", occasion: "Travail", score: 91, favorite: true, items: ["c07", "c15", "c05", "c09"] },
  { id: "l03", name: "Weekend minimal", style: "Minimal", occasion: "Quotidien", score: 88, favorite: false, items: ["c04", "c14", "c08"] },
  { id: "l04", name: "Streetwear", style: "Streetwear", occasion: "Sortie", score: 86, favorite: false, items: ["c10", "c11", "c20"] },
  { id: "l05", name: "Bureau élégant", style: "Élégant", occasion: "Travail", score: 93, favorite: true, items: ["c07", "c04", "c14", "c16"] },
  { id: "l06", name: "Soirée douce", style: "Élégant", occasion: "Soirée", score: 89, favorite: false, items: ["c03", "c12", "c01", "c09"] },
  { id: "l07", name: "Layering automne", style: "Casual", occasion: "Quotidien", score: 90, favorite: false, items: ["c13", "c06", "c01", "c20"] },
  { id: "l08", name: "Brunch city", style: "Smart Casual", occasion: "Sortie", score: 87, favorite: true, items: ["c19", "c02", "c05", "c08"] },
  { id: "l09", name: "Froid assumé", style: "Casual", occasion: "Quotidien", score: 85, favorite: false, items: ["c13", "c12", "c14", "c18", "c09"] },
  { id: "l10", name: "Date night", style: "Élégant", occasion: "Rendez-vous", score: 92, favorite: true, items: ["c07", "c12", "c14", "c16", "c17"] },
];

export const inspirations = [
  { id: "i01", title: "Neutrals Milan", colors: ["#2a2a2a", "#cfc6b8", "#8a7a66"] },
  { id: "i02", title: "Coastal linen", colors: ["#e8e2d6", "#9eb0a8", "#3d4f48"] },
  { id: "i03", title: "Night tailored", colors: ["#12141a", "#1e2a44", "#8b4f2d"] },
  { id: "i04", title: "Urban utility", colors: ["#3f4a34", "#1a1a1a", "#6e7275"] },
  { id: "i05", title: "Soft monochrome", colors: ["#f0ebe3", "#b0aaa2", "#2c2c2c"] },
];

export const navItems = [
  { id: "home", path: "/", label: "Accueil", desc: "Look du jour & météo", icon: "home" },
  { id: "dressing", path: "/dressing", label: "Dressing", desc: "Ton garde-robe", icon: "hanger" },
  { id: "looks", path: "/looks", label: "Looks", desc: "Tenues générées", icon: "spark" },
  { id: "inspiration", path: "/inspiration", label: "Inspiration", desc: "Looks qui t'inspirent", icon: "image" },
  { id: "profile", path: "/profile", label: "Profil", desc: "Style & préférences", icon: "user" },
];

export function getClothing(id) {
  return clothes.find((c) => c.id === id);
}

export function resolveLookItems(look) {
  return look.items.map(getClothing).filter(Boolean);
}
