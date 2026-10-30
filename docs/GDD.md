# Game Design Document (GDD) — PARALYSIS

## 1. Fiche synthétique et pitch high-concept

| Paramètre | Spécification |
| :--- | :--- |
| **Titre du projet** | **PARALYSIS** |
| **Moteur de jeu** | Godot Engine 4.x |
| **Genre** | Platformer 2D / horreur psychologique / action-réflexe |
| **Perspective** | Vue de côté 2D (side-scroller) |
| **Public cible** | Joueurs amateurs d'horreur et de platformers d'action |
| **Durée visée** | 20 à 30 minutes : un prologue et 3 chapitres |
| **Interface (HUD)** | 100 % diégétique : aucun élément d'interface visuel à l'écran |

### High concept

Une jeune fille se réveille brusquement dans sa chambre, au milieu de la nuit. En sortant, elle découvre que sa maison s'est métamorphosée en un cauchemar liminal : couloirs déformés, pièces répétitives, architecture impossible et zones d'ombre. Traquée par une entité aveugle qui réagit aux battements de son cœur, elle doit traverser cet environnement domestique corrompu en gérant son stress pour survivre et comprendre la nature de ce cauchemar.

## 2. Piliers de game design

- **Horreur diégétique et zéro HUD** : l'état du personnage (santé, stress, danger) est transmis par le son, les battements de cœur et les effets visuels.
- **Le pouls comme balise** : le stress accélère le rythme cardiaque, transformant le personnage en source sonore repérable par le monstre.
- **Espaces liminaux et distorsion** : la maison familière se déforme et se répète, créant oppression et désorientation.
- **Prise de risque et choix de parcours** : les joueurs peuvent emprunter des chemins éclairés, plus longs ou techniques, ou traverser des zones sombres, plus rapides mais plus stressantes.

## 3. Boucle de gameplay principale (core loop)

```text
[ Réveil / Exploration ] ──► [ Distorsion / Obscurité ] ──► [ Stress / Pouls rapide ]
          ▲                                                          │
          │                                                          ▼
[ Reprendre le contrôle ] ◄── [ Lumière / Repos ] ◄────── [ La Tête Aveugle chasse ]
```

1. **Exploration et découverte** : progresser dans des lieux familiers devenus étranges (chambre, couloirs infinis, pièces déformées).
2. **Montée de tension** : l'obscurité, les anomalies architecturales, les pièges et la proximité du monstre augmentent le stress.
3. **Feedback audio et visuel** : le pouls s'accélère et la vision se rétrécit pour signaler la vulnérabilité du personnage.
4. **Prise de décision et action** :
   - **Infiltration** : rejoindre une zone éclairée ou s'accroupir pour réduire le bruit et apaiser le rythme cardiaque.
   - **Fuite** : sprinter pour échapper à la créature lorsqu'elle repère le battement de cœur.
5. **Résolution et progression** : atteindre un point de passage sûr ou franchir un seuil menant à la section suivante.

## 4. Mécaniques de jeu détaillées

### 4.1. Contrôles du personnage (player controller)

- **Déplacements horizontaux** : course réactive avec une légère inertie, pour transmettre la vulnérabilité du personnage.
- **Physique de saut** :
  - **Coyote time** : court délai (par exemple 0,15 s) permettant de sauter juste après avoir quitté une plateforme.
  - **Jump buffer** : mémorisation de l'entrée de saut juste avant le contact avec le sol.
- **Posture accroupie et discrétion** : atténue le bruit des pas et accélère la baisse du stress dans les zones sûres.
- **Sprint** : permet de fuir pendant une poursuite, mais peut rendre le personnage plus repérable.

### 4.2. Système de stress (jauge invisible)

La jauge de stress évolue de **0 à 100 %** sans être affichée directement.

| Facteurs d'augmentation | Facteurs de réduction |
| :--- | :--- |
| Obscurité et anomalies visuelles | Présence dans une zone éclairée (lampes, veilleuses) |
| Proximité du monstre | Immobilité ou posture accroupie |
| Sauts difficiles et chutes | Franchissement réussi d'une zone de danger |

**Seuils et effets diégétiques :**

