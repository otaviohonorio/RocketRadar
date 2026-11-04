-- RocketRadar | Locales/ptBR.lua
local ADDON, ns = ...

if GetLocale() ~= "ptBR" then return end

local L = ns.L

L["Play as"] = "Jogar como"
L["Automatic"] = "Automático"
L["Damage or healer"] = "Dano ou cura"
L["Tank"] = "Tanque"
L["Automatic follows your specialization: a tank spec uses the tank markers."] =
    "Automático segue a sua especialização: especialização de tanque usa as marcas de tanque."

L["On every cast that can be interrupted. The outline of the health bar takes the cast's colour and fills up with it, in front of the other plates."] =
    "Em toda conjuração que puder ser interrompida. O contorno da barra de vida ganha a cor da conjuração e se enche junto com ela, à frente das outras placas."
L["Which casts"] = "Quais conjurações"
L["Important only"] = "Só as importantes"
L["All"] = "Todas"
L["Important: only what the game itself marks as important. In a key the addon cannot read the spell, so it cannot have a list of its own."] =
    "Importantes: só o que o próprio jogo marca como importante. Numa chave o addon não consegue ler a magia, então não pode ter uma lista própria."
L["Spread enemy plates (game option)"] = "Separar as placas inimigas"
L["The game's own setting. Plates push each other apart, so two bars rarely cover one another."] =
    "É uma opção do próprio jogo. As placas se afastam umas das outras, então dificilmente uma barra cobre outra."
L["This option cannot change in combat."] = "Esta opção não pode ser mudada em combate."

L["Show who holds each mob"] = "Com quem está cada inimigo"
L["Tank: green is yours and safe, orange is yours about to be lost, red is loose, white is with another tank. Damage and healers: red when a mob turned to you."] =
    "Tanque: verde está seguro com você, laranja está com você por pouco, vermelho está solto e branco está com outro tanque. Dano e cura: vermelho quando um inimigo se voltou para você."
L["Name who holds the mob"] = "Nome de quem está com ele"
L["Beside the marker of a mob you do not hold, in the class colour."] =
    "Ao lado da marca do inimigo que não está com você, na cor da classe."

L["Test on my target"] = "Testar no meu alvo"
L["Shows the mark on the health bar of your current target for a few seconds."] =
    "Mostra a marca na barra de vida do seu alvo por alguns segundos."
L["Target an enemy with a visible nameplate first."] = "Primeiro escolha como alvo um inimigo com a placa visível."

L["Report a problem"] = "Relatar um problema"
L["Report a problem on"] = "Relatar um problema em"
L["Click: choose where to report a problem"] = "Clique: escolher onde relatar um problema"
L["Link copied — paste it in your browser."] = "Endereço copiado: cole no navegador."
L["Rocket Radar %s — report a problem on %s.|n|nPress Ctrl+C to copy the link, then paste it in your browser. Say what you were doing and what happened."] =
    "Rocket Radar %s: relatar um problema em %s.|n|nAperte Ctrl+C para copiar o endereço e cole no navegador. Conte o que você estava fazendo e o que aconteceu."

-- The group section of the options, and the spells of the group (development only for now).
L["Beside each party frame, the major defensives and the burst of each member: lit while active, dark while recharging."] =
    "Ao lado do quadro de cada membro do grupo, os defensivos grandes e o burst de cada um: acesos enquanto ativos, escuros enquanto recarregam."
L["Show mine too"] = "Mostrar os meus também"
L["Your own icons beside your frame, with the game's exact recharge."] =
    "Os seus ícones ao lado do seu quadro, com a recarga exata do jogo."
L["Icon size"] = "Tamanho dos ícones"
L["How large the icons are."] = "O tamanho dos ícones."
L["Icons per row"] = "Ícones por linha"
L["After this many, a new row starts; the block stays centred on the frame."] =
    "Passando desse número, começa outra linha; o bloco continua centrado no quadro."
L["Choose the spells"] = "Escolher as magias"
L["Which spells each specialization shows. Everything is checked at first."] =
    "Quais magias cada especialização mostra. De início, todas vêm marcadas."
L["Spells of the group"] = "Magias do grupo"
L["Automatic screenshots: on."] = "Prints automáticos: ligados."
L["Automatic screenshots: off."] = "Prints automáticos: desligados."
L["Minimap button"] = "Botão no minimapa"
L["The button opens this window with a click. Its tooltip shows who the markers are drawn for."] =
    "O botão abre esta janela com um clique. O balão dele mostra para quem as marcas são desenhadas."
