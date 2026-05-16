# CLAUDE.md — racine `C:\dev\claude\` (meta cross-projets)

## Qu'est-ce que ce fichier

Ce fichier est le **meta racine** de tout le travail Claude sur cette machine. Il s'applique automatiquement a **tous** les projets (Studio Descartes + projets persos oscardcstudio) quand Claude est lance dans `C:\dev\claude\` ou un sous-dossier.

**Usage** : regles, preferences, optimisations et infrastructures qui doivent s'appliquer **cross-projet** (peu importe l'entreprise). Rien d'entreprise-specifique ici — ca vit dans le CLAUDE.md de chaque dossier projet (`studio_descartes\`, `oscardcstudio\`).

Deux dossiers : `studio_descartes\` (org SD) et `oscardcstudio\` (perso). Les repos vivent **directement** dans leur bucket (pas de junctions). Meta-agents generiques dans `C:\Users\oscar\.claude\agents\`.

## Hierarchie de chargement CLAUDE.md

1. `C:\Users\oscar\.claude\CLAUDE.md` — user global (toutes entreprises, toutes machines)
2. `C:\dev\claude\CLAUDE.md` — **ce fichier**, meta cross-projets machine locale
3. `C:\dev\claude\<dossier>\CLAUDE.md` — dossier entreprise (SD) ou perso (oscardcstudio)
4. `C:\dev\claude\<dossier>\<repo>\CLAUDE.md` — specifique au repo

Tout ce qui est declare a un niveau N s'applique a N+1, N+2 etc. Sauf contradiction explicite plus bas.

## Regles universelles (tous projets)

### Langue et communication
- **Francais** par defaut (sauf code, commits techniques, fichiers publics internationaux)
- Reponses directes et concises — pas de preambules, pas de recap de fin inutile
- Pas d'emojis sauf demande explicite
- Oscar ne code pas : executer directement (commandes, git, MCP) sans demander confirmation sur les actions techniques standards

### Git / GitHub — double compte
Deux comptes GitHub distincts sur cette machine :
- **`StudioDescartes`** (org societe) → tout ce qui est dans `studio_descartes\`
- **GitHub perso `oscardcstudio-cell`** → tout ce qui est dans `oscardcstudio\`

**Avant tout push** : verifier que le remote correspond au bon compte. Si mismatch : `gh auth switch` vers le bon user avant de push.

**Auto-push active** : apres un commit significatif, `git push` direct sans demander confirmation. Oscar fait confiance pour juger le bon moment (fin d'etape, refactor propre, ajout de fichiers coherent).

### Propagation de gotchas cross-projet
Si une leçon/piège technique appris sur un projet peut affecter d'autres projets de la machine → l'ajouter dans [`GOTCHAS.md`](GOTCHAS.md) (même dossier que ce fichier). Ne pas mettre de détails techniques dans CLAUDE.md.

### Philosophie du bug — règles universelles (mai 2026)

- **5 Whys avant d'écrire le fix** → la cause racine n'est jamais une personne → voir [`CLAUDE_BUG_DOCTRINE.md`](CLAUDE_BUG_DOCTRINE.md)
- **Après chaque correction d'erreur, question obligatoire** : "Qu'est-ce qui empêche que ça revienne ?" → puis action concrète immédiate sans attendre qu'Oscar la demande :
  - bug reproductible → ajouter un test qui le couvre
  - type/valeur inattendue → ajouter une assertion ou une validation d'entrée
  - config silencieuse → ajouter un check dans le health check du projet
  - erreur d'ordre d'opération → ajouter un invariant ou un guard clause
  - comportement non-évident → ajouter un commentaire + gotcha dans llms.txt
- **Root cause one-liner dans chaque commit bugfix** : `Root cause: <cause systémique en une phrase>` — rappel non-bloquant (hook `commit-root-cause.js` alertera si oublié)

### Optimisation tokens (cross-projet)
- Ne pas relire un fichier deja lu dans la meme conversation sans raison
- Preferer `Grep` / `Glob` cibles aux lectures de repertoires entiers
- Agents specialises (Explore, Plan, general-purpose) pour les recherches larges — garder le contexte principal propre
- Commits atomiques : un commit = une intention. Pas de commits fourre-tout qui forcent a relire beaucoup plus tard

### Documentation et fichiers
- Ne pas creer de fichiers de doc (.md) sauf demande explicite ou necessite claire (MIGRATION, MODULE, CLAUDE)
- Preferer editer un fichier existant que d'en creer un nouveau
- Pas de commentaires de code inutiles (le nom des fonctions suffit)

## Context Engineering — doctrine transverse

Doctrine complète : [`CONTEXT_ENGINEERING_DOCTRINE.md`](CONTEXT_ENGINEERING_DOCTRINE.md)

Résumé des 7 standards : (1) llms.txt à la racine — inventaire unique des fichiers critiques, (2) CLAUDE.md < 200 lignes = règles uniquement, (3) index de sections dans les fichiers > 2000 lignes, (4) blocs désactivés commentés avec raison, (5) audit hebdomadaire sur projets actifs, (6) séquence de classement avant tout ajout à un CLAUDE.md, (7) signaler et corriger la dette documentaire en session.

Checklist nouveau projet : llms.txt | fichiers > 300 lignes documentés | index > 2000 lignes | blocs désactivés commentés | routine audit

## Meta-agents (moteurs cross-projets)

Les **meta-agents generiques** vivent dans `C:\Users\oscar\.claude\agents\` (user scope, charges automatiquement par Claude Code dans tous les projets) :
- `meta-business` — strategie, finance, business plan, pitch, subvention
- `meta-marketing` — marketing, com, social, emails, landing, SEO
- `meta-creation` — DA, design, deck, dossier, visuel, Figma, 3D
- `meta-ui-ux` — dashboards et interfaces internes (Tufte/Nielsen/WCAG, cascade 3 couches, déclinable par projet)
- `meta-philosophe` — philo, citations, concepts, validations

Dans chaque dossier projet, ces meta-agents peuvent etre **surcouches par des personas brandees** qui les chargent en interne :
- Dossier SD → `jules-strategist`, `florian-marketing`, `oscar-creation`, `philosophe` (vivent dans `studio_descartes\claude-agents\`)
- Dossier perso → pas de persona par defaut, utiliser directement les meta-agents

## Créer un nouveau projet

Procédure complète : [`NEW_PROJECT.md`](NEW_PROJECT.md)

Résumé : choisir bucket → `gh auth switch` au bon compte → `mkdir` + `git init` directement dans le bucket → `gh repo create` → installer CLAUDE.md / llms.txt / wiki-template → premier commit + push → référencer dans le CLAUDE.md du bucket.

## Push all — niveaux

- **Push all SD** : `bash C:/dev/claude/studio_descartes/push-all.sh`
- **Push all perso** : `bash C:/dev/claude/oscardcstudio/push-all.sh`
- **Push all global** : TODO — a creer a la racine si Oscar le demande un jour

Claude ne lance `push-all` qu'a la demande explicite d'Oscar ou en fin de session significative.

## Sante infra IA (cross-projet)

Tous les projets respectent les regles definies dans `CLAUDE_HEALTH_RULES.md` (meme niveau que ce fichier).

- **Avant de creer ou modifier un CLAUDE.md** → consulter `CLAUDE_HEALTH_RULES.md` (seuils, patterns `@import`, anti-patterns).
- **Hook auto** : `~/.claude/hooks/claude-md-health-check.js` (SessionStart) alerte si un projet derive (taille, residus, MEMORY.md absent, gros fichiers sans `.claudeignore`).
- **Audit profond manuel** : skill `claude-config-doctor` quand le hook signale critical.
- **Skills officiels** : `claude-md-management:claude-md-improver` pour refactor de CLAUDE.md, `revise-claude-md` pour update post-session.

Pas d'`@import` automatique de `CLAUDE_HEALTH_RULES.md` ici — sinon il gonfle le contexte de tous les projets, l'inverse du but. Lecture a la demande.

## Scoping / separation stricte

**Ne jamais melanger les deux dossiers projets** :
- Un repo SD ne doit jamais pointer vers un remote perso
- Un repo perso ne doit jamais importer des secrets/tokens SD
- Les contenus/marque SD (Jules, Florian, philo) ne s'appliquent QUE sous `studio_descartes\`
- Les projets persos sont neutres (pas de branding SD involontaire)

Si Oscar demande "fais X" en etant dans `oscardcstudio\`, ne pas appliquer automatiquement les regles SD (guide editorial, charte graphique, personas). A l'inverse, toute regle de `C:\dev\claude\CLAUDE.md` (ce fichier) s'applique partout.
