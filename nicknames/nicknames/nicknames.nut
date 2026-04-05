local def = ::Nicknames;

def.Weights <- {
    Combo      = 10
    Attr       = 5
    Trait      = 3
    Talent     = 2
    Background = 1
    Weapon     = 1
};

// Custom trait nicknames (on top of vanilla .m.Titles read at runtime)
def.TraitNicknames <- {
    "trait.strong": ["Bonebreaker", "Strongarm", "Irongrip"]
    "trait.brave": ["Lionheart", "the Valiant", "Stoutheart"]
    "trait.craven": ["Cold Feet", "Shaky Knees", "the Reluctant"]
    "trait.fat": ["Barrel", "Lardball", "the Wide"]
    "trait.huge": ["Bigfoot", "the Colossus", "Thunderstep"]
    "trait.tiny": ["Halfpint", "the Runt", "Thumbling"]
    "trait.dumb": ["Numbskull", "Simpleton", "the Clueless"]
    "trait.bright": ["Sharpwit", "Brainiac", "the Thinker"]
    "trait.bloodthirsty": ["Bloodlust", "the Savage", "Gore"]
    "trait.lucky": ["Four-Leaf", "Lucky Dog", "Lady's Favor"]
    "trait.drunkard": ["Boozy", "Barrel Bottom", "the Sloshed"]
    "trait.iron_jaw": ["Granite Face", "Hard Chin", "Unbreakable"]
    "trait.eagle_eyes": ["Hawkeye", "the Spotter", "Farsight"]
    "trait.swift": ["Lightning", "the Wind", "Quickstep"]
    "trait.survivor": ["Cockroach", "the Unkillable", "Last Man"]
    "trait.night_blind": ["the Mole", "Dusk Fumbler"]
    "trait.short_sighted": ["Squinter", "Mole Eyes"]
    "trait.clubfooted": ["Stumbles", "the Hobbler"]
    "trait.asthmatic": ["Wheezy", "the Puffer"]
    "trait.gluttonous": ["Bottomless Pit", "Gobbler", "the Hungry"]
    "trait.greedy": ["Goldfingers", "Penny Pincher", "the Miser"]
    "trait.paranoid": ["Tinfoil", "Eyes Everywhere"]
    "trait.pessimist": ["Gloom", "Raincloud", "the Downer"]
    "trait.optimist": ["Sunshine", "Smiley", "the Cheerful"]
    "trait.cocky": ["Hotshot", "Big Mouth", "the Showoff"]
    "trait.disloyal": ["Turncoat", "Shifty"]
    "trait.deathwish": ["the Reckless", "No Tomorrow", "Death's Friend"]
    "trait.fearless": ["Nerves of Steel", "Stone Cold"]
    "trait.determined": ["Iron Will", "the Relentless", "the Stubborn"]
    "trait.tough": ["Thick Skin", "Ironhide"]
    "trait.brute": ["Knuckles", "Meatfist"]
    "trait.impatient": ["Twitchy", "Antsy", "the Restless"]
    "trait.fragile": ["Glass Bones", "Paper Skin"]
    "trait.superstitious": ["Rabbit Foot", "Hex Dodger"]
    "trait.bleeder": ["Red Fountain", "Leaky"]
    "trait.hate_undead": ["Gravebane", "the Exorcist"]
    "trait.hate_greenskins": ["Tusk Breaker", "Greenskin Bane"]
    "trait.hate_beasts": ["Monster Bane", "Beast Slayer"]
    "trait.iron_lungs": ["the Tireless", "Never Winded"]
    "trait.fear_undead": ["Bone Shaker", "Ghost Pale"]
    "trait.fear_beasts": ["Fur Allergy", "Beast Shy"]
    "trait.fear_greenskins": ["Orc Shy", "Green Pale"]
    "trait.loyal": ["True Heart", "the Faithful"]
    "trait.weasel": ["Sly", "the Sneaky"]
    "trait.dastard": ["Yellow Belly", "the Cringe"]
    "trait.hesitant": ["Slowstart", "the Hesitant"]
    "trait.insecure": ["Shaky", "the Doubtful"]
    "trait.irrational": ["Wildcard", "Loose Cannon"]
    "trait.fainthearted": ["Pale Face", "the Meek"]
    "trait.clumsy": ["Butterfingers", "Fumbles"]
    "trait.quick": ["Quickdraw", "the Agile"]
    "trait.dexterous": ["Deft Hands", "the Nimble"]
    "trait.sure_footing": ["Steady", "Surefoot"]
    "trait.night_owl": ["the Night Owl", "Moonwatcher"]
    "trait.teamplayer": ["the Team Player", "Brother-in-Arms"]
    "trait.athletic": ["the Athlete", "Sprinter"]
    // Legends traits
    "trait.legend_aggressive": ["the Aggressor", "Hotblood"]
    "trait.legend_fear_dark": ["Shadowfear", "the Nyctophobe"]
    "trait.legend_light": ["Featherweight", "Light Step"]
    "trait.legend_double_tongued": ["Two-Face", "Forked Tongue"]
};

