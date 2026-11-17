// mode: campaign seed=bbtest-battle fresh=1 launch=economy
// mods: mod_fun_facts@dev stdlib@dev
// include: lib/helpers.nut

// The "Spent" facts (1.0.0's TCO, 1.0.3's temple, HEAD's buy prices) against what the
// company's assets actually lose.

::FFT.sum <- function (_field) {
    local total = 0;
    foreach (bro in ::World.getPlayerRoster().getAll()) total += ::FFT.stats(bro).Spent[_field];
    return total;
}

// Food that keeps for the whole test, so only eating takes it.
::FFT.freshFood <- function () {
    foreach (item in ::World.Assets.getStash().getItems())
        if (item != null && item.isItemType(::Const.Items.ItemType.Food)) item.m.BestBefore = 1.0e9;
}

// The exact food in the stash: getFood() rounds each item's amount up.
::FFT.food <- function () {
    local total = 0.0;
    foreach (item in ::World.Assets.getStash().getItems())
        if (item != null && item.isItemType(::Const.Items.ItemType.Food)) total += item.m.Amount;
    return total;
}

// The food part of t.days: code has no world simulation, so the time eaten through is put behind
// LastFoodConsumed for the consumeFood() call after it, as its hourly update would find it.
::FFT.eatFor <- function (_t, _days) {
    if (_t.env != "code") return _t.days(_days, {quiet = true});
    ::World.Assets.m.LastFoodConsumed -= _days * ::World.getTime().SecondsPerDay;
    return _t.frames(1);
}

test("wages: what the bros were paid", function (t) {
    local money = ::World.Assets.getMoney(), wages = ::FFT.sum("Wages");
    local daily = 0;
    foreach (bro in t.roster()) daily += bro.getDailyCost();
    yield t.days(3, {quiet = true});
    local paid = money - ::World.Assets.getMoney();
    t.ok(paid > 0, "wages were paid");
    t.eq(paid % daily, 0, "whole days of wages");
    t.eq(::FFT.sum("Wages") - wages, paid, "Spent.Wages vs money paid");
    foreach (bro in t.roster())
        t.eq(::FFT.stats(bro).Spent.Wages, bro.getDailyCost() * (paid / daily), bro.getName() + "'s wages");
});

test("food: what the bros ate", function (t) {
    ::FFT.freshFood();
    local food = ::FFT.food(), eaten = ::FFT.sum("Food");
    yield ::FFT.eatFor(t, 2);
    ::World.Assets.consumeFood();
    local used = food - ::FFT.food();
    t.ok(used > 0, "food was eaten");
    t.near(::FFT.sum("Food") - eaten, used, 0.01, "Spent.Food vs food eaten");
});

test("F5: no food counted while the company doesn't eat its provisions", function (t) {
    ::FFT.freshFood();
    ::World.Assets.setUseProvisions(false);
    local food = ::FFT.food(), eaten = ::FFT.sum("Food");
    yield ::FFT.eatFor(t, 1);
    ::World.Assets.consumeFood();
    ::World.Assets.setUseProvisions(true);
    t.eq(food - ::FFT.food(), 0.0, "no food taken from the stash");
    t.near(::FFT.sum("Food") - eaten, 0.0, 0.01, "Spent.Food while not using provisions");
});

test("F5b: no food counted when there is none to eat", function (t) {
    foreach (i, item in ::World.Assets.getStash().getItems())
        if (item != null && item.isItemType(::Const.Items.ItemType.Food)) ::World.Assets.getStash().remove(item);
    ::World.Assets.updateFood();
    t.eq(::World.Assets.getFood(), 0, "no food");
    local eaten = ::FFT.sum("Food");
    yield ::FFT.eatFor(t, 1);
    ::World.Assets.consumeFood();
    t.near(::FFT.sum("Food") - eaten, 0.0, 0.01, "Spent.Food while starving");
});

test("herbs: medicine used on a bro's injury", function (t) {
    local bro = t.roster()[0];
    bro.getSkills().add(::new("scripts/skills/injury/cut_arm_injury"));
    ::World.Assets.addMedicine(20);
    local med = ::World.Assets.getMedicine(), herbs = ::FFT.stats(bro).Spent.Herbs;
    yield t.days(3, {quiet = true});
    local used = med - ::World.Assets.getMedicine();
    t.ok(used > 0, "medicine was used");
    t.eq(::FFT.stats(bro).Spent.Herbs - herbs, used, "Spent.Herbs vs medicine used");
    foreach (other in t.roster().slice(1)) t.eq(::FFT.stats(other).Spent.Herbs, 0, other.getName() + "'s herbs");
});

test("ammo: what an archer shot", function (t) {
    ::Tales.toughen(null, true);
    local bro = t.roster()[0];
    local offhand = bro.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
    if (offhand != null) bro.getItems().unequip(offhand);
    ::Tales.equip(bro, "scripts/items/weapons/short_bow");
    ::Tales.equip(bro, "scripts/items/ammo/quiver_of_arrows");
    local quiver = bro.getItems().getItemAtSlot(::Const.ItemSlot.Ammo);
    local before = quiver.getAmmo();
    local stock = ::World.Assets.getAmmo(), left = {};
    t.state.bro <- bro;
    t.state.quiver <- quiver;
    t.state.left <- left;
    yield t.battle({entities = ::Tales.thugs(2), player = ::Tales.scripted([
        function (t) {
            local skill = t.state.bro.getSkills().getSkillByID("actives.quick_shot");
            for (local i = 0; i < 3; i++) skill.onUse(t.state.bro, ::Tales.hostiles()[0].getTile());
            t.state.left.ammo <- t.state.quiver.getAmmo();
        },
        @(t) ::Tales.killAll(t.roster()[1])
    ])});
    local shot = (before - left.ammo) * quiver.getAmmoCost();
    t.eq(before - left.ammo, 3, "arrows shot");
    t.eq([quiver.getAmmo(), stock - ::World.Assets.getAmmo()], [before, shot], "quiver refilled from the stock");
    t.eq(::FFT.stats(bro).Spent.Ammo, shot, "Spent.Ammo vs arrows shot");
    t.eq(::FFT.sum("Ammo"), shot, "nobody else spent ammo");
});

