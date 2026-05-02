# CLAUDE Health Rules — protocole anti-bloat cross-projet

Source de verite pour la sante des `CLAUDE.md` sur cette machine.
Reference depuis `C:\dev\claude\CLAUDE.md` (meta racine).
**Tous les projets** (Studio Descartes + oscardcstudio) doivent respecter ces regles.

## 1. Pourquoi

Chaque `CLAUDE.md` est charge **a chaque message** (pas une fois par session). Bloat = tokens crames a vie + place perdue dans le context window. Le cache prompt baisse le cout en `$` mais **n'enleve pas** le poids dans la fenetre de contexte.

Stack actuelle : `user (5K) + meta (6K) + bucket (2K) + projet (8K cible)` = ~21 KB ~5K tokens. Au-dela de 30 KB cumule on est en zone rouge.

## 2. Seuils chiffres

| Metrique | Warn | Critical |
|----------|------|----------|
| `CLAUDE.md` projet (taille brute) | > 8 KB | > 12 KB |
| Hierarchie totale (user + meta + bucket + projet) | > 20 KB | > 30 KB |
| Residus racine projet (`*.bak`, `*_backup_*.json` multiples, `local_screenshot.png`) | > 2 fichiers | > 5 fichiers |
| Fichier > 5 MB a la racine projet **sans** `.claudeignore` | warn | critical |
| `MEMORY.md` absent dans `memory/` | warn | - |
| Doublon de regle entre niveaux (meme regle ecrite 2 fois) | warn | - |

Le hook `claude-md-health-check.js` (SessionStart, user-level) mesure ces seuils a chaque ouverture de session et alerte si depassement. Read-only, jamais d'ecriture sur les `CLAUDE.md`.

## 3. Patterns a appliquer

### `@import` syntax (lazy load, jusqu'a 5 niveaux)

`CLAUDE.md` supporte nativement `@chemin/relatif/vers/fichier.md`. Le fichier importe **n'est pas charge tant que la conversation ne le declenche pas** (Claude le lit avec `Read` quand il en a besoin). C'est l'outil principal pour decharger les CLAUDE.md.

```markdown
## Regle d'or — hopital des strategies
Voir details complets : @docs/HOSPITAL_RULES.md

3 listes, 3 roles, AUCUN chevauchement :
- WHITELIST : trade en sim/real
- SHADOW : s'entraine en vase clos
- DISABLED : morte (morgue)
```

Garder dans le `CLAUDE.md` uniquement le **principe** + l'**anti-pattern critique**. Le detail va dans le fichier importe.

### Trigger tables au lieu de prose

```markdown
| Skill | Declencheur |
|-------|-------------|
| health-check | "le bot tourne ?" |
| pre-deploy-check | avant push |
```

Plus dense et plus actionnable que des paragraphes.

### Skill > regle longue dans CLAUDE.md

Une regle qui fait > 20 lignes : la transformer en skill (`description` triggerante + `SKILL.md` charge a la demande). Plus jamais dans le CLAUDE.md de base.

### Path-scoped frontmatter (YAML)

Pour des regles qui ne concernent qu'un sous-dossier, utiliser le frontmatter YAML qui scope par chemin. Reduit la pollution cross-projet du meme repo.

### Regle "two strikes"

N'ajouter une instruction au `CLAUDE.md` que **la deuxieme fois** ou Claude se trompe dessus. Premier echec = exception, deuxieme = pattern qui justifie une regle.

## 4. Anti-patterns

- **Residus a la racine projet** : `CLAUDE.md.bak`, `bot_data_backup_*.json` multiples, screenshots de debug. A bouger dans `backups/` ou supprimer.
- **Regles dupliquees inter-niveaux** : si une regle est dans `user/CLAUDE.md`, ne pas la repeter dans `meta/CLAUDE.md`. Dedupliquer.
- **Secrets en clair** : tokens, mots de passe, IDs prives. Toujours en env var. Le hook `secret-scan.js` (PreToolUse Write/Edit) bloque deja, mais pas les CLAUDE.md existants.
- **Sections "Etat actuel"** datees dans le `CLAUDE.md` : ca pourrit en silence. A bouger dans un fichier d'etat dedie (`docs/STATE.md`) qui peut etre regenere.
- **Listes chiffrees longues** (strategies actives, fichiers critiques avec descriptions) : tout ce qui ressemble a de la doc de reference va dans `docs/REFERENCE.md` avec `@import` ou simplement reference textuel.
- **Doublons skills/agents/CLAUDE.md** : si une instruction est aussi dans un skill, ne pas la repeter en prose dans le CLAUDE.md.

## 5. Outils

### Hook `claude-md-health-check.js` (auto, passif)

`~/.claude/hooks/claude-md-health-check.js` — lance par `SessionStart` user-level.
- Mesure les seuils ci-dessus
- Alerte 1 ligne sur stderr si depassement (visible au demarrage de session)
- Loggue dans `~/.claude/claude-md-health.log` pour suivi de derive
- **Ne modifie aucun fichier**

### Skill `claude-config-doctor` (manuel, audit profond)

[github.com/tyabu12/claude-config-doctor](https://github.com/tyabu12/claude-config-doctor) — audit semantique cross-fichiers (CLAUDE.md ↔ hooks ↔ permissions). A installer pour audit ponctuel quand le hook auto alerte serieusement.

### Skills officiels Anthropic

- `claude-md-management:claude-md-improver` — audit + edits proposes
- `claude-md-management:revise-claude-md` — update post-session

## 6. Checklist nouveau projet

Avant de commit le premier `CLAUDE.md` d'un projet :

- [ ] `CLAUDE.md` < 8 KB
- [ ] Hierarchie heritee documentee en haut (`> Hierarchie : herite de ...`)
- [ ] Pas de doublon avec les niveaux superieurs (user/meta/bucket)
- [ ] Si details techniques > 20 lignes : sortir dans `docs/REFERENCE.md` + `@docs/REFERENCE.md`
- [ ] `memory/MEMORY.md` cree (vide ou avec une 1re entree)
- [ ] `.claudeignore` cree si fichiers > 5 MB existent ou sont prevus (data, logs, builds)
- [ ] Aucun secret en clair (tokens, mots de passe, IDs prives)
- [ ] Sections "Etat actuel" / "Strategies actives" dans des fichiers separes (`docs/STATE.md`)

## 7. Quand auditer un projet existant

Declencheurs :

- Le hook auto alerte (warn ou critical)
- Sentiment "j'ai trop ecrit" en relisant
- Apres avoir ajoute un nouveau bloc qui ferait passer au-dessus du seuil
- Tous les ~3 mois sur les projets actifs (passage manuel)
- Avant un onboarding (un nouveau dev / un autre Claude doit prendre le projet en main)

Procedure :

1. Lancer `claude-config-doctor` pour audit profond
2. Identifier ce qui peut sortir en `@import`
3. Identifier les doublons a dedupliquer
4. Bouger les listes datees dans des fichiers d'etat
5. Trimmer les sections > 20 lignes en pointant vers le skill ou `docs/REFERENCE.md`
6. Re-mesurer apres : doit etre sous le seuil warn

## 8. Comment cette doc se diffuse

- Reference depuis `C:\dev\claude\CLAUDE.md` (meta racine) → tous les projets sous `C:\dev\claude\` heritent
- Le hook `claude-md-health-check.js` rappelle l'existence de cette doc dans son alerte
- A consulter explicitement avant toute creation/refacto de `CLAUDE.md`

Pas d'`@import` automatique de cette doc dans le meta racine — sinon elle gonfle le contexte de tous les projets, l'inverse du but. Lecture **a la demande** par Claude.