- **0–30 % — Calme** : pouls lent (~60 BPM), vision claire, ambiance sonore épurée.
- **31–70 % — Anxiété** : pouls accéléré (~110 BPM), vignettage progressif et légère distorsion sonore.
- **71–99 % — Panique** : pouls très rapide (~160 BPM), vignettage marqué, pulsations visuelles, grésillements et musique dissonante.
- **100 % — Seuil critique** : mort immédiate ou attaque fatale de la créature.

### 4.3. La menace : la Tête Aveugle

- **Apparence** : tête humaine déformée et gigantesque, aux orbites vides. Elle se déplace au sol, notamment en rampant à l'aide de ses mains ; son mode de déplacement peut aussi inclure des mouvements de roulade ou de flottement.
- **Errance (patrouille)** : se déplace lentement et au hasard tant que le pouls du joueur reste faible.
- **Alerte** : s'oriente vers la source sonore lorsque le stress ou le pouls dépasse un seuil critique (environ 70 %).
- **Poursuite (sprint)** : chasse rapidement le joueur lorsqu'elle le repère, notamment si celui-ci court ou si son stress devient trop élevé.

## 5. Structure des niveaux et progression

Le jeu se compose d'un **prologue** et de **trois chapitres**.

- **Prologue et chapitre 1 — La Maison Distordue**
  - **Déroulement** : la fillette se réveille dans sa chambre, qui sert de zone calme et de tutoriel pour les mouvements de base. Le couloir principal est altéré : papier peint répétitif, portes donnant sur le vide et pièces inversées aux allures d'espaces liminaux.
  - **Objectif** : faire découvrir progressivement le stress, l'obscurité et la Tête Aveugle.
- **Chapitre 2 — Les Profondeurs Liminales**
  - **Déroulement** : la maison laisse place à des espaces plus vastes et déconnectés de la réalité, comme des caves infinies et des sous-sols industriels étouffants.
  - **Objectif** : proposer des choix de parcours et des poursuites dynamiques.
- **Chapitre 3 — La Crise et la Révélation**
  - **Déroulement** : l'architecture s'effondre et boucle sur elle-même.
  - **Objectif** : conclure par une poursuite finale et un dénouement narratif.
- **Checkpoints** : un point de sauvegarde automatique ramène le joueur au début de la section en cours après une mort.

## 6. Direction artistique, audio et spécifications Godot

### 6.1. Visuels, éclairage et style liminal

- **Direction artistique** : graphismes en aplats et silhouettes noires, associés à des éléments domestiques déformés (portes géantes, couloirs répétés, fenêtres donnant sur le vide).
- **Espaces liminaux** : motifs répétitifs, éclairages jaunâtres ou blafards, ampoules qui clignotent et perspectives décalées.
- **Éclairage Godot** : `PointLight2D` découpe l'obscurité et met en évidence des zones de sécurité (lampes, veilleuses, télévisions allumées).
- **Shader personnalisé** : vignettage dynamique et légère aberration chromatique sur un `CanvasLayer`, ajustés selon le niveau de stress.

### 6.2. Musique dynamique et sound design

- **Sound design** : bruits de pas distincts (marche et course), respiration diégétique et bruits domestiques inquiétants (parquet qui craque, bourdonnement d'ampoules).
- **Composition** : nappes synthétiques oppressantes et grésillements. La musique peut s'enrichir de couches instrumentales (stems) et accélérer en fonction du stress et du rythme cardiaque.

### 6.3. Architecture sous Godot Engine 4

- **Singletons / autoloads** :
  - `StressManager.gd` : calcule le niveau de stress et transmet les variations de pouls au son et à la caméra.
  - `SoundManager.gd` : gère les canaux audio, la musique réactive et les battements de cœur.
- **Scènes principales** :
  - `Player.tscn` (`CharacterBody2D`) : personnage joueur.
  - `BlindMonster.tscn` (`CharacterBody2D`) : Tête Aveugle.
  - `LightZone.tscn` / `DarkZone.tscn` (`Area2D`) : zones modifiant le stress.
  - `LiminalDoor.tscn` / `CorridorLoop.tscn` : éléments de décor et de téléportation créant des boucles et des distorsions spatiales.
