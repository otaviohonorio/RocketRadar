-- RocketRadar | Locales/esMX.lua
-- (04/11/2026) The player's language when the game runs in esMX. A key absent here falls to the key itself, the English
-- text. Translated without a native speaker's review yet: the game's own terms come from its tables for this language
-- (GlobalStrings.esMX).
local ADDON, ns = ...

if GetLocale() ~= "esMX" then return end

local L = ns.L

L["Play as"] = "Jugar como"
L["Automatic"] = "Automático"
L["Damage or healer"] = "Daño o sanador"
L["Tank"] = "Tanque"
L["Automatic follows your specialization: a tank spec uses the tank markers."] =
    "Automático sigue tu especialización: una especialización de tanque usa las marcas de tanque."

L["On every cast that can be interrupted. The outline of the health bar takes the cast's colour and fills up with it, in front of the other plates."] =
    "En cada lanzamiento interrumpible. El contorno de la barra de salud toma el color del lanzamiento y se llena con él, por delante de las demás placas."
L["Which casts"] = "Qué lanzamientos"
L["Important only"] = "Solo los importantes"
L["All"] = "Todos"
L["Important: only what the game itself marks as important. In a key the addon cannot read the spell, so it cannot have a list of its own."] =
    "Importantes: solo lo que el propio juego marca como importante. En una piedra angular el addon no puede leer el hechizo, así que no puede tener una lista propia."
L["Spread enemy plates (game option)"] = "Separar las placas enemigas"
L["The game's own setting. Plates push each other apart, so two bars rarely cover one another."] =
    "Es una opción del propio juego. Las placas se apartan unas de otras, así que es difícil que una barra tape a otra."
L["This option cannot change in combat."] = "Esta opción no se puede cambiar en combate."

L["Show who holds each mob"] = "Con quién está cada enemigo"
L["Tank: green is yours and safe, orange is yours about to be lost, red is loose, white is with another tank. Damage and healers: red when a mob turned to you."] =
    "Tanque: verde, seguro contigo; naranja, contigo por poco; rojo, suelto; blanco, con otro tanque. Daño y sanadores: rojo cuando un enemigo se ha vuelto hacia ti."
L["Name who holds the mob"] = "Nombre de quién lo tiene"
L["Beside the marker of a mob you do not hold, in the class colour."] =
    "Junto a la marca del enemigo que no está contigo, en el color de la clase."

L["Test on my target"] = "Probar en mi objetivo"
L["Shows the mark on the health bar of your current target for a few seconds."] =
    "Muestra la marca en la barra de salud de tu objetivo actual durante unos segundos."
L["Target an enemy with a visible nameplate first."] =
    "Primero selecciona como objetivo a un enemigo con la placa de nombre visible."

L["Report a problem"] = "Reportar un problema"
L["Report a problem on"] = "Reportar un problema en"
L["Click: choose where to report a problem"] = "Clic: elegir dónde reportar un problema"
L["Link copied — paste it in your browser."] = "Enlace copiado: pégalo en tu navegador."
L["Rocket Radar %s — report a problem on %s.|n|nPress Ctrl+C to copy the link, then paste it in your browser. Say what you were doing and what happened."] =
    "Rocket Radar %s: reportar un problema en %s.|n|nPresiona Ctrl+C para copiar el enlace y pégalo en tu navegador. Cuenta qué estabas haciendo y qué pasó."

L["Beside each party frame, the major defensives and the burst of each member: lit while active, dark while recharging."] =
    "Junto al marco de cada miembro del grupo, sus defensivas importantes y su burst: iluminados mientras están activos, oscuros mientras se recargan."
L["Show mine too"] = "Mostrar también los míos"
L["Your own icons beside your frame, with the game's exact recharge."] =
    "Tus propios íconos junto a tu marco, con la recarga exacta del juego."
L["Icon size"] = "Tamaño de los íconos"
L["How large the icons are."] = "El tamaño de los íconos."
L["Icons per row"] = "Íconos por fila"
L["After this many, a new row starts; the block stays centred on the frame."] =
    "Pasado este número empieza otra fila; el bloque sigue centrado en el marco."
L["Choose the spells"] = "Elegir los hechizos"
L["Which spells each specialization shows. Everything is checked at first."] =
    "Qué hechizos muestra cada especialización. Al principio, todos están marcados."
