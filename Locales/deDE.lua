-- RocketRadar | Locales/deDE.lua
-- (04/11/2026) The player's language when the game runs in deDE. A key absent here falls to the key itself, the English
-- text. Translated without a native speaker's review yet: the game's own terms come from its tables for this language
-- (GlobalStrings.deDE). German: "du", as German addons address the player.
local ADDON, ns = ...

if GetLocale() ~= "deDE" then return end

local L = ns.L

L["Play as"] = "Spielen als"
L["Automatic"] = "Automatisch"
L["Damage or healer"] = "Schaden oder Heilung"
L["Tank"] = "Tank"
L["Automatic follows your specialization: a tank spec uses the tank markers."] =
    "Automatisch folgt deiner Spezialisierung: Eine Tankspezialisierung nutzt die Markierungen für Tanks."

L["On every cast that can be interrupted. The outline of the health bar takes the cast's colour and fills up with it, in front of the other plates."] =
    "Bei jedem unterbrechbaren Zauber. Der Rahmen der Gesundheitsleiste nimmt die Farbe des Zaubers an und füllt sich mit ihm, vor den anderen Namensplaketten."
L["Which casts"] = "Welche Zauber"
L["Important only"] = "Nur wichtige"
L["All"] = "Alle"
L["Important: only what the game itself marks as important. In a key the addon cannot read the spell, so it cannot have a list of its own."] =
    "Wichtige: nur, was das Spiel selbst als wichtig markiert. In einem Schlüsselstein kann das Addon den Zauber nicht lesen, also kann es keine eigene Liste haben."
L["Spread enemy plates (game option)"] = "Gegnerische Namensplaketten stapeln"
L["The game's own setting. Plates push each other apart, so two bars rarely cover one another."] =
    "Eine Option des Spiels selbst. Die Namensplaketten weichen einander aus, sodass sich zwei Leisten kaum überdecken."
L["This option cannot change in combat."] = "Diese Option kann im Kampf nicht geändert werden."

L["Show who holds each mob"] = "Zeigen, wer welchen Gegner hält"
L["Tank: green is yours and safe, orange is yours about to be lost, red is loose, white is with another tank. Damage and healers: red when a mob turned to you."] =
    "Tank: Grün ist sicher bei dir, Orange ist bei dir, aber fast verloren, Rot ist frei, Weiß ist bei einem anderen Tank. Schaden und Heilung: Rot, wenn sich ein Gegner dir zugewandt hat."
L["Name who holds the mob"] = "Name, wer den Gegner hält"
L["Beside the marker of a mob you do not hold, in the class colour."] =
    "Neben der Markierung eines Gegners, den du nicht hältst, in der Klassenfarbe."

L["Test on my target"] = "Am Ziel testen"
L["Shows the mark on the health bar of your current target for a few seconds."] =
    "Zeigt die Markierung einige Sekunden lang auf der Gesundheitsleiste deines aktuellen Ziels."
L["Target an enemy with a visible nameplate first."] =
    "Wähle zuerst einen Gegner mit sichtbarer Namensplakette als Ziel."

L["Report a problem"] = "Problem melden"
L["Report a problem on"] = "Problem melden auf"
L["Click: choose where to report a problem"] = "Klick: wählen, wo du ein Problem meldest"
L["Link copied — paste it in your browser."] = "Link kopiert – füge ihn in deinen Browser ein."
L["Rocket Radar %s — report a problem on %s.|n|nPress Ctrl+C to copy the link, then paste it in your browser. Say what you were doing and what happened."] =
    "Rocket Radar %s – Problem melden auf %s.|n|nDrücke Strg+C, um den Link zu kopieren, und füge ihn in deinen Browser ein. Schreib, was du gerade gemacht hast und was passiert ist."

-- The group section of the options, and the spells of the group (development only for now).
L["Beside each party frame, the major defensives and the burst of each member: lit while active, dark while recharging."] =
    "Neben jedem Gruppenrahmen die großen Defensiven und der Burst jedes Mitglieds: hell, solange aktiv, dunkel, solange die Abklingzeit läuft."
