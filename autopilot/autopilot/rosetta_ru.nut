if (!("Rosetta" in getroottable())) return;
if (::Hooks.SQClass.ModVersion(::Rosetta.Version) < ::Hooks.SQClass.ModVersion("0.4.0")) return;

local rosetta = {
    mod = {id = "mod_autopilot_new", version = "2.8.0"}
    author = "hackflow"
    lang = "ru"
}
local pairs = [
    // FILE: autopilot/hooks/tooltip_events.nut
    {
        en = "Mass Wait Turn (H)"
        ru = "Массовое ожидание (H)"
    }
    {
        en = "Pauses all characters' turns and moves them to the end of the queue, if they haven't waited already. Waiting this turn will also have them act later next round."
        ru = "Откладывает ход всех бойцов, ещё не ждавших в этом раунде, и отправляет их в конец очереди. Ожидание в этом ходу отодвинет их и в следующем раунде."
    }
    {
        en = "Ignore"
        ru = "Игнорировать"
    }
    {
        en = "Ends this character's turn and causes him to be ignored on future turns."
        ru = "Завершает ход бойца и заставляет пропускать его на последующих ходах."
    }
    {
        en = "Cancel (V)"
        ru = "Отмена (V)"
    }
    {
        en = "Cancels effects such as End Round, Mass Wait, Mass Shield Wall, Ignore, and AI Control."
        ru = "Отменяет такие действия, как Конец раунда, Массовое ожидание, Массовую стену щитов, Игнорирование и Управление ИИ."
    }
    {
        en = "Mass Shield Wall (N)"
        ru = "Массовая стена щитов (N)"
    }
    {
        en = "Makes all characters automatically use the Shieldwall skill at the start of their turn this round, if possible."
        ru = "Заставляет всех бойцов в этом раунде автоматически вставать в Стену щитов в начале своего хода, если это возможно."
    }
    {
        en = "AI Control (Q)"
        ru = "Управление ИИ (Q)"
    }
    {
        en = "Give control of the party to the AI."
        ru = "Передаёт управление отрядом ИИ."
    }
    // FILE: autopilot/hooks/turn_sequence_bar.nut — showDialogPopup, via Rosetta's dialog_screen hook
    {
        en = "Wait"
        ru = "Ожидание"
    }
    {
        en = "Have all your characters wait until the second phase?"
        ru = "Отложить ход всех бойцов до второй фазы?"
    }
    {
        en = "Shield Wall"
        ru = "Стена щитов"
    }
    {
        en = "Have all your characters shieldwall this turn if they can?"
        ru = "Поставить всех бойцов в стену щитов в этом ходу, если возможно?"
    }
    {
        en = "AI Control"
        ru = "Управление ИИ"
    }
    {
        en = "Turn control over to the AI?"
        ru = "Передать управление ИИ?"
    }
    {
        // text = "Switch to " + item.getName()
        mode = "pattern"
        en = "Switch to <item:str>"
        ru = "Сменить на <item:t>"
    }
    {
        en = "Quickly switch to another item from your bag."
        ru = "Быстро сменить предмет на другой из сумки."
    }
    {
        // text = "Costs [b]" + ::std.Text.positive(cost) + "[/b] AP to switch."
        mode = "pattern"
        en = "Costs [b]<cost:int_tag>[/b] AP to switch."
        ru = "Смена стоит [b]<cost>[/b] ОД."
    }
    // FILE: scripts/!mods_preload/mod_autopilot_new.nut
    {
        en = "Autopilot New"
        ru = "Автопилот New"
    }
    {
        en = "Autopilot"
        ru = "Автопилот"
    }
    {
        en = "Auto Player Characters"
        ru = "Автопилот для игровых персонажей"
    }
    {
        en = "Uncheck this for autopilot mode to skip Player Characters"
        ru = "Снимите галочку, чтобы автопилот пропускал игровых персонажей"
    }
    {
        en = "Behaviors"
        ru = "Поведение"
    }
    {
        en = "Let The Dogs Out"
        ru = "Спустить псов"
    }
    {
        en = "Use dogs in autopilot mode"
        ru = "Использовать псов в режиме автопилота"
    }
    {
        en = "Throw Nets"
        ru = "Метать сети"
    }
    {
        en = "Use Throwing Nets when in autopilot mode"
        ru = "Использовать метательные сети в режиме автопилота"
    }
    {
        en = "Auto break free and wake up"
        ru = "Авто-освобождение и пробуждение"
    }
    {
        en = "Auto break free out of nets and webs and wake allies when unused AP left"
        ru = "Автоматически вырываться из сетей и паутины и будить союзников, когда остаются неиспользованные ОД"
    }
    {
        en = "Auto reload"
        ru = "Авто-перезарядка"
    }
    {
        en = "Auto reload when unused AP left"
        ru = "Автоматически перезаряжаться, когда остаются неиспользованные ОД"
    }
    {
        en = "Verbose AI"
        ru = "Подробный лог ИИ"
    }
    {
        en = "Show AI debugging for auto bros"
        ru = "Показывать отладку ИИ для автоматических бойцов"
    }
    // Internal ActorRef suffix used only in warning/crash messages — not user-facing.
    // FILE: autopilot/fixes.nut
    // en = " of <_obj.getName()>"
    // Verbose-mode AI debug logs (snh_log), shown only with VerboseMode — not user-facing.
    // FILE: scripts/ai/autopilot_step_n_hit.nut
    // en = "step_n_hit: "
    // en = "no melee weapon"
    // en = "AP below auto-end threshold"
    // en = "no known opponent"
    // en = "fleeing"
    // en = "rooted"
    // en = "in opponent ZoC (would AoO on leave)"
    // en = "no candidates (examined=<examined> rej notEmpty=<rejNotEmpty> occupied=<rejOccupied> zoc=<rejZoc> skillUsable=<rejSkillUsable> danger=<rejDanger> noPath=<rejNoPath> costIncomplete=<rejCostIncomplete> wrongEnd=<rejWrongEnd> overBudget=<rejOverBudget> targetValue=<rejTargetValue>) myDanger=<myDanger> skill=<skill.getID()> fullAP=<fullAP> fullFat=<fullFat> apForAttack=<apForAttack>"
    // en = "picked dest=(<choice.Tile.SquareCoords.X>,<choice.Tile.SquareCoords.Y>) target=<choice.Target.getName()> skill=<choice.Skill.getID()> innerScore=<choice.Score> mult(behavior=<behaviorMult> fatigue=<fatigueMult>) finalScore=<finalScore> candidates=<candidates.len()> maxInner=<maxScore>"
    // en = "execute: target=(<this.m.TargetTile.SquareCoords.X>,<this.m.TargetTile.SquareCoords.Y>) attacking=<this.m.TargetActor.getName()> ap=<_entity.getActionPoints()> fat=<_entity.getFatigue()>/<_entity.getFatigueMax()> skillAP=<this.m.Skill.getActionPointCost()> skillFat=<this.m.Skill.getFatigueCost()>"
    // en = "execute: travel finished at (<_entity.getTile().SquareCoords.X>,<_entity.getTile().SquareCoords.Y>)"
    // en = "execute: attacking <target.getName()> with <skill.getID()>"
    // en = "no usable 2-reach melee attack"
]
::Rosetta.add(rosetta, pairs);
