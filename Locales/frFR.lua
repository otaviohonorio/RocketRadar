-- RocketRadar | Locales/frFR.lua
-- (04/11/2026) The player's language when the game runs in frFR. A key absent here falls to the key itself, the English
-- text. Translated without a native speaker's review yet: the game's own terms come from its tables for this language
-- (GlobalStrings.frFR). French: "vous", as French addons and the game do.
local ADDON, ns = ...

if GetLocale() ~= "frFR" then return end

local L = ns.L

L["Play as"] = "Jouer en tant que"
L["Automatic"] = "Automatique"
L["Damage or healer"] = "Dégâts ou soins"
L["Tank"] = "Tank"
L["Automatic follows your specialization: a tank spec uses the tank markers."] =
    "Automatique suit votre spécialisation : une spécialisation de tank utilise les marques de tank."

L["On every cast that can be interrupted. The outline of the health bar takes the cast's colour and fills up with it, in front of the other plates."] =
    "Sur chaque incantation interruptible. Le contour de la barre de vie prend la couleur de l'incantation et se remplit avec elle, devant les autres barres d'info."
L["Which casts"] = "Quelles incantations"
L["Important only"] = "Importantes seulement"
L["All"] = "Tous"
L["Important: only what the game itself marks as important. In a key the addon cannot read the spell, so it cannot have a list of its own."] =
    "Importantes : seulement ce que le jeu lui-même marque comme important. Dans une clé, l'add-on ne peut pas lire le sort, il ne peut donc pas avoir sa propre liste."
L["Spread enemy plates (game option)"] = "Empiler les barres d'info ennemies"
L["The game's own setting. Plates push each other apart, so two bars rarely cover one another."] =
    "Un réglage du jeu lui-même. Les barres d'info s'écartent les unes des autres, et deux barres se recouvrent rarement."
L["This option cannot change in combat."] = "Cette option ne peut pas être modifiée en combat."

L["Show who holds each mob"] = "Afficher qui tient chaque ennemi"
L["Tank: green is yours and safe, orange is yours about to be lost, red is loose, white is with another tank. Damage and healers: red when a mob turned to you."] =
    "Tank : vert, il est sur vous et en sécurité ; orange, sur vous mais presque perdu ; rouge, libre ; blanc, sur un autre tank. Dégâts et soins : rouge quand un ennemi s'est tourné vers vous."
L["Name who holds the mob"] = "Nom de qui tient l'ennemi"
L["Beside the marker of a mob you do not hold, in the class colour."] =
    "À côté de la marque d'un ennemi que vous ne tenez pas, dans la couleur de la classe."

L["Test on my target"] = "Tester sur ma cible"
L["Shows the mark on the health bar of your current target for a few seconds."] =
    "Affiche la marque sur la barre de vie de votre cible actuelle pendant quelques secondes."
L["Target an enemy with a visible nameplate first."] = "Ciblez d'abord un ennemi dont la barre d'info est visible."

L["Report a problem"] = "Signaler un problème"
L["Report a problem on"] = "Signaler un problème sur"
L["Click: choose where to report a problem"] = "Clic : choisir où signaler un problème"
L["Link copied — paste it in your browser."] = "Lien copié : collez-le dans votre navigateur."
L["Rocket Radar %s — report a problem on %s.|n|nPress Ctrl+C to copy the link, then paste it in your browser. Say what you were doing and what happened."] =
    "Rocket Radar %s : signaler un problème sur %s.|n|nAppuyez sur Ctrl+C pour copier le lien, puis collez-le dans votre navigateur. Dites ce que vous faisiez et ce qui s'est passé."

-- The group section of the options, and the spells of the group (development only for now).
L["Beside each party frame, the major defensives and the burst of each member: lit while active, dark while recharging."] =
    "À côté de chaque cadre de groupe, les grands défensifs et le burst de chaque membre : allumés quand ils sont actifs, sombres pendant la recharge."
