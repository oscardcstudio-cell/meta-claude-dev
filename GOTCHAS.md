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