L["Click: open the options"] = "Clique: abrir as opções"

-- Party defensives and bursts (development only).
L["Group icons: %d (%d frames found). Reads %d, hidden %d; errors %d."] =
    "Ícones do grupo: %d (%d quadros achados). Leituras %d, escondidas %d; erros %d."
L["The group frames are not on screen: the cast mark shows on them in a group."] =
    "Os quadros do grupo não estão na tela: a marca da conjuração aparece neles quando você está em grupo."
L["The game did not offer the aura container: the sensor cannot work."] =
    "O jogo não ofereceu o contêiner de auras: o sensor não funciona."

-- (03/11/2026) Liga/desliga, animação e cor de cada marca; penalidades dissipáveis ("dissipar" é a palavra do jogo em
-- português: "Exibir somente penalidades dissipáveis", DISPLAY_ONLY_DISPELLABLE_DEBUFFS).
L["Click: choose a colour"] = "Clique: escolher a cor"
L["Filling"] = "Enchendo"
L["Full"] = "Cheia"
L["Pulsing"] = "Pulsando"
L["Filling: the line fills as the cast goes on, like the game's cast bar. Full: the whole line at once. Pulsing: the whole line, breathing."] =
    "Enchendo: a linha se enche junto com a conjuração, como a barra de conjuração do jogo. Cheia: a linha inteira de uma vez. Pulsando: a linha inteira, pulsando de leve."
L["Cast colour"] = "Cor da conjuração"
L["A cast that can be interrupted. At first, the game's cast bar art itself."] =
    "Conjuração que pode ser interrompida. De início, a própria arte da barra de conjuração do jogo."
L["Channel colour"] = "Cor da canalização"
L["A channel that can be interrupted. At first, the game's channel art."] =
    "Canalização que pode ser interrompida. De início, a arte de canalização do jogo."
L["Uninterruptible colour"] = "Cor da não interrompível"
L["A cast that cannot be interrupted. At first, the game's grey for it."] =
    "Conjuração que não pode ser interrompida. De início, o cinza que o jogo usa para ela."
L["Defensives and bursts"] = "Defensivos e bursts"
L["Enemy plates"] = "Placas de identificação de inimigos"
L["Mark whoever is casting"] = "Marcar quem está conjurando"
L["Also the uninterruptible"] = "Também as não interrompíveis"
L["A cast that cannot be interrupted is marked too, in its own colour. Off: only what can be interrupted."] =
    "A conjuração que não pode ser interrompida também é marcada, na cor dela. Desligado: só o que pode ser interrompido."
L["Animation"] = "Animação"
L["Which debuffs"] = "Quais penalidades"
L["What I can remove: only the types your specialization removes. All: every debuff that has a type, whoever can remove it."] =
    "O que eu removo: só os tipos que a sua especialização remove. Todas: toda penalidade que tem tipo, seja quem for que a remova."
L["What I can remove"] = "O que eu removo"

-- (04/11/2026) the party frame's left and right, the debuff types and the alerts
L["General"] = "Geral"
L["Party frame: left"] = "Quadro do grupo: esquerda"
L["Party frame: right"] = "Quadro do grupo: direita"
L["Debuffs that come off"] = "Penalidades que saem"
L["After the cast, each debuff that can be removed: its own icon, a border in its type's colour that empties with the time left, and in its corners the type's symbol and letters, the time and the stacks. The game itself reads the debuff: it works in a fight and in a key."] =
    "Depois da conjuração, cada penalidade que pode ser removida: o ícone dela, um contorno na cor do tipo que se esvazia com o tempo que falta e, nos cantos, o símbolo e a sigla do tipo, o tempo e os acúmulos. Quem lê a penalidade é o próprio jogo: funciona em combate e em chave."
L["Type"] = "Tipo"
L["Colour"] = "Cor"
L["Alert"] = "Aviso"
L["Sound"] = "Som"
L["Off"] = "Desligado"
L["On you"] = "Só em você"
L["Whole group"] = "Grupo todo"
L["Boss or role debuff"] = "Chefe ou função"
L["Listen"] = "Ouvir"
L["Sound channel"] = "Canal do som"
L["The game's volume the alerts' sounds follow."] = "O volume do jogo que os sons dos avisos seguem."
L["The border's colour for this type. At first, the game's own colour for it."] =
    "A cor do contorno para este tipo. De início, a cor do próprio jogo."