L["Show mine too"] = "Afficher aussi les miens"
L["Your own icons beside your frame, with the game's exact recharge."] =
    "Vos propres icônes à côté de votre cadre, avec la recharge exacte du jeu."
L["Icon size"] = "Taille des icônes"
L["How large the icons are."] = "La taille des icônes."
L["Icons per row"] = "Icônes par ligne"
L["After this many, a new row starts; the block stays centred on the frame."] =
    "Au-delà, une nouvelle ligne commence ; le bloc reste centré sur le cadre."
L["Choose the spells"] = "Choisir les sorts"
L["Which spells each specialization shows. Everything is checked at first."] =
    "Les sorts que chaque spécialisation affiche. Au départ, tout est coché."
L["Spells of the group"] = "Sorts du groupe"
L["Automatic screenshots: on."] = "Captures d'écran automatiques : activées."
L["Automatic screenshots: off."] = "Captures d'écran automatiques : désactivées."
L["Minimap button"] = "Bouton de la minicarte"
L["The button opens this window with a click. Its tooltip shows who the markers are drawn for."] =
    "Un clic sur le bouton ouvre cette fenêtre. Son infobulle indique pour qui les marques sont dessinées."
L["Click: open the options"] = "Clic : ouvrir les options"

-- Party defensives and bursts (development only).
L["Group icons: %d (%d frames found). Reads %d, hidden %d; errors %d."] =
    "Icônes du groupe : %d (%d cadres trouvés). Lectures %d, masquées %d ; erreurs %d."
L["The group frames are not on screen: the cast mark shows on them in a group."] =
    "Les cadres de groupe ne sont pas à l'écran : la marque d'incantation s'y affiche quand vous êtes en groupe."
L["The game did not offer the aura container: the sensor cannot work."] =
    "Le jeu n'a pas fourni le conteneur d'auras : le capteur ne peut pas fonctionner."

-- (03/11/2026) on/off, animation and colour of each mark; the dispellable debuffs.
L["Click: choose a colour"] = "Clic : choisir une couleur"
L["Filling"] = "Remplissage"
L["Full"] = "Pleine"
L["Pulsing"] = "Pulsation"
L["Filling: the line fills as the cast goes on, like the game's cast bar. Full: the whole line at once. Pulsing: the whole line, breathing."] =
    "Remplissage : la ligne se remplit au fil de l'incantation, comme la barre de sorts du jeu. Pleine : toute la ligne d'un coup. Pulsation : toute la ligne, qui pulse doucement."
L["Cast colour"] = "Couleur d'incantation"
L["A cast that can be interrupted. At first, the game's cast bar art itself."] =
    "Une incantation interruptible. Au départ, l'illustration de la barre de sorts du jeu elle-même."
L["Channel colour"] = "Couleur de canalisation"
L["A channel that can be interrupted. At first, the game's channel art."] =
    "Une canalisation interruptible. Au départ, l'illustration de canalisation du jeu."
L["Uninterruptible colour"] = "Couleur non interruptible"
L["A cast that cannot be interrupted. At first, the game's grey for it."] =
    "Une incantation qui ne peut pas être interrompue. Au départ, le gris que le jeu utilise pour elle."
L["Defensives and bursts"] = "Défensifs et bursts"
L["Enemy plates"] = "Barres d'info d'unité ennemie"
L["Mark whoever is casting"] = "Marquer qui incante"
L["Also the uninterruptible"] = "Aussi les non interruptibles"
L["A cast that cannot be interrupted is marked too, in its own colour. Off: only what can be interrupted."] =
    "Une incantation qui ne peut pas être interrompue est marquée aussi, dans sa propre couleur. Désactivé : seulement ce qui peut être interrompu."