// Custom background nicknames (on top of vanilla .m.Titles)
def.BackgroundNicknames <- {
    "farmhand": ["Pitchfork", "Mudfoot", "Hay Bale"]
    "daytaler": ["Odd Jobs", "Dusty Hands", "the Drifter"]
    "sellsword": ["Blade for Hire", "Coin Soldier"]
    "militia": ["Gate Watch", "Town Guard"]
    "servant": ["Yes Sir", "Boot Polisher"]
    "mason": ["Stonefist", "Brickhand"]
    "miller": ["Flour Dust", "Grindstone"]
    "poacher": ["Night Arrow", "Snare Setter"]
    "ratcatcher": ["Rat King", "Pied Piper"]
    "peddler": ["Tinker", "Cheap Wares"]
    "brawler": ["Bare Knuckles", "Bruiser"]
    "bowyer": ["Stringfinger", "Shaft"]
    "messenger": ["Dispatch", "Swift Foot"]
    "tailor": ["Needlefingers", "Patches"]
    "squire": ["Shield Bearer", "the Hopeful"]
    "houndmaster": ["Dog Whisperer", "Alpha"]
    "vagabond": ["Roadworn", "Dustwalker"]
    "gravedigger": ["Shovel", "Bone Picker"]
    "bastard": ["No Name", "Half-Blood"]
    "graverobber": ["Tomb Raider", "the Ghoul"]
    "adventurous_noble": ["Blue Blood", "the Adventurer"]
    "disowned_noble": ["Fallen Grace", "Lost Crown"]
    "retired_soldier": ["Old Guard", "Rusty Blade"]
    "caravan_hand": ["Dusty Boots", "Road Dog"]
    "flagellant": ["Whip Mark", "Scar Back"]
    "wildman": ["Beastblood", "the Feral"]
    "witchhunter": ["Witch Finder", "Stake and Fire"]
    "hedge_knight": ["the Jouster", "Wandering Blade"]
    "swordmaster": ["Old Blade"]
    "apprentice": ["Still Learning", "Half-Trained"]
    "refugee": ["No Home", "the Displaced"]
    // XBE backgrounds
    "hackflows_falconer": ["Hawkmaster", "Bird Caller", "Sky Eye"]
    "hackflows_hangman": ["Noose", "Gallows Hand", "Neck Stretcher"]
    "hackflows_pirate": ["Sea Dog", "Plank Walker", "Barnacle"]
    "hackflows_berserker": ["Rager", "Foaming Mouth", "Bloodlust"]
    "hackflows_carpenter": ["Sawdust", "Nailbiter", "Splinter"]
    "hackflows_barkeep": ["Tap Master", "Ale Lord", "Last Call"]
    "hackflows_herbalist": ["Green Thumb", "Leaf Picker", "Root Digger"]
    "hackflows_con_artist": ["Smooth Talker", "the Grifter", "Fast Talk"]
    "hackflows_bodyguard": ["the Shield", "Iron Shadow", "Watchdog"]
    "hackflows_bounty_hunter": ["Headhunter", "the Tracker", "Bounty"]
    "hackflows_blacksmith": ["Anvil Striker", "Hammer", "Sparks"]
    "hackflows_cook": ["Stewpot", "Spice", "Hot Pot"]
    "hackflows_surgeon": ["Sawbones", "Stitcher", "Bloodstained"]
    "hackflows_torturer": ["Thumbscrew", "the Wrack", "Stretcher"]
    "hackflows_town_watchman": ["Night Watch", "Gate Guard", "Bell Ringer"]
    "hackflows_roofer": ["Shingles", "High Step", "Roofwalker"]
    "hackflows_cobbler": ["Sole Fixer", "Bootmaker", "Heel"]
    "hackflows_drifter": ["Tumbledown", "Dustwalker", "Nowhere Man"]
    "hackflows_lancer": ["Pointy Boy", "the Lancer", "Tilt"]
    "hackflows_master_archer": ["Sharp Eye", "Arrow", "Deadshot"]
    "hackflows_outlander": ["the Stranger", "Outsider", "Far Walker"]
    "hackflows_arbalester": ["Ballista Boy", "Heavy Bolt", "Crank"]
    "hackflows_druid": ["Tree Hugger", "Moss Beard", "Bark Skin"]
    "hackflows_fletcher": ["Arrow Maker", "Featherman", "Quill"]
    "hackflows_gardener": ["Plant Man", "Green Fingers", "Weeder"]
    "hackflows_locksmith": ["Picklock", "Lock Buster", "Key Master"]
    "hackflows_myrmidon": ["Arena Rat", "Ant Soldier", "Pit Fighter"]
    "hackflows_painter": ["Brush Dude", "Color Hands", "Canvas"]
    "hackflows_skirmisher": ["Hit Run", "Quick Jab", "Stinger"]
    "hackflows_cartographer": ["Map Man", "Compass", "Pathfinder"]
    "hackflows_dissenter": ["Rebel", "Free Mind", "Rule Breaker"]
    "hackflows_leper": ["Rags", "Wrapped One", "Spotted"]
    "hackflows_atilliator": ["Gear Head", "Tinkerer", "Gadget Boy"]
};

