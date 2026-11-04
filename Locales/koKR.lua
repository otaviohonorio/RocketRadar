-- RocketRadar | Locales/koKR.lua
-- (04/11/2026) The player's language when the game runs in koKR. A key absent here falls to the key itself, the English
-- text. Translated without a native speaker's review yet: the game's own terms come from its tables for this language
-- (GlobalStrings.koKR).
local ADDON, ns = ...

if GetLocale() ~= "koKR" then return end

local L = ns.L

L["Play as"] = "역할"
L["Automatic"] = "자동"
L["Damage or healer"] = "공격 또는 치유 전담"
L["Tank"] = "방어 전담"
L["Automatic follows your specialization: a tank spec uses the tank markers."] =
    "자동은 전문화를 따릅니다: 방어 전담 전문화는 방어 전담 표시를 씁니다."

L["On every cast that can be interrupted. The outline of the health bar takes the cast's colour and fills up with it, in front of the other plates."] =
    "방해 가능한 모든 시전에 표시합니다. 생명력 막대의 외곽선이 시전 색상으로 바뀌어 시전과 함께 차오르며, 다른 이름표보다 앞에 나옵니다."
L["Which casts"] = "표시할 시전"
L["Important only"] = "중요한 시전만"
L["All"] = "전체"
L["Important: only what the game itself marks as important. In a key the addon cannot read the spell, so it cannot have a list of its own."] =
    "중요: 게임이 직접 중요로 표시한 것만. 신화+에서는 애드온이 주문을 읽을 수 없어 자체 목록을 둘 수 없습니다."
L["Spread enemy plates (game option)"] = "적 이름표 상하 정렬 (게임 설정)"
L["The game's own setting. Plates push each other apart, so two bars rarely cover one another."] =
    "게임 자체 설정입니다. 이름표가 서로 밀어내어 막대가 겹치는 일이 거의 없습니다."
L["This option cannot change in combat."] = "이 설정은 전투 중에 바꿀 수 없습니다."

L["Show who holds each mob"] = "각 적을 누가 잡고 있는지 표시"
L["Tank: green is yours and safe, orange is yours about to be lost, red is loose, white is with another tank. Damage and healers: red when a mob turned to you."] =
    "방어 전담: 초록은 내가 안전하게, 주황은 내가 곧 놓침, 빨강은 풀림, 흰색은 다른 방어 전담. 공격·치유 전담: 적이 나를 노리면 빨강."
L["Name who holds the mob"] = "잡고 있는 사람 이름"
L["Beside the marker of a mob you do not hold, in the class colour."] = "내가 잡고 있지 않은 적의 표시 옆에, 직업 색상으로."

L["Test on my target"] = "내 대상에서 시험"
L["Shows the mark on the health bar of your current target for a few seconds."] = "현재 대상의 생명력 막대에 몇 초 동안 표시를 보여 줍니다."
L["Target an enemy with a visible nameplate first."] = "먼저 이름표가 보이는 적을 대상으로 지정하세요."

L["Report a problem"] = "문제 신고"
L["Report a problem on"] = "문제 신고:"
L["Click: choose where to report a problem"] = "클릭: 문제를 신고할 곳을 고릅니다"
L["Link copied — paste it in your browser."] = "링크를 복사했습니다 — 브라우저에 붙여 넣으세요."
L["Rocket Radar %s — report a problem on %s.|n|nPress Ctrl+C to copy the link, then paste it in your browser. Say what you were doing and what happened."] =
    "Rocket Radar %s — %s에 문제 신고.|n|nCtrl+C로 링크를 복사한 뒤 브라우저에 붙여 넣으세요. 무엇을 하던 중 어떤 일이 있었는지 적어 주세요."

L["Beside each party frame, the major defensives and the burst of each member: lit while active, dark while recharging."] =
    "각 파티 개체창 옆에 파티원별 주요 생존기와 폭딜: 활성 중에는 밝게, 재사용 대기 중에는 어둡게."
L["Show mine too"] = "내 것도 표시"
L["Your own icons beside your frame, with the game's exact recharge."] = "내 개체창 옆에 내 아이콘을, 게임의 정확한 재사용 대기시간으로."
L["Icon size"] = "아이콘 크기"
L["How large the icons are."] = "아이콘의 크기입니다."
L["Icons per row"] = "줄당 아이콘 수"
L["After this many, a new row starts; the block stays centred on the frame."] =
    "이 수를 넘으면 새 줄이 시작되며, 묶음은 개체창 가운데에 맞춰집니다."
