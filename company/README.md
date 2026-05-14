# company/ — Contexte entreprise pour Claude

Ce dossier centralise les infos de ton entreprise. Claude les charge automatiquement pour contextualiser toutes les demandes business, brand, rédaction, stratégie et juridique.

## Structure complète

```
company/
│
├── info.json                     ← Infos légales : nom, SIRET, adresse, contacts, compta, avocat
├── team.json                     ← Équipe : fondateurs, salariés, freelances
│
├── brand/                        ← IDENTITÉ, ÉCRITURE & VISUEL
│   ├── plateforme.md             ← WHY/WHAT/HOW, valeurs, positionnement, bénéfices clients
│   ├── manifesto.md              ← Texte fondateur, tagline
│   ├── fondations.md             ← Origine du nom, mythe fondateur, ambition
│   ├── guide_editorial.md        ← Ton, vocabulaire, interdits, formats par canal ← OBLIGATOIRE
│   ├── cibles.md                 ← Segments prioritaires avec besoins, freins, canaux
│   ├── concurrence.md            ← Mapping concurrentiel, positionnement, codes de catégorie
│   ├── personas.md               ← Portraits clients détaillés
│   ├── charte.md                 ← Couleurs, typographie, logo, règles d'usage
│   └── direction_artistique.md   ← Univers visuel, références, règles photo/vidéo
│
├── strategie/                    ← STRATÉGIE & FINANCE
│   ├── business_plan.md          ← Résumé exécutif, modèle éco, chiffres clés, roadmap
│   ├── pitch_deck.md             ← Structure narrative du pitch (9 slides)
│   ├── plan_financier.md         ← Prévisionnel 3 ans, BFR, hypothèses
│   └── subventions.md            ← Suivi des aides obtenues / en cours / à cibler
│
├── marketing/                    ← MARKETING & COM
│   ├── plan_marketing.md         ← Objectifs, canaux, campagnes, budget
│   └── calendrier_editorial.md   ← Piliers de contenu, rythme, dates clés
│
├── juridique/                    ← JURIDIQUE & GOUVERNANCE
│   ├── statuts.md                ← Résumé gouvernance, actionnariat, clauses importantes
│   └── pacte_associes.md         ← Résumé pacte (pas le document confidentiel)
│
└── projets/                      ← PROJETS EN COURS
    └── TEMPLATE_PROJET.md        ← Copier pour chaque projet
```

## Par où commencer

**Priorité 1 — ce que Claude utilise le plus souvent :**
1. `info.json` — infos légales de base
2. `team.json` — équipe
3. `brand/plateforme.md` — qui vous êtes et pourquoi
4. `brand/guide_editorial.md` — comment vous parlez

**Priorité 2 — pour les demandes stratégiques :**
5. `brand/cibles.md` — pour qui vous écrivez
6. `strategie/business_plan.md` — contexte financier

**Priorité 3 — pour les demandes spécialisées :**
- `brand/charte.md` → quand vous travaillez sur des visuels
- `strategie/subventions.md` → quand vous montez des dossiers
- `juridique/` → quand vous avez des questions de gouvernance

## Sécurité

Ce dossier est versionné dans git. **Ne jamais mettre de mots de passe, tokens ou clés API ici** — utilisez `.env` dans chaque projet pour ça. Pour le pacte d'associés, mettre uniquement un résumé (pas le document confidentiel complet).
