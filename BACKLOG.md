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

---

## 5. Prompt caching — audit apps API

**Etat** : à faire.
**Fichiers** : `subvention_match/server/`, `studio-descartes-slack-bot/index.ts`

Vérifier que le system prompt ne change pas à chaque requête (date injectée, état utilisateur). Si oui → déplacer le contenu dynamique dans les messages, garder le system prompt stable. Impact : cache hit rate + coût + latence.

---

## 6. Tool result clearing — sessions longues

**Etat** : à configurer.
**Fichiers** : `.claude/settings.json` des projets actifs (Auto-Polymarket, SubventionMatch)

Configurer `exclude_tools: ["memory"]` pour que les anciens résultats d'outils (lectures de fichiers massives) soient vidés en gardant la mémoire persistante. Utile quand les sessions dépassent régulièrement 50k tokens.

---

## 7. CLAUDE.md sous-dossiers SD sensibles

**Etat** : partiellement fait (SubventionMatch `server/` done). SD manque.
**Fichiers** : `studio-descartes-centre-appel/agent/`, `studio-descartes-centre-appel/borne/`

Ajouter un `CLAUDE.md` dans `agent/` (règles ElevenLabs sync + validation philosophe obligatoire) et `borne/` (specs hardware B2B, ne pas modifier sans brief client).

---

---

## Convention BACKLOG par projet

Chaque repo peut avoir son propre `BACKLOG.md` à la racine. Format identique à ce fichier (sections `##`). Le hook `backlog-reminder.js` (UserPromptSubmit) rappelle automatiquement les items actifs une fois par jour quand on ouvre Claude dans ce dossier.

**Item actif** : section `##` sans `**Etat** : fait/annulé` dans le corps.
**Item terminé** : ajouter `**Etat** : fait` dans la section, ou préfixer le titre par `~~Titre~~`.
**Ajouter un item** : dire "ajoute ça au backlog" en fin de conversation.

---

## Changelog

- **2026-05-02** : Hook backlog-reminder.js installé (UserPromptSubmit, une fois/jour par projet). Convention documentée.
- **2026-04-25** : Creation du backlog apres audit infra. Migration `studio_descartes` finalisee, hooks installes, meta-agents crees, settings consolides. 18 -> 4 settings.local.json. Worktrees orphelins purges.