L["Show mine too"] = "Meine auch zeigen"
L["Your own icons beside your frame, with the game's exact recharge."] =
    "Deine eigenen Symbole neben deinem Rahmen, mit der genauen Abklingzeit des Spiels."
L["Icon size"] = "Symbolgröße"
L["How large the icons are."] = "Wie groß die Symbole sind."
L["Icons per row"] = "Symbole pro Zeile"
L["After this many, a new row starts; the block stays centred on the frame."] =
    "Danach beginnt eine neue Zeile; der Block bleibt am Rahmen zentriert."
L["Choose the spells"] = "Zauber auswählen"
L["Which spells each specialization shows. Everything is checked at first."] =
    "Welche Zauber jede Spezialisierung zeigt. Anfangs ist alles ausgewählt."
L["Spells of the group"] = "Zauber der Gruppe"
L["Automatic screenshots: on."] = "Automatische Screenshots: an."
L["Automatic screenshots: off."] = "Automatische Screenshots: aus."
L["Minimap button"] = "Minikartensymbol"
L["The button opens this window with a click. Its tooltip shows who the markers are drawn for."] =
    "Ein Klick auf das Symbol öffnet dieses Fenster. Sein Tooltip zeigt, für wen die Markierungen gezeichnet werden."
L["Click: open the options"] = "Klick: Optionen öffnen"

-- Party defensives and bursts (development only).
L["Group icons: %d (%d frames found). Reads %d, hidden %d; errors %d."] =
    "Gruppensymbole: %d (%d Rahmen gefunden). Gelesen %d, verborgen %d; Fehler %d."
L["The group frames are not on screen: the cast mark shows on them in a group."] =
    "Die Gruppenrahmen sind nicht auf dem Bildschirm: Die Zaubermarkierung erscheint dort, wenn du in einer Gruppe bist."
L["The game did not offer the aura container: the sensor cannot work."] =
    "Das Spiel hat den Aurencontainer nicht bereitgestellt: Der Sensor kann nicht arbeiten."

-- (03/11/2026) on/off, animation and colour of each mark; the dispellable debuffs.
L["Click: choose a colour"] = "Klick: Farbe wählen"
L["Filling"] = "Füllen"
L["Full"] = "Voll"
L["Pulsing"] = "Pulsieren"
L["Filling: the line fills as the cast goes on, like the game's cast bar. Full: the whole line at once. Pulsing: the whole line, breathing."] =
    "Füllen: Die Linie füllt sich mit dem Zauber, wie der Zauberbalken des Spiels. Voll: die ganze Linie auf einmal. Pulsieren: die ganze Linie, sanft pulsierend."
L["Cast colour"] = "Zauberfarbe"
L["A cast that can be interrupted. At first, the game's cast bar art itself."] =
    "Ein unterbrechbarer Zauber. Anfangs die Grafik des Zauberbalkens des Spiels selbst."
L["Channel colour"] = "Kanalisierungsfarbe"
L["A channel that can be interrupted. At first, the game's channel art."] =
    "Eine unterbrechbare Kanalisierung. Anfangs die Kanalisierungsgrafik des Spiels."
L["Uninterruptible colour"] = "Farbe: nicht unterbrechbar"
L["A cast that cannot be interrupted. At first, the game's grey for it."] =
    "Ein Zauber, der nicht unterbrochen werden kann. Anfangs das Grau, das das Spiel dafür nutzt."
L["Defensives and bursts"] = "Defensive und Bursts"
L["Enemy plates"] = "Namensplaketten von gegnerischen Einheiten"
L["Mark whoever is casting"] = "Markieren, wer zaubert"
L["Also the uninterruptible"] = "Auch nicht unterbrechbare"
L["A cast that cannot be interrupted is marked too, in its own colour. Off: only what can be interrupted."] =
    "Auch ein Zauber, der nicht unterbrochen werden kann, wird markiert, in seiner eigenen Farbe. Aus: nur, was unterbrochen werden kann."
L["Animation"] = "Animation"
L["Which debuffs"] = "Welche Schwächungszauber"
L["What I can remove: only the types your specialization removes. All: every debuff that has a type, whoever can remove it."] =
    "Bannbar durch mich: nur die Typen, die deine Spezialisierung bannt. Alle: jeder Schwächungszauber mit Typ, egal wer ihn bannen kann."
