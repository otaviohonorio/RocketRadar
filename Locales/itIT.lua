-- RocketRadar | Locales/itIT.lua
-- (04/11/2026) The player's language when the game runs in itIT. A key absent here falls to the key itself, the English
-- text. Translated without a native speaker's review yet: the game's own terms come from its tables for this language
-- (GlobalStrings.itIT). Italian: "tu", as the game does.
local ADDON, ns = ...

if GetLocale() ~= "itIT" then return end

local L = ns.L

L["Play as"] = "Gioca come"
L["Automatic"] = "Automatico"
L["Damage or healer"] = "Assaltatore o guaritore"
L["Tank"] = "Difensore"
L["Automatic follows your specialization: a tank spec uses the tank markers."] =
    "Automatico segue la tua specializzazione: una specializzazione da difensore usa gli indicatori da difensore."

L["On every cast that can be interrupted. The outline of the health bar takes the cast's colour and fills up with it, in front of the other plates."] =
    "A ogni lancio interrompibile. Il contorno della barra della salute prende il colore del lancio e si riempie con esso, davanti alle altre barre."
L["Which casts"] = "Quali lanci"
L["Important only"] = "Solo importanti"
L["All"] = "Tutto"
L["Important: only what the game itself marks as important. In a key the addon cannot read the spell, so it cannot have a list of its own."] =
    "Importanti: solo ciò che il gioco stesso segna come importante. In una chiave l'add-on non può leggere l'incantesimo, quindi non può avere una lista propria."
L["Spread enemy plates (game option)"] = "Impila le barre delle unità nemiche"
L["The game's own setting. Plates push each other apart, so two bars rarely cover one another."] =
    "Un'impostazione del gioco stesso. Le barre si allontanano l'una dall'altra, così due barre si coprono di rado."
L["This option cannot change in combat."] = "Questa opzione non può essere cambiata in combattimento."

L["Show who holds each mob"] = "Mostra chi tiene ogni nemico"
L["Tank: green is yours and safe, orange is yours about to be lost, red is loose, white is with another tank. Damage and healers: red when a mob turned to you."] =
    "Difensore: verde è tuo e al sicuro, arancione è tuo ma stai per perderlo, rosso è libero, bianco è con un altro difensore. Assaltatori e guaritori: rosso quando un nemico si è voltato verso di te."
L["Name who holds the mob"] = "Nome di chi tiene il nemico"
L["Beside the marker of a mob you do not hold, in the class colour."] =
    "Accanto all'indicatore di un nemico che non tieni, nel colore della classe."

L["Test on my target"] = "Prova sul mio bersaglio"
L["Shows the mark on the health bar of your current target for a few seconds."] =
    "Mostra l'indicatore sulla barra della salute del tuo bersaglio attuale per qualche secondo."
L["Target an enemy with a visible nameplate first."] = "Prima prendi di mira un nemico con la barra visibile."

L["Report a problem"] = "Segnala un problema"
L["Report a problem on"] = "Segnala un problema su"
L["Click: choose where to report a problem"] = "Clic: scegli dove segnalare un problema"
L["Link copied — paste it in your browser."] = "Link copiato: incollalo nel browser."
L["Rocket Radar %s — report a problem on %s.|n|nPress Ctrl+C to copy the link, then paste it in your browser. Say what you were doing and what happened."] =
    "Rocket Radar %s: segnala un problema su %s.|n|nPremi Ctrl+C per copiare il link e incollalo nel browser. Racconta cosa stavi facendo e cosa è successo."

-- The group section of the options, and the spells of the group (development only for now).
L["Beside each party frame, the major defensives and the burst of each member: lit while active, dark while recharging."] =
    "Accanto a ogni riquadro di gruppo, le grandi difensive e il burst di ogni membro: accesi quando attivi, scuri durante il recupero."
L["Show mine too"] = "Mostra anche le mie"
L["Your own icons beside your frame, with the game's exact recharge."] =
    "Le tue icone accanto al tuo riquadro, con il recupero esatto del gioco."
L["Icon size"] = "Dimensione delle icone"
L["How large the icons are."] = "Quanto sono grandi le icone."
L["Icons per row"] = "Icone per riga"
L["After this many, a new row starts; the block stays centred on the frame."] =
    "Oltre questo numero inizia una nuova riga; il blocco resta centrato sul riquadro."
L["Choose the spells"] = "Scegli gli incantesimi"
L["Which spells each specialization shows. Everything is checked at first."] =
    "Quali incantesimi mostra ogni specializzazione. All'inizio è tutto selezionato."