L["Choose the spells"] = "주문 고르기"
L["Which spells each specialization shows. Everything is checked at first."] = "각 전문화에서 표시할 주문입니다. 처음에는 모두 선택되어 있습니다."
L["Spells of the group"] = "파티 주문"
L["Automatic screenshots: on."] = "자동 스크린샷: 켜짐."
L["Automatic screenshots: off."] = "자동 스크린샷: 꺼짐."
L["Minimap button"] = "미니맵 버튼"
L["The button opens this window with a click. Its tooltip shows who the markers are drawn for."] =
    "버튼을 클릭하면 이 창이 열립니다. 툴팁에는 표시가 누구 기준으로 그려지는지 나옵니다."
L["Click: open the options"] = "클릭: 설정 열기"

L["Group icons: %d (%d frames found). Reads %d, hidden %d; errors %d."] =
    "파티 아이콘: %d (개체창 %d개 발견). 읽기 %d, 숨김 %d, 오류 %d."
L["The group frames are not on screen: the cast mark shows on them in a group."] =
    "파티 개체창이 화면에 없습니다: 파티 중에는 시전 표시가 개체창에 나타납니다."
L["The game did not offer the aura container: the sensor cannot work."] = "게임이 효과 컨테이너를 제공하지 않아 감지기가 작동할 수 없습니다."

L["Click: choose a colour"] = "클릭: 색상 고르기"
L["Filling"] = "차오름"
L["Full"] = "가득"
L["Pulsing"] = "맥동"
L["Filling: the line fills as the cast goes on, like the game's cast bar. Full: the whole line at once. Pulsing: the whole line, breathing."] =
    "차오름: 시전이 진행되면서 선이 차오릅니다. 게임의 시전바와 같습니다. 가득: 선 전체가 한 번에. 맥동: 선 전체가 은은하게 깜빡입니다."
L["Cast colour"] = "시전 색상"
L["A cast that can be interrupted. At first, the game's cast bar art itself."] = "방해 가능한 시전. 처음에는 게임 시전바 그림 그대로입니다."
L["Channel colour"] = "정신 집중 색상"
L["A channel that can be interrupted. At first, the game's channel art."] = "방해 가능한 정신 집중. 처음에는 게임의 정신 집중 그림입니다."
L["Uninterruptible colour"] = "방해 불가 색상"
L["A cast that cannot be interrupted. At first, the game's grey for it."] = "방해할 수 없는 시전. 처음에는 게임이 쓰는 회색입니다."
L["Defensives and bursts"] = "생존기와 폭딜"
L["Enemy plates"] = "적 이름표"
L["Mark whoever is casting"] = "시전 중인 적 표시"
L["Also the uninterruptible"] = "방해 불가도 표시"
L["A cast that cannot be interrupted is marked too, in its own colour. Off: only what can be interrupted."] =
    "방해할 수 없는 시전도 자체 색상으로 표시합니다. 끄기: 방해 가능한 것만."
L["Animation"] = "애니메이션"
L["Which debuffs"] = "표시할 약화 효과"
L["What I can remove: only the types your specialization removes. All: every debuff that has a type, whoever can remove it."] =
    "내가 무효화 가능: 내 전문화가 무효화하는 종류만. 전체: 종류가 있는 모든 약화 효과, 누가 무효화하든."
L["What I can remove"] = "내가 무효화 가능"

L["General"] = "일반"
L["Party frame: left"] = "파티 개체창: 왼쪽"
L["Party frame: right"] = "파티 개체창: 오른쪽"
L["Debuffs that come off"] = "무효화 가능한 약화 효과"
L["After the cast, each debuff that can be removed: its own icon, a border in its type's colour that empties with the time left, and in its corners the type's symbol and letters, the time and the stacks. The game itself reads the debuff: it works in a fight and in a key."] =
    "시전 다음에, 무효화 가능한 약화 효과마다: 그 아이콘, 남은 시간에 따라 줄어드는 종류 색상의 테두리, 모서리에는 종류 기호와 약자, 시간, 중첩. 약화 효과는 게임이 직접 읽으므로 전투 중에도 신화+에서도 작동합니다."
L["Type"] = "종류"
L["Colour"] = "색상"
L["Alert"] = "경보"
L["Sound"] = "소리"
L["Off"] = "끄기"
L["On you"] = "나에게만"
L["Whole group"] = "파티 전체"
L["Boss or role debuff"] = "우두머리 또는 역할"
L["Listen"] = "듣기"
L["Sound channel"] = "음량"
L["The game's volume the alerts' sounds follow."] = "경보 소리가 따르는 게임 음량입니다."
L["The border's colour for this type. At first, the game's own colour for it."] = "이 종류의 테두리 색상. 처음에는 게임 자체 색상입니다."
L["The border's colour for it. At first, the game's red for a debuff without a type."] =
    "테두리 색상. 처음에는 종류 없는 약화 효과에 게임이 쓰는 빨강입니다."