L["Animation"] = "Animation"
L["Which debuffs"] = "Quels affaiblissements"
L["What I can remove: only the types your specialization removes. All: every debuff that has a type, whoever can remove it."] =
    "Dissipables par moi : seulement les types que votre spécialisation dissipe. Tous : tout affaiblissement qui a un type, quel que soit celui qui peut le dissiper."
L["What I can remove"] = "Dissipables par moi"

-- (04/11/2026) the party frame's left and right, the debuff types and the alerts
L["General"] = "Général"
L["Party frame: left"] = "Cadre de groupe : gauche"
L["Party frame: right"] = "Cadre de groupe : droite"
L["Debuffs that come off"] = "Affaiblissements dissipables"
L["After the cast, each debuff that can be removed: its own icon, a border in its type's colour that empties with the time left, and in its corners the type's symbol and letters, the time and the stacks. The game itself reads the debuff: it works in a fight and in a key."] =
    "Après l'incantation, chaque affaiblissement dissipable : sa propre icône, un contour de la couleur de son type qui se vide avec le temps restant et, dans les coins, le symbole et le sigle du type, le temps et les cumuls. C'est le jeu lui-même qui lit l'affaiblissement : cela fonctionne en combat et dans une clé."
L["Type"] = "Type"
L["Colour"] = "Couleur"
L["Alert"] = "Alerte"
L["Sound"] = "Son"
L["Off"] = "Désactivé"
L["On you"] = "Sur vous"
L["Whole group"] = "Tout le groupe"
L["Boss or role debuff"] = "Boss ou rôle"
L["Listen"] = "Écouter"
L["Sound channel"] = "Canal audio"
L["The game's volume the alerts' sounds follow."] = "Le volume du jeu que suivent les sons des alertes."
L["The border's colour for this type. At first, the game's own colour for it."] =
    "La couleur du contour pour ce type. Au départ, la couleur du jeu lui-même."
L["The border's colour for it. At first, the game's red for a debuff without a type."] =
    "La couleur du contour pour lui. Au départ, le rouge du jeu pour un affaiblissement sans type."
L["A line at the top of the screen while the debuff lasts: its icon, its type, the spell and who has it, in the class colour. On you: only when it is on you."] =
    "Une ligne en haut de l'écran tant que dure l'affaiblissement : son icône, son type, le sort et qui l'a, dans la couleur de la classe. Sur vous : seulement quand il est sur vous."
L["Played when the debuff lands, on the alert's members. The game plays it only for the season's debuffs of this type that the game's tables list: one missing from them shows its line without the sound."] =
    "Joué quand l'affaiblissement est appliqué, sur les membres de l'alerte. Le jeu ne le joue que pour les affaiblissements de ce type de la saison listés dans les tables du jeu : un affaiblissement absent de celles-ci affiche sa ligne sans le son."
L["The game plays an alert's sound only for exact spells, and a boss's debuff has no type to list them by: this alert is the text only."] =
    "Le jeu ne joue le son d'une alerte que pour des sorts précis, et l'affaiblissement d'un boss n'a pas de type pour les lister : cette alerte n'est que le texte."