L["Spells of the group"] = "Hechizos del grupo"
L["Automatic screenshots: on."] = "Capturas automáticas: encendidas."
L["Automatic screenshots: off."] = "Capturas automáticas: apagadas."
L["Minimap button"] = "Botón del minimapa"
L["The button opens this window with a click. Its tooltip shows who the markers are drawn for."] =
    "El botón abre esta ventana con un clic. Su descripción emergente muestra para quién se dibujan las marcas."
L["Click: open the options"] = "Clic: abrir las opciones"

L["Group icons: %d (%d frames found). Reads %d, hidden %d; errors %d."] =
    "Íconos del grupo: %d (%d marcos encontrados). Lecturas %d, ocultos %d; errores %d."
L["The group frames are not on screen: the cast mark shows on them in a group."] =
    "Los marcos de grupo no están en pantalla: la marca del lanzamiento aparece en ellos cuando estás en grupo."
L["The game did not offer the aura container: the sensor cannot work."] =
    "El juego no ofreció el contenedor de auras: el sensor no puede funcionar."

L["Click: choose a colour"] = "Clic: elegir un color"
L["Filling"] = "Llenándose"
L["Full"] = "Completa"
L["Pulsing"] = "Latiendo"
L["Filling: the line fills as the cast goes on, like the game's cast bar. Full: the whole line at once. Pulsing: the whole line, breathing."] =
    "Llenándose: la línea se llena a medida que avanza el lanzamiento, como la barra de lanzamiento del juego. Completa: toda la línea a la vez. Latiendo: toda la línea, con un pulso suave."
L["Cast colour"] = "Color del lanzamiento"
L["A cast that can be interrupted. At first, the game's cast bar art itself."] =
    "Lanzamiento interrumpible. Al principio, el propio arte de la barra de lanzamiento del juego."
L["Channel colour"] = "Color de la canalización"
L["A channel that can be interrupted. At first, the game's channel art."] =
    "Canalización interrumpible. Al principio, el arte de canalización del juego."
L["Uninterruptible colour"] = "Color de lo no interrumpible"
L["A cast that cannot be interrupted. At first, the game's grey for it."] =
    "Lanzamiento que no se puede interrumpir. Al principio, el gris que usa el juego para él."
L["Defensives and bursts"] = "Defensivas y burst"
L["Enemy plates"] = "Placas de nombre de enemigos"
L["Mark whoever is casting"] = "Marcar a quien está lanzando"
L["Also the uninterruptible"] = "También los no interrumpibles"
L["A cast that cannot be interrupted is marked too, in its own colour. Off: only what can be interrupted."] =
    "El lanzamiento que no se puede interrumpir también se marca, en su propio color. Apagado: solo lo interrumpible."
L["Animation"] = "Animación"
L["Which debuffs"] = "Qué perjuicios"
L["What I can remove: only the types your specialization removes. All: every debuff that has a type, whoever can remove it."] =
    "Lo que quito yo: solo los tipos que quita tu especialización. Todos: todo perjuicio que tenga tipo, lo quite quien lo quite."
L["What I can remove"] = "Lo que quito yo"

L["General"] = "General"
L["Party frame: left"] = "Marco de grupo: izquierda"
L["Party frame: right"] = "Marco de grupo: derecha"
L["Debuffs that come off"] = "Perjuicios que se quitan"
L["After the cast, each debuff that can be removed: its own icon, a border in its type's colour that empties with the time left, and in its corners the type's symbol and letters, the time and the stacks. The game itself reads the debuff: it works in a fight and in a key."] =
    "Tras el lanzamiento, cada perjuicio que se puede quitar: su ícono, un borde del color de su tipo que se vacía con el tiempo restante y, en las esquinas, el símbolo y las letras del tipo, el tiempo y las acumulaciones. Quien lee el perjuicio es el propio juego: funciona en combate y en piedra angular."
L["Type"] = "Tipo"
L["Colour"] = "Color"
L["Alert"] = "Alerta"
L["Sound"] = "Sonido"
L["Off"] = "Apagado"
L["On you"] = "En ti"
L["Whole group"] = "Todo el grupo"
L["Boss or role debuff"] = "Jefe o función"
L["Listen"] = "Escuchar"
L["Sound channel"] = "Canal de sonido"
L["The game's volume the alerts' sounds follow."] = "El volumen del juego que siguen los sonidos de las alertas."
L["The border's colour for this type. At first, the game's own colour for it."] =
    "El color del borde para este tipo. Al principio, el color del propio juego."
