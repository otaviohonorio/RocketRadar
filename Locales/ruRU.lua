-- RocketRadar | Locales/ruRU.lua
-- (04/11/2026) The player's language when the game runs in ruRU. A key absent here falls to the key itself, the English
-- text. Translated without a native speaker's review yet: the game's own terms come from its tables for this language
-- (GlobalStrings.ruRU).
local ADDON, ns = ...

if GetLocale() ~= "ruRU" then return end

local L = ns.L

L["Play as"] = "Играть как"
L["Automatic"] = "Автоматически"
L["Damage or healer"] = "Боец или лекарь"
L["Tank"] = "Танк"
L["Automatic follows your specialization: a tank spec uses the tank markers."] =
    "Автоматически — по вашей специализации: у специализации танка метки танка."

L["On every cast that can be interrupted. The outline of the health bar takes the cast's colour and fills up with it, in front of the other plates."] =
    "При каждом прерываемом применении. Контур шкалы здоровья принимает цвет применения и заполняется вместе с ним, поверх других индикаторов."
L["Which casts"] = "Какие применения"
L["Important only"] = "Только важные"
L["All"] = "Все"
L["Important: only what the game itself marks as important. In a key the addon cannot read the spell, so it cannot have a list of its own."] =
    "Важные: только то, что сама игра отмечает как важное. В ключе аддон не может прочитать заклинание, поэтому своего списка у него быть не может."
L["Spread enemy plates (game option)"] = "Разносить индикаторы противников"
L["The game's own setting. Plates push each other apart, so two bars rarely cover one another."] =
    "Это параметр самой игры. Индикаторы расходятся друг от друга, поэтому одна полоса редко закрывает другую."
L["This option cannot change in combat."] = "Этот параметр нельзя менять в бою."

L["Show who holds each mob"] = "У кого какой противник"
L["Tank: green is yours and safe, orange is yours about to be lost, red is loose, white is with another tank. Damage and healers: red when a mob turned to you."] =
    "Танк: зелёный — надёжно у вас, оранжевый — у вас, но вот-вот уйдёт, красный — сорвался, белый — у другого танка. Бойцы и лекари: красный, когда противник повернулся к вам."
L["Name who holds the mob"] = "Имя того, у кого противник"
L["Beside the marker of a mob you do not hold, in the class colour."] =
    "Рядом с меткой противника, который не у вас, цветом класса."

L["Test on my target"] = "Проверить на цели"
L["Shows the mark on the health bar of your current target for a few seconds."] =
    "Показывает метку на шкале здоровья текущей цели на несколько секунд."
L["Target an enemy with a visible nameplate first."] =
    "Сначала выберите целью противника с видимым индикатором здоровья."

L["Report a problem"] = "Сообщить о проблеме"
L["Report a problem on"] = "Сообщить о проблеме на"
L["Click: choose where to report a problem"] = "Нажмите: выбрать, где сообщить о проблеме"
L["Link copied — paste it in your browser."] = "Ссылка скопирована — вставьте её в браузер."
L["Rocket Radar %s — report a problem on %s.|n|nPress Ctrl+C to copy the link, then paste it in your browser. Say what you were doing and what happened."] =
    "Rocket Radar %s — сообщить о проблеме на %s.|n|nНажмите Ctrl+C, чтобы скопировать ссылку, и вставьте её в браузер. Расскажите, что вы делали и что произошло."

L["Beside each party frame, the major defensives and the burst of each member: lit while active, dark while recharging."] =
    "Рядом с рамкой каждого участника группы — его важные защитные способности и бурст: светятся, пока активны, и темнеют на время восстановления."
L["Show mine too"] = "Показывать и мои"
L["Your own icons beside your frame, with the game's exact recharge."] =
    "Ваши значки рядом с вашей рамкой, с точным восстановлением из игры."
L["Icon size"] = "Размер значков"
L["How large the icons are."] = "Насколько велики значки."
L["Icons per row"] = "Значков в ряду"
L["After this many, a new row starts; the block stays centred on the frame."] =
    "После этого числа начинается новый ряд; блок остаётся по центру рамки."
L["Choose the spells"] = "Выбрать заклинания"
L["Which spells each specialization shows. Everything is checked at first."] =
    "Какие заклинания показывает каждая специализация. Сначала отмечены все."