L["What I can remove"] = "Bannbar durch mich"

-- (04/11/2026) the party frame's left and right, the debuff types and the alerts
L["General"] = "Allgemein"
L["Party frame: left"] = "Gruppenrahmen: links"
L["Party frame: right"] = "Gruppenrahmen: rechts"
L["Debuffs that come off"] = "Bannbare Schwächungszauber"
L["After the cast, each debuff that can be removed: its own icon, a border in its type's colour that empties with the time left, and in its corners the type's symbol and letters, the time and the stacks. The game itself reads the debuff: it works in a fight and in a key."] =
    "Nach dem Zauber jeder bannbare Schwächungszauber: sein eigenes Symbol, ein Rahmen in der Farbe seines Typs, der sich mit der verbleibenden Zeit leert, und in den Ecken Symbol und Kürzel des Typs, die Zeit und die Stapel. Das Spiel selbst liest den Schwächungszauber: Es funktioniert im Kampf und in einem Schlüsselstein."
L["Type"] = "Typ"
L["Colour"] = "Farbe"
L["Alert"] = "Hinweis"
L["Sound"] = "Sound"
L["Off"] = "Aus"
L["On you"] = "Auf dir"
L["Whole group"] = "Ganze Gruppe"
L["Boss or role debuff"] = "Boss oder Rolle"
L["Listen"] = "Anhören"
L["Sound channel"] = "Soundkanal"
L["The game's volume the alerts' sounds follow."] = "Die Lautstärke des Spiels, der die Sounds der Hinweise folgen."
L["The border's colour for this type. At first, the game's own colour for it."] =
    "Die Rahmenfarbe für diesen Typ. Anfangs die eigene Farbe des Spiels."
L["The border's colour for it. At first, the game's red for a debuff without a type."] =
    "Die Rahmenfarbe dafür. Anfangs das Rot des Spiels für Schwächungszauber ohne Typ."
L["A line at the top of the screen while the debuff lasts: its icon, its type, the spell and who has it, in the class colour. On you: only when it is on you."] =
    "Eine Zeile oben auf dem Bildschirm, solange der Schwächungszauber anhält: sein Symbol, sein Typ, der Zauber und wer ihn hat, in der Klassenfarbe. Auf dir: nur, wenn er auf dir liegt."
L["Played when the debuff lands, on the alert's members. The game plays it only for the season's debuffs of this type that the game's tables list: one missing from them shows its line without the sound."] =
    "Wird abgespielt, wenn der Schwächungszauber wirkt, bei den Mitgliedern des Hinweises. Das Spiel spielt ihn nur für die Schwächungszauber dieses Typs der Saison ab, die seine Tabellen auflisten: Fehlt einer dort, erscheint seine Zeile ohne Sound."
L["The game plays an alert's sound only for exact spells, and a boss's debuff has no type to list them by: this alert is the text only."] =
    "Das Spiel spielt den Sound eines Hinweises nur für genau bestimmte Zauber ab, und der Schwächungszauber eines Bosses hat keinen Typ, nach dem man sie auflisten könnte: Dieser Hinweis ist nur Text."
