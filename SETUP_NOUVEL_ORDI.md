# Setup nouvel ordi — Oscar

Guide pour reinstaller l'environnement de travail complet sur un nouvel ordi.
Tout copier-coller dans un terminal (PowerShell admin quand indique).

> **Regle critique (decidee le 2026-04-15)** : **le code dev ne va JAMAIS sur Google Drive.**
>
> Google Drive intercepte les fichiers ecrits par `npm install` et les transforme en placeholders 0 bytes pendant la sync (incident Phase 1 studio-descartes-da).
>
> **Convention** :
> - **Code** -> `C:\dev\claude\` partout (les deux buckets : SD + perso)
> - **Backup code** -> GitHub (source de verite cloud, push automatique toutes les 15min — voir partie 5)
> - **Drive** -> uniquement assets non-code : PDFs, Figma exports, dossiers, videos, images

---

## Arborescence cible

```
C:\Users\<user>\.claude\             <- user scope (chargé partout par Claude Code)
                                        repo : oscardcstudio-cell/dotclaude

C:\dev\claude\                       <- meta machine (cross-projets)
|-- CLAUDE.md                        <- meta cross-projets
|-- SETUP_NOUVEL_ORDI.md             <- ce fichier
|-- .claudeignore, .gitignore
|-- push-all-global.sh, .vbs         <- push auto toutes les 15min
|-- .claude-user/                    <- junction Windows -> ~/.claude/ (pratique)
|                                       repo : oscardcstudio-cell/meta-claude-dev
|
|-- studio_descartes\                <- bucket SD (compte org StudioDescartes)
|   |-- CLAUDE.md, claude-agents\, push-all.sh
|   |-- philo_runner\, studio-descartes-da\, -social\, -centre-appel\,
|   |    -info\, -dashboard\
|                                       repo : StudioDescartes/studio-descartes-meta
|
`-- oscardcstudio\                   <- bucket perso (compte oscardcstudio-cell)
    |-- CLAUDE.md, push-all.sh
    `-- Auto_Polymarket\, subvention_match\, Sync-Play\, claude-mobile\
                                        repo : oscardcstudio-cell/oscardcstudio-meta
```

**Hierarchie de chargement CLAUDE.md** : user (`~/.claude/`) -> meta machine (`C:\dev\claude\`) -> bucket (SD ou perso) -> projet.

---

# PARTIE 1 — Commune (tous projets)

## 1. Logiciels de base

### Git
Telecharger et installer : https://git-scm.com/download/win

```bash
git config --global user.name "oscardcstudio-cell"
git config --global user.email "oscardcstudio@gmail.com"
git config --global credential.helper manager
git lfs install
```

### Node.js (v24+)
https://nodejs.org/ — version LTS ou v24+

```bash
node --version   # v24.x
npm --version    # 11.x
```

### Python (3.14)
https://www.python.org/downloads/ — cocher "Add to PATH"

### VS Code
https://code.visualstudio.com/

```bash
code --install-extension bradlc.vscode-tailwindcss
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
```

---

## 2. GitHub CLI (multi-compte)

```bash
winget install --id GitHub.cli --accept-source-agreements --accept-package-agreements --silent
```

Connexion aux **deux** comptes GitHub :
```bash
"/c/Program Files/GitHub CLI/gh.exe" auth login --web --hostname github.com --git-protocol https
# 1ere fois : se logger en oscardcstudio-cell (compte perso)
# Relancer pour ajouter le compte StudioDescartes :
"/c/Program Files/GitHub CLI/gh.exe" auth login --web --hostname github.com --git-protocol https
"/c/Program Files/GitHub CLI/gh.exe" auth setup-git
```

Verifier :
```bash
gh auth status
# Doit lister les 2 comptes : oscardcstudio-cell + StudioDescartes
```

Le hook `gh-switch.js` (etape 4) bascule automatiquement entre comptes selon le bucket courant (`studio_descartes\` -> StudioDescartes ; `oscardcstudio\` -> oscardcstudio-cell).

---

## 3. Claude Code + outils globaux npm

**Attention npm prefix** : sur une install Node neuve Windows, `%APPDATA%\npm` peut ne pas exister.
```bash
mkdir -p "C:\Users\<user>\AppData\Roaming\npm"
npm config set prefix "C:\Users\<user>\AppData\Roaming\npm"
```

Puis :
```bash
npm install -g @anthropic-ai/claude-code
npm install -g gsd-pi
npm install -g @mermaid-js/mermaid-cli
npm install -g quickchart-js
npm install -g @railway/cli
npm install -g uipro-cli
```

Verifier :
```bash
claude --version      # 2.x
gsd --version         # 2.x (CLI standalone, pas un plugin)
mmdc --version
railway --version
```

---

## 4. User scope Claude Code (`~/.claude/`)

Le user scope contient **tout** : CLAUDE.md global, settings.json, agents, commands, skills, hooks, MEMORY.md, DASHBOARDS.md. Il est versionne dans `oscardcstudio-cell/dotclaude`.

### Cloner le user scope

```bash
# Sur un nouvel ordi, ~/.claude/ doit etre vide ou inexistant
# Si Claude Code l'a deja cree avec des fichiers par defaut, les supprimer d'abord :
rm -rf ~/.claude  # attention : detruit toute config Claude Code en cours

