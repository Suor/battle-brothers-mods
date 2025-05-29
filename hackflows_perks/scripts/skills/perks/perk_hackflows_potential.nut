this.perk_hackflows_potential <- ::inherit("scripts/skills/skill", {
    m = {
        Stage = 0
        WillSucceed = false
        Failed = false
        Chance = 75
    },
    Stages = [
        {
            Level = 5
            SlaveLevel = 4
            function up(_this, _actor) {
                _actor.improveMood(0.5, "Promising Potential");
            }
        }
        {
            Level = 8
            SlaveLevel = 7
            function up(_this, _actor) {
                _this.addPerkTrees(["pgc.rf_weapon"], ["pg.rf_tactician"]);
                _actor.improveMood(0.5, "Rising Potential");
            }
        }
        {
            Level = 11
            SlaveLevel = null
            function up(_this, _actor) {
                _actor.resetPerks();
                _actor.m.PerkPoints++;
                // _actor.getSkills().add(this); // Add it back
                _this.addPerkTrees(["pgc.rf_shared_1", "pgc.rf_weapon"], ["pg.rf_tactician"]);
                _actor.improveMood(1.0, "Realized Potential");
            }
        }
    ]
    function create() {
        m.ID = "perk.hackflows.potential";
        setup();

        m.Type = ::Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
        m.Order = ::Const.SkillOrder.Perk;
        if ("IsRefundable" in m) m.IsRefundable = false;
    }

    function isHidden() {
        return m.Stage == 0;
    }

    function setup() {
        local suffix = "_" + m.Stage + (m.Failed ? "_fail" : "");
        m.ID = "perk.hackflows.potential" + suffix;

        local perk = ::Const.Perks.LookupMap[m.ID];
        m.Name = perk.Name;
        m.Description = perk.Tooltip;
        m.Icon = perk.Icon;
        m.IconDisabled = perk.IconDisabled;
    }

    function getBonus() {
        return m.Stage == 3 ? 10 :
               m.Stage == 2 ? 5 :
               m.Stage == 1 ? 2 : 0;
    }
    function getExtraWagePercent() {
        return m.Stage == 3 ? 100 :
               m.Stage == 2 ? 50 : 0;
    }

    function isHidden() {
        return getBonus() == 0;
    }

    function getTooltip() {
        local ret = skill.getTooltip();
        local bonus = getBonus();
        if (bonus > 0) {
            ret.push({
                id = 6
                type = "text"
                icon = "ui/icons/ambition_tooltip.png"
                text = ::std.Text.positive("+" + bonus) + " to all attributes"
            })
        }
        local wagePercent = getExtraWagePercent();
        if (wagePercent > 0) {
            ret.push({
                id = 7,
                type = "text",
                icon = "ui/icons/money.png",
                text = ::std.Text.negative("+" + wagePercent + "%") + " more daily wage"
            })
        }
        return ret;
    }

    function onUpdate(_properties) {
        local bonus = getBonus();
        if (bonus > 0) {
            _properties.Hitpoints += bonus;
            _properties.Stamina += bonus;
            _properties.Initiative += bonus;
            _properties.Bravery += bonus;
            _properties.MeleeSkill += bonus;
            _properties.RangedSkill += bonus;
            _properties.MeleeDefense += bonus;
            _properties.RangedDefense += bonus;
        }
        _properties.DailyWageMult *= 1 + 0.01 * getExtraWagePercent();
    }

    function onAdded() {
        if (!m.IsNew) return;

        m.WillSucceed = ::Math.rand(1, 100) <= m.Chance;

         // Catch up for previous levels, in case we migrate or otherwise not add on level 1
        _syncLevel();
    }

    // Requires MSU
    function onUpdateLevel() {
        _onUpdateLevel(getContainer().getActor().m.Level);
    }

    function _syncLevel() {
        for (local level = 2; level <= getContainer().getActor().m.Level; level++)
            _onUpdateLevel(level);
    }

    function _onUpdateLevel(_level) {
        if (!(m.Stage in Stages)) return;
        local stage = Stages[m.Stage];

        local actor = getContainer().getActor();
        local isSlave = ::World.Assets.getOrigin().getID() == "scenario.manhunters"
                        && actor.getBackground().getID() == "background.slave";

        if (_level == stage.Level || isSlave && _level == stage.SlaveLevel) {
            if (m.WillSucceed) {
                m.Stage++;
                m.WillSucceed = ::Math.rand(1, 100) <= m.Chance;
                stage.up(this, actor);
            } else {
                m.Failed = true;
            }

            // Update perk def in the tree
            actor.getPerkTree().removePerk(getID());
            setup();
            actor.getPerkTree().addPerk(getID(), 1);
        }
    }

    function addPerkTrees(_categories, _exclude = []) {
        local actor = getContainer().getActor();
        local perkTree = actor.getPerkTree();

        foreach (categoryID in _categories) {
            // COPYPASTA FROM reforged/scripts/skills/perks/perk_rf_realized_potential
            local newPerkGroup = ::DynamicPerks.PerkGroupCategories.findById(categoryID)
                .getWeightedRandomPerkGroup(perkTree, @(_pgID) _exclude.find(_pgID) == null);
            if (newPerkGroup != null) perkTree.addPerkGroup(newPerkGroup);
            // local category = ::DynamicPerks.PerkGroupCategories.findById(categoryID);
            // foreach (groupID in category.getGroups()) {
            //     if (perkTree.hasPerkGroup(groupID)) _exclude.push(groupID);
            // }
            // local newPerkGroup = category.getRandomGroup(exclude);
            // if (newPerkGroup != null) perkTree.addPerkGroup(newPerkGroup);
        }

        // COPYPASTA FROM reforged/scripts/skills/perks/perk_rf_realized_potential
        // Adjust bro's perk tree so that no row is longer than 13 perks (so that it fits in the UI properly)
        foreach (i, row in perkTree.getTree())
        {
            if (row.len() <= 13)
                continue;

            for (local i = row.len() - 1; i > 12; i--)
            {
                local id = row[i].ID;
                local tier = i + 1;
                perkTree.removePerk(id);
                if (tier != 7) perkTree.addPerk(id, tier + 1);
            }
        }
    }

    function onSerialize(_out) {
        skill.onSerialize(_out);
        _out.writeU8(m.Stage);
        _out.writeBool(m.WillSucceed);
        _out.writeBool(m.Failed);
    }

    function onDeserialize(_in) {
        skill.onDeserialize(_in);
        m.Stage = _in.readU8();
        m.WillSucceed = _in.readBool();
        m.Failed = _in.readBool();
        setup();
    }
});