L["Voice: \"Dispel\""] = "Stimme: \"Dispel\""
L["Voice: \"Magic\""] = "Stimme: \"Magic\""
L["Voice: \"Curse\""] = "Stimme: \"Curse\""
L["Voice: \"Poison\""] = "Stimme: \"Poison\""
L["Voice: \"Disease\""] = "Stimme: \"Disease\""
L["Voice: \"Bleed\""] = "Stimme: \"Bleed\""
L["Voice: \"Debuff\""] = "Stimme: \"Debuff\""
L["Raid warning"] = "Schlachtzugswarnung"
L["Boss warning"] = "Bosswarnung"
L["Ready check"] = "Bereitschaftscheck"
L["Alarm clock 1"] = "Wecker 1"
L["Alarm clock 2"] = "Wecker 2"
L["Alarm clock 3"] = "Wecker 3"
L["Battle.net toast"] = "Battle.net-Benachrichtigung"
L["Magic: dispel"] = "Magie: bannen"
L["Magic: arcane burst"] = "Magie: arkane Explosion"
L["Magic: arcane charge"] = "Magie: arkane Ladung"
L["Magic: arcane cast"] = "Magie: arkaner Zauber"
L["Curse 1"] = "Fluch 1"
L["Curse 2"] = "Fluch 2"
L["Curse: shadow 1"] = "Fluch: Schatten 1"
L["Curse: shadow 2"] = "Fluch: Schatten 2"
L["Poison 1"] = "Gift 1"
L["Poison 2"] = "Gift 2"
L["Poison: spores 1"] = "Gift: Sporen 1"
L["Poison: spores 2"] = "Gift: Sporen 2"
L["Disease 1"] = "Krankheit 1"
L["Disease: plague 1"] = "Krankheit: Seuche 1"
L["Disease: plague 2"] = "Krankheit: Seuche 2"
L["Bleed 1"] = "Blutung 1"
L["Bleed 2"] = "Blutung 2"
L["Bleed 3"] = "Blutung 3"
L["Bleed 4"] = "Blutung 4"
L["Boss defeated"] = "Boss besiegt"
L["Countdown end"] = "Countdown-Ende"
L["Right click: the game's colour"] = "Rechtsklick: Farbe des Spiels"
L["Party"] = "Gruppe"

-- (04/11/2026) the window in tabs, faithful to the preview, with the notes
L["Profile"] = "Profil"
L["Threat"] = "Bedrohung"
L["A line at the top of the screen while an enemy casts at you: the spell's icon and name. Only on you: the game tells whom a cast goes to only for you."] =
    "Eine Zeile oben auf dem Bildschirm, solange ein Gegner einen Zauber auf dich wirkt: Symbol und Name des Zaubers. Nur auf dir: Das Spiel verrät das Ziel eines Zaubers nur, wenn du es bist."
L["Alerts: all"] = "Hinweise: alle"
L["Cast"] = "Zauber"
L["Cast animation"] = "Zauberanimation"
L["Cast at you"] = "Zauber auf dich"
L["Channel"] = "Kanalisierung"
L["Every row of the table, shown or not beside the party frame."] =
    "Jede Zeile der Tabelle, ob neben dem Gruppenrahmen angezeigt oder nicht."
L["Icon"] = "Symbol"
L["Letters"] = "Kürzel"
L["On"] = "An"
L["Sets the alert of every row at once. The casts take \"On you\" (the game tells whom a cast goes to only for you)."] =
    "Setzt den Hinweis aller Zeilen auf einmal. Die Zauber erhalten „Auf dir“ (das Spiel verrät das Ziel eines Zaubers nur, wenn du es bist)."
L["The game does not let an addon play a sound for a cast at you: what is secret in a fight cannot start a sound."] =
    "Das Spiel lässt ein Addon keinen Sound für einen Zauber auf dich abspielen: Was Blizzard im Kampf sperrt, kann keinen Sound auslösen."
L["The border's colour for it. At first, the colour of the game's own cast bar art."] =
    "Die Rahmenfarbe dafür. Anfangs die Farbe der Zauberbalkengrafik des Spiels."
