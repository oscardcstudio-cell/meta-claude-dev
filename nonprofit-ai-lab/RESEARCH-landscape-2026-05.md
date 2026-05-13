# IA appliquée au monde associatif — état des lieux et niches (mai 2026)

> Recherche d'amorçage du projet `nonprofit-ai-lab`.
> Objectif : valider qu'il y a une place pour un **générateur d'IA spécialisées par association**, couvrant le cycle de vie complet (groupe informel → asso déclarée → vie courante → crise).
> À reprendre lors de la migration vers le repo dédié.

## Verdict en une ligne

**Encombré sur le générique (fundraising IA, grant writing IA), mais vide pile sur le concept visé** : générateur d'IA contextualisée *par* asso + couverture du cycle de vie complet (avant/pendant/après l'asso). Personne, ni FR ni international, ne tient ces trois angles ensemble.

---

## 1. Acteurs et plateformes existants (FR + international)

### Big Tech "AI for nonprofits" — quasiment tous présents

- **Anthropic — Claude for Nonprofits** (lancé 2 déc. 2025, partenariat GivingTuesday) : 70-75 % de remise sur Team/Enterprise, connecteurs Benevity / Blackbaud / Candid, cours "AI Fluency for Nonprofits" gratuit. Plus de 100 ONG accompagnées en pilote. *Le programme le plus généreux du marché actuellement.*
  - https://www.anthropic.com/news/claude-for-nonprofits
  - https://claude.com/solutions/nonprofits
- **OpenAI for Nonprofits** : 20-25 % de remise sur ChatGPT Business/Enterprise. Approche minimaliste, pas de programme produit dédié.
- **Microsoft AI for Good / Tech for Social Impact** : trois piliers (AI for Earth, AI for Accessibility, AI for Humanitarian Action) + Microsoft 365 Business Premium gratuit (10 utilisateurs). https://www.microsoft.com/en-us/nonprofits/empower-your-nonprofit-with-ai
- **Google.org — Generative AI Accelerator + AI Opportunity Fund** (75 M$) : programme de 6 mois pour 21 ONG sélectionnées sur climat, santé, éducation, crise. https://blog.google/outreach-initiatives/google-org/ai-opportunity-fund-march-2025-update/
- **Salesforce — Accelerator AI for Impact + Einstein for Nonprofits** : 10 licences gratuites, Einstein GPT pour hyper-personnalisation donateurs. https://www.salesforce.com/nonprofit/artificial-intelligence/

### Verticales IA (international, dominé US)

- **Virtuous Momentum** : "AI fundraising assistant" qui priorise les contacts donateurs. https://virtuous.org/blog/ai-for-nonprofits/
- **DonorSearch AI** : analytique prédictive donateurs sur 12 mois. https://www.donorsearch.net/resources/ai-for-nonprofits/
- **Funraise AppealAI** : génération de copy fundraising (emails, lettres, social).
- **Grantable** (US) : "AI coworker" pour rédaction de subventions + découverte de funders via données IRS 990. 25 $/mois pour assos < 500k$ budget. https://grantable.co/
- **Instrumentl Apply** (US) : analyse IA d'appels à projets intégrée au CRM de gestion de subventions. https://www.instrumentl.com/blog/best-ai-for-grant-writing
- **Bloomerang Volunteer, VolunteerHub** : scheduling IA bénévoles + détection désengagement. https://bloomerang.com/blog/ai-tools-for-nonprofits/
- **RhinoAgents, MindStudio, Emitrr** : "AI agents for nonprofits" — automation donor/bénévole/comm. https://www.rhinoagents.com/ai-non-profits-agents, https://www.mindstudio.ai/blog/nonprofits

**Observation clé** : 65 % des ONG sont intéressées par l'IA mais seulement 9 % se sentent prêtes à l'adopter, 76 % n'ont aucune stratégie IA. Le marché US est dominé par des SaaS verticaux fundraising-centric (anglo-saxons, modèle US dons individuels).

---

## 2. France spécifiquement

### Plateformes assos françaises et leur intégration IA

- **HelloAsso** : pas de fonctionnalité IA produit native annoncée, mais publie un guide "IA pour son association". https://www.helloasso.com/blog/intelligence-artificielle-pour-son-association/
- **AssoConnect** : pas d'IA dans le produit, position éditoriale "risques et opportunités". https://www.assoconnect.com/blog/chatgpt-ia-association/
- **Eudonet CRM** : seule plateforme FR ayant **intégré l'IA directement dans le produit** (Analytics & Data Intelligence, recommandations prédictives campagnes). https://www.eudonet.com/en/solutions/analytics-data/
- **iRaiser** : CRM fundraising SaaS dédié OBNL, pas de fonctionnalité IA mise en avant.