git clone https://github.com/oscardcstudio-cell/dotclaude.git ~/.claude
```

### Connexion Anthropic
```bash
claude auth
```

### Plugins marketplace (deja referencés dans settings.json mais a installer)
```bash
claude plugin install claude-md-management@claude-plugins-official
claude plugin install figma@claude-plugins-official
```

### GSD v1 (slash commands `/gsd:*`)

Le repo `dotclaude` contient `commands/gsd/`, mais GSD v1 a aussi besoin du framework markdown clone separement :
```bash
cd ~/.claude
git clone https://github.com/gsd-build/get-shit-done.git get-shit-done
cd get-shit-done
mv get-shit-done/workflows .
mv get-shit-done/references .
mv get-shit-done/templates .
mv get-shit-done/contexts .
```

### GSD v2 (CLI standalone)
```bash
gsd config
```

### Verifier
```bash
ls ~/.claude/skills/    # ~40 dossiers
ls ~/.claude/commands/  # gsd/, claude-md-management/, ...
ls ~/.claude/hooks/     # gsd-*.js, gh-switch.js, secret-scan.js, ...
ls ~/.claude/agents/    # meta-business.md, meta-marketing.md, meta-creation.md, meta-philosophe.md
cat ~/.claude/settings.json
```

---

## 5. Hooks Claude Code (deja inclus dans dotclaude)

Inventaire des hooks dans `~/.claude/hooks/` (tous deja presents apres clone) :

| Hook | Trigger | Role |
|---|---|---|
| `gsd-check-update.js` | SessionStart | Check update GSD framework |
| `gh-switch.js` | SessionStart | Bascule auto compte GitHub selon bucket courant (SD/perso) |
| `backup-rotation.js` | SessionStart | Garde 10 backups recents de `.claude.json` |
| `secret-scan.js` | PreToolUse (Write/Edit) | Bloque l'ecriture de tokens (ghp_, sk-ant-, AKIA, JWT, etc.) |
| `gsd-context-monitor.js` | PostToolUse | Suivi tokens/contexte |
| `cost-tracker.js` | Stop | Log cumulatif tokens + cout dans `~/.claude/cost-log.csv` |
| `statusline-combined.js` | Statusline | Affiche statusline GSD + autres |

`secret-scan.js` exit 2 si pattern de secret detecte. Exceptions : `.env`, `credentials.json`, `SECURITY.md`, `~/.claude/settings.json`, lui-meme.

---

## 6. Variables systeme Windows

Cles utilisees globalement (pas dans `.env` repo) — **Parametres > Variables d'environnement** :

| Variable | Source | Usage |
|---|---|---|
| `FIGMA_API_KEY` | Figma > Settings > Personal Access Tokens | Plugin Figma officiel (MCP) |
| `OPENROUTER_API_KEY` | https://openrouter.ai/keys | Acces multi-modeles LLM |
| `GITHUB_TOKEN_OSCAR` | GitHub Settings > PAT | Token compte perso pour scripts |

`ANTHROPIC_API_KEY` est geree automatiquement par `claude auth`.

---

## 7. Meta machine (`C:\dev\claude\`)

Le meta machine contient le `CLAUDE.md` cross-projets, le `push-all-global.sh`, et la junction inverse vers `~/.claude/`. Repo : `oscardcstudio-cell/meta-claude-dev`.

```bash
mkdir -p /c/dev
cd /c/dev
git clone https://github.com/oscardcstudio-cell/meta-claude-dev.git claude
cd claude
```

### Junction inverse vers le user scope (pratique pour naviguer)

PowerShell (pas besoin admin) :
```powershell
New-Item -ItemType Junction -Path "C:\dev\claude\.claude-user" -Target "C:\Users\$env:USERNAME\.claude"
```

Verifie : `ls C:\dev\claude\.claude-user` doit lister le contenu de `~/.claude/`.

(`.claude-user/` est dans `.gitignore` du meta machine — pas versionnee.)

---

## 8. Push automatique (tache planifiee Windows)

Le script `push-all-global.sh` (deja clone avec meta-claude-dev) scanne tous les repos git de l'ecosysteme et push ceux qui ont des commits ahead. Lance toutes les 15min via une tache planifiee Windows.

### Creer la tache

```bash
schtasks //Create //SC MINUTE //MO 15 //TN "ClaudePushAll" //TR "wscript.exe \"C:\\dev\\claude\\push-all-global.vbs\"" //F
```

(Ou en PowerShell :)
```powershell
schtasks /Create /SC MINUTE /MO 15 /TN "ClaudePushAll" /TR "wscript.exe `"C:\dev\claude\push-all-global.vbs`"" /F
```