L["The border's colour for it. At first, the game's red for a debuff without a type."] =
    "A cor do contorno para ela. De início, o vermelho do jogo para penalidade sem tipo."
L["A line at the top of the screen while the debuff lasts: its icon, its type, the spell and who has it, in the class colour. On you: only when it is on you."] =
    "Uma linha no alto da tela enquanto a penalidade durar: o ícone, o tipo, a magia e quem está com ela, na cor da classe. Só em você: só quando estiver em você."
L["Played when the debuff lands, on the alert's members. The game plays it only for the season's debuffs of this type that the game's tables list: one missing from them shows its line without the sound."] =
    "Toca quando a penalidade pega, nos integrantes do aviso. O jogo só toca nas penalidades deste tipo da temporada que as tabelas do jogo listam: a que não estiver nelas mostra a linha sem o som."
L["The game plays an alert's sound only for exact spells, and a boss's debuff has no type to list them by: this alert is the text only."] =
    "O jogo só toca o som de um aviso para magias exatas, e a penalidade de chefe não tem tipo por onde listá-las: este aviso é só o texto."
L["Voice: \"Dispel\""] = "Voz: \"Dispel\""
L["Voice: \"Magic\""] = "Voz: \"Magic\""
L["Voice: \"Curse\""] = "Voz: \"Curse\""
L["Voice: \"Poison\""] = "Voz: \"Poison\""
L["Voice: \"Disease\""] = "Voz: \"Disease\""
L["Voice: \"Bleed\""] = "Voz: \"Bleed\""
L["Voice: \"Debuff\""] = "Voz: \"Debuff\""
L["Raid warning"] = "Aviso de raide"
L["Boss warning"] = "Aviso de chefe"
L["Ready check"] = "Todos prontos?"
L["Alarm clock 1"] = "Despertador 1"
L["Alarm clock 2"] = "Despertador 2"
L["Alarm clock 3"] = "Despertador 3"
L["Battle.net toast"] = "Aviso do Battle.net"
L["Magic: dispel"] = "Magia: dissipar"
L["Magic: arcane burst"] = "Magia: explosão arcana"
L["Magic: arcane charge"] = "Magia: carga arcana"
L["Magic: arcane cast"] = "Magia: conjuração arcana"
L["Curse 1"] = "Maldição 1"
L["Curse 2"] = "Maldição 2"
L["Curse: shadow 1"] = "Maldição: sombra 1"
L["Curse: shadow 2"] = "Maldição: sombra 2"
L["Poison 1"] = "Veneno 1"
L["Poison 2"] = "Veneno 2"
L["Poison: spores 1"] = "Veneno: esporos 1"
L["Poison: spores 2"] = "Veneno: esporos 2"
L["Disease 1"] = "Doença 1"
L["Disease: plague 1"] = "Doença: peste 1"
L["Disease: plague 2"] = "Doença: peste 2"
L["Bleed 1"] = "Sangramento 1"
L["Bleed 2"] = "Sangramento 2"
L["Bleed 3"] = "Sangramento 3"
L["Bleed 4"] = "Sangramento 4"
L["Boss defeated"] = "Chefe derrotado"
L["Countdown end"] = "Fim da contagem"
L["Right click: the game's colour"] = "Clique direito: voltar à cor do jogo"
L["Party"] = "Grupo"

-- (04/11/2026) the window in tabs, faithful to the preview, with the notes
L["Profile"] = "Perfil"
L["Threat"] = "Ameaça"
L["A line at the top of the screen while an enemy casts at you: the spell's icon and name. Only on you: the game tells whom a cast goes to only for you."] =
    "Uma linha no alto da tela enquanto um inimigo conjura em você: o ícone e o nome da magia. Só em você: o jogo só diz para quem vai uma conjuração quando é você."
L["Alerts: all"] = "Avisos: todos"
L["Cast"] = "Conjuração"
L["Cast animation"] = "Animação da conjuração"
L["Cast at you"] = "Conjuração em você ·"
L["Channel"] = "Canalização"
L["Every row of the table, shown or not beside the party frame."] =
    "Todas as linhas da tabela, exibidas ou não ao lado do quadro do grupo."