L["Voice: \"Dispel\""] = "Voix : « Dispel »"
L["Voice: \"Magic\""] = "Voix : « Magic »"
L["Voice: \"Curse\""] = "Voix : « Curse »"
L["Voice: \"Poison\""] = "Voix : « Poison »"
L["Voice: \"Disease\""] = "Voix : « Disease »"
L["Voice: \"Bleed\""] = "Voix : « Bleed »"
L["Voice: \"Debuff\""] = "Voix : « Debuff »"
L["Raid warning"] = "Avertissement Raid"
L["Boss warning"] = "Avertissement de boss"
L["Ready check"] = "Appel"
L["Alarm clock 1"] = "Réveil 1"
L["Alarm clock 2"] = "Réveil 2"
L["Alarm clock 3"] = "Réveil 3"
L["Battle.net toast"] = "Notification Battle.net"
L["Magic: dispel"] = "Magie : dissiper"
L["Magic: arcane burst"] = "Magie : explosion arcanique"
L["Magic: arcane charge"] = "Magie : charge arcanique"
L["Magic: arcane cast"] = "Magie : incantation arcanique"
L["Curse 1"] = "Malédiction 1"
L["Curse 2"] = "Malédiction 2"
L["Curse: shadow 1"] = "Malédiction : ombre 1"
L["Curse: shadow 2"] = "Malédiction : ombre 2"
L["Poison 1"] = "Poison 1"
L["Poison 2"] = "Poison 2"
L["Poison: spores 1"] = "Poison : spores 1"
L["Poison: spores 2"] = "Poison : spores 2"
L["Disease 1"] = "Maladie 1"
L["Disease: plague 1"] = "Maladie : peste 1"
L["Disease: plague 2"] = "Maladie : peste 2"
L["Bleed 1"] = "Saignement 1"
L["Bleed 2"] = "Saignement 2"
L["Bleed 3"] = "Saignement 3"
L["Bleed 4"] = "Saignement 4"
L["Boss defeated"] = "Boss vaincu"
L["Countdown end"] = "Fin du compte à rebours"
L["Right click: the game's colour"] = "Clic droit : couleur du jeu"
L["Party"] = "Groupe"

-- (04/11/2026) the window in tabs, faithful to the preview, with the notes
L["Profile"] = "Profil"
L["Threat"] = "Menace"
L["A line at the top of the screen while an enemy casts at you: the spell's icon and name. Only on you: the game tells whom a cast goes to only for you."] =
    "Une ligne en haut de l'écran pendant qu'un ennemi lance un sort sur vous : l'icône et le nom du sort. Seulement sur vous : le jeu n'indique la cible d'une incantation que lorsque c'est vous."
L["Alerts: all"] = "Alertes : toutes"
L["Cast"] = "Incantation"
L["Cast animation"] = "Animation d'incantation"
L["Cast at you"] = "Sort sur vous"
L["Channel"] = "Canalisation"
L["Every row of the table, shown or not beside the party frame."] =
    "Chaque ligne du tableau, affichée ou non à côté du cadre de groupe."
L["Icon"] = "Icône"
L["Letters"] = "Sigle"
L["On"] = "Activé"
L["Sets the alert of every row at once. The casts take \"On you\" (the game tells whom a cast goes to only for you)."] =
    "Règle l'alerte de toutes les lignes d'un coup. Les incantations passent à « Sur vous » (le jeu n'indique la cible d'une incantation que lorsque c'est vous)."
L["The game does not let an addon play a sound for a cast at you: what is secret in a fight cannot start a sound."] =
    "Le jeu ne laisse pas un add-on jouer un son pour une incantation sur vous : ce que Blizzard bloque en combat ne peut pas déclencher de son."
L["The border's colour for it. At first, the colour of the game's own cast bar art."] =
    "La couleur du contour pour elle. Au départ, la couleur de l'illustration de la barre de sorts du jeu."