L["The border's colour for it. At first, the game's red for a debuff without a type."] =
    "El color del borde para él. Al principio, el rojo del juego para un perjuicio sin tipo."
L["A line at the top of the screen while the debuff lasts: its icon, its type, the spell and who has it, in the class colour. On you: only when it is on you."] =
    "Una línea en la parte superior de la pantalla mientras dura el perjuicio: su ícono, su tipo, el hechizo y quién lo tiene, en el color de la clase. En ti: solo cuando lo tienes tú."
L["Played when the debuff lands, on the alert's members. The game plays it only for the season's debuffs of this type that the game's tables list: one missing from them shows its line without the sound."] =
    "Suena cuando se aplica el perjuicio, en los miembros de la alerta. El juego solo lo reproduce con los perjuicios de este tipo de la temporada que figuran en sus tablas: el que no figure muestra su línea sin sonido."
L["The game plays an alert's sound only for exact spells, and a boss's debuff has no type to list them by: this alert is the text only."] =
    "El juego solo reproduce el sonido de una alerta para hechizos concretos, y el perjuicio de un jefe no tiene tipo con el que listarlos: esta alerta es solo el texto."
L["Voice: \"Dispel\""] = "Voz: \"Dispel\""
L["Voice: \"Magic\""] = "Voz: \"Magic\""
L["Voice: \"Curse\""] = "Voz: \"Curse\""
L["Voice: \"Poison\""] = "Voz: \"Poison\""
L["Voice: \"Disease\""] = "Voz: \"Disease\""
L["Voice: \"Bleed\""] = "Voz: \"Bleed\""
L["Voice: \"Debuff\""] = "Voz: \"Debuff\""
L["Raid warning"] = "Aviso de la banda"
L["Boss warning"] = "Advertencia de jefe"
L["Ready check"] = "Listos"
L["Alarm clock 1"] = "Despertador 1"
L["Alarm clock 2"] = "Despertador 2"
L["Alarm clock 3"] = "Despertador 3"
L["Battle.net toast"] = "Aviso de Battle.net"
L["Magic: dispel"] = "Magia: disipar"
L["Magic: arcane burst"] = "Magia: estallido arcano"
L["Magic: arcane charge"] = "Magia: carga arcana"
L["Magic: arcane cast"] = "Magia: lanzamiento arcano"
L["Curse 1"] = "Maldición 1"
L["Curse 2"] = "Maldición 2"
L["Curse: shadow 1"] = "Maldición: sombra 1"
L["Curse: shadow 2"] = "Maldición: sombra 2"
L["Poison 1"] = "Veneno 1"
L["Poison 2"] = "Veneno 2"
L["Poison: spores 1"] = "Veneno: esporas 1"
L["Poison: spores 2"] = "Veneno: esporas 2"
L["Disease 1"] = "Enfermedad 1"
L["Disease: plague 1"] = "Enfermedad: peste 1"
L["Disease: plague 2"] = "Enfermedad: peste 2"
L["Bleed 1"] = "Sangrado 1"
L["Bleed 2"] = "Sangrado 2"
L["Bleed 3"] = "Sangrado 3"
L["Bleed 4"] = "Sangrado 4"
L["Boss defeated"] = "Jefe derrotado"
L["Countdown end"] = "Fin de la cuenta regresiva"
L["Right click: the game's colour"] = "Clic derecho: volver al color del juego"
L["Party"] = "Grupo"

L["Profile"] = "Perfil"
L["Threat"] = "Amenaza"
L["A line at the top of the screen while an enemy casts at you: the spell's icon and name. Only on you: the game tells whom a cast goes to only for you."] =
    "Una línea en la parte superior de la pantalla mientras un enemigo lanza algo contra ti: el ícono y el nombre del hechizo. Solo en ti: el juego solo dice a quién va un lanzamiento cuando eres tú."
L["Alerts: all"] = "Alertas: todas"
L["Cast"] = "Lanzamiento"
L["Cast animation"] = "Animación del lanzamiento"
L["Cast at you"] = "Lanzamiento contra ti ·"
L["Channel"] = "Canalización"
L["Every row of the table, shown or not beside the party frame."] =
    "Todas las filas de la tabla, se muestren o no junto al marco de grupo."
