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