L["A line at the top of the screen while the debuff lasts: its icon, its type, the spell and who has it, in the class colour. On you: only when it is on you."] =
    "약화 효과가 지속되는 동안 화면 위쪽에 한 줄: 아이콘, 종류, 주문, 걸린 사람(직업 색상). 나에게만: 나에게 걸렸을 때만."
L["Played when the debuff lands, on the alert's members. The game plays it only for the season's debuffs of this type that the game's tables list: one missing from them shows its line without the sound."] =
    "약화 효과가 걸릴 때 경보 대상에게 재생됩니다. 게임은 게임 테이블에 있는 이번 시즌의 이 종류 약화 효과에만 소리를 냅니다. 테이블에 없는 것은 소리 없이 줄만 나옵니다."
L["The game plays an alert's sound only for exact spells, and a boss's debuff has no type to list them by: this alert is the text only."] =
    "게임은 정확한 주문에만 경보 소리를 내는데, 우두머리 약화 효과에는 목록을 만들 종류가 없습니다: 이 경보는 텍스트만 나옵니다."
L["Voice: \"Dispel\""] = "음성: \"Dispel\""
L["Voice: \"Magic\""] = "음성: \"Magic\""
L["Voice: \"Curse\""] = "음성: \"Curse\""
L["Voice: \"Poison\""] = "음성: \"Poison\""
L["Voice: \"Disease\""] = "음성: \"Disease\""
L["Voice: \"Bleed\""] = "음성: \"Bleed\""
L["Voice: \"Debuff\""] = "음성: \"Debuff\""
L["Raid warning"] = "공격대 경보"
L["Boss warning"] = "우두머리 경보"
L["Ready check"] = "전투 준비"
L["Alarm clock 1"] = "알람 시계 1"
L["Alarm clock 2"] = "알람 시계 2"
L["Alarm clock 3"] = "알람 시계 3"
L["Battle.net toast"] = "Battle.net 알림 상자"
L["Magic: dispel"] = "마법: 무효화"
L["Magic: arcane burst"] = "마법: 비전 폭발"
L["Magic: arcane charge"] = "마법: 비전 충전"
L["Magic: arcane cast"] = "마법: 비전 시전"
L["Curse 1"] = "저주 1"
L["Curse 2"] = "저주 2"
L["Curse: shadow 1"] = "저주: 암흑 1"
L["Curse: shadow 2"] = "저주: 암흑 2"
L["Poison 1"] = "독 1"
L["Poison 2"] = "독 2"
L["Poison: spores 1"] = "독: 포자 1"
L["Poison: spores 2"] = "독: 포자 2"
L["Disease 1"] = "질병 1"
L["Disease: plague 1"] = "질병: 역병 1"
L["Disease: plague 2"] = "질병: 역병 2"
L["Bleed 1"] = "출혈 1"
L["Bleed 2"] = "출혈 2"
L["Bleed 3"] = "출혈 3"
L["Bleed 4"] = "출혈 4"
L["Boss defeated"] = "우두머리 처치"
L["Countdown end"] = "카운트다운 종료"
L["Right click: the game's colour"] = "오른쪽 클릭: 게임 색상으로"
L["Party"] = "파티"

L["Profile"] = "프로필"
L["Threat"] = "위협"
L["A line at the top of the screen while an enemy casts at you: the spell's icon and name. Only on you: the game tells whom a cast goes to only for you."] =
    "적이 나에게 시전하는 동안 화면 위쪽에 한 줄: 주문 아이콘과 이름. 나에게만: 게임은 시전 대상이 나일 때만 알려 줍니다."
L["Alerts: all"] = "경보: 전체"
L["Cast"] = "시전"
L["Cast animation"] = "시전 애니메이션"
L["Cast at you"] = "나에게 시전"
L["Channel"] = "정신 집중"
L["Every row of the table, shown or not beside the party frame."] = "표의 모든 줄입니다. 파티 개체창 옆 표시 여부와 관계없습니다."
L["Icon"] = "아이콘"
L["Letters"] = "약자"
L["On"] = "켜기"
L["Sets the alert of every row at once. The casts take \"On you\" (the game tells whom a cast goes to only for you)."] =
    "모든 줄의 경보를 한 번에 설정합니다. 시전은 \"나에게만\"이 됩니다 (게임은 시전 대상이 나일 때만 알려 줍니다)."