test("hiring in town: the price paid", function (t) {
    local town = ::Tales.townWith("building.crowd");
    t.ok(town != null, "a town to hire in");
    town.updateRoster(true);
    local screen = ::Tales.visit(town, "building.crowd");
    local entry = ::World.getRoster(town.getID()).getAll()[0];
    ::World.Assets.addMoney(10000);
    local money = ::World.Assets.getMoney();
    local res = screen.getHireDialogModule().onHireRosterEntry(entry.getID());
    t.eq(res.Result, 0, "hired");
    local paid = money - ::World.Assets.getMoney();
    t.ok(paid > 0, "paid for the hire");
    t.eq(::FFT.stats(entry).Spent.Hire, paid, "Spent.Hire vs money paid");
    t.eq(::FunFacts.Hiring, false, "hiring flag reset");
    t.eq(::FFT.hints(entry.getRosterTooltip(), 6), ["Hired for [img]gfx/ui/tooltips/money.png[/img]" + paid + "."], "tooltip");
});

test("temple: the healing paid for", function (t) {
    local bro = t.roster()[0];
    bro.getSkills().add(::new("scripts/skills/injury/cut_arm_injury"));
    bro.getSkills().add(::new("scripts/skills/injury/bruised_leg_injury"));
    local town = ::Tales.townWith("building.temple");
    t.ok(town != null, "a town with a temple");
    local screen = ::Tales.visit(town, "building.temple");
    ::World.Assets.addMoney(10000);
    local money = ::World.Assets.getMoney(), prices = [];
    foreach (id in ["injury.cut_arm", "injury.bruised_leg"]) {
        local m = ::World.Assets.getMoney();
        screen.getTempleDialogModule().onTreatInjury([bro.getID(), id]);
        prices.push(m - ::World.Assets.getMoney());
    }
    t.ok(prices[0] > 0 && prices[1] > 0, "paid for both");
    t.eq(::FFT.stats(bro).Spent.Temple, prices, "Spent.Temple vs money paid");
    local costs = ::FFT.rosterHints(bro).filter(@(_, h) h.find("Healed") != null);
    t.eq(costs.len(), 1, "a healing line");
    t.ok(costs[0].find("Healed 2 times, [img]gfx/ui/tooltips/money.png[/img]" + (prices[0] + prices[1]) + " total.") != null,
         "healing line: " + costs[0]);
});

test("training hall: the lessons paid for", function (t) {
    local bro = t.roster()[0];
    local town = ::Tales.townWith("building.training_hall");
    t.ok(town != null, "a town with a training hall");
    local screen = ::Tales.visit(town, "building.training_hall");
    ::World.Assets.addMoney(10000);
    local prices = [];
    foreach (id in [0, 2]) {
        bro.getSkills().removeByID("effects.trained");
        local m = ::World.Assets.getMoney();
        screen.getTrainingDialogModule().onTrain([bro.getID(), id]);
        prices.push(m - ::World.Assets.getMoney());
    }
    // Already trained: nothing paid, nothing counted
    screen.getTrainingDialogModule().onTrain([bro.getID(), 1]);
    t.ok(prices[0] > 0 && prices[1] > 0, "paid for both");
    t.eq(::FFT.stats(bro).Spent.Training, prices, "Spent.Training vs money paid");
    local lines = [];
    foreach (h in ::FFT.rosterHints(bro)) lines.extend(split(h, "\n"));
    t.eq(lines.filter(@(_, l) l.find("Trained") == 0),
         ["Trained 2 times, [img]gfx/ui/tooltips/money.png[/img]" + (prices[0] + prices[1]) + " total."],
         "training line");
});

test("buying supplies in a marketplace: the average price", function (t) {
    local town = ::Tales.townWith("building.marketplace");
    t.ok(town != null, "a town with a marketplace");
    local screen = ::Tales.visit(town, "building.marketplace");
    local market = town.getBuilding("building.marketplace");
    local shop = screen.getShopDialogModule();
    ::World.Assets.addMoney(100000);
    foreach (k, v in ::FunFacts.Buys.Stats) { v.Amount = 0; v.Spent = 0; }
    // The market's own stock and its freshness are rolled from the real time: a fresh item has a fixed price.
    local food = ::new("scripts/items/supplies/smoked_ham_item");
    market.getStash().clear();
    market.getStash().add(food);
    // At this time the freshness set on arrival rounds down a day in f32
    ::Time.setVirtualTime(2919.301);
    local amount = food.getAmount(), money = ::World.Assets.getMoney();
    local res = shop.onSwapItem([0, "world-town-screen-shop-dialog-module.shop", null,
                                 "world-town-screen-shop-dialog-module.stash"]);
    t.eq(res != null && res.Result, 0, "bought");
    local paid = money - ::World.Assets.getMoney();
    t.eq(::FunFacts.Buys.Stats.Food, {Amount = amount, Spent = paid}, "recorded purchase");
    t.near(::FunFacts.Buys.getAvgPrice("Food", 4), paid.tofloat() / amount, 0.0001, "average food price");
});
