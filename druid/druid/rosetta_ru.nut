if (!("Rosetta" in getroottable())) return;

local rosetta = {
    mod = {id = "mod_druid", version = "0.1.0"}
    author = "hackflow"
    lang = "ru"
}
local pairs = [
    // FILE: scripts/!mods_preload/mod_druid.nut
    {
        en = "Proper Druid"
        ru = "Годный Друид"
    }
    // en = "body"
    // en = "head"
    // en = "hair"
    // en = "injury"
    // en = "armor"
    // FILE: scripts/config/z_druid.nut
    {
        en = "Regrowth"
        ru = "Живица"
    }
    {
        // Tooltip = "Knit an ally's wounds turn after turn, double for beasts and animals."
        //         + " One bearer at a time."
        //         + "\n" + red("Taking it closes the path of the Beast.")
        mode = "pattern"
        en = "Knit an ally's wounds turn after turn, double for beasts and animals. One bearer at a time.\n<open:tag>Taking it closes the path of the Beast.<close:tag>"
        ru = "Затягивает раны союзника ход за ходом, вдвое быстрее всякому зверью. Лишь один носитель за раз.\n<open:tag>Взяв его, вы закроете путь Зверя.<close:tag>"
    }
    {
        en = "Hatch"
        ru = "Выводок"
    }
    {
        // Tooltip = "Will summon " + green("every other turn") + ", not once per battle."
        mode = "pattern"
        en = "Will summon <open:tag>every other turn<close:tag>, not once per battle."
        ru = "Призывает <open:tag>через ход<close:tag>, а не раз за бой."
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
        // Tooltip = "Your call reaches greater beasts. Direwolves and hyenas answer frenzied,"
        //         + " spiders bloated and broodmother-sized, and young schrats rise full-grown."
        en = "Your call reaches greater beasts. Direwolves and hyenas answer frenzied, spiders bloated and broodmother-sized, and young schrats rise full-grown."
        ru = "Твой зов достигает более грозных тварей. Лютоволки и гиены приходят бешеными, пауки раздуваются до размеров матки, а юные шраты встают в полный рост."
    }
    {
        en = "Beastform"
        ru = "Форма зверя"
    }
    {
        // Tooltip = "Take the shape of the beast for good: " + green("+10% Melee Skill") + ", "
        //         + green("+10% Melee Defense") + " and " + green("+20% Hitpoints") + "."
        //         + " But you can no longer bear heavy shields, helmets or armor, nor ranged weapons."
        //         + "\n" + red("Taking it closes the path of Nature.")
        mode = "pattern"
        en = "Take the shape of the beast for good: <o1:tag>+10% Melee Skill<c1:tag>, <o2:tag>+10% Melee Defense<c2:tag> and <o3:tag>+20% Hitpoints<c3:tag>. But you can no longer bear heavy shields, helmets or armor, nor ranged weapons.\n<o4:tag>Taking it closes the path of Nature.<c4:tag>"
        ru = "Навсегда примите облик зверя: <o1:tag>+10% к навыку ближнего боя<c1:tag>, <o2:tag>+10% к защите в ближнем бою<c2:tag> и <o3:tag>+20% к здоровью<c3:tag>. Но вы больше не сможете носить тяжёлые щиты, шлемы и броню, а также дальнобойное оружие.\n<o4:tag>Взяв его, вы закроете путь Природы.<c4:tag>"
    }
    {
        en = "Beast Aura"
        ru = "Аура зверя"
    }
    {
        // Tooltip = "Beasts know you for their alpha. Your beasts keep to your side instead of"
        //         + " chasing the foe, and any allied beast near you stands " + green("fearless")
        //         + " and emboldened."
        mode = "pattern"
        en = "Beasts know you for their alpha. Your beasts keep to your side instead of chasing the foe, and any allied beast near you stands <open:tag>fearless<close:tag> and emboldened."
        ru = "Звери признают в вас вожака. Ваши звери держатся рядом, а не гонятся за врагом, и любой союзный зверь возле вас стоит <open:tag>бесстрашно<close:tag> и воодушевлён."
    }
    {
        en = "Beast Rage"
        ru = "Ярость зверя"
    }
    {
        // Tooltip = "Blood feeds a rising fury: stacking melee damage, Resolve and Initiative and"
        //         + " " + green("healing") + " each turn, at the cost of Melee Defense. At its height"
        //         + " you tear off your own shield and roar."
        mode = "pattern"
        en = "Blood feeds a rising fury: stacking melee damage, Resolve and Initiative and <open:tag>healing<close:tag> each turn, at the cost of Melee Defense. At its height you tear off your own shield and roar."
        ru = "Кровь питает растущую ярость: накапливает урон в ближнем бою, Решимость, Инициативу и <open:tag>исцеление<close:tag> каждый ход - ценой защиты в ближнем бою. На пике вы срываете собственный щит и издаёте рык."
    }
    {
        en = "Venom"
        ru = "Яд"
    }
    {
        // Tooltip = "Envenomed fang and sting: a weakening venom that blurs sight and slows the foe."
        //         + " Your summoned beasts hunt with it - but once you walk in Beastform it is yours"
        //         + " alone, riding your own bite instead of theirs."
        en = "Envenomed fang and sting: a weakening venom that blurs sight and slows the foe. Your summoned beasts hunt with it - but once you walk in Beastform it is yours alone, riding your own bite instead of theirs."
        ru = "Ядовитый клык и жало: ослабляющий яд мутит зрение и замедляет врага. С ним охотятся ваши призванные звери - но в зверином облике он лишь ваш, ложась на ваш укус, а не на их."
    }
    // Lock reasons shown by DPF's perk tooltip (perkBlockReason / verifyPrerequisites).
    {
        en = "Locked because this character walks the path of the Beast"
        ru = "Закрыто: этот персонаж идёт путём Зверя"
    }
    {
        en = "Locked because this character walks the path of Nature"
        ru = "Закрыто: этот персонаж идёт путём Природы"
    }
    {
        en = "Locked because it requires Beastform"
        ru = "Закрыто: требуется Звериный облик"
    }
    {
        en = "Locked because Venom and Beast Rage are mutually exclusive"
        ru = "Закрыто: Яд и Звериная ярость несовместимы"
    }
    // en = "wolf"
    // en = "direwolf"
    // en = "spider"
    // en = "hyena"
    // en = "serpent"
    // FILE: scripts/druid_pg.nut
    {
        en = "Druid"
        ru = "Друид"
    }
    // FILE: scripts/scenarios/world/druid_scenario.nut
    {
        en = "The Wolf and the Bear"
        ru = "Волк и Медведь"
    }
    {
        en = "[p=c][img]gfx/ui/events/event_25.png[/img][/p][p]The wild was in your blood before you had words for it. The green things and the beasts that walk beneath the canopy know their own, and they have always known you. Now two of you walk the world with the wild at your back.\n\n[color=#bcad8c]The Wolf and the Bear:[/color] You begin as a pair, both walkers of the wild paths - one who has taken the beast's shape to fight tooth and claw, and one who calls the beasts and mends his fellows' wounds.\n[color=#bcad8c]Player Characters:[/color] Don't let both the Wolf and the Bear die.\n[color=#bcad8c]Children of the Wild:[/color] You begin with rough woodsfolk rather than trained soldiers, and will hire no hunters or poachers.[/p]"
        ru = "[p=c][img]gfx/ui/events/event_25.png[/img][/p][p]Дикое было в вашей крови ещё до того, как у вас появились для него слова. Зелень и звери, что бродят под пологом леса, чуют своего - и всегда чуяли вас. Теперь по миру странствуют двое, и дикая чаща идёт за вами.\n\n[color=#bcad8c]Волк и Медведь:[/color] Вы начинаете вдвоём, оба - странники диких троп: один принял звериный облик и бьётся клыком и когтем, другой призывает зверей и врачует раны собратьев.\n[color=#bcad8c]Игровые персонажи:[/color] Вы проиграете, лишь если погибнут оба - и Волк, и Медведь.\n[color=#bcad8c]Дети дикой природы:[/color] Вы начинаете с грубым лесным людом, а не с обученными солдатами, и не нанимаете охотников и браконьеров.[/p]"
    }
    {
        en = "the Bear"
        ru = "Медведь"
    }
    {
        en = "the Wolf"
        ru = "Волк"
    }
    // FILE: scripts/skills/actives/druid_entangle.nut
    {
        // this.m.Description = "Call writhing roots from the earth to root an enemy in place,"
        //                    + " holding them fast for a turn.";
        en = "Call writhing roots from the earth to root an enemy in place, holding them fast for a turn."
        ru = "Поднимает из земли извивающиеся корни, оплетающие врага и удерживающие его на месте на ход."
    }
    {
        // text = "Has a range of " + ::std.Text.positive(this.getMaxRange()) + " tiles"
        mode = "pattern"
        en = "Has a range of <range:int_tag> tiles"
        ru = "Дальность - <range> клеток"
    }
    // FILE: scripts/skills/actives/druid_regrowth.nut
    {
        // this.m.Description = "Channel nature's vigor into an ally, mending their wounds turn"
        //                    + " after turn, double for beasts and animals. One bearer at a"
        //                    + " time, and never the undead.";
        en = "Channel nature's vigor into an ally, mending their wounds turn after turn, double for beasts and animals. One bearer at a time, and never the undead."
        ru = "Направляет силу природы в союзника, исцеляя его раны ход за ходом, а зверей и животных - вдвое быстрее. Лишь один носитель за раз, и никогда нежить."
    }
    {
        // ::Const.UI.getColorizedEntityName(target) + " is wreathed in healing growth"
        mode = "pattern"
        en = "<actor:str_tag> is wreathed in healing growth"
        ru = "<actor> окутан исцеляющей порослью"
    }
    // FILE: scripts/skills/actives/druid_summon_beast.nut
    {
        en = "Summon Beast"
        ru = "Призыв зверя"
    }
    {
        // this.m.Description = "Call a beast of the surrounding wilds to a free tile beside you."
        //                    + " It will hunt your enemies but cannot otherwise be commanded.";
        en = "Call a beast of the surrounding wilds to a free tile beside you. It will hunt your enemies but cannot otherwise be commanded."
        ru = "Призывает зверя окрестных земель на свободную клетку рядом с вами. Он будет охотиться на врагов, но в остальном не подчиняется приказам."
    }
    {
        // charge = this.hasHatch()
        //     ? "Recharges in " + ::std.Text.negative(this.m.Cooldown)
        //         + (this.m.Cooldown == 1 ? " turn" : " turns")
        //     : "Spent for this battle";
        mode = "pattern"
        en = "Recharges in <n:int_tag> turn"
        ru = "Восстановится через <n> ход"
    }
    {
        // charge = this.hasHatch()
        //     ? "Recharges in " + ::std.Text.negative(this.m.Cooldown)
        //         + (this.m.Cooldown == 1 ? " turn" : " turns")
        //     : "Spent for this battle";
        mode = "pattern"
        en = "Recharges in <n:int_tag> turns"
        ru = "Восстановится через <n> хода"
    }
    {
        // charge = this.hasHatch()
        //     ? "Recharges in " + ::std.Text.negative(this.m.Cooldown)
        //         + (this.m.Cooldown == 1 ? " turn" : " turns")
        //     : "Spent for this battle";
        en = "Spent for this battle"
        ru = "Истрачен на этот бой"
    }
    {
        // charge = this.hasHatch() ? "Ready - recharges every other turn" : "Ready - once per battle";
        en = "Ready - recharges every other turn"
        ru = "Готов - восстанавливается через ход"
    }
    {
        // charge = this.hasHatch() ? "Ready - recharges every other turn" : "Ready - once per battle";
        en = "Ready - once per battle"
        ru = "Готов - один раз за бой"
    }
    // FILE: scripts/skills/backgrounds/druid_background.nut
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

    {
        en = "{Wrapped in furs and bark-dyed cloth, %name% smells of moss and old rain. | %name% speaks little to men and much to the trees, or so it seems. | Wherever %name% treads, beasts watch from the treeline and do not flee. | %name% carries no idols, yet kneels often to press an ear against the soil. | The crows seem to follow %name%, and he never shoos them away.} {He was raised at the forest's edge, far from any lord's reach. | Some say he was a hermit who learned the old green tongues. | He was driven from his village for speaking with wolves, they whisper. | None know whence he came, only that the woods opened to let him pass. | He claims the wild folk taught him, and you are not inclined to argue.} {%name% whistles a low note and a hare comes to his hand, then bounds away. | %name% lays a palm on a sick mule and by morning it stands hale. | %name% names the weather by the smell of the wind, and is seldom wrong. | %name% points to a thicket and bids you wait - moments later a stag breaks cover where he pointed.}"
        ru = "{Закутанный в меха и крашенную корой ткань, %name% пахнет мхом и давним дождём. | %name% мало говорит с людьми и много - с деревьями, так по крайней мере кажется. | Где бы ни ступал %name%, звери смотрят из-за деревьев и не бегут. | %name% не носит идолов, но часто опускается на колени, прижимая ухо к земле. | Вороны словно следуют за %name%, и он никогда их не гонит.} {Он вырос на опушке леса, вдали от власти любого лорда. | Поговаривают, он был отшельником, постигшим старые зелёные наречия. | Шепчут, что его изгнали из деревни за разговоры с волками. | Никто не знает, откуда он пришёл, - лишь то, что лес расступился, пропуская его. | Он уверяет, что его учил дикий народ, и спорить с ним не хочется.} {%name% тихо свистит, и заяц идёт к его руке, а затем уносится прочь. | %name% кладёт ладонь на больного мула, и к утру тот здоров. | %name% угадывает погоду по запаху ветра и редко ошибается. | %name% указывает на чащу и велит подождать - и спустя миг там, куда он показал, выходит олень.}"
    }
    // FILE: scripts/skills/effects/druid_beast_aura_effect.nut
    {
        en = "An alpha of the wild stands near. This beast is emboldened and will not flee the field while the aura holds."
        ru = "Рядом стоит вожак дикой природы. Этот зверь воодушевлён и не покинет поле боя, пока держится аура."
    }
    // FILE: scripts/skills/effects/druid_regrowth_effect.nut
    {
        // return "Nature mends this character, restoring " + heal + " hitpoints at the start of each turn.";
        mode = "pattern"
        en = "Nature mends this character, restoring <n:int> hitpoints at the start of each turn."
        ru = "Природа исцеляет бойца, восстанавливая <n> ОЗ в начале каждого хода."
    }
    {
        // return "Nature mends this beast, restoring " + heal + " hitpoints at the start of each turn.";
        mode = "pattern"
        en = "Nature mends this beast, restoring <n:int> hitpoints at the start of each turn."
        ru = "Природа исцеляет зверя, восстанавливая <n> ОЗ в начале каждого хода."
    }
    {
        // ::Const.UI.getColorizedEntityName(actor) + " heals for " + healed + " hitpoints"
        mode = "pattern"
        en = "<actor:str_tag> heals for <hp:int> hitpoints"
        ru = "<actor> исцеляется на <hp> ОЗ"
    }
    // FILE: scripts/skills/perks/perk_druid_beast_rage.nut
    {
        // return this.m.RageStacks > 1 ? this.m.Name + " (x" + this.m.RageStacks + ")" : this.m.Name;
        mode = "pattern"
        en = "<this.m.Name> (x<this.m.RageStacks>)"
        ru = "<this.m.Name> (x<this.m.RageStacks>)"
    }
    {
        // return "The taste of blood and the thrill of the kill drive this beast into a deepening fury. "
        //      + "Every melee hit, kill, blow taken - even a missed swing - feeds the rage, and once roused it must be fed to last.";
        en = "The taste of blood and the thrill of the kill drive this beast into a deepening fury. Every melee hit, kill, blow taken - even a missed swing - feeds the rage, and once roused it must be fed to last."
        ru = "Вкус крови и упоение убийством ввергают зверя во всё более глубокую ярость. Каждый удар в ближнем бою, каждое убийство, каждый полученный удар - и даже промах - питает ярость, а разгоревшись однажды, она должна питаться, чтобы не угаснуть."
    }
    {
        // text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + (s * R.PerStackDamageMult * 100).tointeger() + "%[/color] Melee Damage"
        mode = "pattern"
        en = "[color=<this.Const.UI.Color.PositiveValue>]+<s*R.PerStackDamageMult*100.tointeger()>%[/color] Melee Damage"
        ru = "[color=<this.Const.UI.Color.PositiveValue>]+<s*R.PerStackDamageMult*100.tointeger()>%[/color] к урону в ближнем бою"
    }
    {
        // text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + (s * R.PerStackHpRegen) + "[/color] Hitpoints regenerated each turn"
        mode = "pattern"
        en = "[color=<this.Const.UI.Color.PositiveValue>]+<s*R.PerStackHpRegen>[/color] Hitpoints regenerated each turn"
        ru = "[color=<this.Const.UI.Color.PositiveValue>]+<s*R.PerStackHpRegen>[/color] здоровья восстанавливается каждый ход"
    }
    {
        // this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " gains rage!");
        mode = "pattern"
        en = "<this.Const.UI.getColorizedEntityName(actor)> gains rage!"
        ru = "<this.Const.UI.getColorizedEntityName(actor)> приходит в ярость!"
    }
    {
        // this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_actor) + " tears off the shield with a roar!");
        mode = "pattern"
        en = "<this.Const.UI.getColorizedEntityName(_actor)> tears off the shield with a roar!"
        ru = "<this.Const.UI.getColorizedEntityName(_actor)> с рыком срывает щит!"
    }
    // FILE: scripts/skills/racial/druid_fearless.nut
    {
        en = "Fearless"
        ru = "Бесстрашие"
    }
    {
        en = "This beast knows its master for the alpha. It may be shaken in the thick of battle, but it will never flee the field."
        ru = "Этот зверь признаёт в хозяине вожака. В горниле боя его можно поколебать, но он никогда не побежит с поля боя."
    }
    // FILE: scripts/skills/racial/druid_venom.nut
    {
        en = "This beast hunts with envenomed fang and sting. A deep bite poisons the prey, blurring its sight and slowing it until the venom fades."
        ru = "Этот зверь охотится ядовитым клыком и жалом. Глубокий укус отравляет добычу, мутит ей зрение и замедляет, пока яд не выветрится."
    }
]
::Rosetta.add(rosetta, pairs);