L["Turn all on"] = "Alle einschalten"
L["Uninterruptible"] = "Nicht unterbrechbar"
L["What it is"] = "Was es ist"
L["Whether it shows beside the party frame."] = "Ob es neben dem Gruppenrahmen erscheint."
L["— (no list of spells)"] = "— (keine Zauberliste)"
L["— (the game does not allow it)"] = "— (das Spiel erlaubt es nicht)"
L["Debuffs"] = "Schwächungszauber"
L["Alerts"] = "Hinweise"
L["Beside the party frame"] = "Neben dem Gruppenrahmen"
L["Alerts on the screen"] = "Hinweise auf dem Bildschirm"
L["What to do"] = "Was tun"
L["an enemy casting"] = "Gegner zaubert"
L["an enemy channelling"] = "Gegner kanalisiert"
L["cannot be interrupted"] = "nicht unterbrechbar"
L["from a boss or a mechanic"] = "von Boss oder Mechanik"
L["can be removed"] = "bannbar"
L["you can remove it"] = "von dir bannbar"
L["interrupt"] = "unterbrechen"
L["defensive and heal"] = "Defensive und Heilung"
L["remove"] = "bannen"
L["no dispel type"] = "ohne Bannart"
L["free it"] = "befreien"
L["Frees a teammate:"] = "Befreit einen Verbündeten:"
L["Frees only themselves:"] = "Befreit nur sich selbst:"
L["Without the talent, the class does not have the spell. The icon uses the game's crowd control filter: a stun or a fear without a type can show in it too."] = "Ohne das Talent hat die Klasse den Zauber nicht. Das Symbol nutzt den Kontrollfilter des Spiels: Auch eine Betäubung oder Furcht ohne Art kann darin erscheinen."
L["The border's colour for it. At first, a light blue: the game has no colour for it."] = "Die Randfarbe dafür. Zu Beginn ein helles Blau: Das Spiel hat keine Farbe dafür."
L["No class removes it: a boss's or a mechanic's debuff. Defensive and heal."] =
    "Keine Klasse bannt ihn: ein Schwächungszauber eines Bosses oder einer Mechanik. Defensive und Heilung."
L["No class spell in the game's tables removes it."] = "Kein Klassenzauber in den Tabellen des Spiels bannt ihn."
L["Without the specialization or the talent, the class does not have the spell."] =
    "Ohne die Spezialisierung oder das Talent hat die Klasse den Zauber nicht."

-- (04/11/2026) the examples at the top of each tab (Examples.lua)
L["Example"] = "Beispiel"
L["Party frame"] = "Gruppenrahmen"
L["Casting"] = "Zaubert"
L["Channelling"] = "Kanalisiert"
L["Left: defensives and bursts (lit = on; dark with a sweep = recharging)."] =
    "Links: Defensive und Bursts (hell = aktiv; dunkel mit Drehung = Abklingzeit läuft)."
L["Right: the cast coming | what you remove | the boss's or the role's."] =
    "Rechts: der kommende Zauber | was du bannst | der des Bosses oder der Rolle."
L["The cast: the border fills, the time in the middle."] = "Der Zauber: Der Rahmen füllt sich, die Zeit in der Mitte."
L["the type's symbol (the game's)"] = "Symbol des Typs (vom Spiel)"
L["the stacks (above 1)"] = "Stapel (über 1)"
L["the type's letters (the game's)"] = "Kürzel des Typs (vom Spiel)"
L["the border: the type's colour, emptying"] = "Rahmen: Farbe des Typs, leert sich"
L["the time left"] = "verbleibende Zeit"

-- (04/11/2026) one tab per feature, the threat's palette
L["Plates"] = "Namensplaketten"
L["The tabs"] = "Die Reiter"
L["Each tab shows one part, with its example on top: the enemy plates, the threat, the party frame, the debuffs and the alerts."] =
    "Jeder Reiter zeigt einen Teil, mit seinem Beispiel oben: die gegnerischen Namensplaketten, die Bedrohung, den Gruppenrahmen, die Schwächungszauber und die Hinweise."
L["Using another nameplate addon? Turn off \"Mark whoever is casting\": the Radar then touches no plate."] =
    "Nutzt du ein anderes Namensplaketten-Addon? Schalte „Markieren, wer zaubert“ aus: Dann rührt der Radar keine Namensplakette an."
L["Yours use the game's exact recharge. A teammate who deals damage shows up after the inspection, out of combat; a tank and a healer, at once."] =
    "Deine nutzen die genaue Abklingzeit des Spiels. Ein Gruppenmitglied mit Schadensrolle erscheint nach dem Betrachten, außerhalb des Kampfes; Tank und Heiler sofort."
L["Nothing goes on the game's frame. The cast is exact for you; for the others it is still a test. Types and colours: the \"Debuffs\" tab; warnings: the \"Alerts\" tab."] =
    "Nichts kommt auf den Rahmen des Spiels. Der Zauber ist für dich genau; für die anderen ist er noch ein Test. Typen und Farben: Reiter „Schwächungszauber“; Hinweise: Reiter „Hinweise“."