L["The game does not let an addon play a sound for a cast at you: what is secret in a fight cannot start a sound."] =
    "게임은 나에게 오는 시전에 애드온이 소리를 내지 못하게 합니다: 전투 중 Blizzard가 차단한 데이터로는 소리를 시작할 수 없습니다."
L["The border's colour for it. At first, the colour of the game's own cast bar art."] =
    "테두리 색상. 처음에는 게임 시전바 그림의 색상입니다."
L["Turn all on"] = "모두 켜기"
L["Uninterruptible"] = "방해 불가"
L["What it is"] = "설명"
L["Whether it shows beside the party frame."] = "파티 개체창 옆에 표시할지 여부입니다."
L["— (no list of spells)"] = "— (주문 목록 없음)"
L["— (the game does not allow it)"] = "— (게임이 허용하지 않음)"
L["Debuffs"] = "약화 효과"
L["Alerts"] = "경보"
L["Beside the party frame"] = "파티 개체창 옆"
L["Alerts on the screen"] = "화면 경보"
L["What to do"] = "대처"
L["an enemy casting"] = "시전 중인 적"
L["an enemy channelling"] = "정신 집중 중인 적"
L["cannot be interrupted"] = "방해 불가"
L["from a boss or a mechanic"] = "우두머리 또는 메커니즘"
L["can be removed"] = "무효화 가능"
L["you can remove it"] = "내가 무효화 가능"
L["interrupt"] = "방해"
L["defensive and heal"] = "생존기와 치유"
L["remove"] = "무효화"
L["no dispel type"] = "무효화 유형 없음"
L["free it"] = "해제"
L["Frees a teammate:"] = "아군 해제:"
L["Frees only themselves:"] = "자신만 해제:"
L["Without the talent, the class does not have the spell. The icon uses the game's crowd control filter: a stun or a fear without a type can show in it too."] = "특성이 없으면 해당 직업은 그 주문이 없습니다. 아이콘은 게임의 군중 제어 필터를 사용합니다: 유형이 없는 기절이나 공포도 표시될 수 있습니다."
L["The border's colour for it. At first, a light blue: the game has no colour for it."] = "테두리 색상입니다. 처음에는 하늘색입니다: 게임에 이 색상이 없습니다."
L["No class removes it: a boss's or a mechanic's debuff. Defensive and heal."] =
    "어떤 직업도 무효화할 수 없음: 우두머리나 메커니즘의 약화 효과. 생존기와 치유."
L["No class spell in the game's tables removes it."] = "게임 테이블의 어떤 직업 주문도 무효화하지 못합니다."
L["Without the specialization or the talent, the class does not have the spell."] =
    "해당 전문화나 특성이 없으면 그 직업에게 이 주문이 없습니다."

L["Example"] = "예시"
L["Party frame"] = "파티 개체창"
L["Casting"] = "시전 중"
L["Channelling"] = "정신 집중 중"
L["Left: defensives and bursts (lit = on; dark with a sweep = recharging)."] =
    "왼쪽: 생존기와 폭딜 (밝음 = 활성, 어둡고 회전 = 재사용 대기 중)."
L["Right: the cast coming | what you remove | the boss's or the role's."] = "오른쪽: 오는 시전 | 내가 무효화할 것 | 우두머리나 역할의 것."
L["The cast: the border fills, the time in the middle."] = "시전: 테두리가 차오르고, 가운데에 시간."
L["the type's symbol (the game's)"] = "종류 기호 (게임 것)"
L["the stacks (above 1)"] = "중첩 (2 이상)"
L["the type's letters (the game's)"] = "종류 약자 (게임 것)"
L["the border: the type's colour, emptying"] = "테두리: 종류 색상, 줄어듦"
L["the time left"] = "남은 시간"

L["Plates"] = "이름표"
L["The tabs"] = "탭"
L["Each tab shows one part, with its example on top: the enemy plates, the threat, the party frame, the debuffs and the alerts."] =
    "탭마다 한 부분을 보여 주며, 위에 예시가 있습니다: 적 이름표, 위협, 파티 개체창, 약화 효과, 경보."
L["Using another nameplate addon? Turn off \"Mark whoever is casting\": the Radar then touches no plate."] =
    "다른 이름표 애드온을 쓰나요? \"시전 중인 적 표시\"를 끄면 Radar는 이름표를 전혀 건드리지 않습니다."
L["Yours use the game's exact recharge. A teammate who deals damage shows up after the inspection, out of combat; a tank and a healer, at once."] =
    "내 것은 게임의 정확한 재사용 대기시간을 씁니다. 공격 전담 파티원은 전투 밖에서 살펴보기를 마친 뒤 나타나고, 방어 전담과 치유 전담은 바로 나타납니다."