L["Spells of the group"] = "Incantesimi del gruppo"
L["Automatic screenshots: on."] = "Schermate automatiche: attive."
L["Automatic screenshots: off."] = "Schermate automatiche: disattivate."
L["Minimap button"] = "Pulsante della minimappa"
L["The button opens this window with a click. Its tooltip shows who the markers are drawn for."] =
    "Il pulsante apre questa finestra con un clic. La sua descrizione mostra per chi vengono disegnati gli indicatori."
L["Click: open the options"] = "Clic: apri le opzioni"

-- Party defensives and bursts (development only).
L["Group icons: %d (%d frames found). Reads %d, hidden %d; errors %d."] =
    "Icone del gruppo: %d (%d riquadri trovati). Letture %d, nascoste %d; errori %d."
L["The group frames are not on screen: the cast mark shows on them in a group."] =
    "I riquadri di gruppo non sono sullo schermo: l'indicatore del lancio compare su di essi quando sei in gruppo."
L["The game did not offer the aura container: the sensor cannot work."] =
    "Il gioco non ha fornito il contenitore delle aure: il sensore non può funzionare."

-- (03/11/2026) on/off, animation and colour of each mark; the dispellable debuffs.
L["Click: choose a colour"] = "Clic: scegli un colore"
L["Filling"] = "Riempimento"
L["Full"] = "Piena"
L["Pulsing"] = "Pulsazione"
L["Filling: the line fills as the cast goes on, like the game's cast bar. Full: the whole line at once. Pulsing: the whole line, breathing."] =
    "Riempimento: la linea si riempie con il lancio, come la barra degli incantesimi del gioco. Piena: tutta la linea subito. Pulsazione: tutta la linea, che pulsa piano."
L["Cast colour"] = "Colore del lancio"
L["A cast that can be interrupted. At first, the game's cast bar art itself."] =
    "Un lancio interrompibile. All'inizio, la grafica stessa della barra degli incantesimi del gioco."
L["Channel colour"] = "Colore della canalizzazione"
L["A channel that can be interrupted. At first, the game's channel art."] =
    "Una canalizzazione interrompibile. All'inizio, la grafica di canalizzazione del gioco."
L["Uninterruptible colour"] = "Colore non interrompibile"
L["A cast that cannot be interrupted. At first, the game's grey for it."] =
    "Un lancio che non può essere interrotto. All'inizio, il grigio che il gioco usa per esso."
L["Defensives and bursts"] = "Difensive e burst"
L["Enemy plates"] = "Barre delle unità nemiche"
L["Mark whoever is casting"] = "Segna chi sta lanciando"
L["Also the uninterruptible"] = "Anche i non interrompibili"
L["A cast that cannot be interrupted is marked too, in its own colour. Off: only what can be interrupted."] =
    "Anche un lancio che non può essere interrotto viene segnato, nel suo colore. Disattivato: solo ciò che si può interrompere."
L["Animation"] = "Animazione"
L["Which debuffs"] = "Quali penalità"
L["What I can remove: only the types your specialization removes. All: every debuff that has a type, whoever can remove it."] =
    "Dissolvibili da me: solo i tipi che la tua specializzazione dissolve. Tutto: ogni penalità che ha un tipo, chiunque possa dissolverla."
L["What I can remove"] = "Dissolvibili da me"

-- (04/11/2026) the party frame's left and right, the debuff types and the alerts
L["General"] = "Generale"
L["Party frame: left"] = "Riquadro di gruppo: sinistra"
L["Party frame: right"] = "Riquadro di gruppo: destra"
L["Debuffs that come off"] = "Penalità dissolvibili"
L["After the cast, each debuff that can be removed: its own icon, a border in its type's colour that empties with the time left, and in its corners the type's symbol and letters, the time and the stacks. The game itself reads the debuff: it works in a fight and in a key."] =
    "Dopo il lancio, ogni penalità dissolvibile: la sua icona, un contorno nel colore del suo tipo che si svuota con il tempo rimasto e, negli angoli, il simbolo e la sigla del tipo, il tempo e gli accumuli. È il gioco stesso a leggere la penalità: funziona in combattimento e in una chiave."
L["Type"] = "Tipo"
L["Colour"] = "Colore"
L["Alert"] = "Avviso"
L["Sound"] = "Audio"
L["Off"] = "Disattivato"
L["On you"] = "Su di te"
L["Whole group"] = "Tutto il gruppo"
L["Boss or role debuff"] = "Boss o ruolo"
L["Listen"] = "Ascolta"
L["Sound channel"] = "Canale audio"
L["The game's volume the alerts' sounds follow."] = "Il volume del gioco seguito dall'audio degli avvisi."
L["The border's colour for this type. At first, the game's own colour for it."] =
    "Il colore del contorno per questo tipo. All'inizio, il colore del gioco stesso."