L["Turn all on"] = "Tout activer"
L["Uninterruptible"] = "Non interruptible"
L["What it is"] = "Ce que c'est"
L["Whether it shows beside the party frame."] = "S'il s'affiche à côté du cadre de groupe."
L["— (no list of spells)"] = "— (pas de liste de sorts)"
L["— (the game does not allow it)"] = "— (le jeu ne le permet pas)"
L["Debuffs"] = "Affaiblissements"
L["Alerts"] = "Alertes"
L["Beside the party frame"] = "À côté du cadre de groupe"
L["Alerts on the screen"] = "Alertes à l'écran"
L["What to do"] = "Que faire"
L["an enemy casting"] = "ennemi en incantation"
L["an enemy channelling"] = "ennemi en canalisation"
L["cannot be interrupted"] = "non interruptible"
L["from a boss or a mechanic"] = "de boss ou de mécanique"
L["can be removed"] = "dissipable"
L["you can remove it"] = "dissipable par vous"
L["interrupt"] = "interrompre"
L["defensive and heal"] = "défensif et soins"
L["remove"] = "dissiper"
L["no dispel type"] = "sans type de dissipation"
L["free it"] = "libérer"
L["Frees a teammate:"] = "Libère un allié :"
L["Frees only themselves:"] = "Se libère seulement soi-même :"
L["Without the talent, the class does not have the spell. The icon uses the game's crowd control filter: a stun or a fear without a type can show in it too."] = "Sans le talent, la classe n'a pas le sort. L'icône utilise le filtre de contrôle du jeu : un étourdissement ou une peur sans type peut aussi y apparaître."
L["The border's colour for it. At first, a light blue: the game has no colour for it."] = "La couleur de sa bordure. Au départ, un bleu clair : le jeu n'a pas de couleur pour cela."
L["No class removes it: a boss's or a mechanic's debuff. Defensive and heal."] =
    "Aucune classe ne le dissipe : c'est un affaiblissement de boss ou de mécanique. Défensif et soins."
L["No class spell in the game's tables removes it."] = "Aucun sort de classe dans les tables du jeu ne le dissipe."
L["Without the specialization or the talent, the class does not have the spell."] =
    "Sans la spécialisation ou le talent, la classe n'a pas le sort."

-- (04/11/2026) the examples at the top of each tab (Examples.lua)
L["Example"] = "Exemple"
L["Party frame"] = "Cadre de groupe"
L["Casting"] = "Incantation"
L["Channelling"] = "Canalisation"
L["Left: defensives and bursts (lit = on; dark with a sweep = recharging)."] =
    "À gauche : défensifs et bursts (allumé = actif ; sombre avec balayage = en recharge)."
L["Right: the cast coming | what you remove | the boss's or the role's."] =
    "À droite : l'incantation qui arrive | ce que vous dissipez | celui du boss ou du rôle."
L["The cast: the border fills, the time in the middle."] =
    "L'incantation : le contour se remplit, le temps au milieu."
L["the type's symbol (the game's)"] = "symbole du type (celui du jeu)"
L["the stacks (above 1)"] = "cumuls (au-delà de 1)"
L["the type's letters (the game's)"] = "sigle du type (celui du jeu)"
L["the border: the type's colour, emptying"] = "contour : couleur du type, qui se vide"
L["the time left"] = "temps restant"

-- (04/11/2026) one tab per feature, the threat's palette
L["Plates"] = "Barres d'info"
L["The tabs"] = "Les onglets"
L["Each tab shows one part, with its example on top: the enemy plates, the threat, the party frame, the debuffs and the alerts."] =
    "Chaque onglet montre une partie, avec son exemple en haut : les barres d'info ennemies, la menace, le cadre de groupe, les affaiblissements et les alertes."
L["Using another nameplate addon? Turn off \"Mark whoever is casting\": the Radar then touches no plate."] =
    "Vous utilisez un autre add-on de barres d'info ? Désactivez « Marquer qui incante » : le Radar ne touche alors à aucune barre."
L["Yours use the game's exact recharge. A teammate who deals damage shows up after the inspection, out of combat; a tank and a healer, at once."] =
    "Les vôtres utilisent la recharge exacte du jeu. Un coéquipier dégâts apparaît après l'inspection, hors de combat ; un tank et un soigneur, tout de suite."
L["Nothing goes on the game's frame. The cast is exact for you; for the others it is still a test. Types and colours: the \"Debuffs\" tab; warnings: the \"Alerts\" tab."] =
    "Rien ne se place sur le cadre du jeu. L'incantation est exacte pour vous ; pour les autres, c'est encore un test. Types et couleurs : onglet « Affaiblissements » ; alertes : onglet « Alertes »."