L["Icon"] = "Ícono"
L["Letters"] = "Letras"
L["On"] = "Encendido"
L["Sets the alert of every row at once. The casts take \"On you\" (the game tells whom a cast goes to only for you)."] =
    "Cambia la alerta de todas las filas a la vez. Los lanzamientos quedan en \"En ti\" (el juego solo dice a quién va un lanzamiento cuando eres tú)."
L["The game does not let an addon play a sound for a cast at you: what is secret in a fight cannot start a sound."] =
    "El juego no deja que un addon reproduzca un sonido por un lanzamiento contra ti: lo que son datos bloqueados por Blizzard en combate no puede activar un sonido."
L["The border's colour for it. At first, the colour of the game's own cast bar art."] =
    "El color del borde para él. Al principio, el color del arte de la barra de lanzamiento del juego."
L["Turn all on"] = "Encender todas"
L["Uninterruptible"] = "No interrumpible"
L["What it is"] = "Qué es"
L["Whether it shows beside the party frame."] = "Si se muestra junto al marco de grupo."
L["— (no list of spells)"] = "— (sin lista de hechizos)"
L["— (the game does not allow it)"] = "— (el juego no lo permite)"
L["Debuffs"] = "Perjuicios"
L["Alerts"] = "Alertas"
L["Beside the party frame"] = "Junto al marco de grupo"
L["Alerts on the screen"] = "Alertas en pantalla"
L["What to do"] = "Qué hacer"
L["an enemy casting"] = "enemigo lanzando"
L["an enemy channelling"] = "enemigo canalizando"
L["cannot be interrupted"] = "no interrumpible"
L["from a boss or a mechanic"] = "de jefe o mecánica"
L["can be removed"] = "se puede quitar"
L["you can remove it"] = "lo quitas tú"
L["interrupt"] = "interrumpir"
L["defensive and heal"] = "defensiva y sanación"
L["remove"] = "quitar"
L["no dispel type"] = "sin tipo de disipación"
L["free it"] = "liberar"
L["Frees a teammate:"] = "Libera a un aliado:"
L["Frees only themselves:"] = "Solo se libera a sí mismo:"
L["Without the talent, the class does not have the spell. The icon uses the game's crowd control filter: a stun or a fear without a type can show in it too."] = "Sin el talento, la clase no tiene el hechizo. El ícono usa el filtro de control de masas del juego: también puede aparecer un aturdimiento o un miedo sin tipo."
L["The border's colour for it. At first, a light blue: the game has no colour for it."] = "El color del borde. Al principio, un azul claro: el juego no tiene color para esto."
L["No class removes it: a boss's or a mechanic's debuff. Defensive and heal."] =
    "Ninguna clase lo quita: es un perjuicio de jefe o de mecánica. Defensiva y sanación."
L["No class spell in the game's tables removes it."] = "Ningún hechizo de clase de las tablas del juego lo quita."
L["Without the specialization or the talent, the class does not have the spell."] =
    "Sin la especialización o el talento, la clase no tiene el hechizo."

L["Example"] = "Ejemplo"
L["Party frame"] = "Marco de grupo"
L["Casting"] = "Lanzando"
L["Channelling"] = "Canalizando"
L["Left: defensives and bursts (lit = on; dark with a sweep = recharging)."] =
    "Izquierda: defensivas y burst (iluminado = activo; oscuro con barrido = recargando)."
L["Right: the cast coming | what you remove | the boss's or the role's."] =
    "Derecha: el lanzamiento que viene | lo que quitas | el del jefe o de la función."
L["The cast: the border fills, the time in the middle."] =
    "El lanzamiento: el borde se llena, el tiempo en el centro."
L["the type's symbol (the game's)"] = "símbolo del tipo (el del juego)"
L["the stacks (above 1)"] = "acumulaciones (más de 1)"
L["the type's letters (the game's)"] = "letras del tipo (las del juego)"
L["the border: the type's colour, emptying"] = "borde: el color del tipo, vaciándose"
L["the time left"] = "tiempo restante"

L["Plates"] = "Placas"
L["The tabs"] = "Las pestañas"
L["Each tab shows one part, with its example on top: the enemy plates, the threat, the party frame, the debuffs and the alerts."] =
    "Cada pestaña muestra una parte, con su ejemplo arriba: las placas enemigas, la amenaza, el marco de grupo, los perjuicios y las alertas."
L["Using another nameplate addon? Turn off \"Mark whoever is casting\": the Radar then touches no plate."] =
    "¿Usas otro addon de placas de nombre? Apaga \"Marcar a quien está lanzando\": así el Radar no toca ninguna placa."
