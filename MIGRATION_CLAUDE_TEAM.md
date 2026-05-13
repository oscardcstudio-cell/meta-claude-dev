# Migration Claude Pro -> Claude Team

Procedure de bascule du compte Anthropic actuel (perso, plan Pro) vers un nouveau compte sur adresse pro avec plan Team. Conçu pour le setup `~/.claude/` + `C:\dev\claude\` documenté dans [SETUP_NOUVEL_ORDI.md](SETUP_NOUVEL_ORDI.md).

## Principe

**Aucun fichier local ne dépend du compte Anthropic.** Le changement de compte = uniquement un re-login. Tout le contexte (CLAUDE.md hierarchie, agents, hooks, settings, memoires locales, historique `/resume`) survit intact.

Ce qui change :
- **Facturation** : nouveau plan Team sur le nouvel email
- **Memory claude.ai web** (feature server-side Settings > Memory) : repart de zéro — non critique si workflow 100% Claude Code
- **Historique conversations claude.ai web** : non transféré — l'historique Claude Code (`/resume`) est local, indépendant

## Pré-flight (avant la bascule)

Snapshot de l'état actuel pour pouvoir comparer après. À lancer dans Git Bash :

```bash
# Backup credentials au cas où
cp ~/.claude/.credentials.json ~/.claude/.credentials.json.bak-pre-team-migration 2>/dev/null || echo "Pas de .credentials.json — OK"

# Snapshot état
{
  echo "=== Date snapshot ==="
  date
  echo
  echo "=== Compte actuel ==="
  claude --version
  echo
  echo "=== Agents ~/.claude/agents/ ==="
  ls ~/.claude/agents/
  echo
  echo "=== Hooks ~/.claude/hooks/ ==="
  ls ~/.claude/hooks/
  echo
  echo "=== Skills (count) ==="
  ls ~/.claude/skills/ | wc -l
  echo
  echo "=== Commands ==="
  ls ~/.claude/commands/
  echo
  echo "=== MEMORY.md user ==="
  test -f ~/.claude/MEMORY.md && wc -l ~/.claude/MEMORY.md || echo "absent"
  echo
  echo "=== Memoires projets ==="
  ls ~/.claude/projects/ 2>/dev/null | head -20
  echo
  echo "=== Plugins ==="
  claude plugin list 2>&1 | head -20
  echo
  echo "=== Settings hooks declares ==="
  grep -A2 '"hooks"' ~/.claude/settings.json 2>/dev/null | head -30
  echo
  echo "=== gh auth ==="
  gh auth status 2>&1
} > ~/migration-snapshot-PRE.txt

echo "Snapshot ecrit dans ~/migration-snapshot-PRE.txt"
```

Note quelque part (papier, note app) :
- Email du compte actuel
- Plan actuel (Pro probablement)
- Date de fin de cycle de facturation (utile pour timer l'annulation)

## Bascule

1. **Créer le compte Team** sur claude.ai/team avec l'adresse pro. Utiliser un email **différent** de l'actuel — sinon conflit.
2. **Activer le workspace Team**, devenir admin. Pas besoin d'inviter qui que ce soit pour usage solo.
3. **Côté Claude Code** :
   ```bash
   # Dans une session Claude Code active :
   /logout

   # Ou en CLI direct :
   claude logout   # purge tokens locaux

   # Re-login avec le nouveau compte
   claude   # premier lancement déclenche le flow auth
   # Choisir "Login with Claude account" -> ouvre browser -> login email pro
   ```
4. **Vérifier que le plan Team est bien détecté** : dans une session, taper `/status` ou regarder le statusline (devrait afficher "Team" au lieu de "Pro").

## Checklist post-migration

Lancer dans Git Bash, dans `C:\dev\claude\` :

```bash
cd /c/dev/claude
claude   # nouvelle session
```

Dans la session, exécuter ces commandes et vérifier :

### A. Auth et plan

- [ ] `/status` -> nouvel email affiché, plan **Team**
- [ ] Pas de prompt de re-login intempestif

### B. Contexte chargé

- [ ] `/memory` -> liste les CLAUDE.md (user `~/.claude/` + meta `C:\dev\claude\` au minimum)
- [ ] `/agents` -> liste les meta-agents (`meta-business`, `meta-marketing`, `meta-creation`, `meta-philosophe`)
- [ ] `/hooks` ou inspection settings -> 7 hooks listés (gsd-check-update, gh-switch, backup-rotation, secret-scan, gsd-context-monitor, cost-tracker, statusline-combined, claude-md-health-check)
- [ ] Plugins : `/plugins` ou `claude plugin list` -> `claude-md-management`, `figma` présents

### C. Tests fonctionnels

- [ ] Petit prompt simple (`"dis bonjour"`) -> réponse OK = auth + modèle OK
- [ ] `claude --resume` (en CLI) -> liste les sessions locales précédentes (preuve : historique local survit)
- [ ] Test MCP GitHub : demander "liste mes derniers PRs sur oscardcstudio-cell" -> MCP répond
- [ ] Test secret-scan : essayer de write un faux token style `sk-ant-xxx` -> hook bloque

### D. Buckets et gh-switch

```bash
cd /c/dev/claude/studio_descartes
gh auth status   # doit montrer compte StudioDescartes actif (hook gh-switch.js)