L["Spells of the group"] = "Заклинания группы"
L["Automatic screenshots: on."] = "Автоматические снимки экрана: вкл."
L["Automatic screenshots: off."] = "Автоматические снимки экрана: откл."
L["Minimap button"] = "Кнопка у мини-карты"
L["The button opens this window with a click. Its tooltip shows who the markers are drawn for."] =
    "Кнопка открывает это окно щелчком. Её подсказка показывает, для кого рисуются метки."
L["Click: open the options"] = "Нажмите: открыть параметры"

L["Group icons: %d (%d frames found). Reads %d, hidden %d; errors %d."] =
    "Значки группы: %d (найдено рамок: %d). Чтений %d, скрыто %d; ошибок %d."
L["The group frames are not on screen: the cast mark shows on them in a group."] =
    "Рамок группы нет на экране: метка применения появляется на них, когда вы в группе."
L["The game did not offer the aura container: the sensor cannot work."] =
    "Игра не предоставила контейнер аур: датчик не может работать."

L["Click: choose a colour"] = "Нажмите: выбрать цвет"
L["Filling"] = "Заполнение"
L["Full"] = "Целиком"
L["Pulsing"] = "Пульсация"
L["Filling: the line fills as the cast goes on, like the game's cast bar. Full: the whole line at once. Pulsing: the whole line, breathing."] =
    "Заполнение: линия заполняется по ходу применения, как индикатор заклинаний игры. Целиком: вся линия сразу. Пульсация: вся линия, мягко пульсируя."
L["Cast colour"] = "Цвет применения"
L["A cast that can be interrupted. At first, the game's cast bar art itself."] =
    "Прерываемое применение. Изначально — оформление индикатора заклинаний самой игры."
L["Channel colour"] = "Цвет поддержания"
L["A channel that can be interrupted. At first, the game's channel art."] =
    "Прерываемое поддерживаемое заклинание. Изначально — оформление поддержания из игры."
L["Uninterruptible colour"] = "Цвет непрерываемого"
L["A cast that cannot be interrupted. At first, the game's grey for it."] =
    "Применение, которое нельзя прервать. Изначально — серый цвет, который для него использует игра."
L["Defensives and bursts"] = "Защитные и бурсты"
L["Enemy plates"] = "Индикаторы здоровья противников"
L["Mark whoever is casting"] = "Отмечать применяющих"
L["Also the uninterruptible"] = "И непрерываемые"
L["A cast that cannot be interrupted is marked too, in its own colour. Off: only what can be interrupted."] =
    "Применение, которое нельзя прервать, тоже отмечается, своим цветом. Откл.: только то, что можно прервать."
L["Animation"] = "Анимация"
L["Which debuffs"] = "Какие отриц. эффекты"
L["What I can remove: only the types your specialization removes. All: every debuff that has a type, whoever can remove it."] =
    "Что снимаю я: только типы, которые снимает ваша специализация. Все: любой отрицательный эффект с типом, кто бы его ни снимал."
L["What I can remove"] = "Что снимаю я"

L["General"] = "Общий"
L["Party frame: left"] = "Рамка группы: слева"
L["Party frame: right"] = "Рамка группы: справа"
L["Debuffs that come off"] = "Снимаемые отриц. эффекты"
L["After the cast, each debuff that can be removed: its own icon, a border in its type's colour that empties with the time left, and in its corners the type's symbol and letters, the time and the stacks. The game itself reads the debuff: it works in a fight and in a key."] =
    "После применения — каждый отрицательный эффект, который можно снять: его значок, рамка цвета его типа, убывающая с оставшимся временем, а по углам — символ и буквы типа, время и число наложений. Эффект читает сама игра: это работает и в бою, и в ключе."
L["Type"] = "Тип"
L["Colour"] = "Цвет"
L["Alert"] = "Оповещение"
L["Sound"] = "Звук"
L["Off"] = "Откл."
L["On you"] = "На вас"
L["Whole group"] = "Вся группа"
L["Boss or role debuff"] = "Босс или роль"
L["Listen"] = "Прослушать"
L["Sound channel"] = "Звуковой канал"
L["The game's volume the alerts' sounds follow."] = "Громкость игры, которой следуют звуки оповещений."
L["The border's colour for this type. At first, the game's own colour for it."] =
    "Цвет рамки для этого типа. Изначально — цвет самой игры."