### Acteurs de structuration (têtes de réseau)

- **Le Mouvement Associatif** : pas d'initiative IA propre identifiée — relais d'études.
- **Le RAMEAU** (laboratoire) : centre de ressources partenariats asso/entreprise ; pas d'angle IA produit. https://fonda.asso.fr/organisations/le-rameau
- **France Générosités** : très actif — sondage IA membres déc. 2024/janv. 2025 (91 % la jugent utile, 99 % opportunité), guide IA modulaire copublié avec Don en Confiance, dossier dédié. https://www.francegenerosites.org/dossiers-thematiques/intelligence-artificielle/
- **Hexopée + France Active + RNMA + Centres sociaux** : enquête commune sur santé financière, pas spécifiquement IA.
- **Solidatech** (Emmaüs / Les Ateliers du Bocage) : **le hub IA français le plus structuré** pour assos. Formation "IA générative au service des associations", webinaires (recherche de financements, risques/opportunités), 45 000+ assos accompagnées depuis 2008. https://www.solidatech.fr/

### Programme phare FR : IA for Good

Co-fondé par **Latitudes + Share IT + Bayes Impact + Data for Good**, soutenu par la Fondation Société Générale et Fondation Crédit Coopératif. Sensibilise et accompagne les acteurs de l'ESS dans l'adoption de l'IA générative. Inclut "La Bataille de l'IA spéciale ESS" (jeu de cartes pour cas d'usage).
- https://www.iaforgood.org/
- https://www.share-it.io/blog/manifeste-de-notre-programme-ia-for-good

### Subventions / matching IA (lien direct avec subvention_match)

- **Data.Subvention** (beta.gouv.fr, porté par DJEPVA + DINUM) : raffinerie de données publiques sur 1,5 M d'assos, API publique. **Côté État, pas côté assos** — outil pour agents publics qui décident des subventions. https://datasubvention.beta.gouv.fr/
- **Aides-Territoires** (beta.gouv.fr) : recensement aides territoriales, API publique. Pas d'IA de matching native dans le service public. https://aides-territoires.beta.gouv.fr/
- **Data for Good — projet "IA for Good (appels à projets)"** : automatise l'analyse de docs et l'enrichissement web pour répondre à des AAP. **Directement concurrent du projet subvention_match.** https://dataforgood.fr/projects/iaforgood/

### Initiatives publiques

- **France Num** (DGE) : guide générique "associations et numérique", pas spécifiquement IA. https://www.francenum.gouv.fr/
- **Société Numérique / Labo** (ANCT) : dossiers sur "monde associatif face au numérique". https://labo.societenumerique.gouv.fr/

---

## 3. Recherche académique et think tanks

- **arXiv (oct. 2025)** — *AI Adoption in NGOs: A Systematic Literature Review* : 6 catégories d'usage (engagement, créativité, décision, prédiction, management, optimisation). Conclusion : **adoption inégale, biaisée vers les grandes structures**. https://arxiv.org/html/2510.15509v1
- **SSRN (2025)** — Wihbey et al., Northeastern Univ. : étude qualitative 5 ONG Boston, recommande "IA comme collaborateur, pas remplaçant". https://papers.ssrn.com/sol3/Delivery.cfm/5368337.pdf
- **Taylor & Francis (2024)** — *AI in Nonprofit Human Services: Hype, Harm, and Hope*. https://www.tandfonline.com/doi/full/10.1080/23303131.2024.2427459
- **Joseph Rowntree Foundation (UK, 2025)** — *AI for Public Good: Non-profit and Grassroots Perspectives on Generative AI*. Constat central : **les ONG grassroots sont exclues du débat IA** par manque d'invitation, d'awareness et de ressources. https://www.jrf.org.uk/ai-for-public-good/grassroots-and-non-profit-perspectives-on-generative-ai
- **Stanford HAI** : programme de formation IA pour civil society + nonprofits. https://hai.stanford.edu/education/civil-society-and-non-profit-ai-training
- **Stanford SSIR (2025)** — *Data Is the Key to Building AI for Social Good*. https://ssir.org/articles/entry/ai-for-social-good-data
- **Recherches & Solidarités x Solidatech (nov. 2025)** — *La place du numérique dans le projet associatif en 2025*, 5e édition, 2 285 dirigeants associatifs. **Chiffres clés FR** : 18 % des assos utilisent déjà l'IA, 13 % y réfléchissent, 47 % expriment des craintes éthiques. https://www.francegenerosites.org/ressources/place-du-numerique-dans-le-projet-associatif-solidatech-x-recherches-et-solidarites-2025/

**ESSEC** Chaire Innovation Sociale / E&MISE : très active sur l'entrepreneuriat social mais pas d'angle IA produit identifié.

---

