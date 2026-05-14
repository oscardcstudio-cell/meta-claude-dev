# Setup — Nouveau collaborateur / pote

Guide pour installer l'environnement de travail Claude sur un ordi neuf.
**Version simplifiée** : un seul compte GitHub, pas de bucket SD.

---

## Arborescence cible

```
C:\Users\<user>\.claude\     ← user scope (CLAUDE.md global, skills, agents, hooks)
                                repo : ton-compte/dotclaude

C:\dev\claude\               ← meta machine (cross-projets)
|-- CLAUDE.md                ← règles cross-projets
|-- company/                 ← infos de ton entreprise (à remplir)
|-- GOTCHAS.md, SETUP_TIERS.md
|
`-- <ton-bucket>/            ← tes projets (pas versionné ici, add dans .gitignore)
```

---

## 1. Logiciels

### Git
https://git-scm.com/download/win

```bash
git config --global user.name "ton-user-github"
git config --global user.email "ton@email.com"
git config --global credential.helper manager
```

### Node.js (v22+)
https://nodejs.org/ — version LTS

### Python (si besoin)
https://www.python.org/downloads/ — cocher "Add to PATH"

---

## 2. GitHub CLI

```bash
winget install --id GitHub.cli --accept-source-agreements --accept-package-agreements --silent
gh auth login --web --hostname github.com --git-protocol https
gh auth status  # vérifie que le compte est connecté
```

---

## 3. Claude Code

```bash
# Fixer le prefix npm si nécessaire
mkdir -p "C:\Users\<user>\AppData\Roaming\npm"
npm config set prefix "C:\Users\<user>\AppData\Roaming\npm"

# Installer Claude Code
npm install -g @anthropic-ai/claude-code
claude --version  # doit afficher 2.x+

# Se connecter
claude auth
```

---

## 4. User scope (~/.claude/)

Le user scope contient le CLAUDE.md global, les skills, agents, hooks et settings.
Deux options :

### Option A — Cloner le dotclaude de référence (recommandé)
```bash
# Si ~/.claude/ existe déjà avec du contenu par défaut, le supprimer d'abord :
rm -rf ~/.claude
git clone https://github.com/oscardcstudio-cell/dotclaude.git ~/.claude
```
Contient : ~40 skills, meta-agents génériques, hooks de sécurité, settings.json.

### Option B — Créer ton propre user scope
```bash
mkdir -p ~/.claude
# Puis créer manuellement ~/.claude/CLAUDE.md avec tes préférences
```

---

## 5. Meta machine (C:\dev\claude\)

```bash
mkdir -p /c/dev
cd /c/dev
git clone https://github.com/oscardcstudio-cell/meta-claude-dev.git claude
cd claude
```

---

## 6. Remplir company/ (contexte entreprise)

Le dossier `company/` contient les infos de ton entreprise.
Claude les charge automatiquement pour tout contexte business et brand.

```
company/
  info.json               ← SIRET, adresse, contacts, compta, avocat
  team.json               ← équipe
  brand/
    plateforme.md         ← WHY/WHAT/HOW, valeurs, positionnement, cibles
    guide_editorial.md    ← ton, vocabulaire, interdits
```

**À faire maintenant :**
1. Ouvrir `company/info.json` — remplir les champs (nom, adresse, SIRET, contacts)
2. Ouvrir `company/team.json` — ajouter ton équipe
3. Ouvrir `company/brand/plateforme.md` — décrire ton entreprise (WHY/WHAT/HOW)
4. Ouvrir `company/brand/guide_editorial.md` — ton style de communication

Voir `company/README.md` pour le détail.

---

## 7. Tes projets

Ajoute tes repos dans un sous-dossier (ex: `C:\dev\claude\monprojet\`).
Ce sous-dossier doit être dans `.gitignore` du meta machine (déjà configuré pour `studio_descartes/` et `oscardcstudio/` — ajouter le tien sur le même modèle).

```bash
cd /c/dev/claude
git clone https://github.com/ton-compte/mon-projet.git monprojet
```

---

## 8. Push automatique (optionnel)

Pour pusher tous tes repos d'un coup toutes les 15 min en arrière-plan :

```bash
# Tâche planifiée Windows
schtasks /Create /SC MINUTE /MO 15 /TN "ClaudePushAll" /TR "wscript.exe \"C:\dev\claude\push-all-global.vbs\"" /F
```

Vérifier :
```bash
schtasks /Query /TN "ClaudePushAll"
```

---

## 9. Variables d'environnement (si besoin)

**Paramètres Windows > Variables d'environnement > Utilisateur**

| Variable | Usage |
|---|---|
| `FIGMA_API_KEY` | Plugin Figma MCP |
| `OPENROUTER_API_KEY` | Accès multi-modèles LLM (OpenRouter) |

`ANTHROPIC_API_KEY` est gérée automatiquement par `claude auth`.

---

## 10. Vérification finale

```bash
# Versions
node --version && git --version && claude --version

# GitHub
gh auth status

# User scope
ls ~/.claude/CLAUDE.md
ls ~/.claude/skills/    # si tu as cloné dotclaude

# Meta machine
ls /c/dev/claude/CLAUDE.md
ls /c/dev/claude/company/

# Test Claude
claude "dis bonjour"
```

---

## Comptes à connecter

- [ ] GitHub — `gh auth status`
- [ ] Claude — `claude auth`
- [ ] Figma — token dans `FIGMA_API_KEY` (si tu utilises Figma)
- [ ] OpenRouter — clé dans `OPENROUTER_API_KEY` (si tu veux accès multi-LLM)
