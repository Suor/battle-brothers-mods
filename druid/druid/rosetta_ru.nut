if (!("Rosetta" in getroottable())) return;

local rosetta = {
    mod = {id = "mod_druid", version = "0.1.0"}
    author = "hackflow"
    lang = "ru"
}
local pairs = [
    // FILE: druid/scripts/!mods_preload/mod_druid.nut
    {
        en = "Proper Druid"
        ru = "Годный Друид"
    }

    // FILE: druid/scripts/config/z_druid.nut
    {
        en = "Regrowth"
        ru = "Живица"
    }
    {
        mode = "pattern"
        en = "Channel nature's vigor into a single ally, knitting their wounds back at <hp:int_tag> hitpoints per turn. Only one ally can carry it at a time - bestow it elsewhere and the previous one stops mending."
        ru = "Направляет животворную силу в одного союзника, затягивая его раны на <hp> ОЗ за ход. Носить дар может лишь один союзник - наложение на другого снимает его с прежнего."
    }
    {
        en = "Hatch"
        ru = "Выводок"
    }
    {
        mode = "pattern"
        en = "The wilds teem with new broods. Your summon no longer spends itself once per battle - instead it recharges, ready again <open:tag>every other turn<close:tag>."
        ru = "Дикие земли кишат новыми выводками. Призыв больше не тратится раз за бой - он восстанавливается и готов снова <open:tag>через ход<close:tag>."
    }
    {
        en = "Entangling Roots"
        ru = "Оплетающие корни"
    }
    {
        en = "Call writhing roots from the earth to root an enemy in place."
        ru = "Поднимает из земли извивающиеся корни, оплетающие врага на месте."
    }
    {
        en = "Apex Predators"
        ru = "Высшие хищники"
    }
    {
        en = "Your call reaches greater beasts. Wolves answer as direwolves, hyenas come frenzied, spiders bloated and broodmother-sized, and young schrats rise full-grown."
        ru = "Твой зов достигает более грозных тварей. Волки приходят лютоволками, гиены - бешеными, пауки раздуваются до размеров матки, а юные шраты встают в полный рост."
    }
    {
        en = "Venom"
        ru = "Яд"
    }
    {
        en = "Your beasts hunt with envenomed fang and sting. Their bites poison the prey."
        ru = "Твои звери охотятся ядовитым клыком и жалом. Их укусы отравляют добычу."
    }
    {
        en = "Pack Leader"
        ru = "Вожак стаи"
    }
    {
        mode = "pattern"
        en = "The beasts know you for their alpha. Summoned beasts arrive <open:tag>confident<close:tag> and will never flee the field."
        ru = "Звери признают в тебе вожака. Призванные звери приходят <open:tag>уверенными<close:tag> и никогда не бегут с поля боя."
    }

    // FILE: druid/scripts/skills/backgrounds/druid_background.nut
    {
        en = "Druid"
        ru = "Друид"
    }
    {
        en = "the Druid"
        ru = "Друид"
    }
    {
        en = "the Hedge Witch"
        ru = "Ведун"
    }
    {
        en = "Greenmantle"
        ru = "Зелёный Плащ"
    }
    {
        en = "the Beast Caller"
        ru = "Покровитель Зверей"
    }
    {
        en = "Can summon a beast fitting the battlefield to fight at his side"
        ru = "Может призвать зверя, подходящего полю боя, сражаться на его стороне"
    }

    // FILE: druid/scripts/skills/actives/druid_summon_beast.nut
    {
        en = "Summon Beast"
        ru = "Призыв зверя"
    }
    {
        en = "Call a beast of the surrounding wilds to a free tile beside you. It will hunt your enemies but cannot otherwise be commanded."
        ru = "Призывает зверя окрестных земель на свободную клетку рядом с вами. Он будет охотиться на врагов, но в остальном не подчиняется приказам."
    }
    {
        mode = "pattern"
        en = "Recharges in <n:int_tag> turn"
        ru = "Восстановится через <n> ход"
    }
    {
        mode = "pattern"
        en = "Recharges in <n:int_tag> turns"
        ru = "Восстановится через <n> хода"
    }
    {
        en = "Ready - recharges every other turn"
        ru = "Готов - восстанавливается через ход"
    }
    {
        en = "Ready - once per battle"
        ru = "Готов - один раз за бой"
    }
    {
        en = "Spent for this battle"
        ru = "Истрачен на этот бой"
    }

    // FILE: druid/scripts/skills/actives/druid_entangle.nut
    {
        en = "Call writhing roots from the earth to root an enemy in place, holding them fast for a turn."
        ru = "Поднимает из земли извивающиеся корни, оплетающие врага и удерживающие его на месте на ход."
    }

    // FILE: druid/scripts/skills/actives/druid_regrowth.nut
    {
        en = "Channel nature's vigor into an ally, mending their wounds turn after turn. Only one ally can carry it - bestowing it anew stops the previous one from mending."
        ru = "Направляет силу природы в союзника, исцеляя его раны ход за ходом. Носить дар может лишь один союзник - наложение на нового снимает его с прежнего."
    }

    // FILE: druid/scripts/skills/effects/druid_regeneration_effect.nut
    {
        en = "Nature mends this character, restoring 10 hitpoints at the start of each turn."
        ru = "Природа исцеляет бойца, восстанавливая 10 ОЗ в начале каждого хода."
    }

    // FILE: druid/scripts/scenarios/world/druid_scenario.nut
    {
        en = "[p=c][img]gfx/ui/events/event_25.png[/img][/p][p]You learned to speak with the green things and the beasts that walk beneath the canopy. Now you walk the world with them at your back.\n\n[color=#bcad8c]Player Character:[/color] This druid is you. Should you fall, no beast will answer for the others.\n[color=#bcad8c]Children of the Wild:[/color] You begin with rough woodsfolk rather than trained soldiers.\n[color=#bcad8c]Call of the Wild:[/color] From the first day you can summon a beast fitting the battlefield to fight at your side.[/p]"
        ru = "[p=c][img]gfx/ui/events/event_25.png[/img][/p][p]Вы научились говорить с зеленью и зверьём, что бродит под пологом леса. Теперь вы странствуете по миру, и они идут за вами.\n\n[color=#bcad8c]Игровой персонаж:[/color] Этот друид - вы. Если падёте вы, ни один зверь не заменит остальных.\n[color=#bcad8c]Дети дикой природы:[/color] Вы начинаете с грубым лесным людом, а не с обученными солдатами.\n[color=#bcad8c]Зов дикой природы:[/color] С первого же дня вы можете призвать зверя, подходящего полю боя, сражаться на вашей стороне.[/p]"
    }
    {
        en = "the Greenmantle"
        ru = "Зелёный Плащ"
    }
    {
        en = "This beast hunts with envenomed fang and sting. A deep enough bite poisons the prey, draining their hitpoints each turn until it fades."
        ru = "Этот зверь охотится ядовитым клыком и жалом. Достаточно глубокий укус отравляет добычу, истощая её здоровье каждый ход, пока яд не выветрится."
    }
    {
        en = "Fearless"
        ru = "Бесстрашие"
    }
    {
        en = "This beast knows its master for the alpha. It may be shaken in the thick of battle, but it will never flee the field."
        ru = "Этот зверь признаёт в хозяине вожака. В горниле боя его можно поколебать, но он никогда не побежит с поля боя."
    }
    {
        mode = "pattern"
        en = "Has a range of <range:int_tag> tiles"
        ru = "Дальность - <range> клеток"
    }
    {
        mode = "pattern"
        en = "<actor:str_tag> is wreathed in healing growth"
        ru = "<actor> окутан исцеляющей порослью"
    }
    {
        mode = "pattern"
        en = "<actor:str_tag> heals for <hp:int> hitpoints"
        ru = "<actor> исцеляется на <hp> ОЗ"
    }

    // Internal beast script identifiers - not user-facing.
    // en = "wolf"
    // en = "spider"
    // en = "hyena"
    // en = "serpent"
    // en = "direwolf"
    // en = "schrat"

    // Sprite part names scaled by makeApex() - not user-facing.
    // en = "body"
    // en = "head"
    // en = "injury"
    // en = "armor"

    {
        en = "{Wrapped in furs and bark-dyed cloth, %name% smells of moss and old rain. | %name% speaks little to men and much to the trees, or so it seems. | Wherever %name% treads, beasts watch from the treeline and do not flee. | %name% carries no idols, yet kneels often to press an ear against the soil. | The crows seem to follow %name%, and he never shoos them away.} {He was raised at the forest's edge, far from any lord's reach. | Some say he was a hermit who learned the old green tongues. | He was driven from his village for speaking with wolves, they whisper. | None know whence he came, only that the woods opened to let him pass. | He claims the wild folk taught him, and you are not inclined to argue.} {%name% whistles a low note and a hare comes to his hand, then bounds away. | %name% lays a palm on a sick mule and by morning it stands hale. | %name% names the weather by the smell of the wind, and is seldom wrong. | %name% points to a thicket and bids you wait - moments later a stag breaks cover where he pointed.}"
        ru = "{Закутанный в меха и крашенную корой ткань, %name% пахнет мхом и давним дождём. | %name% мало говорит с людьми и много - с деревьями, так по крайней мере кажется. | Где бы ни ступал %name%, звери смотрят из-за деревьев и не бегут. | %name% не носит идолов, но часто опускается на колени, прижимая ухо к земле. | Вороны словно следуют за %name%, и он никогда их не гонит.} {Он вырос на опушке леса, вдали от власти любого лорда. | Поговаривают, он был отшельником, постигшим старые зелёные наречия. | Шепчут, что его изгнали из деревни за разговоры с волками. | Никто не знает, откуда он пришёл, - лишь то, что лес расступился, пропуская его. | Он уверяет, что его учил дикий народ, и спорить с ним не хочется.} {%name% тихо свистит, и заяц идёт к его руке, а затем уносится прочь. | %name% кладёт ладонь на больного мула, и к утру тот здоров. | %name% угадывает погоду по запаху ветра и редко ошибается. | %name% указывает на чащу и велит подождать - и спустя миг там, куда он показал, выходит олень.}"
    }
]

::Rosetta.add(rosetta, pairs);