L["The border's colour for it. At first, the game's red for a debuff without a type."] =
    "Цвет рамки для него. Изначально — красный цвет игры для отрицательного эффекта без типа."
L["A line at the top of the screen while the debuff lasts: its icon, its type, the spell and who has it, in the class colour. On you: only when it is on you."] =
    "Строка вверху экрана, пока действует отрицательный эффект: его значок, тип, заклинание и на ком он, цветом класса. На вас: только когда он на вас."
L["Played when the debuff lands, on the alert's members. The game plays it only for the season's debuffs of this type that the game's tables list: one missing from them shows its line without the sound."] =
    "Звучит, когда эффект накладывается на тех, кого охватывает оповещение. Игра проигрывает его только для эффектов этого типа текущего сезона из своих таблиц: для отсутствующего в них строка показывается без звука."
L["The game plays an alert's sound only for exact spells, and a boss's debuff has no type to list them by: this alert is the text only."] =
    "Игра проигрывает звук оповещения только для конкретных заклинаний, а у эффекта босса нет типа, по которому их перечислить: это оповещение — только текст."
L["Voice: \"Dispel\""] = "Голос: \"Dispel\""
L["Voice: \"Magic\""] = "Голос: \"Magic\""
L["Voice: \"Curse\""] = "Голос: \"Curse\""
L["Voice: \"Poison\""] = "Голос: \"Poison\""
L["Voice: \"Disease\""] = "Голос: \"Disease\""
L["Voice: \"Bleed\""] = "Голос: \"Bleed\""
L["Voice: \"Debuff\""] = "Голос: \"Debuff\""
L["Raid warning"] = "Объявление рейду"
L["Boss warning"] = "Предупреждение босса"
L["Ready check"] = "Готовность"
L["Alarm clock 1"] = "Будильник 1"
L["Alarm clock 2"] = "Будильник 2"
L["Alarm clock 3"] = "Будильник 3"
L["Battle.net toast"] = "Уведомление Battle.net"
L["Magic: dispel"] = "Магия: рассеивание"
L["Magic: arcane burst"] = "Магия: тайный взрыв"
L["Magic: arcane charge"] = "Магия: тайный заряд"
L["Magic: arcane cast"] = "Магия: тайное применение"
L["Curse 1"] = "Проклятие 1"
L["Curse 2"] = "Проклятие 2"
L["Curse: shadow 1"] = "Проклятие: тьма 1"
L["Curse: shadow 2"] = "Проклятие: тьма 2"
L["Poison 1"] = "Яд 1"
L["Poison 2"] = "Яд 2"
L["Poison: spores 1"] = "Яд: споры 1"
L["Poison: spores 2"] = "Яд: споры 2"
L["Disease 1"] = "Болезнь 1"
L["Disease: plague 1"] = "Болезнь: чума 1"
L["Disease: plague 2"] = "Болезнь: чума 2"
L["Bleed 1"] = "Кровотечение 1"
L["Bleed 2"] = "Кровотечение 2"
L["Bleed 3"] = "Кровотечение 3"
L["Bleed 4"] = "Кровотечение 4"
L["Boss defeated"] = "Босс побежден"
L["Countdown end"] = "Конец отсчета"
L["Right click: the game's colour"] = "ПКМ: вернуть цвет игры"
L["Party"] = "Группа"

L["Profile"] = "Профиль"
L["Threat"] = "Угроза"
L["A line at the top of the screen while an enemy casts at you: the spell's icon and name. Only on you: the game tells whom a cast goes to only for you."] =
    "Строка вверху экрана, пока противник применяет способность на вас: значок и название заклинания. Только на вас: игра сообщает цель применения, только если это вы."
L["Alerts: all"] = "Оповещения: все"
L["Cast"] = "Применение"
L["Cast animation"] = "Анимация применения"
L["Cast at you"] = "Применение на вас ·"
L["Channel"] = "Поддержание"
L["Every row of the table, shown or not beside the party frame."] =
    "Все строки таблицы, показанные или нет рядом с рамкой группы."