L["Yours use the game's exact recharge. A teammate who deals damage shows up after the inspection, out of combat; a tank and a healer, at once."] =
    "Los tuyos usan la recarga exacta del juego. Un compañero de daño aparece tras la inspección, fuera de combate; un tanque y un sanador, al momento."
L["Nothing goes on the game's frame. The cast is exact for you; for the others it is still a test. Types and colours: the \"Debuffs\" tab; warnings: the \"Alerts\" tab."] =
    "Nada se pone encima del marco del juego. El lanzamiento es exacto para ti; para los demás aún es una prueba. Tipos y colores: pestaña \"Perjuicios\"; avisos: pestaña \"Alertas\"."
L["Colour: a click picks one, a right click goes back to the game's. The symbol and the letters are the game's own."] =
    "Color: un clic elige uno, un clic derecho vuelve al del juego. El símbolo y las letras son los del juego."
L["The line stays while the debuff lasts. The sound plays only for the season's debuffs the game's tables list. Every alert starts off."] =
    "La línea se queda mientras dura el perjuicio. El sonido solo suena con los perjuicios de la temporada que figuran en las tablas del juego. Todas las alertas empiezan apagadas."
L["casting: the outline fills in the cast's colour, in front of the other plates"] =
    "lanzando: el contorno se llena del color del lanzamiento, por delante de las demás placas"
L["channelling: the game's green art, emptying"] = "canalizando: el arte verde del juego, vaciándose"
L["cannot be interrupted: the game's grey (an option, off at first)"] =
    "no interrumpible: el gris del juego (opción, apagada al principio)"
L["Not casting"] = "Sin lanzamiento"
L["not casting: the game's plate, nothing of ours"] = "sin lanzamiento: la placa del juego, nada nuestro"
L["The cast bar under the health is the game's own: the Radar only adds the outline."] =
    "La barra de lanzamiento bajo la salud es la del juego: el Radar solo añade el contorno."
L["Playing a tank"] = "Jugando de tanque"
L["Playing damage or healer (in a group)"] = "Jugando de daño o sanador (en grupo)"
L["Mob"] = "Enemigo"
L["green: the mob is with you and safe"] = "verde: el enemigo está seguro contigo"
L["orange: with you, about to be lost"] = "naranja: contigo, a punto de perderlo"
L["red and blinking: loose, with the name of who took it"] =
    "rojo parpadeando: suelto, con el nombre de quien lo tomó"
L["white: with the other tank"] = "blanco: con el otro tanque"
L["red: the mob turned to you"] = "rojo: el enemigo se ha vuelto hacia ti"
L["Safe with you"] = "Seguro contigo"
L["About to be lost"] = "A punto de perderlo"
L["Loose (or turned to you)"] = "Suelto (o vuelto hacia ti)"
L["With the other tank"] = "Con el otro tanque"
L["The shield's colour in this state. At first, the game's own."] =
    "El color del escudo en este estado. Al principio, el del juego."

L["Follows your specialization: a tank specialization plays as tank, any other as damage or healer."] =
    "Sigue tu especialización: una especialización de tanque juega como tanque; cualquier otra, como daño o sanador."
L["The shield beside every enemy plate says who holds it: green, safe with you; orange, about to be lost; red and blinking, loose, with the name of who took it; white, with the other tank."] =
    "El escudo junto a cada placa enemiga dice con quién está: verde, seguro contigo; naranja, a punto de perderlo; rojo parpadeando, suelto, con el nombre de quien lo tomó; blanco, con el otro tanque."
L["The shield shows only when an enemy turns to you (in a group): red, so you step back or use a defensive."] =
    "El escudo solo aparece cuando un enemigo se vuelve hacia ti (en grupo): rojo, para que te apartes o uses una defensiva."
L["casting: the outline fills in the cast's colour"] = "lanzando: el contorno se llena de su color"
L["uninterruptible: the game's grey (an option)"] = "no interrumpible: el gris del juego (opción)"
L["green: safe with you"] = "verde: seguro contigo"
L["red and blinking: loose, with who took it"] = "rojo parpadeando: suelto, con quien lo tomó"
L["Left: defensives and bursts (lit = on; dark with a sweep = recharging). Right: the cast coming | what you remove | the boss's."] =
    "Izquierda: defensivas y burst (iluminado = activo; oscuro con barrido = recargando). Derecha: el lanzamiento que viene | lo que quitas | el del jefe."