### Verifier

```powershell
schtasks /Query /TN "ClaudePushAll"
schtasks /Run /TN "ClaudePushAll"   # test manuel
Get-Content C:\dev\claude\.push-all.log -Tail 5
```

### Comportement
- **Silencieux** : aucune fenetre console (wrapper `.vbs`).
- **Lock anti-conflit** : `%TEMP%/push-all-claude.lock`. Si deja actif, exit. Stale apres 14min.
- **Ne commit JAMAIS** : push uniquement les commits deja faits.
- **Logs** : `C:/dev/claude/.push-all.log` (rotation a 1000 lignes).

---

# PARTIE 2 — Bucket Studio Descartes

> **Compte GitHub actif** : `StudioDescartes` (org). Le hook `gh-switch.js` bascule auto.
> **Push** : si `Repository not found` malgre auth OK -> conflit Git Credential Manager. Pattern de fallback :
> ```bash
> GH_TOKEN=$("/c/Program Files/GitHub CLI/gh.exe" auth token)
> git push "https://${GH_TOKEN}@github.com/StudioDescartes/<repo>.git" main:main
> ```

## 9. Cloner les repos SD

Cloner d'abord le **bucket meta SD** dans `C:\dev\claude\studio_descartes\` :

```bash
cd /c/dev/claude
git clone https://github.com/StudioDescartes/studio-descartes-meta.git studio_descartes
cd studio_descartes
```

Le bucket meta contient deja : `CLAUDE.md` SD, `claude-agents/` (4 personas brandees), `push-all.sh`, ARCHITECTURE.md, SERVICES.md, etc.