L["Icon"] = "Значок"
L["Letters"] = "Буквы"
L["On"] = "Вкл."
L["Sets the alert of every row at once. The casts take \"On you\" (the game tells whom a cast goes to only for you)."] =
    "Меняет оповещение во всех строках сразу. Для применений — \"На вас\" (игра сообщает цель применения, только если это вы)."
L["The game does not let an addon play a sound for a cast at you: what is secret in a fight cannot start a sound."] =
    "Игра не позволяет аддону проигрывать звук при применении на вас: данные, заблокированные Blizzard в бою, не могут запустить звук."
L["The border's colour for it. At first, the colour of the game's own cast bar art."] =
    "Цвет рамки для него. Изначально — цвет оформления индикатора заклинаний самой игры."
L["Turn all on"] = "Включить все"
L["Uninterruptible"] = "Непрерываемое"
L["What it is"] = "Что это"
L["Whether it shows beside the party frame."] = "Показывать ли рядом с рамкой группы."
L["— (no list of spells)"] = "— (нет списка заклинаний)"
L["— (the game does not allow it)"] = "— (игра не позволяет)"
L["Debuffs"] = "Отриц. эффекты"
L["Alerts"] = "Оповещения"
L["Beside the party frame"] = "Рядом с рамкой группы"
L["Alerts on the screen"] = "Оповещения на экране"
L["What to do"] = "Что делать"
L["an enemy casting"] = "противник применяет"
L["an enemy channelling"] = "противник поддерживает"
L["cannot be interrupted"] = "нельзя прервать"
L["from a boss or a mechanic"] = "от босса или механики"
L["can be removed"] = "можно снять"
L["you can remove it"] = "снимаете вы"
L["interrupt"] = "прервать"
L["defensive and heal"] = "защита и лечение"
L["remove"] = "снять"
L["no dispel type"] = "без типа рассеивания"
L["free it"] = "освободить"
L["Frees a teammate:"] = "Освобождает союзника:"
L["Frees only themselves:"] = "Освобождает только себя:"
L["Without the talent, the class does not have the spell. The icon uses the game's crowd control filter: a stun or a fear without a type can show in it too."] = "Без таланта у класса нет этого заклинания. Значок использует фильтр контроля игры: в нём может появиться и оглушение или страх без типа."
L["The border's colour for it. At first, a light blue: the game has no colour for it."] = "Цвет рамки. Сначала голубой: у игры нет для этого цвета."
L["No class removes it: a boss's or a mechanic's debuff. Defensive and heal."] =
    "Ни один класс его не снимает: это эффект босса или механики. Защита и лечение."
L["No class spell in the game's tables removes it."] = "Ни одно классовое заклинание в таблицах игры его не снимает."
L["Without the specialization or the talent, the class does not have the spell."] =
    "Без специализации или таланта у класса нет этого заклинания."

L["Example"] = "Пример"
L["Party frame"] = "Рамка группы"
L["Casting"] = "Применение"
L["Channelling"] = "Поддержание"
L["Left: defensives and bursts (lit = on; dark with a sweep = recharging)."] =
    "Слева: защитные и бурсты (светится = активно; темно с разверткой = восстанавливается)."
L["Right: the cast coming | what you remove | the boss's or the role's."] =
    "Справа: предстоящее применение | что снимаете вы | от босса или для роли."
L["The cast: the border fills, the time in the middle."] = "Применение: рамка заполняется, время в центре."
L["the type's symbol (the game's)"] = "символ типа (из игры)"
L["the stacks (above 1)"] = "наложения (больше 1)"
L["the type's letters (the game's)"] = "буквы типа (из игры)"
L["the border: the type's colour, emptying"] = "рамка: цвет типа, убывает"
L["the time left"] = "оставшееся время"

L["Plates"] = "Индикаторы"
L["The tabs"] = "Вкладки"
L["Each tab shows one part, with its example on top: the enemy plates, the threat, the party frame, the debuffs and the alerts."] =
    "Каждая вкладка показывает одну часть, с примером вверху: индикаторы противников, угрозу, рамку группы, отрицательные эффекты и оповещения."
L["Using another nameplate addon? Turn off \"Mark whoever is casting\": the Radar then touches no plate."] =
    "Используете другой аддон индикаторов? Отключите \"Отмечать применяющих\": тогда Radar не трогает ни один индикатор."
