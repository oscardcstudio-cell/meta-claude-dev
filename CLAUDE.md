# CLAUDE.md — racine `C:\dev\claude\` (meta cross-projets)

## Qu'est-ce que ce fichier

Ce fichier est le **meta racine** de tout le travail Claude sur cette machine. Il s'applique automatiquement a **tous** les projets (Studio Descartes + projets persos oscardcstudio) quand Claude est lance dans `C:\dev\claude\` ou un sous-dossier.

**Usage** : regles, preferences, optimisations et infrastructures qui doivent s'appliquer **cross-projet** (peu importe l'entreprise). Rien d'entreprise-specifique ici — ca vit dans le CLAUDE.md de chaque dossier projet (`studio_descartes\`, `oscardcstudio\`).

## Arborescence

```
C:\dev\claude\                      <- racine meta (ce fichier)
|-- CLAUDE.md                       <- meta cross-projets (celui-ci)
|-- .claudeignore                   <- exclusions globales (node_modules, .env, assets lourds)
|-- studio_descartes\               <- dossier entreprise SD (repo parent + sous-repos)
|   |-- CLAUDE.md                   <- meta SD (marque, guide editorial, charte)
|   |-- philo_runner\, studio-descartes-da\, -social\, -centre-appel\, -info\, -questionnaire\
|   |-- claude-agents\              <- personas brandees SD (jules/florian/oscar/philosophe)
|   |-- push-all.sh                 <- push all repos SD
|   `-- ... (autres repos SD)
`-- oscardcstudio\                  <- dossier projets persos (repos physiques)
    |-- CLAUDE.md                   <- meta perso (compte GitHub perso, regles)
    |-- .gitignore                  <- protection transverse dossier projet perso
    |-- push-all.sh                 <- push all repos perso
    |-- Auto_Polymarket\, subvention_match\, Sync-Play\
```

Les **meta-agents generiques** (moteurs business/marketing/creation/philosophe) vivent dans `C:\Users\oscar\.claude\agents\meta-*.md` (user scope, charges automatiquement par Claude Code partout). Voir section "Meta-agents" plus bas.

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

### Compaction
Quand Claude compresse une longue session, toujours conserver : liste complète des fichiers modifiés, commandes de test actives, décisions non committées.

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

Le **context engineering** est la discipline de rendre le codebase navigable et lisible pour les agents Claude, afin de reduire les erreurs, les lectures inutiles, et les regressions silencieuses. C'est un domaine etabli (Martin Fowler, Anthropic engineering blog, standard `llms.txt`).

Origine sur ce repo : audit de lisibilite Auto-Polymarket (mai 2026). Toutes les regles ci-dessous s'appliquent a **tout projet actif** sauf mention contraire.

### Les 5 standards a respecter dans chaque projet

**1. CLAUDE.md precis**
- Chaque fichier critique (> 300 lignes) liste avec sa vraie responsabilite — pas ce qu'on pensait qu'il faisait
- La description doit reflechir ou la logique se trouve REELLEMENT (`engine.js` ne fait pas le sizing si le sizing est dans `sizeCalc.js`)
- Quand un nouveau fichier critique est cree → l'ajouter au CLAUDE.md dans le meme commit

**2. `llms.txt` a la racine du repo**
Fichier de navigation pour tout agent arrivant a froid (remote agent, nouveau contexte). Different de CLAUDE.md : CLAUDE.md = instructions, `llms.txt` = carte.
Template minimal :
```markdown
# Nom du projet
> Description en 1 ligne

## Vue d'ensemble
- [CLAUDE.md](CLAUDE.md): Instructions completes pour Claude Code (architecture, regles, fichiers critiques, gotchas)

## Fichiers critiques
- [src/xxx.js](src/xxx.js): Role precis du fichier
- [src/yyy.js](src/yyy.js): Role precis du fichier

## Points non-evidents (gotchas)
- Invariant 1 a connaitre avant de toucher au code
- Invariant 2
```
Adoption : Anthropic, Cloudflare, Stripe. Standard propose par Answer.AI (sept. 2024).

**3. Index de sections dans les fichiers > 2000 lignes**
Tout fichier > 2000 lignes avec plusieurs responsabilites → bloc de commentaires en tete avec numeros de lignes approximatifs et role de chaque bloc. Voir `src/logic/shadowTrading.js` dans Auto-Polymarket comme modele.