Puis les sous-repos a l'interieur :
```bash
git clone https://github.com/StudioDescartes/philo-runner.git philo_runner
git clone https://github.com/StudioDescartes/studio-descartes-info.git studio-descartes-info
git clone https://github.com/StudioDescartes/studio-descartes-da.git studio-descartes-da
git clone https://github.com/StudioDescartes/studio-descartes-social.git studio-descartes-social
git clone https://github.com/StudioDescartes/studio-descartes-centre-appel.git studio-descartes-centre-appel
git clone https://github.com/StudioDescartes/studio-descartes-dashboard.git studio-descartes-dashboard
```

> `hot_content_pipeline/` vit **a l'interieur** de `studio-descartes-social/` — pas de clone separe.
> `_legacy-questionnaire/` vit **a l'interieur** de `studio-descartes-dashboard/` (mergé du repo questionnaire en avril 2026).

## 10. Personas brandees SD (sync vers user scope)

Les 4 personas SD vivent dans `studio_descartes/claude-agents/` (versionnees dans `studio-descartes-meta`). Pour qu'elles soient utilisables par Claude Code dans tous les contextes, les copier dans `~/.claude/agents/` :

```bash
cp /c/dev/claude/studio_descartes/claude-agents/*.md ~/.claude/agents/
```

Personas attendues : `jules-strategist.md`, `florian-marketing.md`, `oscar-creation.md`, `philosophe.md`. Elles surcouchent les meta-agents generiques (`meta-business`, `meta-marketing`, `meta-creation`, `meta-philosophe`).

## 11. Secrets SD (.env.local par repo)

Backup secrets SD : Drive (`backup_claude_ancien_ordi/secrets/`).

```bash
DRIVE=H  # adapter selon la lettre de drive
BACKUP="/${DRIVE,,}/Mon Drive/STUDIO_DESCARTES/backup_claude_ancien_ordi/secrets"
REPOS="/c/dev/claude/studio_descartes"

cp "$BACKUP/studio-descartes-da.env.local" "$REPOS/studio-descartes-da/.env.local"
cp "$BACKUP/studio-descartes-centre-appel-agent.env.local" "$REPOS/studio-descartes-centre-appel/agent/.env.local"
```

Si une cle manque dans le Drive — la regenerer depuis le service :

| Cle | Service | Dashboard |
|---|---|---|
| `FAL_KEY` | fal.ai | https://fal.ai/dashboard/keys |
| `ELEVENLABS_API_KEY` | ElevenLabs | https://elevenlabs.io/app/settings/api-keys |
| `FIGMA_API_KEY` | Figma | https://www.figma.com/settings > Personal Access Tokens |

Ajouter aussi une copie dans `backup_claude_ancien_ordi/secrets/` apres regeneration.

## 12. Memoire Claude SD

Memoire SD (brand, projets, users, feedbacks) -> `~/.claude/projects/C--dev-claude-studio_descartes/memory/` :

```bash
DEST=~/.claude/projects/C--dev-claude-studio_descartes/memory
mkdir -p "$DEST"
DRIVE=H  # adapter
cp "/${DRIVE,,}/Mon Drive/STUDIO_DESCARTES/backup_claude_ancien_ordi/memory/"*.md "$DEST/"
```

> Si un `MEMORY.md` local existe deja (session en cours), fusionner manuellement.

---

# PARTIE 3 — Bucket perso (oscardcstudio)

> **Compte GitHub actif** : `oscardcstudio-cell` (perso). Le hook `gh-switch.js` bascule auto.

## 13. Cloner le bucket meta perso

```bash
cd /c/dev/claude
git clone https://github.com/oscardcstudio-cell/oscardcstudio-meta.git oscardcstudio
cd oscardcstudio
```

Le bucket meta perso contient : `CLAUDE.md` perso, `push-all.sh`, `dashboard.html`.

## 14. Cloner les sous-repos perso

```bash
git clone https://github.com/oscardcstudio-cell/subvention_match.git subvention_match
git clone https://github.com/oscardcstudio-cell/Sync-Play.git Sync-Play
git clone https://github.com/oscardcstudio-cell/claude-mobile.git claude-mobile

# Auto_Polymarket vit dans org arckler-corp
git clone https://github.com/arckler-corp/AUTO_POLYMARKET.git Auto_Polymarket
```

