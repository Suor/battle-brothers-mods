::Autopilot.Tooltips <- {
    "tactical-screen.turn-sequence-bar-module.WaitTurnAllButton": [
        {
            id = 1,
            type = "title",
            text = "Mass Wait Turn (H)"
        },
        {
            id = 2,
            type = "description",
            text = "Pauses all characters' turns and moves them to the end of the queue, if they haven't waited already. Waiting this turn will also have them act later next round."
        }
    ]
    "tactical-screen.turn-sequence-bar-module.IgnoreButton": [
        {
            id = 1,
            type = "title",
            text = "Ignore"
        },
        {
            id = 2,
            type = "description",
            text = "Ends this character's turn and causes him to be ignored on future turns."
        }
    ]
    "tactical-screen.turn-sequence-bar-module.CancelButton": [
        {
            id = 1,
            type = "title",
            text = "Cancel (V)"
        },
        {
            id = 2,
            type = "description",
            text = "Cancels effects such as End Round, Mass Wait, Mass Shield Wall, Ignore, and AI Control."
        }
    ]
    "tactical-screen.turn-sequence-bar-module.ShieldWallButton": [
        {
            id = 1,
            type = "title",
            text = "Mass Shield Wall (N)"
        },
        {
            id = 2,
            type = "description",
            text = "Makes all characters automatically use the Shieldwall skill at the start of their turn this round, if possible."
        }
    ]
    "tactical-screen.turn-sequence-bar-module.AIButton": [
        {
            id = 1,
            type = "title",
            text = "AI Control"
        },
        {
            id = 2,
            type = "description",
            text = "Ends the current character's turn and gives control of the party to the AI."
        }
    ]
}

::Hooks.getMod("mod_autopilot_new").hook("scripts/ui/screens/tooltip/tooltip_events", function (q) {
    q.general_queryUIElementTooltipData = @(__original)
        function (_entityId, _elementId, _elementOwner)
    {
        if (_elementId in ::Autopilot.Tooltips) return ::Autopilot.Tooltips[_elementId];
        return __original(_entityId, _elementId, _elementOwner);
    }

    q.onQuerySkillTooltipData = @(__original) function(_entityId, _skillId) {
        local tooltip = __original(_entityId, _skillId);
        if (tooltip != null) return tooltip;

        local entity = Tactical.getEntityByID(_entityId);
        local items = entity.getItems();
        local item = items.getItemByInstanceID(_skillId);
        if (item == null) return null;

        local currentItem = items.getItemAtSlot(item.getSlotType());
        local cost = items.getActionCost(currentItem != null ? [currentItem, item] : [item]);
        return [
            {
                id = 1,
                type = "title",
                text = "Switch to " + item.getName()
            },
            {
                id = 2,
                type = "description",
                text = "Quickly switch to another item from your bag."
            },
            {
                id = 3,
                type = "text",
                text = "Costs [b]" + ::std.Text.positive(cost) + "[/b] AP to switch."
            }
        ];
    }
})