**4. Commentaires sur code desactive intentionnellement**
Tout bloc desactive en dur (`if (false)`, feature flag off, dead branch) → commentaire visible expliquant POURQUOI et qui decide de le reactiver. Sans ca Claude peut le lire comme actif et baser une modification dessus.

**5. Audit de lisibilite periodique**
Routine schedulee hebdomadaire sur les projets actifs qui detecte : nouveaux fichiers > 300 lignes non documentes, fichiers > 2000 lignes sans index, descriptions obsoletes.
Modele de routine : Auto-Polymarket `trig_0198tTQrATeMpeBEgaifUNqR` (lundi 8h Paris).
Quand un audit remonte des corrections universelles → les remonter ici, pas les garder dans le CLAUDE.md projet.

### Outils utiles

| Outil | Usage | Lien |
|-------|-------|------|
| **Repomix** | Packager tout le repo en un fichier AI-friendly pour analyse globale ponctuelle | https://repomix.com |
| **Claude Context MCP** | Recherche semantique sur le codebase (~40% reduction tokens vs grep manuel) | https://github.com/zilliztech/claude-context |
| `gsd:map-codebase` | Audit ponctuel complet (skill local) | — |

### Propagation vers les projets existants

**Deux niveaux de propagation — a faire dans l'ordre :**

**Niveau 1 — automatisable (llms.txt)** : peut etre applique par un remote agent sur n'importe quel repo sans connaissance metier. A faire en premier sur tous les projets.
→ Lancer depuis n'importe ou : "cree le llms.txt pour le projet X (repo GitHub : URL)"

**Niveau 2 — necessite contexte projet (audit complet)** : verification CLAUDE.md vs code reel, index de sections sur les gros fichiers, audit des descriptions. Necessite d'etre dans le projet.
→ A faire projet par projet : ouvrir le projet, dire "applique le context engineering selon les standards du meta CLAUDE.md"

**Checklist par projet (a cocher a chaque nouveau projet ou audit annuel) :**
- [ ] `llms.txt` present a la racine
- [ ] Tous les fichiers > 300 lignes listes dans CLAUDE.md avec description precise
- [ ] Fichiers > 2000 lignes avec index de sections en tete
- [ ] Blocs desactives commentes
- [ ] Routine d'audit schedulee (si projet actif avec commits reguliers)

**Projets a passer en context engineering (mai 2026) :**
- [x] Auto-Polymarket — fait (mai 2026)
- [x] subvention_match — llms.txt ajouté (mai 2026)
- [x] Sync-Play — llms.txt ajouté (mai 2026)
- [x] Repos Studio Descartes actifs — llms.txt ajouté sur tous les repos + meta (mai 2026)
- [x] meta-claude-dev — llms.txt ajouté (mai 2026)

> Niveau 1 (llms.txt) : 100% des projets couverts. Niveau 2 (audit CLAUDE.md vs code réel) : à faire projet par projet.

## Meta-agents (moteurs cross-projets)

Les **meta-agents generiques** vivent dans `C:\Users\oscar\.claude\agents\` (user scope, charges automatiquement par Claude Code dans tous les projets) :
- `meta-business` — strategie, finance, business plan, pitch, subvention
- `meta-marketing` — marketing, com, social, emails, landing, SEO
- `meta-creation` — DA, design, deck, dossier, visuel, Figma, 3D
- `meta-philosophe` — philo, citations, concepts, validations

Dans chaque dossier projet, ces meta-agents peuvent etre **surcouches par des personas brandees** qui les chargent en interne :
- Dossier SD → `jules-strategist`, `florian-marketing`, `oscar-creation`, `philosophe` (vivent dans `studio_descartes\claude-agents\`)
- Dossier perso → pas de persona par defaut, utiliser directement les meta-agents

## Dashboards — registry global

Index : `C:\Users\oscar\.claude\DASHBOARDS.md`

Tous les dashboards, interfaces HTML, vues visuelles et mini-apps construits sur cette machine sont catalogues la. Consulter avant d'en creer un nouveau, mettre a jour apres creation/modif substantielle. Skill dedie : `dashboards-index`.

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
