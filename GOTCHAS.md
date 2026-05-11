# GOTCHAS — pièges cross-projets

Pièges techniques découverts sur un projet et applicables à tous les projets de la machine.
Chaque entrée : symptôme, cause, règle à retenir, origine.

---

## Node.js — npm vs bun lock file

**Symptôme** : build Railway/Vercel/CI échoue avec erreur lock file (`npm ci` ne trouve pas `package-lock.json` à jour).
**Cause** : `bun install` génère `bun.lock` mais ne met pas à jour `package-lock.json`. Si les deux coexistent, le CI Node utilise `npm ci` qui exige `package-lock.json` cohérent.
**Règle** : toujours `npm install` (pas `bun install` seul) quand on touche les deps sur un projet avec `package-lock.json`.
**Réflexe pre-push** : si `package.json` modifié mais `package-lock.json` inchangé → lancer `npm install` avant commit.
**Origine** : Auto-Polymarket, mai 2026.

---

## Railway — `railway up` depuis un git worktree packe le repo principal, pas le worktree

**Symptôme** : tu fixes un bug dans un git worktree, tu lances `railway up` depuis le worktree, le build Railway échoue toujours sur l'erreur que tu pensais avoir corrigée. L'erreur pointe sur des lignes/contenus qui n'existent pas dans le worktree mais qui existent dans le main repo (souvent sur une branche différente comme `main`).
**Cause** : `railway up` ne packe PAS le contenu local du worktree. Il suit la résolution Git et envoie le contenu de la branche déployée du repo principal. Le path de cache dans les logs Railway révèle le vrai working dir (`s/<id>-<chemin-relatif>`).
**Règle** : pour qu'un fix arrive en prod via `railway up`, il doit être commité **sur la branche déployée du main repo** (souvent `main`), pas sur la branche du worktree. Vérifier avec `cd <main-repo> && git log` que le commit est bien là avant de lancer le déploiement.
**Réflexe** : avant `railway up`, faire `cd` dans le main repo (sortir du worktree), checkout la branche déployée, cherry-pick / merge le fix, push, puis `railway up`.
**Origine** : studio-descartes-da, mai 2026.
**Note v2.1.133 (ne résout PAS ce bug)** : Claude Code a ajouté la setting `worktree.baseRef: "head"` pour que les `EnterWorktree` CC partent du HEAD local (incluant commits non pushés). Cette setting concerne uniquement les worktrees créés par CC — elle ne change rien au comportement de `railway up` qui continue d'uploader le main repo.

---

## Railway — monorepo : Railpack analyse la racine et échoue si seuls des .md sont présents

**Symptôme** : deploy Railway fail avec *"Railpack analyzed the repo root and found only documentation and markdown files, with no recognizable project files to build."* Le service existe bien, `railway up` s'est lancé, mais le build échoue.
**Cause** : `railway up` depuis un sous-dossier d'un monorepo envoie parfois la racine du repo git parent au lieu du sous-dossier. Railpack ne trouve pas de `package.json` / `Dockerfile` à la racine — seulement les `.md` du méta-repo.
**Règle** : utiliser `--path-as-root` et lancer depuis le dossier parent SD :
```
cd C:/dev/claude/studio_descartes
railway up studio-descartes-dashboard --path-as-root --service sd-dashboard --detach
```
`--path-as-root` force Railway à utiliser le contenu du sous-dossier comme racine de l'archive, sans remonter au repo git parent. Le `rootDirectory` côté Railway doit rester vide (`""`) — ne pas le setter à `studio-descartes-dashboard` (Railway cherche alors un sous-dossier dans l'archive, mais il n'existe pas car `--path-as-root` l'a déjà aplatit).
**Réflexe** : si deploy fail avec ce message → vérifier que la commande utilise bien `--path-as-root` + que `rootDirectory` est vide dans Railway (API ou dashboard).
**Origine** : studio-descartes-dashboard, mai 2026.

---

## Claude Code v2.1.133 — `worktree.baseRef` change de défaut (régression silencieuse)

**Symptôme** : un worktree créé via `--worktree`, `EnterWorktree` ou agent-isolation ne contient plus tes commits locaux non pushés. Les agents lancés en worktree partent d'une base "vide" alors qu'avant ils héritaient du HEAD local.
**Cause** : depuis v2.1.128, `EnterWorktree` partait du HEAD local. v2.1.133 a inversé le défaut pour repartir d'`origin/<default>` (`fresh`), pour éviter de propager des commits buggés. Si tu travailles avec des commits locaux non pushés, ils sont absents du worktree.
**Règle** : si tu as régulièrement des commits locaux non pushés que tu veux retrouver dans tes worktrees CC → ajouter `"worktree.baseRef": "head"` dans `~/.claude/settings.json`.
**Origine** : Anthropic v2.1.133 (7 mai 2026), repéré dans le changelog par la routine veille.


---

## Railway — `npm warn config production` (Nixpacks)

**Symptôme** : build Railway affiche `npm warn config production Use --omit=dev instead.` à chaque deploy.
**Cause** : Nixpacks passe `--production` en interne lors de la phase install. Pas configurable depuis `railway.json`.
**Fix** : créer un `nixpacks.toml` à la racine du repo avec :
```toml
[phases.install]
cmds = ["npm install --omit=dev"]
```
**Règle** : si un nouveau repo SD déploie sur Railway avec Nixpacks → créer ce fichier dès le setup.
**Origine** : studio-descartes-da, mai 2026.

---

## Railway — Railpack échoue si `package.json` sans `dependencies`

**Symptôme** : deploy Railway fail avec *"could not determine how to build the app"* même si un `package.json` est présent avec un script `start`. Railpack ne détecte pas le projet comme Node.js.
**Cause** : Railpack (nouveau builder Railway) requiert au moins un champ `dependencies` (non vide) dans `package.json` pour reconnaître un projet Node.js. Un `package.json` avec uniquement `scripts` ne suffit pas — Railpack l'ignore.
**Fix** : ajouter la dépendance principale en `dependencies` (ex. `"serve": "^14.2.3"` pour un site statique) + un champ `engines`. Passer le script de `npx serve` à `serve` directement (serve installé localement).
```json
{
  "engines": { "node": ">=18" },
  "scripts": { "start": "serve -p ${PORT:-3000} ." },
  "dependencies": { "serve": "^14.2.3" }
}
```
**Règle** : tout nouveau repo SD qui déploie sur Railway avec un `package.json` → toujours déclarer la dépendance principale dans `dependencies`, jamais uniquement dans `scripts`.
**Origine** : studio-descartes-info, mai 2026.

---

## Railway — volumes CLI (Windows)

**Symptôme** : `railway volume add --mount-path /data` échoue avec "Mount path must start with a `/`" depuis bash Windows — le CLI strippe le slash.
**Fix** : `powershell -Command "railway volume add --mount-path '/data'"` fonctionne.
**Règle** : l'onglet "Volumes" n'existe pas dans l'UI service — passer par clic droit sur le canvas projet → "New Volume" (ou `Cmd+K`). Si Oscar est sur téléphone ou bloqué → Claude fait l'action CLI lui-même via PowerShell sans demander.