L["The border's colour for it. At first, the game's red for a debuff without a type."] =
    "Il colore del contorno per essa. All'inizio, il rosso del gioco per una penalità senza tipo."
L["A line at the top of the screen while the debuff lasts: its icon, its type, the spell and who has it, in the class colour. On you: only when it is on you."] =
    "Una riga in alto sullo schermo finché dura la penalità: la sua icona, il tipo, l'incantesimo e chi ce l'ha, nel colore della classe. Su di te: solo quando è su di te."
L["Played when the debuff lands, on the alert's members. The game plays it only for the season's debuffs of this type that the game's tables list: one missing from them shows its line without the sound."] =
    "Viene riprodotto quando la penalità viene applicata, sui membri dell'avviso. Il gioco lo riproduce solo per le penalità di questo tipo della stagione elencate nelle tabelle del gioco: una che manca mostra la sua riga senza audio."
L["The game plays an alert's sound only for exact spells, and a boss's debuff has no type to list them by: this alert is the text only."] =
    "Il gioco riproduce l'audio di un avviso solo per incantesimi precisi, e la penalità di un boss non ha un tipo con cui elencarli: questo avviso è solo il testo."
L["Voice: \"Dispel\""] = "Voce: \"Dispel\""
L["Voice: \"Magic\""] = "Voce: \"Magic\""
L["Voice: \"Curse\""] = "Voce: \"Curse\""
L["Voice: \"Poison\""] = "Voce: \"Poison\""
L["Voice: \"Disease\""] = "Voce: \"Disease\""
L["Voice: \"Bleed\""] = "Voce: \"Bleed\""
L["Voice: \"Debuff\""] = "Voce: \"Debuff\""
L["Raid warning"] = "Avviso incursione"
L["Boss warning"] = "Avviso boss"
L["Ready check"] = "Appello"
L["Alarm clock 1"] = "Sveglia 1"
L["Alarm clock 2"] = "Sveglia 2"
L["Alarm clock 3"] = "Sveglia 3"
L["Battle.net toast"] = "Notifica Battle.net"
L["Magic: dispel"] = "Magia: dissolvere"
L["Magic: arcane burst"] = "Magia: esplosione arcana"
L["Magic: arcane charge"] = "Magia: carica arcana"
L["Magic: arcane cast"] = "Magia: lancio arcano"
L["Curse 1"] = "Maledizione 1"
L["Curse 2"] = "Maledizione 2"
L["Curse: shadow 1"] = "Maledizione: ombra 1"
L["Curse: shadow 2"] = "Maledizione: ombra 2"
L["Poison 1"] = "Veleno 1"
L["Poison 2"] = "Veleno 2"
L["Poison: spores 1"] = "Veleno: spore 1"
L["Poison: spores 2"] = "Veleno: spore 2"
L["Disease 1"] = "Malattia 1"
L["Disease: plague 1"] = "Malattia: peste 1"
L["Disease: plague 2"] = "Malattia: peste 2"
L["Bleed 1"] = "Sanguinamento 1"
L["Bleed 2"] = "Sanguinamento 2"
L["Bleed 3"] = "Sanguinamento 3"
L["Bleed 4"] = "Sanguinamento 4"
L["Boss defeated"] = "Boss sconfitto"
L["Countdown end"] = "Fine del conto alla rovescia"
L["Right click: the game's colour"] = "Clic destro: colore del gioco"
L["Party"] = "Gruppo"

-- (04/11/2026) the window in tabs, faithful to the preview, with the notes
L["Profile"] = "Profilo"
L["Threat"] = "Minaccia"
L["A line at the top of the screen while an enemy casts at you: the spell's icon and name. Only on you: the game tells whom a cast goes to only for you."] =
    "Una riga in alto sullo schermo mentre un nemico lancia un incantesimo su di te: l'icona e il nome dell'incantesimo. Solo su di te: il gioco dice il bersaglio di un lancio solo quando sei tu."
L["Alerts: all"] = "Avvisi: tutti"
L["Cast"] = "Lancio"
L["Cast animation"] = "Animazione del lancio"
L["Cast at you"] = "Lancio su di te"
L["Channel"] = "Canalizzazione"
L["Every row of the table, shown or not beside the party frame."] =
    "Ogni riga della tabella, mostrata o no accanto al riquadro di gruppo."
L["Icon"] = "Icona"
L["Letters"] = "Sigla"
L["On"] = "Attivato"
L["Sets the alert of every row at once. The casts take \"On you\" (the game tells whom a cast goes to only for you)."] =
    "Imposta l'avviso di tutte le righe in una volta. I lanci passano a \"Su di te\" (il gioco dice il bersaglio di un lancio solo quando sei tu)."
