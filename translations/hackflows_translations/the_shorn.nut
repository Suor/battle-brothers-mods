if (!("Rosetta" in getroottable())) return;
if (::Hooks.SQClass.ModVersion(::Rosetta.Version) < ::Hooks.SQClass.ModVersion("0.5.0")) return;

local rosetta = {
    mod = {id = "mod_the_shorn", version = "1.0.0"}
    author = "hackflow"
    lang = "ru"
}
local pairs = [
    // FILE: scripts/events/events/scenario/shorn_intro_event.nut
    // en = "A"
    {
        en = "[img]gfx/ui/events/event_107.png[/img]{Beasts beset civilisation at every turn, marauding and slaughtering innocents by the dozen. You were the commander of a troupe of beast hunters, dedicated to the defense of the common people. But that was years ago now. \n\n Your company was slaughtered by a hexe who commanded a legion of schrats. Only you and your second in command survived. Since then, the beasts have only gotten more numerous, and staying in retirement would be a dishonor on your fallen brothers. \n\n But a human is far too frail to battle the night. You must become more. Monsters for monsters. You enlist the help of your old second in command, another beast hunter, and an anatomist to build a company of things beyond humanity. \n\n You create the Shorn. }"
        ru = "[img]gfx/ui/events/event_107.png[/img]{Чудовища на каждом шагу теснят людей, разоряют деревни и режут невинных десятками. Когда-то вы водили отряд зверобоев, что стоял на защите простого люда. Но было это много лет назад. \n\n Ваш отряд вырезала ведьма, что повелевала целым войском леших. Выжили лишь вы да ваш заместитель. С тех пор чудищ стало только больше, и отсиживаться на покое значит позорить память павших братьев. \n\n Но человек слишком слаб, чтобы биться с ночью. Вы должны стать чем-то большим. Чудовища против чудовищ. Вы зовёте старого заместителя, ещё одного зверобоя и анатома, чтобы собрать отряд тех, кто уже не совсем люди. \n\n Так рождаются Стриженые. }"
    }
    {
        en = "The cost of evolution will be paid for in blood."
        ru = "За перерождение заплатим кровью."
    }
    {
        en = "A New Beginning"
        ru = "Новое начало"
    }
    // FILE: scripts/scenarios/world/shorn_scenario.nut
    {
        en = "The Shorn"
        ru = "Стриженые"
    }
    {
        en = "[p=c][img]gfx/ui/events/event_44.png[/img][/p][p]Two beast hunters and an anatomist walk into a bar, they decide to become monsters. The shorn are a group of monster hunters who work with anatomists to mutate themselves into something beyond human.\n\n[color=#bcad8c]Field Researchers:[/color] Start with a bad joke and low funds. Gain mutagens from fallen enemies. \n[color=#bcad8c]Promising Candidates:[/color] Characters come with the 'Resilient' perk. \n[color=#bcad8c]Skinners:[/color] Each beast you slay has a 25% chance to drop an additional trophy.\n[color=#bcad8c]Filthy Mutants:[/color] Get 25% worse prices.[/p]"
        ru = "[p=c][img]gfx/ui/events/event_44.png[/img][/p][p]Заходят как-то в трактир два зверобоя и анатом и решают стать чудовищами. Стриженые — охотники на чудовищ, которые с помощью анатомов перекраивают себя во что-то большее, чем человек.\n\n[color=#bcad8c]Полевые исследователи:[/color] Начните с несмешной шуткой и тощим кошельком. Добывайте мутагены из павших врагов. \n[color=#bcad8c]Подающие надежды:[/color] Все бойцы приходят с навыком «Выдержка». \n[color=#bcad8c]Живодёры:[/color] С каждого убитого чудовища на 25% выше шанс получить дополнительный трофей.\n[color=#bcad8c]Мерзкие мутанты:[/color] Покупаете на 25% дороже, продаёте на 25% дешевле.[/p]"
    }
    {
        en = "{You and %name% were the sole survivors of an ambush on your old company years ago, and if it wasn't for him, you would probably be dead too. They're one of the best fighters you've ever seen, and are a prime candidate to become one of the first shorn.}"
        ru = "{Много лет назад вы с %name% единственные пережили засаду, в которой полёг ваш старый отряд, и если бы не он, лежать бы вам там же. Лучшего бойца вы не встречали, и он первый кандидат в Стриженые.}"
    }
    {
        en = "Is back in business"
        ru = "Снова в деле"
    }
    {
        en = "{%name% is a damned good anatomist, and a bit of an odd sort, you'd have to be to go along with this plan. But their people are the only ones who knows how to extract the mutagens necessary to create a shorn, and for that sole reason, they are critical to your cause.}"
        ru = "{%name% — чертовски хороший анатом и немного чудак, а иначе на такую затею и не согласишься. Но только его братия умеет добывать мутагены, без которых Стриженых не создать, и уже поэтому без него вам не обойтись.}"
    }
    {
        en = "Eager to get started"
        ru = "Рвётся начать"
    }
    {
        en = "{A fellow beast hunter your old friend managed to string along, %name% seems decent enough. They're a good shot and if they're crazy enough to come along, they're perfect to become a shorn.}"
        ru = "{%name%, зверобой, которого старый друг сумел уговорить пойти с вами, кажется вполне толковым. Стреляет он метко, а раз уж хватило безумия ввязаться в это, из него выйдет отличный Стриженый.}"
    }
    {
        en = "Is unsure of this plan"
        ru = "Сомневается в этой затее"
    }
]
::Rosetta.add(rosetta, pairs);
