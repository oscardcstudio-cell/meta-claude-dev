# Context Engineering — Doctrine transverse

Le **context engineering** est la discipline de rendre le codebase navigable et lisible pour les agents Claude, afin de réduire les erreurs, les lectures inutiles, et les régressions silencieuses.

Origine : audit de lisibilité Auto-Polymarket (mai 2026). Standards adoptés par Anthropic, Cloudflare, Stripe. Proposé par Answer.AI (sept. 2024).

## Les 7 standards

**1. CLAUDE.md précis**
- Fichiers critiques (> 300 lignes) → descriptions dans **llms.txt** (pas CLAUDE.md). CLAUDE.md = règles de comportement, pas inventaire.
- La description doit refléter où la logique se trouve RÉELLEMENT (`engine.js` ne fait pas le sizing si le sizing est dans `sizeCalc.js`)
- Quand un nouveau fichier critique est créé → l'ajouter dans llms.txt dans le même commit

**2. `llms.txt` à la racine du repo**
Fichier de navigation pour tout agent arrivant à froid. CLAUDE.md = règles, `llms.txt` = carte + **inventaire unique** des fichiers sources. Ne pas dupliquer cet inventaire dans CLAUDE.md.
Template minimal :
```markdown
# Nom du projet
> Description en 1 ligne

## Vue d'ensemble
- [CLAUDE.md](CLAUDE.md): Instructions complètes pour Claude Code

## Fichiers critiques
- [src/xxx.js](src/xxx.js): Rôle précis du fichier

## Points non-évidents (gotchas)
- Invariant à connaître avant de toucher au code
```

**3. Index de sections dans les fichiers > 2000 lignes**
Tout fichier > 2000 lignes avec plusieurs responsabilités → bloc de commentaires en tête avec numéros de lignes approximatifs et rôle de chaque bloc. Voir `src/logic/shadowTrading.js` dans Auto-Polymarket comme modèle.

**4. Commentaires sur code désactivé intentionnellement**
Tout bloc désactivé en dur (`if (false)`, feature flag off, dead branch) → commentaire visible expliquant POURQUOI et qui décide de le réactiver. Sans ça Claude peut le lire comme actif et baser une modification dessus.

**5. Audit de lisibilité périodique**
Routine schedulée hebdomadaire sur les projets actifs qui détecte : nouveaux fichiers > 300 lignes non documentés, fichiers > 2000 lignes sans index, descriptions obsolètes.
Modèle de routine : Auto-Polymarket `trig_0198tTQrATeMpeBEgaifUNqR` (lundi 8h Paris).

**6. Où placer une règle (séquence obligatoire avant tout ajout à un CLAUDE.md)**

Avant d'écrire quoi que ce soit dans un CLAUDE.md projet, classer d'abord :
1. **Règle qui change chaque décision routinière** → CLAUDE.md (court, 1-3 lignes max)
2. **Référence / inventaire / liste** → `docs/` ou `CLAUDE_REFERENCE.md` + pointeur dans CLAUDE.md
3. **Workflow / procédure > 5 lignes** → skill `.claude/skills/` ou `docs/`
4. **État projet / backlog / statut** → `memory/` ou git log
5. **Doublon d'un CLAUDE.md parent** → supprimer (l'héritage est automatique)

Test final : *"Si je supprime cette ligne, Claude ferait-il des erreurs sur des tâches routinières ?"* Si non → ça n'appartient pas au CLAUDE.md.

Règles techniques : CLAUDE.md < 200 lignes. Hook PreToolUse rappelle ce framework à chaque édition. Hook PostToolUse bloque si dépassement. `@import` n'est PAS du chargement conditionnel (même coût token qu'inline). Seuls les **skills** (`.claude/skills/`) sont vraiment à la demande.

**7. Signal de dette documentaire en session**
Quand Claude est contraint de lire un fichier source pour comprendre un comportement qui aurait dû être documenté, il doit :
1. Le signaler explicitement : "j'ai dû lire X pour trouver Y — ça manque dans la doc"
2. Spawner une tâche (chip) pour ajouter le commentaire/gotcha au bon endroit
3. Ne pas absorber silencieusement : chaque lecture forcée = dette à rembourser dans le même commit ou le suivant

Exemple : `dischargeStrategy()` dans Auto-Polymarket ne fonctionne pas — il faut modifier `config.js` directement. Non documenté → lecture de fichier à mi-session → tokens perdus.

## Propagation vers les projets existants

Niveau 1 (llms.txt) automatisable sans contexte projet — lancer : "crée le llms.txt pour le projet X".
Niveau 2 (audit complet CLAUDE.md vs code réel) → ouvrir le projet et dire "applique le context engineering selon les standards du meta CLAUDE.md".

**Checklist par projet (nouveau projet ou audit annuel) :**
- [ ] `llms.txt` présent à la racine
- [ ] Tous les fichiers > 300 lignes listés dans llms.txt avec description précise
- [ ] Fichiers > 2000 lignes avec index de sections en tête
- [ ] Blocs désactivés commentés
- [ ] Routine d'audit schedulée (si projet actif avec commits réguliers)