cd /c/dev/claude/oscardcstudio
gh auth status   # doit montrer compte oscardcstudio-cell actif
```

- [ ] gh-switch bascule bien entre les deux comptes selon le bucket
- [ ] Dans `studio_descartes/`, lancer `claude` -> personas SD (`jules-strategist`, etc.) listées dans `/agents`

### E. Mémoires

- [ ] `cat ~/.claude/MEMORY.md` -> contenu intact
- [ ] `ls ~/.claude/projects/C--dev-claude-studio_descartes/memory/` -> fichiers SD présents
- [ ] `ls ~/.claude/projects/` -> tous les slugs projet présents

### F. Push automatique

- [ ] `schtasks //Query //TN "ClaudePushAll"` -> tache toujours active (indépendante du compte Anthropic)
- [ ] `tail -5 /c/dev/claude/.push-all.log` -> dernière exécution récente
- [ ] Forcer un cycle : `schtasks //Run //TN "ClaudePushAll"`, vérifier le log

### G. Snapshot POST et diff

```bash
{
  echo "=== Date snapshot POST ==="
  date
  echo
  echo "=== Agents ==="
  ls ~/.claude/agents/
  echo
  echo "=== Hooks ==="
  ls ~/.claude/hooks/
  echo
  echo "=== Plugins ==="
  claude plugin list 2>&1 | head -20
} > ~/migration-snapshot-POST.txt

diff ~/migration-snapshot-PRE.txt ~/migration-snapshot-POST.txt
```

Différences attendues : `Date snapshot` uniquement. Toute autre différence = à investiguer.

## Si quelque chose casse

| Symptôme | Cause probable | Fix |
|---|---|---|
| `claude` demande auth en boucle | tokens corrompus | `rm ~/.claude/.credentials.json` puis `claude` |
| Plugins absents | marketplace pas réinstallé sur ce compte | `claude plugin install claude-md-management@claude-plugins-official` et `figma@claude-plugins-official` |
| MCP GitHub fail | `GITHUB_TOKEN_OSCAR` env var absente ou token expiré | régénérer PAT sur github.com -> Settings env Windows |
| Hooks ne firent pas | settings.json corrompu ou ancien backup actif | comparer `~/.claude/settings.json` vs commit récent dans `dotclaude` |
| `/agents` vide | clone `dotclaude` incomplet | `cd ~/.claude && git status && git pull` |
| Statusline absente | hook statusline-combined.js KO | check `node ~/.claude/hooks/statusline-combined.js` direct |
| Cost tracker n'écrit plus | normal, nouveau cycle | `~/.claude/cost-log.csv` continue à s'écrire (pas reset, mais nouvelles lignes attribuables au compte Team via timestamp) |

## Annulation de l'ancien abonnement

**Ne PAS annuler avant validation complète de la checklist.** Une fois tout vert :

1. Login claude.ai avec ancien email
2. Settings -> Billing -> Cancel subscription
3. **Garder le compte gratuit** : utile si besoin de récupérer un truc dans l'historique web, ou pour /resume sur conversations claude.ai antérieures
4. Pas de suppression de compte

## Décision à acter : single ou dual compte ?

Deux options post-migration :

**A. Single Team** (recommandé pour simplicité) — Le compte Team gère tout, SD + perso. Facturation pro unique. Pas d'auto-switch nécessaire.

**B. Dual** — Team pour SD, gratuit pour perso. Permet attribution facture stricte. **Limitation** : pas d'équivalent `gh-switch.js` pour Claude — bascule manuelle `/logout` + `/login` quand on change de bucket. Coût cognitif réel.

Si choix B retenu un jour : ajouter une note ici sur le pattern de bascule manuelle, ou explorer un hook SessionStart custom qui détecte le bucket et avertit si mauvais compte connecté.

## Historique

- **2026-05-13** : Première version. Bascule compte perso Pro -> compte pro Team avec adresse Studio Descartes. Branche `claude/migrate-claude-team-6k6rb`.
