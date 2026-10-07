# VESTIA — Dressing intelligent

Prototype HTML/CSS/JS d’une application mobile de mode et de gestion de garde-robe.

Pensé **mobile first** (viewport téléphone ~390px, menu déroulant premium, gestes tactiles).

## Démo en ligne

https://xsylou7.github.io/Clothing/

## Lancer en local

Sers le dossier en local (les modules ES ne marchent pas en `file://`) :

```bash
# Si Python est installé :
python -m http.server 5173

# Ou avec Node :
npx serve -l 5173
```

Puis ouvre [http://localhost:5173](http://localhost:5173) et active la vue téléphone dans les DevTools.

## Structure

- `css/` — design system, composants, menu, pages, animations
- `js/data/mock.js` — données fictives (20 vêtements, 10 looks, 5 inspirations, profil)
- `js/components/` — header, menu déroulant, cartes
- `js/pages/` — écrans de l’app
- `js/state.js` — état local (favoris, statuts, génération simulée)
- `js/router.js` — navigation hash (`#/`, `#/dressing`, …)

## Sections

Accueil · Dressing · Looks · Inspiration · Profil · Habille-moi · détail look / vêtement · ajout vêtement

Tout fonctionne avec des données mockées — aucune IA, auth ou API distante.