L["The game does not let an addon play a sound for a cast at you: what is secret in a fight cannot start a sound."] =
    "Il gioco non permette a un add-on di riprodurre un suono per un lancio su di te: ciò che Blizzard blocca in combattimento non può avviare un suono."
L["The border's colour for it. At first, the colour of the game's own cast bar art."] =
    "Il colore del contorno per esso. All'inizio, il colore della grafica della barra degli incantesimi del gioco."
L["Turn all on"] = "Attiva tutti"
L["Uninterruptible"] = "Non interrompibile"
L["What it is"] = "Cos'è"
L["Whether it shows beside the party frame."] = "Se compare accanto al riquadro di gruppo."
L["— (no list of spells)"] = "— (nessun elenco di incantesimi)"
L["— (the game does not allow it)"] = "— (il gioco non lo permette)"
L["Debuffs"] = "Penalità"
L["Alerts"] = "Avvisi"
L["Beside the party frame"] = "Accanto al riquadro di gruppo"
L["Alerts on the screen"] = "Avvisi sullo schermo"
L["What to do"] = "Cosa fare"
L["an enemy casting"] = "nemico in lancio"
L["an enemy channelling"] = "nemico in canalizzazione"
L["cannot be interrupted"] = "non interrompibile"
L["from a boss or a mechanic"] = "da boss o meccanica"
L["can be removed"] = "dissolvibile"
L["you can remove it"] = "dissolvibile da te"
L["interrupt"] = "interrompere"
L["defensive and heal"] = "difensiva e cure"
L["remove"] = "dissolvere"
L["no dispel type"] = "senza tipo di dissoluzione"
L["free it"] = "liberare"
L["Frees a teammate:"] = "Libera un alleato:"
L["Frees only themselves:"] = "Libera solo se stesso:"
L["Without the talent, the class does not have the spell. The icon uses the game's crowd control filter: a stun or a fear without a type can show in it too."] = "Senza il talento, la classe non ha l'incantesimo. L'icona usa il filtro di controllo del gioco: può apparirvi anche uno stordimento o una paura senza tipo."
L["The border's colour for it. At first, a light blue: the game has no colour for it."] = "Il colore del bordo. All'inizio, un azzurro: il gioco non ha un colore per questo."
L["No class removes it: a boss's or a mechanic's debuff. Defensive and heal."] =
    "Nessuna classe la dissolve: è una penalità di boss o di meccanica. Difensiva e cure."
L["No class spell in the game's tables removes it."] =
    "Nessun incantesimo di classe nelle tabelle del gioco la dissolve."
L["Without the specialization or the talent, the class does not have the spell."] =
    "Senza la specializzazione o il talento, la classe non ha l'incantesimo."

-- (04/11/2026) the examples at the top of each tab (Examples.lua)
L["Example"] = "Esempio"
L["Party frame"] = "Riquadro di gruppo"
L["Casting"] = "Lancio in corso"
L["Channelling"] = "Canalizzazione"
L["Left: defensives and bursts (lit = on; dark with a sweep = recharging)."] =
    "A sinistra: difensive e burst (acceso = attivo; scuro con rotazione = in recupero)."
L["Right: the cast coming | what you remove | the boss's or the role's."] =
    "A destra: il lancio in arrivo | ciò che dissolvi | quella del boss o del ruolo."
L["The cast: the border fills, the time in the middle."] = "Il lancio: il contorno si riempie, il tempo al centro."
L["the type's symbol (the game's)"] = "simbolo del tipo (del gioco)"
L["the stacks (above 1)"] = "accumuli (oltre 1)"
L["the type's letters (the game's)"] = "sigla del tipo (del gioco)"
L["the border: the type's colour, emptying"] = "contorno: colore del tipo, che si svuota"
L["the time left"] = "tempo rimasto"

-- (04/11/2026) one tab per feature, the threat's palette
L["Plates"] = "Barre"
L["The tabs"] = "Le schede"
L["Each tab shows one part, with its example on top: the enemy plates, the threat, the party frame, the debuffs and the alerts."] =
    "Ogni scheda mostra una parte, con il suo esempio in alto: le barre dei nemici, la minaccia, il riquadro di gruppo, le penalità e gli avvisi."
L["Using another nameplate addon? Turn off \"Mark whoever is casting\": the Radar then touches no plate."] =
    "Usi un altro add-on per le barre? Disattiva \"Segna chi sta lanciando\": il Radar non tocca nessuna barra."
