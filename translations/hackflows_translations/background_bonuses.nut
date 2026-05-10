if (!("Rosetta" in getroottable())) return;
if (::Hooks.SQClass.ModVersion(::Rosetta.Version) < ::Hooks.SQClass.ModVersion("0.4.0")) return;

local rosetta = {
    mod = {id = "backgroundBonuses", version = "1.11"}
    author = "hackflow"
    lang = "ru"
}
local pairs = [
    // FILE: scripts/!mods_preload/mod_backgroundBonuses_combined.nut
    // en = "Background Bonuses"  // mod name, not user-facing
    {
        en = "Gain ranged defense equal to 10% of resolve."
        ru = "Защита в дальнем бою увеличивается на 10% от Решимости."
    }
    {
        en = "All allies regain +1 hitpoints at the start of this unit's turn."
        ru = "Все союзники восстанавливают +1 ОЗ в начале хода этого персонажа."
    }
    {
        // this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " heals all allies for 1 HP.");
        mode = "pattern"
        en = "<actor:str_tag> heals all allies for 1 HP."
        ru = "<actor> лечит всех союзников на 1 ОЗ."
    }
    {
        en = "Continue gaining stats and perks until level 12."
        ru = "Продолжает получать характеристики и навыки до 12 уровня."
    }
    {
        en = "All dagger attacks ignore 100% of armor."
        ru = "Все удары кинжалом игнорируют 100% брони."
    }
    {
        en = "Melee damage has +15% more armor piercing against enemies who are stunned, dazed, distracted, webbed, rooted, or netted."
        ru = "Урон в ближнем бою пробивает на +15% больше брони по врагам, оглушённым, с выбитым духом, отвлечённым, опутанным паутиной, обездвиженным или пойманным в сеть."}
    {
        en = "Heals for 20% of damage dealt."
        ru = "Восстанавливает 20% от нанесённого урона в виде ОЗ."
    }
    {
        en = "Deals 15% increased damage to Noble House enemies."
        ru = "Наносит на 15% больше урона врагам знатных домов."
    }
    {
        en = "Deals 15% increased damage to beasts."
        ru = "Наносит на 15% больше урона зверям."
    }
    {
        en = "Gain one extra perk point."
        ru = "Получает одно дополнительное очко навыка."
    }
    {
        en = "Deal 5 non-lethal damage to enemies whenever this character dodges their attack."
        ru = "При уклонении наносит 5 единиц нелетального урона атакующему."
    }
    {
        // this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_attacker) + " takes 5 damage.");
        mode = "pattern"
        en = "<attacker:str_tag> takes 5 damage."
        ru = "<attacker> получает 5 урона."
    }
    {
        en = "Deals +1 additional damage with each tile distant from target."
        ru = "+1 к урону за каждую клетку расстояния до цели."
    }
    {
        en = "Accumulates 50% less fatigue from enemy attacks, whether they hit or miss."
        ru = "Накапливает на 50% меньше усталости от вражеских атак, вне зависимости от попадания."
    }
    {
        en = "Applies one additional stack of bleeding whenever dealing damage, regardless of weapon."
        ru = "При каждом попадании накладывает дополнительный стак кровотечения, независимо от оружия."
    }
    {
        en = "Deals 15% increased damage to bandits."
        ru = "Наносит на 15% больше урона бандитам."
    }
    {
        en = "Increase all stats by +2."
        ru = "+2 ко всем характеристикам."
    }
    {
        en = "All single-target weapon skills, melee and ranged, have +1 max range."
        ru = "Все одноцелевые умения оружия, ближнего и дальнего боя, получают +1 к максимальному радиусу."
    }
    {
        en = "Gain +2 to all stats for each injury."
        ru = "+2 ко всем характеристикам за каждую травму."
    }
    {
        en = "Deals 30% increased damage to undead."
        ru = "Наносит на 30% больше урона нежити."
    }
    {
        en = "Has a positive morale check upon allies dying."
        ru = "Получает положительную проверку боевого духа при гибели союзников."
    }
    {
        en = "Increase base fatigue by 30%. Regain -3 fatigue each turn."
        ru = "Базовая выносливость увеличивается на 30%. Восстанавливает на 3 выносливости меньше за ход."
    }
    {
        en = "Deals 20% increased damage when wavering, and 40% increased damage when breaking."
        ru = "Наносит на 20% больше урона при нерешительном боевом духе и на 40% при сломленном."
    }
    {
        en = "The effects of a positive morale state are twice as strong. The effects of negative morale states are 50% stronger."
        ru = "Эффекты положительного боевого духа вдвое сильнее. Эффекты отрицательного боевого духа на 50% сильнее."
    }
    {
        en = "The effects of negative morale states are 25% weaker."
        ru = "Эффекты отрицательного боевого духа на 25% слабее."
    }
    {
        en = "Will always be at confident morale."
        ru = "Всегда находится в решительном боевом духе."
    }
    {
        en = "Always gains the effects of confident morale, and will never be below steady morale."
        ru = "Всегда получает эффекты решительного боевого духа и никогда не опускается ниже уравновешенного."
    }
    {
        en = "Immune to charm, fear, and other mental effects."
        ru = "Невосприимчив к обаянию, страху и другим ментальным эффектам."
    }
    {
        en = "Increases base fatigue by 10%. Gain +5% chance to hit with pitchforks and hooked blades."
        ru = "Базовая выносливость увеличивается на 10%. +5% к шансу попасть вилами и крюками."
    }
    {
        en = "Increases base fatigue by 10%."
        ru = "Базовая выносливость увеличивается на 10%."
    }
    {
        en = "Can throw nets for 0 ap."
        ru = "Может бросать сети за 0 ОД."
    }
    {
        en = "Has a positive morale check upon taking damage."
        ru = "Получает положительную проверку боевого духа при получении урона."
    }
    {
        en = "Gain % bonus damage equal to % health lost."
        ru = "Бонус к урону в % равен % потерянного здоровья."
    }
    {
        en = "Roll the dice upon leveling. On a 1, stats increase by 1. On a 2-5, stats increase normally. On a 6, stats increase by maximum values +1."
        ru = "При повышении уровня бросает кости. На 1 — характеристики растут на 1. На 2–5 — нормально. На 6 — до максимума +1."
    }
    {
        en = "Gain 0.3% bonus damage in melee for each other unit, ally and enemy, not currently engaged in melee."
        ru = "+0,3% к урону в ближнем бою за каждый юнит, союзника или врага, не вступившего в ближний бой."
    }
    {
        en = "Gain +1 max fatigue for each ally who has died, up to +30."
        ru = "+1 к выносливости за каждого погибшего союзника, до +30."
    }
    {
        en = "Gain +1 head and body armor for each ally who has died, up to +30."
        ru = "+1 к прочности шлема и доспеха за каждого погибшего союзника, до +30."
    }
    {
        en = "Reduces armor penetrating damage by 10%."
        ru = "Снижает пробивающий броню урон на 10%."
    }
    {
        en = "Has access to perks three tiers higher than this character's level."
        ru = "Может брать навыки на три уровня выше текущего уровня персонажа."
    }
    {
        en = "Can release hounds for 0 ap."
        ru = "Может спускать гончих за 0 ОД."
    }
    {
        en = "Vision is increased by +2."
        ru = "Обзор увеличен на +2."
    }
    {
        en = "Gives +2 max fatigue to each other non-indebted in the party."
        ru = "+2 к выносливости каждому бойцу кроме рабов."
    }
    {
        en = "Currently equipped throwing items that use ammo regain 1 ammo each turn."
        ru = "Снаряжённые метательные предметы с боеприпасами восстанавливают 1 заряд каждый ход."
    }
    {
        // this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " gains one extra ammo.");
        mode = "pattern"
        en = "<actor:str_tag> gains one extra ammo."
        ru = "<actor> получает дополнительный заряд."
    }
    {
        en = "Deals an additional +15% damage in melee on hits to the head."
        ru = "+15% к урону в ближнем бою при попаданиях по голове."
    }
    {
        en = "Gains +3 action points each round."
        ru = "+3 ОД каждый ход."
    }
    {
        en = "Immune to stuns and knockbacks. Deals +30% bonus melee damage to higher leveled enemies."
        ru = "Невосприимчив к оглушениям и отбрасываниям. +30% к урону в ближнем бою по врагам более высокого уровня."
    }
    {
        en = "Axe skills cost 3 less fatigue."
        ru = "Умения топоров стоят на 3 меньше выносливости."
    }
    {
        en = "Whip skills cost 2 less fatigue and gain +5 chance to hit."
        ru = "Умения с кнутом стоят на 2 выносливости меньше и дают +5 к шансу попасть."
    }
    {
        en = "Base melee defense is increased by 50%. Melee skill is reduced by the same amount."
        ru = "Базовая защита в ближнем бою увеличивается на 50%. Навык ближнего боя снижается на столько же."
    }
    {
        en = "Reduces fatigue cost of movement by 50%."
        ru = "Стоимость передвижения в выносливости снижается на 50%."
    }
    {
        en = "Deals 15% increased damage when allies outnumber enemies."
        ru = "Наносит на 15% больше урона, когда союзников больше, чем врагов."
    }
    {
        en = "Gains HP equal to 15% of max fatigue."
        ru = "Получает ОЗ, равные 15% максимальной выносливости."
    }
    {
        en = "Deals an additional 10% damage to armor."
        ru = "Дополнительные 10% урона по броне."
    }
    {
        en = "Restores +3 fatigue to all allies if wielding a lute at the start of this unit's turn."
        ru = "Восстанавливает +3 выносливости всем союзникам в начале хода, если держит лютню."
    }
    {
        // this.Tactical.EventLog.log("All allies regain 3 fatigue from " + this.Const.UI.getColorizedEntityName(actor) + "'s song!");
        mode = "pattern"
        en = "All allies regain 3 fatigue from <actor:str_tag>'s song!"
        ru = "Все союзники восстанавливают 3 выносливости от песен <actor>!"
    }
    {
        en = "Immune to bleeding."
        ru = "Невосприимчив к кровотечению."
    }
    {
        en = "Deals 15% increased damage if moved this turn. Deals 10% less damage otherwise."
        ru = "Наносит на 15% больше урона, если двигался в этот ход. Иначе — на 10% меньше."
    }
    {
        en = "Deals 15% increased damage against adjacent enemies who aren't surrounded by any of the oathtaker's allies."
        ru = "Наносит на 15% больше урона соседним врагам, не окружённым союзниками клятвенника."
    }
    {
        en = "Deals 30% increased damage to greenskins."
        ru = "Наносит на 30% больше урона зеленокожим."
    }
    {
        en = "Gain +1 head and body armor per 1000 gold, up to +50."
        ru = "+1 к прочности шлема и доспеха за каждые 1000 крон в казне, до +50."
    }
    {
        en = "All allies start combat at one higher morale state."
        ru = "Все союзники начинают бой на одну ступень боевого духа выше."
    }
    {
        en = "All allies gain morale!"
        ru = "Все союзники воспрянули духом!"
    }
    {
        en = "Deals 15% increased ranged damage if no allies are adjacent."
        ru = "Наносит на 15% больше урона в дальнем бою, если нет соседних союзников."
    }
    {
        en = "Deals 15% increased damage to settlement and caravan factions."
        ru = "Наносит на 15% больше урона фракциям поселений и торговых обозов."
    }
    {
        en = "Can always apply poison for 0 ap. Gain +5 melee skill when using poisoned weapons."
        ru = "Всегда может наносить яд за 0 ОД. +5 к навыку ближнего боя при использовании отравленного оружия."
    }
    {
        en = "-1 ap per tile moved, but fatigue cost of movement is increased by 50%."
        ru = "-1 ОД за клетку при движении, но стоимость в выносливости увеличивается на 50%."
    }
    {
        en = "Immune to 'Overwhelm' effect."
        ru = "Невосприимчив к эффекту «Подавление»."
    }
    {
        en = "Increases damage dealt by a percentage equal to 10% of daily wage."
        ru = "Урон увеличивается на %, равный 10% дневной платы."
    }
    {
        en = "Less likely to be targeted by enemies."
        ru = "Реже становится целью врагов."
    }
    {
        en = "Can use slings in melee range. Gain +10% chance to hit with slings."
        ru = "Может использовать пращу в ближнем бою. +10% к шансу попасть из пращи."
    }
    {
        en = "Can use slings in melee range."
        ru = "Может использовать пращу в ближнем бою."
    }
    {
        en = "Gain +1 melee skill per 20 days with the company, up to +30 melee skill."
        ru = "+1 к навыку ближнего боя за каждые 20 дней в отряде, до +30."
    }
    {
        en = "Has +1% armor piercing for every 5 initiative the user is faster than the target."
        ru = "+1% пробивания брони за каждые 5 инициативы преимущества над целью."
    }
    {
        en = "Fully repairs their armor at the end of each battle."
        ru = "Полностью чинит броню в конце каждого боя."
    }
    {
        en = "Gain 10 crowns on each hit against non-beast enemies."
        ru = "+10 крон за каждое попадание по небестиальным врагам."
    }
    {
        en = "Gain +5% damage for each tile moved this turn."
        ru = "+5% к урону за каждую пройденную в этот ход клетку."
    }
    {
        en = "Doubles max health when wearing neither head nor body armor."
        ru = "Максимальное ОЗ удваивается, если не надеты ни шлем, ни броня."
    }
    {
        en = "Gains +1 max range with crossbows."
        ru = "+1 к максимальному радиусу стрельбы из арбалета."
    }
    {
        en = "When using crossbows, hits knock targets back one tile."
        ru = "При использовании арбалета попадания отбрасывают цель на одну клетку."
    }
    {
        en = "An additional 15% of damage from crossbows ignores armor."
        ru = "Дополнительные 15% урона от арбалетов игнорируют броню."
    }
    {
        en = "Cannot receive addict trait. Deals 25% increased damage when drunk."
        ru = "Не может получить черту «Пьяница». Наносит на 25% больше урона в состоянии опьянения."
    }
    {
        en = "Increase max HP by +2 upon being hit. Bonus lasts until end of battle."
        ru = "При получении удара максимальное ОЗ увеличивается на +2. Бонус действует до конца боя."
    }
    {
        en = "The company's currently equipped weapons regain +10 durability at the end of combat."
        ru = "Снаряжённое оружие отряда восстанавливает +10 прочности в конце боя."
    }
    {
        en = "Much more likely to be targeted by enemies."
        ru = "Значительно чаще становится целью врагов."
    }
    {
        en = "Gain 50 crowns for each kill. Reward is 10x larger for champion kills."
        ru = "+50 крон за каждое убийство. Награда в 10 раз больше за убийство чемпионов."
    }
    {
        // this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " gains the company 500 crowns for killing " + this.Const.UI.getColorizedEntityName(_victim) + ".");
        mode = "pattern"
        en = "<actor:str_tag> gains the company <n:int> crowns for killing <victim:str_tag>."
        ru = "<actor> приносит отряду <n> крон, убив <victim>."
    }
    {
        en = "Melee and ranged defense of this unit's equipped shield is increased by 25%, and by 50% when using shieldwall."
        ru = "Защита щита в ближнем и дальнем бою увеличивается на 25%, и на 50% при «Стене щитов»."
    }
    {
        en = "Attacks gain 2% chance to hit with each tile distant from the target."
        ru = "+2% к шансу попасть за каждую клетку расстояния до цели."
    }
    {
        en = "Gain +7 to all stats if this unit is the furthest forward in the party."
        ru = "+7 ко всем характеристикам, если стоит ближе всего к врагу в отряде."
    }
    {
        en = "Builds up three less fatigue for each tile traversed."
        ru = "Накапливает на 3 меньше усталости за каждую пройденную клетку."
    }
    {
        en = "Any attack which deals at least 5 HP damage applies the distracted effect."
        ru = "Любая атака с уроном не менее 5 ОЗ применяет эффект «Отвлечён»."
    }
    {
        en = "Is immune to fire damage and consumes no food from the stash."
        ru = "Невосприимчив к урону от огня и не потребляет еду из запасов."
    }
    {
        en = "Morale checks from attacks made by this unit have a penalty to the target's resolve equal to 10% of this unit's resolve."
        ru = "Проверки боевого духа от атак этого персонажа накладывают штраф к решимости цели, равный 10% его решимости."
    }
    {
        en = "Gain +3 initiative for each tile distant this unit is from it's tile on battle start, up to +60."
        ru = "+3 к инициативе за каждую клетку от начальной позиции, до +60."
    }
    {
        en = "On turn start, gain a bonus depending on the terrain of starting tile."
        ru = "В начале хода получает бонус в зависимости от местности стартовой клетки."
    }
    {
        en = "No bonus when starting the turn on this terrain."
        ru = "Нет бонуса при начале хода на этой местности."
    }
    {
        en = "Snow bonus: When starting the turn on this tile, the first attack this turn chills the target on hit."
        ru = "Бонус снега: первая атака в ход при попадании замораживает цель."
    }
    {
        en = "Water bonus: When starting the turn on this tile, restore 10 HP."
        ru = "Бонус воды: восстанавливает 10 ОЗ."
    }
    {
        en = "Swamp bonus: When starting the turn on this tile, the first attack this turn poisons the target on hit."
        ru = "Бонус болота: первая атака в ход при попадании отравляет цель."
    }
    {
        en = "Desert bonus: When starting the turn on this tile, the first attack this turn burns the target tile on hit."
        ru = "Бонус пустыни: первая атака в ход при попадании поджигает клетку цели."
    }
    {
        en = "Rocky bonus: When starting the turn on this tile, the threshold to inflict injuries for this turn is reduced by 50% (stacks with crippling strikes)."
        ru = "Бонус скал: порог нанесения травм снижается на 50% (суммируется с «Калечащими ударами»)."
    }
    {
        en = "Forest bonus: When starting the turn on this tile, the first attack this turn roots the target tile on hit."
        ru = "Бонус леса: первая атака в ход при попадании обездвиживает цель."
    }
    {
        en = "Plains bonus: When starting the turn on this tile, melee and ranged defense are increased by 15% of initiative."
        ru = "Бонус равнины: защита в ближнем и дальнем бою увеличивается на 15% инициативы."
    }
    {
        en = "fire"
        ru = "огонь"
    }
    {
        en = "Fire rages here, melting armor and flesh alike"
        ru = "Здесь бушует огонь, пожирающий броню и плоть"
    }
    {
        // this.Tactical.EventLog.log("For starting the turn in water, " + getColorizedEntityName(actor) + " regains 10 HP.");
        mode = "pattern"
        en = "For starting the turn in water, <actor:str_tag> regains 10 HP."
        ru = "Начав ход в воде, <actor> восстанавливает 10 ОЗ."
    }
    {
        // this.Tactical.EventLog.log("For starting the turn in snow, " + getColorizedEntityName(actor) + "'s first attack will chill on hit.");
        mode = "pattern"
        en = "For starting the turn in snow, <actor:str_tag>'s first attack will chill on hit."
        ru = "Начав ход на снегу, первая атака <actor> при попадании замораживает цель."
    }
    {
        // this.Tactical.EventLog.log("For starting the turn in swamp, " + getColorizedEntityName(actor) + "'s first attack will poison on hit.");
        mode = "pattern"
        en = "For starting the turn in swamp, <actor:str_tag>'s first attack will poison on hit."
        ru = "Начав ход на болоте, первая атака <actor> при попадании отравляет цель."
    }
    {
        // this.Tactical.EventLog.log("For starting the turn in desert, " + getColorizedEntityName(actor) + "'s first attack will ignite the target tile on hit.");
        mode = "pattern"
        en = "For starting the turn in desert, <actor:str_tag>'s first attack will ignite the target tile on hit."
        ru = "Начав ход в пустыне, первая атака <actor> при попадании поджигает клетку цели."
    }
    {
        // this.Tactical.EventLog.log("For starting the turn on stone, " + getColorizedEntityName(actor) + "'s attacks have a 50% lowered threshold to inflict injuries.");
        mode = "pattern"
        en = "For starting the turn on stone, <actor:str_tag>'s attacks have a 50% lowered threshold to inflict injuries."
        ru = "Начав ход на камне, атаки <actor> имеют порог нанесения травм ниже на 50%."
    }
    {
        // this.Tactical.EventLog.log("For starting the turn in plains, " + getColorizedEntityName(actor) + " gains melee and ranged defense equal to 15% of initiative.");
        mode = "pattern"
        en = "For starting the turn in plains, <actor:str_tag> gains melee and ranged defense equal to 15% of initiative."
        ru = "Начав ход на равнине, <actor> получает защиту в ближнем и дальнем бою, равную 15% инициативы."
    }
    {
        // this.Tactical.EventLog.log("For starting the turn in forest, " + getColorizedEntityName(actor) + "'s first attack will root the target on hit");
        mode = "pattern"
        en = "For starting the turn in forest, <actor:str_tag>'s first attack will root the target on hit"
        ru = "Начав ход в лесу, первая атака <actor> при попадании обездвиживает цель."
    }
    {
        en = "Can release falcons for free."
        ru = "Может выпускать соколов бесплатно."
    }
    {
        en = "This unit's equipped quiver refills one arrow at the start of each turn."
        ru = "Снаряжённый колчан пополняется на одну стрелу в начале каждого хода."
    }
    {
        // this.Tactical.EventLog.log(getColorizedEntityName(this.getContainer().getActor()) + " regains 1 ammo.");
        mode = "pattern"
        en = "<actor:str_tag> regains 1 ammo."
        ru = "<actor> восстанавливает 1 заряд."
    }
    {
        en = "Gain +1 to either melee skill, melee defense, fatigue, or resolve for each kill made during settlement defense contracts."
        ru = "+1 к навыку ближнего боя, защите в ближнем бою, выносливости или решимости за каждое убийство в контрактах по обороне поселений."
    }
    {
        // text = "Gain +1 to either melee skill, melee defense, fatigue, or resolve for each kill made during settlement defense contracts. Current bonuses: " + mSkillBonus + " Melee Skill, " + mDefBonus + " Melee Defense, " + stamBonus + " Fatigue, " + bravBonus + " Resolve."
        mode = "pattern"
        en = "Gain +1 to either melee skill, melee defense, fatigue, or resolve for each kill made during settlement defense contracts. Current bonuses: <ms:int> Melee Skill, <md:int> Melee Defense, <st:int> Fatigue, <br:int> Resolve."
        ru = "+1 к навыку ближнего боя, защите в ближнем бою, выносливости или решимости за убийство в контрактах обороны поселений. Текущие бонусы: <ms> навык, <md> защита в ближнем бою, <st> выносливость, <br> решимость."
    }
    {
        // this.Tactical.EventLog.log(getColorizedEntityName(actor) + " gains +1 permanent max fatigue.");
        mode = "pattern"
        en = "<actor:str_tag> gains +1 permanent max fatigue."
        ru = "<actor> навсегда получает +1 к выносливости."
    }
    {
        // this.Tactical.EventLog.log(getColorizedEntityName(actor) + " gains +1 permanent max resolve.");
        mode = "pattern"
        en = "<actor:str_tag> gains +1 permanent max resolve."
        ru = "<actor> навсегда получает +1 к максимальной решимости."
    }
    {
        // this.Tactical.EventLog.log(getColorizedEntityName(actor) + " gains +1 permanent melee skill.");
        mode = "pattern"
        en = "<actor:str_tag> gains +1 permanent melee skill."
        ru = "<actor> навсегда получает +1 к навыку ближнего боя."
    }
    {
        // this.Tactical.EventLog.log(getColorizedEntityName(actor) + " gains +1 permanent melee defense.");
        mode = "pattern"
        en = "<actor:str_tag> gains +1 permanent melee defense."
        ru = "<actor> навсегда получает +1 к защите в ближнем бою."
    }
    {
        en = "This unit's stats become the average of their own stats with the stats of all adjacent allies."
        ru = "Характеристики персонажа становятся средним между его собственными и характеристиками всех соседних союзников."
    }
    {
        en = "Gain +3 resolve for each unit that has died this combat."
        ru = "+3 к решимости за каждый погибший в этом бою юнит."
    }
    {
        en = "Can bandage allies for 0 ap, and can bandage allies up to two tiles distant."
        ru = "Может перевязывать союзников за 0 ОД, в том числе на расстоянии до двух клеток."
    }
    {
        en = "Spears and polearms deal an additional 20% damage to armor."
        ru = "Копья и древковое оружие наносят дополнительные 20% урона по броне."
    }
    {
        en = "Deals 10% of max HP to all adjacent units at the start of this unit's turn as non-lethal damage (only affects units who can bleed)."
        ru = "В начале хода наносит 10% от максимальных ОЗ всем соседним юнитам как нелетальный урон (только юнитам, способным истекать кровью)."
    }
    {
        // this.Tactical.EventLog.log(getColorizedEntityName(actor) + " deals " + Math.floor(actor.getHitpointsMax() * 0.1) + " damage to all adjacent units.");
        mode = "pattern"
        en = "<actor:str_tag> deals <n:int> damage to all adjacent units."
        ru = "<actor> наносит <n> урона всем соседним юнитам."
    }
    {
        en = "Always deals a minimum of 5 HP damage with each hit."
        ru = "Каждое попадание наносит не менее 5 урона по ОЗ."
    }
    {
        en = "The penalty to hitchance from obstructed line-of-sight is reduced by 20%."
        ru = "Штраф к шансу попасть из-за перекрытой линии видимости снижается на 20%."
    }
    {
        en = "Gain +10% chance to hit bleeding enemies."
        ru = "+10% к шансу попасть по истекающим кровью врагам."
    }
    {
        en = "Gain +1 to all stats for each tile distant from the nearest ally, up to +15."
        ru = "+1 ко всем характеристикам за каждую клетку расстояния от ближайшего союзника, до +15."
    }
    {
        en = "Gains +15 to all stats. This bonus is lost upon dealing or receiving damage."
        ru = "+15 ко всем характеристикам. Бонус теряется при нанесении или получении урона."
    }
    {
        en = "Reduce damage received to armor and health by a flat amount equal to 2% of resolve."
        ru = "Снижает получаемый урон по броне и ОЗ на фиксированную величину, равную 2% решимости."
    }
    {
        en = "Swapping to a handgonne automatically reloads it. Firing the handgonne costs +2 ap."
        ru = "Переключение на пищаль автоматически перезаряжает её. Выстрел из пищали стоит на +2 ОД больше."
    }
    {
        en = "Gains an additional +10% chance to hit for each level of height advantage over the target."
        ru = "+10% к шансу попасть за каждый уровень высотного преимущества над целью."
    }
    {
        en = "The first attack each turn with a throwing item (except for slings) costs -2 AP."
        ru = "Первая атака метательным предметом в ход (кроме пращи) стоит на 2 ОД меньше."
    }
    {
        en = "On turn start, heal the lowest % HP adjacent ally 50% of their missing HP."
        ru = "В начале хода лечит соседнего союзника с наименьшим % ОЗ на 50% недостающего здоровья."
    }
    {
        en = "Deals 25% increased damage, but will never reduce enemies below 1 HP (unless they were already at 1 hp)."
        ru = "Наносит на 25% больше урона, но не снижает ОЗ врагов ниже 1 (если они уже не были на 1 ОЗ)."
    }
    {
        en = "Gains +5 melee skill and melee defense after waiting."
        ru = "+5 к навыку и защите в ближнем бою после ожидания."
    }
    {
        en = "When nothing is equipped in the offhand, follow up each attack against adjacent targets with a clawed swipe."
        ru = "Если левая рука пуста, каждая атака соседней цели дополняется ударом когтями."
    }
    {
        en = "Does not trigger attacks when moving through zone of control."
        ru = "Не вызывает атак при движении через зону контроля."
    }
    {
        en = "Any skill book skills that cost AP have their AP cost reduced by 2, to a minimum of 0."
        ru = "Стоимость умений из книг навыков снижается на 2 ОД (минимум 0)."
    }
    {
        en = "Gains +1 AP when wielding goblin weapons, doubled when famed."
        ru = "+1 ОД при использовании гоблинского оружия, удваивается когда прославлен."
    }
    // en = "<weapon.getID().find(goblin)!=null>"  // internal identifier
    {
        en = "On hits that deal at least 10 HP damage, apply a stacking poison that reduces target's AP by one for one turn."
        ru = "При попаданиях с уроном не менее 10 ОЗ накладывает суммирующийся яд, снижающий ОД цели на 1 на один ход."
    }
    {
        en = "Gain +7 to all stats, and -1 to all stats at the end of each round."
        ru = "+7 ко всем характеристикам, и -1 ко всем характеристикам в конце каждого раунда."
    }
    {
        en = "Immune to stuns and knockbacks, and suffers no fatigue penalty for using orc weapons."
        ru = "Невосприимчив к оглушениям и отбрасываниям, нет штрафа к выносливости при использовании орочьего оружия."
    }
    {
        en = "Base fatigue is reduced by 70%. Skills and movement consume no fatigue."
        ru = "Базовая выносливость снижается на 70%. Умения и движение её не тратят."
    }
    {
        en = "Upon being attacked by an adjacent entity, will attempt to move to an empty adjacent tile while ignoring ZOC."
        ru = "При атаке соседним существом пытается переместиться на свободную соседнюю клетку, игнорируя зону контроля."
    }
    {
        en = "Gains +1 to all stats for each controlled undead."
        ru = "+1 ко всем характеристикам за каждую подконтрольную нежить."
    }
]
::Rosetta.add(rosetta, pairs);
