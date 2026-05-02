# BACKLOG — Infra Claude (cross-projets)

Items identifies pendant l'audit infra du 2026-04-25. Pas urgent, a reprendre quand pertinent.

---

## 1. Split CLAUDE.md avec @imports

**Etat** : repousse — pas urgent.
**Trigger pour reactiver** : quand `C:\dev\claude\CLAUDE.md` depasse ~400 lignes.

Aujourd'hui ~180 lignes — charge a chaque conversation. Quand ca deviendra lourd, extraire les sections lourdes (git multi-compte, push-all, regles de scoping) dans des fichiers separes et referencer via `@chemin.md` dans le CLAUDE.md principal. Claude charge alors le fichier importe seulement quand pertinent.

---

## 2. Personas SD → Subagents

**Etat** : a discuter — decision de design.
**Beneficiaires probables** : Jules (analyses strat longues), Philosophe (verification rigoureuse).
**A laisser en chat** : Oscar-creation, Florian (dialogue rapide).

Aujourd'hui, les personas brandees vivent dans `studio_descartes/claude-agents/*.md` et sont jouees dans le contexte principal. Les passer en Subagents = chacun dans sa propre fenetre, contexte principal allege, parallelisable.

Action concrete si feu vert : creer `~/.claude/agents/jules-strategist.md` + `philosophe.md` avec frontmatter `description:` + le prompt. Les autres restent en .md "persona joue dans le chat".

---

## 3. Dashboard registry — Astro

**Etat** : repousse — overkill.
**Trigger pour reactiver** : 30+ dashboards actifs OU envie d'une vraie vitrine publique.

Aujourd'hui `~/.claude/DASHBOARDS.md` (markdown) suffit. Astro = mini site statique avec miniatures, tags, recherche. Build step + serveur local = trop pour <20 dashboards.

---

## 4. Reduction des prompts de permission

**Etat** : audit fait sur Auto_Polymarket (2026-04-25). Les autres projets sont deja propres.
**Methode** : pas de skill auto — audit manuel + regles generiques (`Bash(node -e:*)`) au lieu de one-offs.

Si un projet recommence a accumuler du bruit dans son `settings.local.json`, ouvrir le fichier, deduper, remplacer les patterns repetitifs par des regles globales. Voir `oscardcstudio/Auto_Polymarket/.claude/settings.local.json` comme reference (118 -> 55 entrees).

---

## Changelog

- **2026-04-25** : Creation du backlog apres audit infra. Migration `studio_descartes` finalisee, hooks installes, meta-agents crees, settings consolides. 18 -> 4 settings.local.json. Worktrees orphelins purges.