L["Yours use the game's exact recharge. A teammate who deals damage shows up after the inspection, out of combat; a tank and a healer, at once."] =
    "I tuoi usano il recupero esatto del gioco. Un compagno assaltatore compare dopo l'ispezione, fuori dal combattimento; un difensore e un guaritore, subito."
L["Nothing goes on the game's frame. The cast is exact for you; for the others it is still a test. Types and colours: the \"Debuffs\" tab; warnings: the \"Alerts\" tab."] =
    "Niente va sopra il riquadro del gioco. Il lancio è esatto per te; per gli altri è ancora una prova. Tipi e colori: scheda \"Penalità\"; avvisi: scheda \"Avvisi\"."
L["Colour: a click picks one, a right click goes back to the game's. The symbol and the letters are the game's own."] =
    "Colore: un clic ne sceglie uno, un clic destro torna a quello del gioco. Il simbolo e la sigla sono quelli del gioco."
L["The line stays while the debuff lasts. The sound plays only for the season's debuffs the game's tables list. Every alert starts off."] =
    "La riga resta finché dura la penalità. L'audio viene riprodotto solo per le penalità della stagione elencate nelle tabelle del gioco. Ogni avviso parte disattivato."
L["casting: the outline fills in the cast's colour, in front of the other plates"] =
    "lancio: il contorno si riempie del colore del lancio, davanti alle altre barre"
L["channelling: the game's green art, emptying"] = "canalizzazione: il verde del gioco, che si svuota"
L["cannot be interrupted: the game's grey (an option, off at first)"] =
    "non interrompibile: il grigio del gioco (opzione, disattivata all'inizio)"
L["Not casting"] = "Nessun lancio"
L["not casting: the game's plate, nothing of ours"] = "nessun lancio: la barra del gioco, niente di nostro"
L["The cast bar under the health is the game's own: the Radar only adds the outline."] =
    "La barra degli incantesimi sotto la salute è quella del gioco: il Radar aggiunge solo il contorno."
L["Playing a tank"] = "Da difensore"
L["Playing damage or healer (in a group)"] = "Da assaltatore o guaritore (in gruppo)"
L["Mob"] = "Nemico"
L["green: the mob is with you and safe"] = "verde: il nemico è al sicuro con te"
L["orange: with you, about to be lost"] = "arancione: con te, stai per perderlo"
L["red and blinking: loose, with the name of who took it"] =
    "rosso lampeggiante: libero, con il nome di chi l'ha preso"
L["white: with the other tank"] = "bianco: con l'altro difensore"
L["red: the mob turned to you"] = "rosso: il nemico si è voltato verso di te"
L["Safe with you"] = "Al sicuro con te"
L["About to be lost"] = "Sta per essere perso"
L["Loose (or turned to you)"] = "Libero (o voltato verso di te)"
L["With the other tank"] = "Con l'altro difensore"
L["The shield's colour in this state. At first, the game's own."] =
    "Il colore dello scudo in questo stato. All'inizio, quello del gioco."

-- (04/11/2026) the "?" of "Play as"
L["Follows your specialization: a tank specialization plays as tank, any other as damage or healer."] =
    "Segue la tua specializzazione: una specializzazione da difensore gioca da difensore, qualsiasi altra da assaltatore o guaritore."
L["The shield beside every enemy plate says who holds it: green, safe with you; orange, about to be lost; red and blinking, loose, with the name of who took it; white, with the other tank."] =
    "Lo scudo accanto a ogni barra nemica dice chi tiene il nemico: verde, al sicuro con te; arancione, stai per perderlo; rosso lampeggiante, libero, con il nome di chi l'ha preso; bianco, con l'altro difensore."
L["The shield shows only when an enemy turns to you (in a group): red, so you step back or use a defensive."] =
    "Lo scudo compare solo quando un nemico si volta verso di te (in gruppo): rosso, così ti allontani o usi una difensiva."
-- (04/11/2026) the General example as the preview
L["casting: the outline fills in the cast's colour"] = "lancio: il contorno si riempie del colore del lancio"
L["uninterruptible: the game's grey (an option)"] = "non interrompibile: il grigio del gioco (opzione)"
L["green: safe with you"] = "verde: al sicuro con te"
L["red and blinking: loose, with who took it"] = "rosso lampeggiante: libero, con chi lo ha"
L["Left: defensives and bursts (lit = on; dark with a sweep = recharging). Right: the cast coming | what you remove | the boss's."] =
    "A sinistra: difensive e burst (acceso = attivo; scuro con rotazione = in recupero). A destra: il lancio in arrivo | ciò che dissolvi | quella del boss."