L["Icon"] = "Ícone"
L["Letters"] = "Sigla"
L["On"] = "Ligado"
L["Sets the alert of every row at once. The casts take \"On you\" (the game tells whom a cast goes to only for you)."] =
    "Muda o aviso de todas as linhas de uma vez. As conjurações ficam em \"Só em você\" (o jogo só diz para quem vai uma conjuração quando é você)."
L["The game does not let an addon play a sound for a cast at you: what is secret in a fight cannot start a sound."] =
    "O jogo não deixa um addon tocar som para uma conjuração em você: o que é dado bloqueado pela Blizzard em combate não pode disparar um som."
L["The border's colour for it. At first, the colour of the game's own cast bar art."] =
    "A cor do contorno para ela. De início, a cor da arte da barra de conjuração do jogo."
L["Turn all on"] = "Ligar todos"
L["Uninterruptible"] = "Não interrompível"
L["What it is"] = "O que é"
L["Whether it shows beside the party frame."] = "Se aparece ao lado do quadro do grupo."
L["— (no list of spells)"] = "— (sem lista de magias)"
L["— (the game does not allow it)"] = "— (o jogo não deixa)"
L["Debuffs"] = "Penalidades"
L["Alerts"] = "Avisos"
L["Beside the party frame"] = "Ao lado do quadro do grupo"
L["Alerts on the screen"] = "Avisos na tela"
L["What to do"] = "O que fazer"
L["an enemy casting"] = "inimigo conjurando"
L["an enemy channelling"] = "inimigo canalizando"
L["cannot be interrupted"] = "não dá para interromper"
L["from a boss or a mechanic"] = "de chefe ou de mecânica"
L["can be removed"] = "removível"
L["you can remove it"] = "removível por você"
L["interrupt"] = "interromper"
L["defensive and heal"] = "defensivo e cura"
L["remove"] = "remover"
L["no dispel type"] = "sem tipo de dispel"
L["free it"] = "libertar"
L["Frees a teammate:"] = "Liberta um aliado:"
L["Frees only themselves:"] = "Liberta só a si mesmo:"
L["Without the talent, the class does not have the spell. The icon uses the game's crowd control filter: a stun or a fear without a type can show in it too."] = "Sem o talento, a classe não tem a magia. O ícone usa o filtro de controle de grupo do jogo: um atordoamento ou um medo sem tipo também pode aparecer nele."
L["The border's colour for it. At first, a light blue: the game has no colour for it."] = "A cor da borda dele. De início, um azul claro: o jogo não tem cor para ele."
L["No class removes it: a boss's or a mechanic's debuff. Defensive and heal."] =
    "Nenhuma classe remove: é penalidade de chefe ou de mecânica. Defensivo e cura."
L["No class spell in the game's tables removes it."] = "Nenhuma magia de classe nas tabelas do jogo remove."
L["Without the specialization or the talent, the class does not have the spell."] =
    "Sem a especialização ou o talento, a classe não tem a magia."

-- (04/11/2026) the examples at the top of each tab (Examples.lua)
L["Example"] = "Exemplo"
L["Party frame"] = "Quadro do grupo"
L["Casting"] = "Conjurando"
L["Channelling"] = "Canalizando"
L["Left: defensives and bursts (lit = on; dark with a sweep = recharging)."] =
    "À esquerda: defensivos e bursts (aceso = ativo; escuro com giro = em recarga)."
L["Right: the cast coming | what you remove | the boss's or the role's."] =
    "À direita: a conjuração que vem | o que você remove | a do chefe ou da função."
L["The cast: the border fills, the time in the middle."] = "A conjuração: o contorno se preenche, o tempo no meio."
L["the type's symbol (the game's)"] = "símbolo do tipo (o do jogo)"
L["the stacks (above 1)"] = "acúmulos (acima de 1)"
L["the type's letters (the game's)"] = "sigla do tipo (a do jogo)"
L["the border: the type's colour, emptying"] = "contorno: a cor do tipo, se esvaziando"
L["the time left"] = "tempo que falta"

-- (04/11/2026) one tab per feature, the threat's palette
L["Plates"] = "Placas"
L["The tabs"] = "As abas"
L["Each tab shows one part, with its example on top: the enemy plates, the threat, the party frame, the debuffs and the alerts."] =
    "Cada aba mostra uma parte, com o exemplo em cima: as placas inimigas, a ameaça, o quadro do grupo, as penalidades e os avisos."
L["Using another nameplate addon? Turn off \"Mark whoever is casting\": the Radar then touches no plate."] =
    "Usa outro addon de placas? Desligue \"Marcar quem está conjurando\": o Radar não toca em placa nenhuma."