L["Nothing goes on the game's frame. The cast is exact for you; for the others it is still a test. Types and colours: the \"Debuffs\" tab; warnings: the \"Alerts\" tab."] =
    "게임 개체창 위에는 아무것도 올리지 않습니다. 시전은 나에게는 정확하고, 다른 사람에게는 아직 시험 중입니다. 종류와 색상: \"약화 효과\" 탭, 경보: \"경보\" 탭."
L["Colour: a click picks one, a right click goes back to the game's. The symbol and the letters are the game's own."] =
    "색상: 클릭하면 고르고, 오른쪽 클릭하면 게임 색상으로 돌아갑니다. 기호와 약자는 게임 것입니다."
L["The line stays while the debuff lasts. The sound plays only for the season's debuffs the game's tables list. Every alert starts off."] =
    "줄은 약화 효과가 지속되는 동안 남습니다. 소리는 게임 테이블에 있는 이번 시즌 약화 효과에만 납니다. 모든 경보는 꺼진 상태로 시작합니다."
L["casting: the outline fills in the cast's colour, in front of the other plates"] =
    "시전 중: 외곽선이 시전 색상으로 차오르고, 다른 이름표보다 앞에"
L["channelling: the game's green art, emptying"] = "정신 집중 중: 게임의 초록 그림, 줄어듦"
L["cannot be interrupted: the game's grey (an option, off at first)"] = "방해 불가: 게임의 회색 (설정, 처음에는 꺼짐)"
L["Not casting"] = "시전 없음"
L["not casting: the game's plate, nothing of ours"] = "시전 없음: 게임 이름표 그대로, 추가 없음"
L["The cast bar under the health is the game's own: the Radar only adds the outline."] =
    "생명력 아래의 시전바는 게임 것입니다: Radar는 외곽선만 더합니다."
L["Playing a tank"] = "방어 전담일 때"
L["Playing damage or healer (in a group)"] = "공격 또는 치유 전담일 때 (파티 중)"
L["Mob"] = "적"
L["green: the mob is with you and safe"] = "초록: 적이 나에게 안전하게 있음"
L["orange: with you, about to be lost"] = "주황: 나에게 있지만 곧 놓침"
L["red and blinking: loose, with the name of who took it"] = "빨강 깜빡임: 풀림, 가져간 사람 이름과 함께"
L["white: with the other tank"] = "흰색: 다른 방어 전담에게 있음"
L["red: the mob turned to you"] = "빨강: 적이 나를 노림"
L["Safe with you"] = "나에게 안전"
L["About to be lost"] = "곧 놓침"
L["Loose (or turned to you)"] = "풀림 (또는 나를 노림)"
L["With the other tank"] = "다른 방어 전담에게"
L["The shield's colour in this state. At first, the game's own."] = "이 상태의 방패 색상. 처음에는 게임 자체 색상입니다."

L["Follows your specialization: a tank specialization plays as tank, any other as damage or healer."] =
    "전문화를 따릅니다: 방어 전담 전문화는 방어 전담으로, 그 밖에는 공격 또는 치유 전담으로."
L["The shield beside every enemy plate says who holds it: green, safe with you; orange, about to be lost; red and blinking, loose, with the name of who took it; white, with the other tank."] =
    "적 이름표마다 옆의 방패가 누가 잡고 있는지 알려 줍니다: 초록, 나에게 안전; 주황, 곧 놓침; 빨강 깜빡임, 풀림, 가져간 사람 이름과 함께; 흰색, 다른 방어 전담에게."
L["The shield shows only when an enemy turns to you (in a group): red, so you step back or use a defensive."] =
    "방패는 적이 나를 노릴 때만 나타납니다 (파티 중): 빨강이면 물러나거나 생존기를 쓰세요."
L["casting: the outline fills in the cast's colour"] = "시전 중: 외곽선이 시전 색상으로 차오름"
L["uninterruptible: the game's grey (an option)"] = "방해 불가: 게임의 회색 (설정)"
L["green: safe with you"] = "초록: 나에게 안전"
L["red and blinking: loose, with who took it"] = "빨강 깜빡임: 풀림, 가져간 사람과 함께"
L["Left: defensives and bursts (lit = on; dark with a sweep = recharging). Right: the cast coming | what you remove | the boss's."] =
    "왼쪽: 생존기와 폭딜 (밝음 = 활성, 어둡고 회전 = 재사용 대기 중). 오른쪽: 오는 시전 | 내가 무효화할 것 | 우두머리의 것."