// Talent nicknames by attribute index (for 3-star talents)
// Index: 0=Hitpoints, 1=Stamina, 2=MeleeSkill, 3=Initiative, 4=RangedSkill, 5=Bravery, 6=MeleeDefense, 7=RangedDefense
def.TalentNicknames <- [
    ["Tank", "Thick Hide", "Meatbox"],                         // 0: Hitpoints
    ["the Machine", "Never Tired", "Stamina Freak"],           // 1: Fatigue/Stamina
    ["Swordguy", "Blade Master", "Choppy"],                    // 2: MeleeSkill
    ["Quick Feet", "Twitchy", "Fastdraw"],                     // 3: Initiative
    ["Arrow Wizard", "Shots On Point", "Bullseye"],            // 4: RangedSkill
    ["Fearless", "No Doubts", "Guts"],                         // 5: Bravery/Resolve
    ["Slippy", "Evasive", "Never Touched"],                    // 6: MeleeDefense
    ["Dodgy", "Untouchable Ranged", "Bulletproof"]             // 7: RangedDefense
];

// Attribute nicknames for extreme values (generated dynamically based on background range)
// Format: {attr getter name, high nicknames, low nicknames}
def.AttrNicknames <- [
    {attr = "Hitpoints",    high = ["Tank", "Chunky"],                  low = ["Squishy", "Paperman"]}
    {attr = "MeleeSkill",   high = ["Swordguy", "Choppy"],              low = ["Butterfingers", "Miss-a-lot"]}
    {attr = "RangedSkill",  high = ["Sharpshot", "Bullseye"],           low = ["Blind Archer", "Off-Target"]}
    {attr = "MeleeDefense", high = ["Dodgy", "Untouchable"],            low = []}
    {attr = "RangedDefense",high = ["Ranged Dodger", "Stray Proof"],    low = []}
    {attr = "Bravery",      high = ["Fearless", "Guts"],                low = ["Scaredy Cat", "Jelly Legs"]}
    {attr = "Stamina",      high = ["Tireless", "Energizer"],           low = ["Huffpuff", "the Winded"]}
    {attr = "Initiative",   high = ["Zippy", "Speedster"],              low = ["Slowpoke", "Sluggish"]}
];

