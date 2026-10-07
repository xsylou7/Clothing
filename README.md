# Philia — Dressing intelligent (Godot 4)

Prototype mobile d’application de mode / garde-robe, reconstruit en **Godot 4.7** (GDScript).

## Lancer

1. Ouvre le dossier dans Godot 4.7+ (`godot .` ou importer le `project.godot`)
2. Appuie sur **F5** (scène principale : `scenes/main/main.tscn`)

```bash
godot --path .
```

Résolution de référence : **390×844** (portrait).

## Architecture

| Dossier | Rôle |
|---------|------|
| `data/` | Resources + données mock (20 vêtements, 10 looks, 5 inspirations) |
| `scripts/autoload/` | `AppState` (état) · `Nav` (navigation) |
| `scripts/ui/` | Design tokens / helpers (`PhiliaStyle`) |
| `scenes/main/` | Shell + header + menu déroulant |
| `scenes/ui/` | Cartes vêtement / look |
| `scenes/screens/` | Accueil, Dressing, Looks, Inspiration, Profil, Habille-moi, détails, ajout |
| `archive/html-prototype/` | Ancien prototype HTML (référence) |

## Fonctionnalités mock

- Menu déroulant premium depuis le haut
- Dressing avec filtres et statuts (Disponible / Au lavage / Indisponible)
- Looks + favoris
- Habille-moi (génération simulée, ignore les pièces non dispo)
- Ajout vêtement avec analyse fictive
- Profil styliste

Pas d’IA réelle, auth, ni backend — volontairement.