## 4. Initiatives "AI for Good" en lien direct avec assos

- **UN AI for Good Global Summit (ITU)** — éd. juillet 2025 à Genève, 53 agences ONU partenaires, accès gratuit pour société civile. Vitrine internationale, pas un opérateur. https://aiforgood.itu.int/ai-for-good-global-summit-2025-2/
- **Patrick J. McGovern Foundation** — **75,8 M$ en 2025** (149 grants, 13 pays) pour "public purpose AI". Cible institutions, communautés, ONG. Convening "Fund.AI". *Le plus gros financeur "AI for civil society" mondial.* https://www.mcgovern.org/2025-press-release/
- **Fast Forward** (US, depuis 2014) : seul accélérateur dédié aux **tech nonprofits**. Cohorte 2024 : 12 ONG dont > 50 % construisent du AI-powered. 25 k$ + mentorat. 112 ONG accélérées. https://www.ffwd.org/accelerator
- **Data for Good France** (7 000 experts bénévoles) : 15 assos accompagnées 6 mois/an, projets IA explicites (IA pour appels à projets, GenAI Impact environnemental). Livre blanc IA générative. https://dataforgood.fr/

---

## 5. Gaps / niches non couvertes

### Niche 1 — Les très petites assos (< 10 bénévoles, 0 salarié)
L'écosystème (Anthropic, Salesforce, Eudonet, iRaiser, Virtuous) cible des ONG **avec staff et budget**. Les petites assos françaises ont besoin de trésorerie, comptabilité, recrutement bénévoles, comm — un *assistant à 360°* à la place d'un directeur opérationnel inexistant. Solidatech forme mais ne livre pas un produit packagé. **Marché orphelin en SaaS produit**.

### Niche 2 — "Aider un groupe informel à devenir asso"
**Aucun acteur identifié** ne couvre le pré-asso : collectif Whatsapp, groupe de voisins, parents d'élèves qui veulent se structurer. Le parcours "statuts, déclaration en préfecture, numéro RNA, premier compte bancaire, première AG" est documenté (associations.gouv.fr) mais pas assisté par IA.

### Niche 3 — "Aider une asso qui n'a rien demandé" (outreach inverse)
**Niche complètement vide**. Le pendant fundraising existe (Momentum priorise les donateurs à appeler) — l'équivalent côté capacity building n'existe pas.

### Niche 4 — Générateur d'IA spécialisée *par* asso (vs SaaS générique)
Lindy, MindStudio, Voiceflow font du no-code AI agent builder mais horizontal et anglophone. Les Custom GPTs OpenAI sont génériques et nécessitent un compte ChatGPT Plus. **Personne ne propose** : *"Décris ton asso, on te génère ton IA — sur tes statuts, tes financeurs, ton planning bénévoles, ta charte"*. **Le concept "machine à fabriquer des IA pour assos" n'existe pas en tant que tel**, ni en France ni à l'international.

### Niche 5 — Couverture du cycle de vie complet
Tout l'écosystème est en silos : fundraising (Virtuous, Funraise), subventions (Grantable, Instrumentl, subvention_match côté FR), bénévoles (VolunteerHub), comm (AppealAI). Aucun opérateur ne couvre les 4 phases : émergence du groupe → création formelle → vie courante → crise/refonte.

---

## Recommandations stratégiques

1. **Ne pas refaire un n-ième SaaS fundraising IA** — terrain saturé US, Anthropic/Salesforce mangent la valeur par le haut.
2. **Différenciateur défendable** = *génération à la demande* d'une IA contextualisée (statuts + historique + écosystème local) + couverture du *cycle de vie complet*. Ni Claude for Nonprofits, ni Solidatech, ni IA for Good ne tiennent ça.
3. **Alliés FR logiques** : Solidatech (distribution + crédibilité) et/ou France Générosités (têtes de réseau OBNL) plutôt qu'attaque frontale.
4. **Cohabitation propre avec subvention_match** : Data.Subvention est côté agent public — pas en concurrence frontale. Mais le projet Data for Good "IA for Good AAP" est à surveiller comme un faucon.
5. **Veille à garder** : Fast Forward (modèle d'incubation), McGovern Foundation (financement disponible), Joseph Rowntree (intuition grassroots).

---

## Données dures à retenir

- **18 %** des assos FR utilisent déjà l'IA, **13 %** y réfléchissent (Recherches & Solidarités x Solidatech, nov. 2025, 2 285 dirigeants).
- **65 %** des ONG intéressées par l'IA mais **9 %** se sentent prêtes, **76 %** sans stratégie IA (intl).
- **75,8 M$** distribués en 2025 par McGovern Foundation pour "public purpose AI".
- **45 000+** assos accompagnées par Solidatech depuis 2008.
