# Procédure — créer un nouveau projet/repo

Procédure cross-bucket pour initialiser proprement un nouveau projet sous `C:\dev\claude\<bucket>\<nom>`.

## 1. Choisir le bucket

| Bucket                  | Compte GitHub        | Pour quoi |
|-------------------------|----------------------|-----------|
| `studio_descartes\`     | `StudioDescartes`    | Tout projet société SD |
| `oscardcstudio\`        | `oscardcstudio-cell` | Projets persos Oscar (tout ce qui n'est pas SD) |

**Règle absolue** : un repo SD ne pointe JAMAIS vers un remote perso, et inversement.

## 2. Switcher le compte GitHub actif AVANT toute commande `gh`

```bash
gh auth status                          # voir l'utilisateur actif
gh auth switch -u <user>                # switcher si mismatch
```

`<user>` = `StudioDescartes` ou `oscardcstudio-cell`.

## 3. Créer le repo physiquement dans le bucket

Les repos vivent **directement** dans leur bucket (pas ailleurs, pas de junctions). Le `Nothing_But_Blue_Sky` épisode (mai 2026) a confirmé : créer un dossier physique séparé + junction est inutile et complique pour rien.

```bash
mkdir "C:/dev/claude/<bucket>/<nom>"
git -C "C:/dev/claude/<bucket>/<nom>" init
git -C "C:/dev/claude/<bucket>/<nom>" checkout -b main
```

## 4. Créer le repo GitHub et ajouter le remote

```bash
gh repo create <nom> --private --description "<courte description>"
git -C "C:/dev/claude/<bucket>/<nom>" remote add origin https://github.com/<user>/<nom>.git
```

## 5. Installer la structure de base

**Toujours** :
- `CLAUDE.md` — règles et contexte projet (< 200 lignes, règles uniquement)
- `llms.txt` — inventaire des fichiers/dossiers critiques
- `README.md` — pitch court du projet
- `wiki/` — copier depuis `C:\dev\claude\oscardcstudio\wiki-template\` (pattern Karpathy : index/entities/decisions/gotchas/patterns)

**Selon nature du projet** : créer les dossiers métier (ex. court métrage → `script/`, `production/`, `visual/`, `notes/` ; app → `src/`, `tests/`, `docs/` ; etc.) avec `.gitkeep` si vides.

## 6. Premier commit + push

```bash
git -C "C:/dev/claude/<bucket>/<nom>" add -A
git -C "C:/dev/claude/<bucket>/<nom>" commit -m "feat: init <nom> — <description>

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
git -C "C:/dev/claude/<bucket>/<nom>" push -u origin main
```

## 7. Référencer le projet dans le CLAUDE.md du bucket

Ajouter une ligne au tableau `## Projets` du `CLAUDE.md` du bucket (`studio_descartes\CLAUDE.md` ou `oscardcstudio\CLAUDE.md`), commit + push ce CLAUDE.md.

## 8. Checklist santé infra (context engineering)

Avant de clore l'init :
- [ ] `llms.txt` présent à la racine
- [ ] `CLAUDE.md` < 200 lignes, règles uniquement (pas de doc d'archi)
- [ ] Pas de fichier > 300 lignes non documenté dans llms.txt
- [ ] `.gitignore` adapté (au minimum : secrets, dépendances, build, OS)

## Anti-patterns à ne pas répéter

- **Junction Windows** vers un repo physique ailleurs → inutile, casse l'intuition, fait perdre du temps. Garder le repo dans son bucket.
- **Init git dans un sous-dossier d'un repo parent existant** sans vérifier — si le bucket est lui-même un repo git, le nouveau projet sera un repo imbriqué non-tracké. Vérifier `git -C <bucket> rev-parse --is-inside-work-tree` avant.
- **Créer le repo GitHub sans switcher `gh auth`** → repo créé sur le mauvais compte, douleur garantie.
- **Skipper le wiki-template** → on perd la mémoire cumulée du projet entre sessions.
