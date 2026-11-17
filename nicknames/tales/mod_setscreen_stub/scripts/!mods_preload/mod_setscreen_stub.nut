// Test-only: replaces events/event.setScreen outright after nicknames' hooks, as Legends does.
local mod = ::Hooks.register("mod_setscreen_stub", "1.0.0", "setScreen replacer (bbtales)");
mod.queue(">mod_nicknames", function () {
    mod.hook("scripts/events/event", function (q) {
        q.setScreen = @(__original) function (_screen) {
            if (_screen == null) return;
            this.m.ActiveScreen = clone _screen;
            this.m.ActiveScreen.Options = [];
            foreach (option in _screen.Options) this.m.ActiveScreen.Options.push(clone option);
            if ("List" in this.m.ActiveScreen) this.m.ActiveScreen.List = [];
            else this.m.ActiveScreen.List <- [];
            if ("Characters" in this.m.ActiveScreen) this.m.ActiveScreen.Characters = [];
            if ("Banner" in this.m.ActiveScreen) this.m.ActiveScreen.Banner = [];
            this.m.ActiveScreen.start(this);
            this.m.ActiveScreen.Text = this.buildText(this.m.ActiveScreen.Text);
            foreach (option in this.m.ActiveScreen.Options) {
                option.Text = this.buildText(option.Text);
                option.Event <- this;
            }
        }
    });
}, ::Hooks.QueueBucket.VeryLate);