L["Yours use the game's exact recharge. A teammate who deals damage shows up after the inspection, out of combat; a tank and a healer, at once."] =
    "Ваши используют точное восстановление из игры. Союзник-боец появляется после осмотра, вне боя; танк и лекарь — сразу."
L["Nothing goes on the game's frame. The cast is exact for you; for the others it is still a test. Types and colours: the \"Debuffs\" tab; warnings: the \"Alerts\" tab."] =
    "Поверх рамки игры ничего не ставится. Применение точное для вас; для остальных это пока проверка. Типы и цвета: вкладка \"Отриц. эффекты\"; оповещения: вкладка \"Оповещения\"."
L["Colour: a click picks one, a right click goes back to the game's. The symbol and the letters are the game's own."] =
    "Цвет: щелчок выбирает, ПКМ возвращает цвет игры. Символ и буквы — из самой игры."
L["The line stays while the debuff lasts. The sound plays only for the season's debuffs the game's tables list. Every alert starts off."] =
    "Строка держится, пока действует эффект. Звук играет только для эффектов сезона из таблиц игры. Все оповещения изначально отключены."
L["casting: the outline fills in the cast's colour, in front of the other plates"] =
    "применение: контур заполняется цветом применения, поверх других индикаторов"
L["channelling: the game's green art, emptying"] = "поддержание: зелёное оформление игры, убывает"
L["cannot be interrupted: the game's grey (an option, off at first)"] =
    "нельзя прервать: серый цвет игры (параметр, изначально откл.)"
L["Not casting"] = "Без применения"
L["not casting: the game's plate, nothing of ours"] = "без применения: индикатор игры, ничего нашего"
L["The cast bar under the health is the game's own: the Radar only adds the outline."] =
    "Индикатор заклинаний под здоровьем — игровой: Radar только добавляет контур."
L["Playing a tank"] = "Играя танком"
L["Playing damage or healer (in a group)"] = "Играя бойцом или лекарем (в группе)"
L["Mob"] = "Противник"
L["green: the mob is with you and safe"] = "зелёный: противник надёжно у вас"
L["orange: with you, about to be lost"] = "оранжевый: у вас, но вот-вот уйдёт"
L["red and blinking: loose, with the name of who took it"] = "красный мигающий: сорвался, с именем того, кто его взял"
L["white: with the other tank"] = "белый: у другого танка"
L["red: the mob turned to you"] = "красный: противник повернулся к вам"
L["Safe with you"] = "Надёжно у вас"
L["About to be lost"] = "Вот-вот уйдёт"
L["Loose (or turned to you)"] = "Сорвался (или к вам)"
L["With the other tank"] = "У другого танка"
L["The shield's colour in this state. At first, the game's own."] =
    "Цвет щита в этом состоянии. Изначально — цвет игры."

L["Follows your specialization: a tank specialization plays as tank, any other as damage or healer."] =
    "По вашей специализации: специализация танка играет как танк, любая другая — как боец или лекарь."
L["The shield beside every enemy plate says who holds it: green, safe with you; orange, about to be lost; red and blinking, loose, with the name of who took it; white, with the other tank."] =
    "Щит рядом с каждым индикатором противника показывает, у кого он: зелёный — надёжно у вас; оранжевый — вот-вот уйдёт; красный мигающий — сорвался, с именем того, кто его взял; белый — у другого танка."
L["The shield shows only when an enemy turns to you (in a group): red, so you step back or use a defensive."] =
    "Щит появляется, только когда противник поворачивается к вам (в группе): красный — чтобы вы отошли или применили защитную способность."
L["casting: the outline fills in the cast's colour"] = "применение: контур заполняется цветом применения"
L["uninterruptible: the game's grey (an option)"] = "непрерываемое: серый цвет игры (параметр)"
L["green: safe with you"] = "зелёный: надёжно у вас"
L["red and blinking: loose, with who took it"] = "красный мигающий: сорвался, с тем, кто взял"
L["Left: defensives and bursts (lit = on; dark with a sweep = recharging). Right: the cast coming | what you remove | the boss's."] =
    "Слева: защитные и бурсты (светится = активно; темно с разверткой = восстанавливается). Справа: предстоящее применение | что снимаете вы | от босса."
