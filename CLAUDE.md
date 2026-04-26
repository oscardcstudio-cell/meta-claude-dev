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

### Optimisation tokens (cross-projet)
- Ne pas relire un fichier deja lu dans la meme conversation sans raison
- Preferer `Grep` / `Glob` cibles aux lectures de repertoires entiers
- Agents specialises (Explore, Plan, general-purpose) pour les recherches larges — garder le contexte principal propre
- Commits atomiques : un commit = une intention. Pas de commits fourre-tout qui forcent a relire beaucoup plus tard

### Documentation et fichiers
- Ne pas creer de fichiers de doc (.md) sauf demande explicite ou necessite claire (MIGRATION, MODULE, CLAUDE)
- Preferer editer un fichier existant que d'en creer un nouveau
- Pas de commentaires de code inutiles (le nom des fonctions suffit)

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

## Scoping / separation stricte

**Ne jamais melanger les deux dossiers projets** :
- Un repo SD ne doit jamais pointer vers un remote perso
- Un repo perso ne doit jamais importer des secrets/tokens SD
- Les contenus/marque SD (Jules, Florian, philo) ne s'appliquent QUE sous `studio_descartes\`
- Les projets persos sont neutres (pas de branding SD involontaire)

Si Oscar demande "fais X" en etant dans `oscardcstudio\`, ne pas appliquer automatiquement les regles SD (guide editorial, charte graphique, personas). A l'inverse, toute regle de `C:\dev\claude\CLAUDE.md` (ce fichier) s'applique partout.
