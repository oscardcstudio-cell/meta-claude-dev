# company/ — Contexte entreprise pour Claude

Ce dossier centralise les infos de ton entreprise. Claude les charge automatiquement pour contextualiser toutes les demandes business, brand et rédaction.

## Fichiers à remplir

```
company/
  info.json               ← Infos légales : nom, SIRET, adresse, contacts, compta, avocat
  team.json               ← Équipe : fondateurs, salariés, freelances
  brand/
    plateforme.md         ← WHY/WHAT/HOW, valeurs, positionnement, cibles, concurrence
    guide_editorial.md    ← Ton, vocabulaire, interdits, formats par canal
```

## Comment ça marche

Une fois les fichiers remplis, Claude sait :
- Qui tu es et ce que fait ton entreprise
- À qui vous parlez et comment
- Ton style d'écriture et ce que tu ne dis jamais
- Tes contacts clés (compta, avocat, équipe)

**Tu n'as plus besoin de réexpliquer le contexte à chaque session.**

## Optionnel — fichiers supplémentaires

Tu peux ajouter dans `brand/` :
- `charte.md` — couleurs, typo, visuels
- `offre.md` — détail de tes produits/services
- `presentations.md` — textes prêts à l'emploi (bio Instagram, pitch court, pitch long)
- `projets.md` — projets en cours ou à venir

## Sécurité

Ce dossier est versionné dans git. **Ne jamais mettre de mots de passe, tokens ou clés API ici** — utilise `.env` dans chaque projet pour ça.