// Combo nicknames — the best, most creative, checked first
local ht = @(bro, id) def.hasTrait(bro, id);
local hb = @(bro, s)  def.hasBg(bro, s);
local wt = @(bro, t)  def.hasWeaponType(bro, t);
local ah = @(bro, a)  def.isAttrHigh(bro, a);
local WT = ::Const.Items.WeaponType;
def.ComboNicknames <- [
    // Trait + trait combos
    {check = @(bro) ht(bro, "trait.strong") && ht(bro, "trait.brave"),
     nicknames = ["Bulldozer", "the Hammer", "Unrelenting"]}
    {check = @(bro) ht(bro, "trait.strong") && ht(bro, "trait.huge"),
     nicknames = ["the Titan", "Goliath", "the Colossus"]}
    {check = @(bro) ht(bro, "trait.strong") && ht(bro, "trait.dumb"),
     nicknames = ["the Oaf", "Dumb Muscle", "Gentle Giant"]}
    {check = @(bro) ht(bro, "trait.brave") && ht(bro, "trait.deathwish"),
     nicknames = ["Glory Chaser", "Daredevil", "the Reckless"]}
    {check = @(bro) ht(bro, "trait.tiny") && ht(bro, "trait.swift"),
     nicknames = ["the Gnat", "Little Lightning", "Ankle Biter"]}
    {check = @(bro) ht(bro, "trait.fat") && ht(bro, "trait.tough"),
     nicknames = ["the Boulder", "Unmovable", "Meatshield"]}
    {check = @(bro) ht(bro, "trait.craven") && ht(bro, "trait.lucky"),
     nicknames = ["Born Survivor", "Slippery", "the Dodger"]}
    {check = @(bro) ht(bro, "trait.bright") && ht(bro, "trait.eagle_eyes"),
     nicknames = ["the Tactician", "All-Seeing", "Mastermind"]}
    {check = @(bro) ht(bro, "trait.drunkard") && ht(bro, "trait.brave"),
     nicknames = ["Dutch Courage", "Liquid Bravery", "Booze Berserker"]}
    {check = @(bro) ht(bro, "trait.bloodthirsty") && ht(bro, "trait.brute"),
     nicknames = ["the Maniac", "Gore Fiend", "Maddog"]}
    {check = @(bro) ht(bro, "trait.greedy") && ht(bro, "trait.disloyal"),
     nicknames = ["the Mercenary", "Sold Soul", "Coin Chaser"]}
    {check = @(bro) ht(bro, "trait.pessimist") && ht(bro, "trait.craven"),
     nicknames = ["Doomed", "Walking Misery", "the Grim"]}
    {check = @(bro) ht(bro, "trait.huge") && ht(bro, "trait.bloodthirsty"),
     nicknames = ["the Ogre", "Man Eater", "the Horror"]}
    {check = @(bro) ht(bro, "trait.tiny") && ht(bro, "trait.bright"),
     nicknames = ["the Imp", "Little Professor", "Small but Sharp"]}
    {check = @(bro) ht(bro, "trait.drunkard") && ht(bro, "trait.fat"),
     nicknames = ["the Keg", "Tavern King", "Beer Belly"]}
    {check = @(bro) ht(bro, "trait.optimist") && ht(bro, "trait.brave"),
     nicknames = ["Cheerful", "Always Grins", "Smileface"]}
    {check = @(bro) ht(bro, "trait.paranoid") && ht(bro, "trait.eagle_eyes"),
     nicknames = ["the Sentinel", "Ever Watchful"]}
    {check = @(bro) ht(bro, "trait.strong") && ht(bro, "trait.iron_jaw"),
     nicknames = ["the Fortress", "Unbreakable Wall", "Steelborn"]}
    {check = @(bro) ht(bro, "trait.swift") && ht(bro, "trait.brave"),
     nicknames = ["the Charger", "First In", "Vanguard"]}
    {check = @(bro) ht(bro, "trait.dumb") && ht(bro, "trait.huge"),
     nicknames = ["the Troll", "Simple Giant", "Big Dumb"]}

    // Background + trait combos
    {check = @(bro) hb(bro, "hedge_knight") && ht(bro, "trait.brave"),
     nicknames = ["the True Knight", "Gallant", "the Chivalrous"]}
    {check = @(bro) hb(bro, "thief") && ht(bro, "trait.lucky"),
     nicknames = ["the Phantom", "Ghost Fingers", "the Untouchable"]}
    {check = @(bro) hb(bro, "monk") && ht(bro, "trait.fearless"),
     nicknames = ["the Crusader", "Holy Fury", "Righteous Fist"]}
    {check = @(bro) hb(bro, "butcher") && ht(bro, "trait.bloodthirsty"),
     nicknames = ["the Slaughterhouse", "Blood and Guts", "Meatgrinder"]}
    {check = @(bro) hb(bro, "shepherd") && ht(bro, "trait.brave"),
     nicknames = ["the Sheepdog", "Wolf Among Sheep"]}
    {check = @(bro) hb(bro, "beggar") && ht(bro, "trait.lucky"),
     nicknames = ["Rags to Riches", "Fortune's Fool"]}
    {check = @(bro) hb(bro, "wildman") && ht(bro, "trait.huge"),
     nicknames = ["the Yeti", "Forest Giant", "Sasquatch"]}
    {check = @(bro) hb(bro, "cultist") && ht(bro, "trait.deathwish"),
     nicknames = ["the Martyr", "the Fanatic", "Self-Sacrifice"]}
    {check = @(bro) hb(bro, "minstrel") && ht(bro, "trait.bright"),
     nicknames = ["Silver Tongue", "the Poet", "Wordsmith"]}
    {check = @(bro) hb(bro, "gravedigger") && ht(bro, "trait.tough"),
     nicknames = ["Dirt Eater", "the Undertaker"]}
    {check = @(bro) hb(bro, "gambler") && ht(bro, "trait.lucky"),
     nicknames = ["the Jackpot", "Always Wins", "House Buster"]}
    {check = @(bro) hb(bro, "lumberjack") && ht(bro, "trait.strong"),
     nicknames = ["the Woodcutter", "Treesplitter", "Oak Feller"]}
    {check = @(bro) hb(bro, "miner") && ht(bro, "trait.tough"),
     nicknames = ["Rockjaw", "the Tunneler", "Iron Ore"]}
    {check = @(bro) hb(bro, "fisherman") && ht(bro, "trait.lucky"),
     nicknames = ["the Big Catch", "Golden Net"]}
    {check = @(bro) hb(bro, "ratcatcher") && ht(bro, "trait.tiny"),
     nicknames = ["the Rat", "Sewer Prince"]}
    {check = @(bro) hb(bro, "sellsword") && ht(bro, "trait.greedy"),
     nicknames = ["Gold Before Glory", "the Price Tag"]}
    {check = @(bro) hb(bro, "killer_on_the_run") && ht(bro, "trait.paranoid"),
     nicknames = ["the Hunted", "Looking Over Shoulder"]}
    {check = @(bro) hb(bro, "deserter") && ht(bro, "trait.craven"),
     nicknames = ["the Escaped", "Born Runner", "Fleet Foot"]}

    // Weapon + high attribute combos
    {check = @(bro) wt(bro, WT.Bow)      && ah(bro, "RangedSkill"),
     nicknames = ["the Sharpshooter", "Eagle's Arrow", "Bullseye"]}
    {check = @(bro) wt(bro, WT.Crossbow) && ah(bro, "RangedSkill"),
     nicknames = ["the Sniper", "Bolt of Death", "One Shot"]}
    {check = @(bro) wt(bro, WT.Sword)    && ah(bro, "MeleeSkill"),
     nicknames = ["Surecut", "Deathstroke", "the Duelist"]}
    {check = @(bro) wt(bro, WT.Axe)      && ht(bro, "trait.strong"),
     nicknames = ["Skull Splitter", "the Woodcutter", "Axe Storm"]}
    {check = @(bro) wt(bro, WT.Spear)    && ah(bro, "Initiative"),
     nicknames = ["First Blood", "the Viper", "Quick Jab"]}
    {check = @(bro) wt(bro, WT.Hammer)   && ht(bro, "trait.strong"),
     nicknames = ["Earthshaker", "the Crusher", "Plate Buster"]}
    {check = @(bro) wt(bro, WT.Dagger)   && ht(bro, "trait.tiny"),
     nicknames = ["Little Sting", "Flea Bite", "Pin Prick"]}
    {check = @(bro) wt(bro, WT.Polearm)  && ah(bro, "MeleeSkill"),
     nicknames = ["the Reaper", "Long Arm of Death"]}
    {check = @(bro) wt(bro, WT.Flail)    && ht(bro, "trait.brute"),
     nicknames = ["Whirlwind of Pain", "Chain Fury"]}
    {check = @(bro) wt(bro, WT.Mace)     && ah(bro, "MeleeSkill"),
     nicknames = ["Skull Denter", "the Concussor"]}

    // Talent + background combos
    {check = @(bro) bro.m.Talents[2] == 3 && def.isEliteBg(bro),
     nicknames = ["Born Mercenary", "Natural Killer"]}
    {check = @(bro) bro.m.Talents[4] == 3 && hb(bro, "hunter"),
     nicknames = ["the Deadeye", "Hawk", "Nature's Archer"]}
    {check = @(bro) bro.m.Talents[0] == 3 && ht(bro, "trait.strong"),
     nicknames = ["Doom Blade", "the Annihilator", "Wrecking Ball"]}
    {check = @(bro) bro.m.Talents[4] == 3 && ht(bro, "trait.eagle_eyes"),
     nicknames = ["Telescopic", "the Sharpshooter"]}
    {check = @(bro) bro.m.Talents[2] == 3 && hb(bro, "squire"),
     nicknames = ["Future Knight", "the Promising"]}
    {check = @(bro) bro.m.Talents[5] == 3 && hb(bro, "monk"),
     nicknames = ["the Abbot", "Voice of God"]}
];