L["Colour: a click picks one, a right click goes back to the game's. The symbol and the letters are the game's own."] =
    "Farbe: Ein Klick wählt eine, ein Rechtsklick kehrt zur Farbe des Spiels zurück. Symbol und Kürzel stammen vom Spiel selbst."
L["The line stays while the debuff lasts. The sound plays only for the season's debuffs the game's tables list. Every alert starts off."] =
    "Die Zeile bleibt, solange der Schwächungszauber anhält. Der Sound spielt nur für die Schwächungszauber der Saison, die die Tabellen des Spiels auflisten. Jeder Hinweis ist anfangs aus."
L["casting: the outline fills in the cast's colour, in front of the other plates"] =
    "zaubert: Der Rahmen füllt sich in der Zauberfarbe, vor den anderen Namensplaketten"
L["channelling: the game's green art, emptying"] = "kanalisiert: die grüne Grafik des Spiels, leert sich"
L["cannot be interrupted: the game's grey (an option, off at first)"] =
    "nicht unterbrechbar: das Grau des Spiels (Option, anfangs aus)"
L["Not casting"] = "Zaubert nicht"
L["not casting: the game's plate, nothing of ours"] = "zaubert nicht: nur die Namensplakette des Spiels"
L["The cast bar under the health is the game's own: the Radar only adds the outline."] =
    "Der Zauberbalken unter der Gesundheit gehört zum Spiel: Der Radar fügt nur den Rahmen hinzu."
L["Playing a tank"] = "Als Tank"
L["Playing damage or healer (in a group)"] = "Als Schaden oder Heiler (in einer Gruppe)"
L["Mob"] = "Gegner"
L["green: the mob is with you and safe"] = "grün: Der Gegner ist sicher bei dir"
L["orange: with you, about to be lost"] = "orange: bei dir, fast verloren"
L["red and blinking: loose, with the name of who took it"] =
    "rot und blinkend: frei, mit dem Namen dessen, der ihn hat"
L["white: with the other tank"] = "weiß: beim anderen Tank"
L["red: the mob turned to you"] = "rot: Der Gegner hat sich dir zugewandt"
L["Safe with you"] = "Sicher bei dir"
L["About to be lost"] = "Fast verloren"
L["Loose (or turned to you)"] = "Frei (oder dir zugewandt)"
L["With the other tank"] = "Beim anderen Tank"
L["The shield's colour in this state. At first, the game's own."] =
    "Die Farbe des Schilds in diesem Zustand. Anfangs die des Spiels."

-- (04/11/2026) the "?" of "Play as"
L["Follows your specialization: a tank specialization plays as tank, any other as damage or healer."] =
    "Folgt deiner Spezialisierung: Eine Tankspezialisierung spielt als Tank, jede andere als Schaden oder Heiler."
L["The shield beside every enemy plate says who holds it: green, safe with you; orange, about to be lost; red and blinking, loose, with the name of who took it; white, with the other tank."] =
    "Der Schild neben jeder gegnerischen Namensplakette zeigt, wer den Gegner hält: grün, sicher bei dir; orange, fast verloren; rot und blinkend, frei, mit dem Namen dessen, der ihn hat; weiß, beim anderen Tank."
L["The shield shows only when an enemy turns to you (in a group): red, so you step back or use a defensive."] =
    "Der Schild erscheint nur, wenn sich ein Gegner dir zuwendet (in einer Gruppe): rot, damit du zurückweichst oder eine Defensive nutzt."
-- (04/11/2026) the General example as the preview
L["casting: the outline fills in the cast's colour"] = "zaubert: Der Rahmen füllt sich in der Zauberfarbe"
L["uninterruptible: the game's grey (an option)"] = "nicht unterbrechbar: das Grau des Spiels (Option)"
L["green: safe with you"] = "grün: sicher bei dir"
L["red and blinking: loose, with who took it"] = "rot und blinkend: frei, mit dem neuen Halter"
L["Left: defensives and bursts (lit = on; dark with a sweep = recharging). Right: the cast coming | what you remove | the boss's."] =
    "Links: Defensive und Bursts (hell = aktiv; dunkel mit Drehung = Abklingzeit läuft). Rechts: der kommende Zauber | was du bannst | der des Bosses."
