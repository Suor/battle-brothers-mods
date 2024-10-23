if (!("Rosetta" in getroottable())) return;

local rosetta = {
    mod = {id = "mod_necro", version = "0.4.0"}
    author = "hacflow"
    lang = "ru"
}
local pairs = [
    // FILE: necro/scripts/!mods_preload/mod_necro.nut
        // en = "necro-"
        // en = "placeholder to fool mod_plan_perks"
        // en = "mace"
        // en = "cleaver"
        // en = "sword"
        // en = "dagger"
        // en = "polearm"
        // en = "crossbow"
        // en = "throwing"
    {
        en = "Proper Necro"
        ru = "Годный Некромант"
    }
    {
        en = "Possess an undead giving it extra speed, skill, defense and damage tolerance."
        ru = "Вселяется в нежить, повышая её скорость, навыки, защиту и сопротивление урону."
    }
    // FILE: necro/scripts/config/z_necro.nut
    {
        en = "Undead Regeneration"
        ru = "Регенерация нежити"
    }
    {
        mode = "pattern"
        en = "The restoration won't stop after a corpse is raised, but continue at <rate:int_tag> hitpoints per turn."
        ru = "Восстановление не прекращается после поднятия трупа, а продолжается со скоростью <rate> ОЗ за ход."
    }
    {
        en = "Necromastery"
        ru = "Некромастерство"
    }
    {
        mode = "pattern"
        en = "Master raising undead. Use <open:tag><ap:int> AP<close:tag> and <fat:str_tag> less fatigue to raise."
        ru = "Мастер поднятия нежити. Тратит только <open><ap> ОД<close> и на <fat> меньше выносливости для поднятия мертвецов."
    }
    {
        en = "Possess"
        ru = "Власть над нежитью"
    }
    {
        en = "Allows possessing raised undead. The master will feel when his puppet is hurt."
        ru = "Позволяет вселяться в поднятую нежить. Хозяин чувствует боль марионетки."
    }
    {
        en = "Mind Meld"
        ru = "Слияние разумов"
    }
    {
        en = "Share some of your perks with raised undead and learn a couple in return."
        ru = "Передаёт некоторые навыками поднятой нежити и получает кое-что взамен."
    }
    {
        en = "Blood Suckers"
        ru = "Кровососы"
    }
    {
        en = "Give your undead blood sucking ability."
        ru = "Наделяет свою нежить способностью высасывать кровь."
    }
    {
        en = "Necrotic Reach"
        ru = "Некротический охват"
    }
    {
        en = "Extend your necrotic reach. Allows raising undead twice as far."
        ru = "Расширь свой некротический охват. Позволяет поднимать нежить в два раза дальше."
    }
    {
        en = "Flesh of Iron"
        ru = "Железная плоть"
    }
    {
        en = "Iron is another dead matter. Partially restores armor when raising undead.\n\nContinues to do so if you also have Undead Regeneration."
        ru = "Железо - та же мёртвая материя. Частично восстанавливает броню при поднятии нежити."
           + "\n\nПродолжает постепенное восстановление, если у вас также есть 'Регенерация нежити'."
    }
    {
        en = "Soul Link"
        ru = "Связь душ"
    }
    {
        en = "Redirect some hits to one of his undead. If about to die will evaporate one of them instead."
        ru = "Перенаправляет часть полученных ударов на одну из марионеток."
            + " Если удар смертелен, то нежить будет развеяна."
    }
    // FILE: necro/scripts/scenarios/world/necro_scenario.nut
    {
        en = "Proper Necromancer"
        ru = "Годный Некромант"
    }
    {
        id = "scripts/scenarios/world/necro_scenario.Description"
        en = "[p=c][img]gfx/ui/events/event_76.png[/img][/p][p]Having death always around you found a way to revert it. Somewhat.\n\n[color=#bcad8c]Player Character:[/color] This necromancer is you. Don't die, there is noone to raise you.\n[color=#bcad8c]An outcast:[/color] People wary about your craft. Starting relations are cold and people joining you expect better pay.\n[color=#bcad8c]Cannon Fodder:[/color] You have your ways of finding lots of cripples, various misfits and other corpse material for a handful of crowns. Proper mercenaries are willing to join you less. Have 25 roster slots.[/p]"
        ru = "[p=c][img]gfx/ui/events/event_76.png[/img][/p][p]После многих лет изучения смерти вокруг себя, вы нашли способ обратить ее. В каком-то смысле.\n\n[color=#bcad8c]Персонаж игрока:[/color] Этот некромант — вы. Не умирайте, вас некому поднять.\n[color=#bcad8c]Изгой:[/color] Люди с подозрением относятся к вашему ремеслу. Стартовые отношения холодны, и ваши люди ожидают повышенной платы.\n[color=#bcad8c]Пушечное мясо:[/color] Вы всегда знаете где найти всяких калек, неудачников и прочего материала для трупов за горстку крон. Толковые наемники готовы присоединяться к вам реже. Вы можете нанять до 25 ребят.[/p]"
    }
    {
        en = "the Dark Master"
        ru = "Тёмный Мастер"
    }
    {
        en = "Your craft is not welcome"
        ru = "Ваше ремесло не приветствуется"
    }
    {
        en = "Disgrunted by undead"
        ru = "Недоволен нежитью"
    }
    // FILE: necro/scripts/skills/actives/necro_raise_undead.nut
    {
        id = "scripts/skills/actives/necro_raise_undead.Description"
        en = "Raises a corpse to fight for you as undead. Will attack your enemies but otherwise cannot really be controlled."
        ru = "Поднимает труп, чтобы он сражался за вас в качестве нежити."
           + "Атакует ваших врагов, но в остальном не поддаётся контролю."
    }
    {
        plural = "range"
        en = "Has a range of <range:int_tag> tiles"
        n1 = "Имеет дальность в <range> клетку"
        n2 = "Имеет дальность в <range> клетки"
        n5 = "Имеет дальность в <range> клеток"
    }
    // FILE: necro/scripts/skills/backgrounds/necro_background.nut
    {
        en = "Necromancer"
        ru = "Некромант"
    }
    {
        en = "the Necro"
        ru = "Некрота"
    }
    {
        en = "the Necromancer"
        ru = "Некромант"
    }
    {
        en = "Dark"
        ru = "Тёмный"
    }
    {
        en = "the Dark Mage"
        ru = "Тёмный Маг"
    }
    {
        en = "No morale check triggered upon allies dying"
        ru = "При гибели соратников не происходит проверки боевого духа"
    }
    {
        id = "scripts/skills/backgrounds/necro_background.onBuildDescription"
        en = "{Clothed in strangely colored robes, %name% appears to be more of an ambassador of the dark than a man of flesh and blood. | A curious fellow, %name% carries a slumped posture, as if he is weighted by otherworldly knowledge. | %name%'s face is hidden well inside the dark of his cowl, a crescent of yellow teeth the only notion that a man dwells within. | Not much is known about %name%, but strange rumors of sorcery and dark arts follow him. | Wherever animals mysteriously begin to die, %name% makes an appearance. | The brooches on %name%'s cloak seem to swirl and dance like midnight in a jug. | %name%'s hands are rare to see, only coming out as if to portray the feelings of his face which lies hidden deep in his hood. | %name%'s eyes could be mistaken for a cat's one day and for a blind man's the next.} {Little is known about whence he came. | From where he hails is but a mystery to most. | Some say he traveled deep into the northern foothills, returning with unspoken knowledge. | Ostensibly, the dark arts are his heritage, or so he puts on. | The man's past is kept from all. Maybe it's just uninteresting, or maybe just the opposite. | One rumor of the man says he traveled the land as a magician. | Rumors of magic surround the man, though some incredulous cynics are hardly impressed. | One rumor is that he was a conman, and another is that he's a sorcerer. You're not sure which you prefer. | With rumors of dark arts being practiced once more, the man's magical proclamation just might be true. | Some say he eats toads for breakfast and black cats for dinner.} {You ask %name% a lot of questions, but through some handwaves and nods, you realize you have forgotten his answers. Or did you ask the questions at all? | %name% produces a dove from his sleeve. An old trick that fancies no one - until it turns in the air, returning to him as a crow. | %name% has shown the ability to shoot smoke from his mouth. It's not fire, but it's close, and has people talking in hushed tones. | %name% floats a gold coin into the air. An amazing display that leaves the man too tired to attempt it again. | Predictions of the weather are common, but %name% is unusually accurate with his own. | %name% asks to read your palms. You decline. His presence alone is as close as you're willing to go. | %name% suggests that the stars are a roadmap to another world. He seems to know a lot about the heavens above. | %name% suggests that the heavens above are in fact just endless streams of beings, continuing on for eons. What a jest! | %name% points to one star in the sky and seems to suggest that is where he came from. You don't ask for a clarification on the matter.}"
        ru = "{Одетый в странно окрашенную мантию, %name% кажется скорее послом тьмы, чем человеком из плоти и крови. | Любопытный парень, %name% постоянно горбиться, как будто он отягощен потусторонним знанием. | Лицо %name% надежно скрыто в темноте его капюшона, полумесяц желтых зубов — единственное, что указывает на то, что внутри обитает человек. | О %name% известно немного, но странные слухи о колдовстве и темных искусствах преследуют его. | Где бы ни начинали таинственно умирать животные, %name% неподалёку. | Броши на плаще %name%, кажется, кружатся и танцуют, как полночь в кувшине. | Руки %name% редко можно увидеть, они появляются только для того, чтобы отобразить чувства вместо его лица, скрытого глубоко под капюшоном. | Глаза %name% можно было бы ошибочно принять за кошачьи в один день и за глаза слепого в другой.} {Мало что известно о том, откуда он пришел. | Откуда он родом, для большинства остается загадкой. | Говорят, что он путешествовал в глубь северных предгорий, вернувшись с тайными знаниями. | По-видимому, темные искусства — его наследие, или он просто делает вид, что это так. | Прошлое этого человека скрыто ото всех. Может быть, оно просто неинтересно, а может быть, как раз наоборот. | Есть слух, что он путешествовал по стране как фокусник. | Слухи о магии окружают этого человека, хотя некоторые циники не ждут чего-то затаив дыхание. | Один слух говорит о том, что он был мошенником, а другой — что он колдун. Вы не уверены, что вам больше нравится. | Учитывая все слухи о том, что темные искусства снова практикуются, болтовня этого человека о магии может оказаться правдой. | Поговаривают, что он ест жаб на завтрак и черных кошек на ужин.} {Вы задаете %name% много вопросов, но по взмахам рук и кивкам вы понимаете, что забыли его ответы. А вы вообще что-то спрашивали? | %name% достает голубя из рукава. Старый трюк, который никому не нравится - пока он не переворачивается в воздухе, возвращаясь к нему в виде вороны. | %name% продемонстрировал способность выпускать дым изо рта. Это не огонь, но он близок к этому, к нему предпочитают не лезть. | %name% заставляет золотую монету парить в воздухе. Удивительное зрелище, но это слишком утомительно, чтобы повторять. | Предсказания погоды распространены, но %name% необычайно точен в своих собственных. | %name% просит погадать вам по ладони. Вы отказываетесь. Его одного присутствия уже достаточно. | %name% предполагает, что звезды - это дорожная карта в другой мир. Кажется, он много знает о небесах. | %name% предполагает, что небеса на самом деле являются просто бесконечными потоками существ, продолжающимися в течение эонов. Что за шутка! | %name% указывает на одну звезду в небе и, кажется, предполагает, что именно оттуда он и пришел. Вы не просите разъяснений по этому вопросу.}"
    }
    // FILE: necro/scripts/skills/perks/perk_necro_flesh_of_iron.nut
        // en = "head"
        // en = "body"
    // FILE: necro/scripts/skills/perks/perk_necro_soul_link.nut
    {
        en = "Soul Link was activated!"
        ru = "Связь душ была активирована!"
    }
    // FILE: necro/scripts/skills/racial/necro_regeneration.nut
        // en = "Undead Regeneration"
        // en = "head"
        // en = "body"
    {
        mode = "pattern"
        en = "<actor:str_tag> heals for <hp:int> points and restores some armor"
        ru = "<actor> восстанавливает <hp> ОЗ и часть брони"
    }
    {
        mode = "pattern"
        en = "<actor:str_tag> heals for <hp:int> points"
        ru = "<actor> восстанавливает <hp> ОЗ"
    }
    {
        mode = "pattern"
        en = "<actor:str_tag> restores some armor"
        ru = "<actor> восстанавливает часть брони"
    }
]
::Rosetta.add(rosetta, pairs);
