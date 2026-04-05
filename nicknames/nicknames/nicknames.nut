local def = ::Nicknames;

// Per-factor-type weights; entry weight = product of each factor's weight
// factors: "trait.*", "background.*", "weapon.*" (WT name), "talent.*" (index, 3-star),
//          "AttrName.high" / "AttrName.low"
def.Weights <- {
    Attr       = 7
    Trait      = 10
    Talent     = 5
    Background = 2
    Weapon     = 3
};

def.Nicknames <- [
    // ── Multi-factor combos ──────────────────────────────────────────────

    // Trait + trait
    {factors = ["trait.strong", "trait.brave"],
     nicknames = ["Bulldozer", "the Hammer", "Unrelenting"]}
    {factors = ["trait.strong", "trait.huge"],
     nicknames = ["the Titan", "Goliath", "the Colossus"]}
    {factors = ["trait.strong", "trait.dumb"],
     nicknames = ["the Oaf", "Dumb Muscle", "Gentle Giant"]}
    {factors = ["trait.brave", "trait.deathwish"],
     nicknames = ["Glory Chaser", "Daredevil", "the Reckless"]}
    {factors = ["trait.tiny", "trait.swift"],
     nicknames = ["the Gnat", "Little Lightning", "Ankle Biter"]}
    {factors = ["trait.fat", "trait.tough"],
     nicknames = ["the Boulder", "Unmovable", "Meatshield"]}
    {factors = ["trait.craven", "trait.lucky"],
     nicknames = ["Born Survivor", "Slippery", "the Dodger"]}
    {factors = ["trait.bright", "trait.eagle_eyes"],
     nicknames = ["the Tactician", "All-Seeing", "Mastermind"]}
    {factors = ["trait.drunkard", "trait.brave"],
     nicknames = ["Dutch Courage", "Liquid Bravery", "Booze Berserker"]}
    {factors = ["trait.bloodthirsty", "trait.brute"],
     nicknames = ["the Maniac", "Gore Fiend", "Maddog"]}
    {factors = ["trait.greedy", "trait.disloyal"],
     nicknames = ["the Mercenary", "Sold Soul", "Coin Chaser"]}
    {factors = ["trait.pessimist", "trait.craven"],
     nicknames = ["Doomed", "Walking Misery", "the Grim"]}
    {factors = ["trait.huge", "trait.bloodthirsty"],
     nicknames = ["the Ogre", "Man Eater", "the Horror"]}
    {factors = ["trait.tiny", "trait.bright"],
     nicknames = ["the Imp", "Little Professor", "Small but Sharp"]}
    {factors = ["trait.drunkard", "trait.fat"],
     nicknames = ["the Keg", "Tavern King", "Beer Belly"]}
    {factors = ["trait.optimist", "trait.brave"],
     nicknames = ["Cheerful", "Always Grins", "Smileface"]}
    {factors = ["trait.paranoid", "trait.eagle_eyes"],
     nicknames = ["the Sentinel", "Ever Watchful"]}
    {factors = ["trait.strong", "trait.iron_jaw"],
     nicknames = ["the Fortress", "Unbreakable Wall", "Steelborn"]}
    {factors = ["trait.swift", "trait.brave"],
     nicknames = ["the Charger", "First In", "Vanguard"]}
    {factors = ["trait.dumb", "trait.huge"],
     nicknames = ["the Troll", "Simple Giant", "Big Dumb"]}

    // Background + trait
    {factors = ["background.hedge_knight", "trait.brave"],
     nicknames = ["the True Knight", "Gallant", "the Chivalrous"]}
    {factors = ["background.thief", "trait.lucky"],
     nicknames = ["the Phantom", "Ghost Fingers", "the Untouchable"]}
    {factors = ["background.monk", "trait.fearless"],
     nicknames = ["the Crusader", "Holy Fury", "Righteous Fist"]}
    {factors = ["background.butcher", "trait.bloodthirsty"],
     nicknames = ["the Slaughterhouse", "Blood and Guts", "Meatgrinder"]}
    {factors = ["background.shepherd", "trait.brave"],
     nicknames = ["the Sheepdog", "Wolf Among Sheep"]}
    {factors = ["background.beggar", "trait.lucky"],
     nicknames = ["Rags to Riches", "Fortune's Fool"]}
    {factors = ["background.wildman", "trait.huge"],
     nicknames = ["the Yeti", "Forest Giant", "Sasquatch"]}
    {factors = ["background.cultist", "trait.deathwish"],
     nicknames = ["the Martyr", "the Fanatic", "Self-Sacrifice"]}
    {factors = ["background.minstrel", "trait.bright"],
     nicknames = ["Silver Tongue", "the Poet", "Wordsmith"]}
    {factors = ["background.gravedigger", "trait.tough"],
     nicknames = ["Dirt Eater", "the Undertaker"]}
    {factors = ["background.gambler", "trait.lucky"],
     nicknames = ["the Jackpot", "Always Wins", "House Buster"]}
    {factors = ["background.lumberjack", "trait.strong"],
     nicknames = ["the Woodcutter", "Treesplitter", "Oak Feller"]}
    {factors = ["background.miner", "trait.tough"],
     nicknames = ["Rockjaw", "the Tunneler", "Iron Ore"]}
    {factors = ["background.fisherman", "trait.lucky"],
     nicknames = ["the Big Catch", "Golden Net"]}
    {factors = ["background.ratcatcher", "trait.tiny"],
     nicknames = ["the Rat", "Sewer Prince"]}
    {factors = ["background.sellsword", "trait.greedy"],
     nicknames = ["Gold Before Glory", "the Price Tag"]}
    {factors = ["background.killer_on_the_run", "trait.paranoid"],
     nicknames = ["the Hunted", "Looking Over Shoulder"]}
    {factors = ["background.deserter", "trait.craven"],
     nicknames = ["the Escaped", "Born Runner", "Fleet Foot"]}

    // Weapon + attr or trait
    {factors = ["weapon.Bow",      "RangedSkill.high"],
     nicknames = ["the Sharpshooter", "Eagle's Arrow", "Bullseye"]}
    {factors = ["weapon.Crossbow", "RangedSkill.high"],
     nicknames = ["the Sniper", "Bolt of Death", "One Shot"]}
    {factors = ["weapon.Sword",    "MeleeSkill.high"],
     nicknames = ["Surecut", "Deathstroke", "the Duelist"]}
    {factors = ["weapon.Axe",      "trait.strong"],
     nicknames = ["Skull Splitter", "the Woodcutter", "Axe Storm"]}
    {factors = ["weapon.Spear",    "Initiative.high"],
     nicknames = ["First Blood", "the Viper", "Quick Jab"]}
    {factors = ["weapon.Hammer",   "trait.strong"],
     nicknames = ["Earthshaker", "the Crusher", "Plate Buster"]}
    {factors = ["weapon.Dagger",   "trait.tiny"],
     nicknames = ["Little Sting", "Flea Bite", "Pin Prick"]}
    {factors = ["weapon.Polearm",  "MeleeSkill.high"],
     nicknames = ["the Reaper", "Long Arm of Death"]}
    {factors = ["weapon.Flail",    "trait.brute"],
     nicknames = ["Whirlwind of Pain", "Chain Fury"]}
    {factors = ["weapon.Mace",     "MeleeSkill.high"],
     nicknames = ["Skull Denter", "the Concussor"]}

    // Talent + background/trait
    {factors = ["talent.2", "cost.20"],
     nicknames = ["Born Mercenary", "Natural Killer"]}
    {factors = ["talent.4", "background.hunter"],
     nicknames = ["the Deadeye", "Hawk", "Nature's Archer"]}
    {factors = ["talent.0", "trait.strong"],
     nicknames = ["Doom Blade", "the Annihilator", "Wrecking Ball"]}
    {factors = ["talent.4", "trait.eagle_eyes"],
     nicknames = ["Telescopic", "the Sharpshooter"]}
    {factors = ["talent.2", "background.squire"],
     nicknames = ["Future Knight", "the Promising"]}
    {factors = ["talent.5", "background.monk"],
     nicknames = ["the Abbot", "Voice of God"]}

    // ── Single-factor: talents (3-star) ──────────────────────────────────
    {factors = ["talent.0"], nicknames = ["Tank", "Thick Hide", "Meatbox"]}
    {factors = ["talent.1"], nicknames = ["the Machine", "Never Tired", "Stamina Freak"]}
    {factors = ["talent.2"], nicknames = ["Swordguy", "Blade Master", "Choppy"]}
    {factors = ["talent.3"], nicknames = ["Quick Feet", "Twitchy", "Fastdraw"]}
    {factors = ["talent.4"], nicknames = ["Arrow Wizard", "Shots On Point", "Bullseye"]}
    {factors = ["talent.5"], nicknames = ["Fearless", "No Doubts", "Guts"]}
    {factors = ["talent.6"], nicknames = ["Slippy", "Evasive", "Never Touched"]}
    {factors = ["talent.7"], nicknames = ["Dodgy", "Untouchable Ranged", "Bulletproof"]}

    // ── Single-factor: attrs ─────────────────────────────────────────────
    {factors = ["Hitpoints.high"],     nicknames = ["Tank", "Chunky"]}
    {factors = ["Hitpoints.low"],      nicknames = ["Squishy", "Paperman"]}
    {factors = ["MeleeSkill.high"],    nicknames = ["Swordguy", "Choppy"]}
    {factors = ["MeleeSkill.low"],     nicknames = ["Butterfingers", "Miss-a-lot"]}
    {factors = ["RangedSkill.high"],   nicknames = ["Sharpshot", "Bullseye"]}
    {factors = ["RangedSkill.low"],    nicknames = ["Blind Archer", "Off-Target"]}
    {factors = ["MeleeDefense.high"],  nicknames = ["Dodgy", "Untouchable"]}
    {factors = ["RangedDefense.high"], nicknames = ["Ranged Dodger", "Stray Proof"]}
    {factors = ["Bravery.high"],       nicknames = ["Fearless", "Guts"]}
    {factors = ["Bravery.low"],        nicknames = ["Scaredy Cat", "Jelly Legs"]}
    {factors = ["Stamina.high"],       nicknames = ["Tireless", "Energizer"]}
    {factors = ["Stamina.low"],        nicknames = ["Huffpuff", "the Winded"]}
    {factors = ["Initiative.high"],    nicknames = ["Zippy", "Speedster"]}
    {factors = ["Initiative.low"],     nicknames = ["Slowpoke", "Sluggish"]}

    // ── Single-factor: traits ────────────────────────────────────────────
    {factors = ["trait.strong"],        nicknames = ["Bonebreaker", "Strongarm", "Irongrip"]}
    {factors = ["trait.brave"],         nicknames = ["Lionheart", "the Valiant", "Stoutheart"]}
    {factors = ["trait.craven"],        nicknames = ["Cold Feet", "Shaky Knees", "the Reluctant"]}
    {factors = ["trait.fat"],           nicknames = ["Barrel", "Lardball", "the Wide"]}
    {factors = ["trait.huge"],          nicknames = ["Bigfoot", "the Colossus", "Thunderstep"]}
    {factors = ["trait.tiny"],          nicknames = ["Halfpint", "the Runt", "Thumbling"]}
    {factors = ["trait.dumb"],          nicknames = ["Numbskull", "Simpleton", "the Clueless"]}
    {factors = ["trait.bright"],        nicknames = ["Sharpwit", "Brainiac", "the Thinker"]}
    {factors = ["trait.bloodthirsty"],  nicknames = ["Bloodlust", "the Savage", "Gore"]}
    {factors = ["trait.lucky"],         nicknames = ["Four-Leaf", "Lucky Dog", "Lady's Favor"]}
    {factors = ["trait.drunkard"],      nicknames = ["Boozy", "Barrel Bottom", "the Sloshed"]}
    {factors = ["trait.iron_jaw"],      nicknames = ["Granite Face", "Hard Chin", "Unbreakable"]}
    {factors = ["trait.eagle_eyes"],    nicknames = ["Hawkeye", "the Spotter", "Farsight"]}
    {factors = ["trait.swift"],         nicknames = ["Lightning", "the Wind", "Quickstep"]}
    {factors = ["trait.survivor"],      nicknames = ["Cockroach", "the Unkillable", "Last Man"]}
    {factors = ["trait.night_blind"],   nicknames = ["the Mole", "Dusk Fumbler"]}
    {factors = ["trait.short_sighted"], nicknames = ["Squinter", "Mole Eyes"]}
    {factors = ["trait.clubfooted"],    nicknames = ["Stumbles", "the Hobbler"]}
    {factors = ["trait.asthmatic"],     nicknames = ["Wheezy", "the Puffer"]}
    {factors = ["trait.gluttonous"],    nicknames = ["Bottomless Pit", "Gobbler", "the Hungry"]}
    {factors = ["trait.greedy"],        nicknames = ["Goldfingers", "Penny Pincher", "the Miser"]}
    {factors = ["trait.paranoid"],      nicknames = ["Tinfoil", "Eyes Everywhere"]}
    {factors = ["trait.pessimist"],     nicknames = ["Gloom", "Raincloud", "the Downer"]}
    {factors = ["trait.optimist"],      nicknames = ["Sunshine", "Smiley", "the Cheerful"]}
    {factors = ["trait.cocky"],         nicknames = ["Hotshot", "Big Mouth", "the Showoff"]}
    {factors = ["trait.disloyal"],      nicknames = ["Turncoat", "Shifty"]}
    {factors = ["trait.deathwish"],     nicknames = ["the Reckless", "No Tomorrow", "Death's Friend"]}
    {factors = ["trait.fearless"],      nicknames = ["Nerves of Steel", "Stone Cold"]}
    {factors = ["trait.determined"],    nicknames = ["Iron Will", "the Relentless", "the Stubborn"]}
    {factors = ["trait.tough"],         nicknames = ["Thick Skin", "Ironhide"]}
    {factors = ["trait.brute"],         nicknames = ["Knuckles", "Meatfist"]}
    {factors = ["trait.impatient"],     nicknames = ["Twitchy", "Antsy", "the Restless"]}
    {factors = ["trait.fragile"],       nicknames = ["Glass Bones", "Paper Skin"]}
    {factors = ["trait.superstitious"], nicknames = ["Rabbit Foot", "Hex Dodger"]}
    {factors = ["trait.bleeder"],       nicknames = ["Red Fountain", "Leaky"]}
    {factors = ["trait.hate_undead"],   nicknames = ["Gravebane", "the Exorcist"]}
    {factors = ["trait.hate_greenskins"],nicknames = ["Tusk Breaker", "Greenskin Bane"]}
    {factors = ["trait.hate_beasts"],   nicknames = ["Monster Bane", "Beast Slayer"]}
    {factors = ["trait.iron_lungs"],    nicknames = ["the Tireless", "Never Winded"]}
    {factors = ["trait.fear_undead"],   nicknames = ["Bone Shaker", "Ghost Pale"]}
    {factors = ["trait.fear_beasts"],   nicknames = ["Fur Allergy", "Beast Shy"]}
    {factors = ["trait.fear_greenskins"],nicknames = ["Orc Shy", "Green Pale"]}
    {factors = ["trait.loyal"],         nicknames = ["True Heart", "the Faithful"]}
    {factors = ["trait.weasel"],        nicknames = ["Sly", "the Sneaky"]}
    {factors = ["trait.dastard"],       nicknames = ["Yellow Belly", "the Cringe"]}
    {factors = ["trait.hesitant"],      nicknames = ["Slowstart", "the Hesitant"]}
    {factors = ["trait.insecure"],      nicknames = ["Shaky", "the Doubtful"]}
    {factors = ["trait.irrational"],    nicknames = ["Wildcard", "Loose Cannon"]}
    {factors = ["trait.fainthearted"],  nicknames = ["Pale Face", "the Meek"]}
    {factors = ["trait.clumsy"],        nicknames = ["Butterfingers", "Fumbles"]}
    {factors = ["trait.quick"],         nicknames = ["Quickdraw", "the Agile"]}
    {factors = ["trait.dexterous"],     nicknames = ["Deft Hands", "the Nimble"]}
    {factors = ["trait.sure_footing"],  nicknames = ["Steady", "Surefoot"]}
    {factors = ["trait.night_owl"],     nicknames = ["the Night Owl", "Moonwatcher"]}
    {factors = ["trait.teamplayer"],    nicknames = ["the Team Player", "Brother-in-Arms"]}
    {factors = ["trait.athletic"],      nicknames = ["the Athlete", "Sprinter"]}
    // Legends traits
    {factors = ["trait.legend_aggressive"],    nicknames = ["the Aggressor", "Hotblood"]}
    {factors = ["trait.legend_fear_dark"],     nicknames = ["Shadowfear", "the Nyctophobe"]}
    {factors = ["trait.legend_light"],         nicknames = ["Featherweight", "Light Step"]}
    {factors = ["trait.legend_double_tongued"],nicknames = ["Two-Face", "Forked Tongue"]}

    // ── Single-factor: backgrounds ───────────────────────────────────────
    {factors = ["background.farmhand"],   nicknames = ["Pitchfork", "Mudfoot", "Hay Bale"]}
    {factors = ["background.daytaler"],   nicknames = ["Odd Jobs", "Dusty Hands", "the Drifter"]}
    {factors = ["background.sellsword"],  nicknames = ["Blade for Hire", "Coin Soldier"]}
    {factors = ["background.militia"],    nicknames = ["Gate Watch", "Town Guard"]}
    {factors = ["background.servant"],    nicknames = ["Yes Sir", "Boot Polisher"]}
    {factors = ["background.mason"],      nicknames = ["Stonefist", "Brickhand"]}
    {factors = ["background.miller"],     nicknames = ["Flour Dust", "Grindstone"]}
    {factors = ["background.poacher"],    nicknames = ["Night Arrow", "Snare Setter"]}
    {factors = ["background.ratcatcher"], nicknames = ["Rat King", "Pied Piper"]}
    {factors = ["background.peddler"],    nicknames = ["Tinker", "Cheap Wares"]}
    {factors = ["background.brawler"],    nicknames = ["Bare Knuckles", "Bruiser"]}
    {factors = ["background.bowyer"],     nicknames = ["Stringfinger", "Shaft"]}
    {factors = ["background.messenger"],  nicknames = ["Dispatch", "Swift Foot"]}
    {factors = ["background.tailor"],     nicknames = ["Needlefingers", "Patches"]}
    {factors = ["background.squire"],     nicknames = ["Shield Bearer", "the Hopeful"]}
    {factors = ["background.houndmaster"],nicknames = ["Dog Whisperer", "Alpha"]}
    {factors = ["background.vagabond"],   nicknames = ["Roadworn", "Dustwalker"]}
    {factors = ["background.gravedigger"],nicknames = ["Shovel", "Bone Picker"]}
    {factors = ["background.bastard"],    nicknames = ["No Name", "Half-Blood"]}
    {factors = ["background.graverobber"],nicknames = ["Tomb Raider", "the Ghoul"]}
    {factors = ["background.adventurous_noble"], nicknames = ["Blue Blood", "the Adventurer"]}
    {factors = ["background.disowned_noble"],    nicknames = ["Fallen Grace", "Lost Crown"]}
    {factors = ["background.retired_soldier"],   nicknames = ["Old Guard", "Rusty Blade"]}
    {factors = ["background.caravan_hand"],      nicknames = ["Dusty Boots", "Road Dog"]}
    {factors = ["background.flagellant"],  nicknames = ["Whip Mark", "Scar Back"]}
    {factors = ["background.wildman"],     nicknames = ["Beastblood", "the Feral"]}
    {factors = ["background.witchhunter"], nicknames = ["Witch Finder", "Stake and Fire"]}
    {factors = ["background.hedge_knight"],nicknames = ["the Jouster", "Wandering Blade"]}
    {factors = ["background.swordmaster"], nicknames = ["Old Blade"]}
    {factors = ["background.apprentice"],  nicknames = ["Still Learning", "Half-Trained"]}
    {factors = ["background.refugee"],     nicknames = ["No Home", "the Displaced"]}
    // XBE backgrounds
    {factors = ["background.hackflows_falconer"],    nicknames = ["Hawkmaster", "Bird Caller", "Sky Eye"]}
    {factors = ["background.hackflows_hangman"],     nicknames = ["Noose", "Gallows Hand", "Neck Stretcher"]}
    {factors = ["background.hackflows_pirate"],      nicknames = ["Sea Dog", "Plank Walker", "Barnacle"]}
    {factors = ["background.hackflows_berserker"],   nicknames = ["Rager", "Foaming Mouth", "Bloodlust"]}
    {factors = ["background.hackflows_carpenter"],   nicknames = ["Sawdust", "Nailbiter", "Splinter"]}
    {factors = ["background.hackflows_barkeep"],     nicknames = ["Tap Master", "Ale Lord", "Last Call"]}
    {factors = ["background.hackflows_herbalist"],   nicknames = ["Green Thumb", "Leaf Picker", "Root Digger"]}
    {factors = ["background.hackflows_con_artist"],  nicknames = ["Smooth Talker", "the Grifter", "Fast Talk"]}
    {factors = ["background.hackflows_bodyguard"],   nicknames = ["the Shield", "Iron Shadow", "Watchdog"]}
    {factors = ["background.hackflows_bounty_hunter"],nicknames = ["Headhunter", "the Tracker", "Bounty"]}
    {factors = ["background.hackflows_blacksmith"],  nicknames = ["Anvil Striker", "Hammer", "Sparks"]}
    {factors = ["background.hackflows_cook"],        nicknames = ["Stewpot", "Spice", "Hot Pot"]}
    {factors = ["background.hackflows_surgeon"],     nicknames = ["Sawbones", "Stitcher", "Bloodstained"]}
    {factors = ["background.hackflows_torturer"],    nicknames = ["Thumbscrew", "the Wrack", "Stretcher"]}
    {factors = ["background.hackflows_town_watchman"],nicknames = ["Night Watch", "Gate Guard", "Bell Ringer"]}
    {factors = ["background.hackflows_roofer"],      nicknames = ["Shingles", "High Step", "Roofwalker"]}
    {factors = ["background.hackflows_cobbler"],     nicknames = ["Sole Fixer", "Bootmaker", "Heel"]}
    {factors = ["background.hackflows_drifter"],     nicknames = ["Tumbledown", "Dustwalker", "Nowhere Man"]}
    {factors = ["background.hackflows_lancer"],      nicknames = ["Pointy Boy", "the Lancer", "Tilt"]}
    {factors = ["background.hackflows_master_archer"],nicknames = ["Sharp Eye", "Arrow", "Deadshot"]}
    {factors = ["background.hackflows_outlander"],   nicknames = ["the Stranger", "Outsider", "Far Walker"]}
    {factors = ["background.hackflows_arbalester"],  nicknames = ["Ballista Boy", "Heavy Bolt", "Crank"]}
    {factors = ["background.hackflows_druid"],       nicknames = ["Tree Hugger", "Moss Beard", "Bark Skin"]}
    {factors = ["background.hackflows_fletcher"],    nicknames = ["Arrow Maker", "Featherman", "Quill"]}
    {factors = ["background.hackflows_gardener"],    nicknames = ["Plant Man", "Green Fingers", "Weeder"]}
    {factors = ["background.hackflows_locksmith"],   nicknames = ["Picklock", "Lock Buster", "Key Master"]}
    {factors = ["background.hackflows_myrmidon"],    nicknames = ["Arena Rat", "Ant Soldier", "Pit Fighter"]}
    {factors = ["background.hackflows_painter"],     nicknames = ["Brush Dude", "Color Hands", "Canvas"]}
    {factors = ["background.hackflows_skirmisher"],  nicknames = ["Hit Run", "Quick Jab", "Stinger"]}
    {factors = ["background.hackflows_cartographer"],nicknames = ["Map Man", "Compass", "Pathfinder"]}
    {factors = ["background.hackflows_dissenter"],   nicknames = ["Rebel", "Free Mind", "Rule Breaker"]}
    {factors = ["background.hackflows_leper"],       nicknames = ["Rags", "Wrapped One", "Spotted"]}
    {factors = ["background.hackflows_atilliator"],  nicknames = ["Gear Head", "Tinkerer", "Gadget Boy"]}
];