L["Yours use the game's exact recharge. A teammate who deals damage shows up after the inspection, out of combat; a tank and a healer, at once."] =
    "Os seus usam a recarga exata do jogo. Colega de dano aparece depois da inspeção, fora de combate; tanque e curador, na hora."
L["Nothing goes on the game's frame. The cast is exact for you; for the others it is still a test. Types and colours: the \"Debuffs\" tab; warnings: the \"Alerts\" tab."] =
    "Nada vai em cima do quadro do jogo. A conjuração é exata para você; para os outros ainda é um teste. Tipos e cores: aba \"Penalidades\"; avisos: aba \"Avisos\"."
L["Colour: a click picks one, a right click goes back to the game's. The symbol and the letters are the game's own."] =
    "Cor: o clique escolhe, o clique direito volta à do jogo. O símbolo e a sigla são os do jogo."
L["The line stays while the debuff lasts. The sound plays only for the season's debuffs the game's tables list. Every alert starts off."] =
    "A linha fica enquanto a penalidade durar. O som toca só nas penalidades da temporada que as tabelas do jogo listam. Todo aviso começa desligado."
L["casting: the outline fills in the cast's colour, in front of the other plates"] = "conjurando: o contorno se enche na cor da conjuração, à frente das outras placas"
L["channelling: the game's green art, emptying"] = "canalizando: a arte verde do jogo, esvaziando"
L["cannot be interrupted: the game's grey (an option, off at first)"] = "não dá para interromper: o cinza do jogo (opção, desligada de início)"
L["Not casting"] = "Sem conjuração"
L["not casting: the game's plate, nothing of ours"] = "sem conjuração: a placa do jogo, nada nosso"
L["The cast bar under the health is the game's own: the Radar only adds the outline."] = "A barra de conjuração embaixo da vida é a do jogo: o Radar só acrescenta o contorno."
L["Playing a tank"] = "Jogando de tanque"
L["Playing damage or healer (in a group)"] = "Jogando de dano ou cura (em grupo)"
L["Mob"] = "Inimigo"
L["green: the mob is with you and safe"] = "verde: o inimigo está seguro com você"
L["orange: with you, about to be lost"] = "laranja: está com você, prestes a perder"
L["red and blinking: loose, with the name of who took it"] = "vermelho piscando: solto, com o nome de quem pegou"
L["white: with the other tank"] = "branco: com o outro tanque"
L["red: the mob turned to you"] = "vermelho: o inimigo virou para você"
L["Safe with you"] = "Seguro com você"
L["About to be lost"] = "Prestes a perder"
L["Loose (or turned to you)"] = "Solto (ou virou para você)"
L["With the other tank"] = "Com o outro tanque"
L["The shield's colour in this state. At first, the game's own."] = "A cor do escudo neste estado. De início, a do jogo."

-- (04/11/2026) the "?" of "Play as"
L["Follows your specialization: a tank specialization plays as tank, any other as damage or healer."] =
    "Segue a sua especialização: especialização de tanque joga como tanque; qualquer outra, como dano ou cura."
L["The shield beside every enemy plate says who holds it: green, safe with you; orange, about to be lost; red and blinking, loose, with the name of who took it; white, with the other tank."] =
    "O escudo ao lado de cada placa inimiga diz com quem está o inimigo: verde, seguro com você; laranja, prestes a perder; vermelho piscando, solto, com o nome de quem pegou; branco, com o outro tanque."
L["The shield shows only when an enemy turns to you (in a group): red, so you step back or use a defensive."] =
    "O escudo só aparece quando um inimigo vira para você (em grupo): vermelho, para você se afastar ou usar um defensivo."
-- (04/11/2026) the General example as the preview
L["casting: the outline fills in the cast's colour"] = "conjurando: o contorno enche na cor da conjuração"
L["uninterruptible: the game's grey (an option)"] = "não interrompível: o cinza do jogo (opção)"
L["green: safe with you"] = "verde: seguro com você"
L["red and blinking: loose, with who took it"] = "vermelho piscando: solto, com quem pegou"
L["Left: defensives and bursts (lit = on; dark with a sweep = recharging). Right: the cast coming | what you remove | the boss's."] =
    "À esquerda: defensivos e bursts (aceso = ativo; escuro com giro = em recarga). À direita: a conjuração que vem | o que você remove | a do chefe."