(Verifier les noms d'orgs / repos avec `gh repo list oscardcstudio-cell` et `gh repo list arckler-corp`.)

## 15. Secrets perso (.env par repo)

Chaque projet perso gere ses propres secrets dans son `.env` local. Pas de backup centralise sur le Drive — les regenerer depuis chaque service au besoin :

| Projet | Variables critiques | Source |
|---|---|---|
| Auto_Polymarket | `GITHUB_TOKEN`, `SUPABASE_URL`, `SUPABASE_KEY`, `DASHBOARD_TOKEN`, `POLYMARKET_*` | Supabase, Polymarket dashboard, GitHub PAT |
| subvention_match | `OPENROUTER_API_KEY`, `RESEND_API_KEY`, `STRIPE_*`, `SUPABASE_*` | OpenRouter, Resend, Stripe, Supabase |
| Sync-Play | (selon `.env.example`) | (cf repo) |

Recreer `.env` a partir de `.env.example` dans chaque repo, remplir les valeurs.

---

# PARTIE 4 — Verification

## 16. Verifier l'install complete

```bash
# Versions
node --version && npm --version && git --version && python --version && claude --version

# Comptes Github
gh auth status

# User scope
ls ~/.claude/CLAUDE.md ~/.claude/MEMORY.md ~/.claude/agents/

# Meta machine
ls /c/dev/claude/CLAUDE.md /c/dev/claude/push-all-global.sh
ls /c/dev/claude/.claude-user/  # via junction

# Repos SD
cd /c/dev/claude/studio_descartes && ls
cd philo_runner && git status && cd ..
cd studio-descartes-info && git status && cd ..
cd studio-descartes-social && git status && ls hot_content_pipeline && cd ..
cd studio-descartes-dashboard && git status && ls _legacy-questionnaire && cd ..

# Repos perso
cd /c/dev/claude/oscardcstudio && ls
cd Auto_Polymarket && git status && cd ..
cd subvention_match && git status && cd ..

# Tache push automatique
schtasks //Query //TN "ClaudePushAll"
cat /c/dev/claude/.push-all.log | tail -5

# Claude Code
claude "dis bonjour"
```

## 17. Comptes a connecter

- [ ] **GitHub** — 2 comptes (`gh auth status` doit lister les deux)
- [ ] **Claude** — `claude auth` (login Anthropic)
- [ ] **Figma** — Personal Access Token dans `FIGMA_API_KEY` (variable systeme)
- [ ] **OpenRouter** — cle dans `OPENROUTER_API_KEY` (variable systeme)
- [ ] **Google Drive** — installer Google Drive for Desktop pour retrouver le `G:\` ou `H:\` (secrets SD + assets)
- [ ] **Railway** — `railway login` si deploiement de bots

---

## Historique

- **2026-04-26** : Refonte avec architecture meta versionnee. Ajout repos `dotclaude` (user scope), `meta-claude-dev` (meta machine), `oscardcstudio-meta` (bucket perso), `studio-descartes-dashboard` (avec questionnaire mergé en `_legacy-questionnaire`). Ajout junction inverse `.claude-user/`. Ajout push automatique 15min (push-all-global.sh + tache planifiee Windows ClaudePushAll). Section 4 (user scope) refondue : clone simple au lieu de copies depuis Drive.
- **2026-04-25** : Refonte cross-projet. Deplace de `studio_descartes/docs/` vers la racine meta. Ajout sections bucket perso, hooks custom (gh-switch, secret-scan, backup-rotation, cost-tracker), meta-agents, GitHub multi-compte.
- **2026-04-20** : Migration vers `C:\dev\claude\` (regle "tout code dans `C:\dev\claude\`"), slug memory `C--dev-claude-studio_descartes`.
- **2026-04-14** : Premiere version (SD-only). Clone repo meta + sous-repos, hooks GSD, GSD v1/v2, MCP Figma, copie secrets/memory depuis Drive.