L["Colour: a click picks one, a right click goes back to the game's. The symbol and the letters are the game's own."] =
    "Couleur : un clic en choisit une, un clic droit revient à celle du jeu. Le symbole et le sigle sont ceux du jeu."
L["The line stays while the debuff lasts. The sound plays only for the season's debuffs the game's tables list. Every alert starts off."] =
    "La ligne reste tant que dure l'affaiblissement. Le son n'est joué que pour les affaiblissements de la saison listés dans les tables du jeu. Chaque alerte est désactivée au départ."
L["casting: the outline fills in the cast's colour, in front of the other plates"] =
    "incantation : le contour se remplit de la couleur de l'incantation, devant les autres barres"
L["channelling: the game's green art, emptying"] = "canalisation : l'illustration verte du jeu, qui se vide"
L["cannot be interrupted: the game's grey (an option, off at first)"] =
    "non interruptible : le gris du jeu (option, désactivée au départ)"
L["Not casting"] = "Pas d'incantation"
L["not casting: the game's plate, nothing of ours"] = "pas d'incantation : la barre du jeu, rien de nous"
L["The cast bar under the health is the game's own: the Radar only adds the outline."] =
    "La barre de sorts sous la vie est celle du jeu : le Radar ajoute seulement le contour."
L["Playing a tank"] = "En tant que tank"
L["Playing damage or healer (in a group)"] = "En tant que dégâts ou soigneur (en groupe)"
L["Mob"] = "Ennemi"
L["green: the mob is with you and safe"] = "vert : l'ennemi est sur vous, en sécurité"
L["orange: with you, about to be lost"] = "orange : sur vous, presque perdu"
L["red and blinking: loose, with the name of who took it"] = "rouge clignotant : libre, avec le nom de qui l'a pris"
L["white: with the other tank"] = "blanc : sur l'autre tank"
L["red: the mob turned to you"] = "rouge : l'ennemi s'est tourné vers vous"
L["Safe with you"] = "En sécurité sur vous"
L["About to be lost"] = "Presque perdu"
L["Loose (or turned to you)"] = "Libre (ou tourné vers vous)"
L["With the other tank"] = "Sur l'autre tank"
L["The shield's colour in this state. At first, the game's own."] =
    "La couleur du bouclier dans cet état. Au départ, celle du jeu."

-- (04/11/2026) the "?" of "Play as"
L["Follows your specialization: a tank specialization plays as tank, any other as damage or healer."] =
    "Suit votre spécialisation : une spécialisation de tank joue en tank, toute autre en dégâts ou soigneur."
L["The shield beside every enemy plate says who holds it: green, safe with you; orange, about to be lost; red and blinking, loose, with the name of who took it; white, with the other tank."] =
    "Le bouclier à côté de chaque barre d'info ennemie indique qui tient l'ennemi : vert, en sécurité sur vous ; orange, presque perdu ; rouge clignotant, libre, avec le nom de qui l'a pris ; blanc, sur l'autre tank."
L["The shield shows only when an enemy turns to you (in a group): red, so you step back or use a defensive."] =
    "Le bouclier n'apparaît que lorsqu'un ennemi se tourne vers vous (en groupe) : rouge, pour que vous reculiez ou utilisiez un défensif."
-- (04/11/2026) the General example as the preview
L["casting: the outline fills in the cast's colour"] = "incantation : le contour se remplit de sa couleur"
L["uninterruptible: the game's grey (an option)"] = "non interruptible : le gris du jeu (option)"
L["green: safe with you"] = "vert : en sécurité sur vous"
L["red and blinking: loose, with who took it"] = "rouge clignotant : libre, avec qui l'a pris"
L["Left: defensives and bursts (lit = on; dark with a sweep = recharging). Right: the cast coming | what you remove | the boss's."] =
    "À gauche : défensifs et bursts (allumé = actif ; sombre avec balayage = en recharge). À droite : l'incantation qui arrive | ce que vous dissipez | celui du boss."
