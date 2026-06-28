local gt = this.getroottable();
if (!("Companions" in gt.Const))
{
	gt.Const.Companions <- {};
}

gt.Const.Companions.CanineNames <- [
	"Bruno", "Hunter", "Smoke", "Outlaw", "Kane", "Digger", "Lightning", "Oracle", "Phantom",
	"Mudroch", "Hawkeye", "Bullet",	"Loki", "Riggs", "Comet", "Bear", "Lupus", "Echo", "Snow",
	"Ball",	"Rider", "Dane", "Brutus", "Thunder", "Jax", "Bones", "Riptide", "Hercules",
	"Phoenix", "Twilight", "Myth", "Tank", "Bruno",	"Farkas", "Magnus", "Brock", "Silver",
	"Brown", "Trouble", "Drake", "Ice", "Grunt", "Maverick", "Hannibal", "Bane", "Boulder",
	"Blaze", "Dash", "Atilla", "Scar", "Hulk", "Alpha", "Archer", "Boon", "Nero", "Storm",
	"Ralph", "Jinx", "Fern", "Brick", "Titan", "Shade", "Menace", "Blitz", "Justice", "Raven",
	"Hector", "Rebel", "Dust", "Maximus", "Caesar", "Logan", "Shadow", "Camelot", "King",
	"Bolt", "Judge", "Odin", "Shredder", "Mayhem", "Sly", "Omen", "Razor", "Lupin", "Ghost",
	"Frost", "Goliath", "Baron", "Fury", "Nightmare", "Diablo",	"Lotus", "Rags", "Whisper",
	"Dot", "Rogue",	"Bo", "Chronos", "Winter", "Lore", "Banshee"
];
this.Const.Companions.CanineNames.extend(this.Const.Strings.WardogNames);

gt.Const.Companions.SlitherachnoNames <- [
	"Szeq\'ri", "Ichik\'zol", "Ok\'tur", "Raq\'rud", "Cor\'os", "Zit\'iced", "Qaq\'rivir",
	"Nair\'eh", "At\'or", "Zachik\'sas", "Khocuk\'zed", "Chian\'qe", "Char\'al", "Qezeet\'ih",
	"Nash\'ti", "Rhas\'tol", "Yak\'seesil", "Sak\'sieh", "Esit\'iar", "As\'tu",	"Nok\'sul",
	"Ziq\'rid", "Cek\'zo", "Yeezis\'tis", "Zhocit\'is", "Sen\'qeh", "Ros\'tah", "Yit\'er",
	"Khis\'ti", "Rhis\'tuq", "Zhik\'zuq", "Niq\'rih", "Seet\'u", "Yeq\'rud", "Zhir\'ar",
	"Khen\'qir", "Szek\'seer", "Qait\'oq", "Lan\'qiq", "At\'eeh", "Zheq\'ririaq", "Ik\'suza",
	"Qhes\'tuq", "Qot\'el", "Qhaik\'zil", "Qhas\'til", "Cik\'ziq", "Cit\'ol", "Zees\'toq",
	"Lar\'a", "Savoq\'ri", "Aq\'ro", "Qaq\'roh", "Eq\'rar", "An\'qad", "Yik\'ziq", "Nis\'tod",
	"Zharik\'se", "Rat\'oq", "Nik\'sah", "Reeq\'rie", "Khas\'tar", "En\'qiqar", "Sin\'qeh",
	"It\'e", "Chair\'os", "Cicer\'oh", "Er\'ee", "Seek\'sod", "Szet\'i", "Yaik\'zaq", "Nak\'rix",
	"Caqel\'zas", "Ok\'zax", "Kal\'zichab", "Lat\'as", "Kriqurk\'aat", "Srin\'qax", "Sricik\'rox",
	"Nek\'za", "Chak\'zokir", "Neq\'zachar", "Es\'tizar", "Ork\'urrax", "Zel\'zeex", "Szaaq\'tir",
	"Krak\'sax", "Sichaq\'zar", "Nos\'tieqix", "Kik\'rutes", "Oug\'zee", "Qhok\'saciad",
	"Sacog\'zar", "Kiq\'zaq", "Sairul\'zis", "Zork\'ab", "Kek\'zeb", "Naq\'tiet", "Srak\'sux",
	"Oun\'qit", "Zrel\'zut", "Srazark\'et", "Otin\'qaix", "Kreeq\'zid", "Krikos\'te", "Krak\'sis",
	"Rik\'saq", "Ark\'iit", "Kiqork\'er", "Rhacuq\'zax", "Yial\'zit", "San\'qo", "Krork\'iq",
	"Sriakog\'zi", "Zren\'qiex", "Zrex\'ut", "Chok\'riq", "Zrezis\'tiq", "Qirk\'ees", "Izik\'ze",
	"Szal\'zob", "Srarrix\'aaq", "Leex\'ieria", "Zeen\'qiq", "Rhouk\'rix", "Yak\'rox", "Rel\'zuq",
	"Zril\'zax", "Sreek\'terri", "Kais\'za", "Yex\'uq", "Eek\'zucheb", "Khakiq\'zot", "Al\'zix"
];

gt.Const.Companions.GutturalNames <- [
	"Koq", "Guaq", "Zajoq", "Chatzug", "Butgaq", "Voz", "Jik", "Ubac", "Rubbag", "Rixzok",
	"Boz", "Vok", "Bax", "Khograk", "Kunaq", "Khaz", "Zujid", "Khok", "Gux", "Kog", "Joqric",
	"Auskux", "Agzac", "Orgod", "Bod", "Khud", "Uquk", "Onkoz", "Boq", "Vuq", "Vodrut",
	"Guzzax", "Ralgruq", "Gubbot", "Galgac", "Chot", "Gattaz", "Jutgouz", "Vaut", "Gaubnac",
	"Kottaug", "Khixnog", "Kodrod", "Urduq", "Jugrik", "Gaz", "Gurgud", "Khitgoq", "Zogrok",
	"Zoug", "Kalkrak", "Koktoc", "Chuk", "Zuxxat", "Umkag", "Khoz", "Zusgaz", "Vuk", "Aggox",
	"Ruknat", "Bokux", "Varak", "Orok", "Khik", "Vugduq", "Rablok", "Banzod", "Jalkog", "Zuk",
	"Jogzud", "Oxuz", "Khax", "Khingrok", "Askrauq", "Babloz", "Khutaq", "Ozbac", "Ukvod",
	"Kamux", "Atrac", "Gukuz", "Guthib", "Ardrok", "Chankrax", "Khuksud", "Burvod", "Zumgud",
	"Juk", "Gaxzoz", "Chokdux", "Khosqot", "Kirbug", "Chonkrok", "Zolkot", "Chalgog", "Ongrod",
	"Olduq", "Zosqid", "Aqok", "Zituq", "Uldoz", "Balgrag", "Onkag", "Rankuc", "Aqruq", "Gog",
	"Gunkat", "Khak", "Kitgut", "Khugot", "Khuzut", "Boxud", "Bidroq", "Kazluz", "Vamkag",
	"Zudrid", "Gonkrid", "Vuzbuk", "Gakzak", "Bingrok", "Akgix", "Chokgog", "Ilgruk", "Vabluz"
];

gt.Const.Companions.TreefolkNames <- [
	"Pervalur", "Tralen", "Carnel", "Fenmaris", "Elakas", "Glynmenor", "Waesven", "Genren",
	"Lutoris", "Qinnorin", "Thelamin", "Heimenor", "Dornan", "Tracan", "Advalur", "Elsalor",
	"Kelxalim", "Naehorn", "Aexidor", "Raloris", "Fenwarin", "Leolar", "Keanan", "Qidark",
	"Umero", "Patoris", "Urijor", "Olonan", "Fenwraek", "Zumvalur", "Mirasalor", "Kelqen",
	"Paren", "Permaer", "Lujor", "Leoran", "Eljor", "Sarren", "Sarfir", "Zumfaren", "Naeceran",
	"Adnorin", "Wranneiros", "Perxalim", "Naetoris", "Gensalor", "Farquinal", "Ilizeiros",
	"Norkian", "Aelen", "Waesran", "Beifir", "Mirawraek", "Heryarus", "Lumaris", "Farlen",
	"Elpetor", "Mormaris", "Iliris", "Zinsandoral", "Morkian", "Vacan", "Elaven", "Zumtoris",
	"Trawarin", "Glynhice", "Tramenor", "Crafaren", "Virpetor", "Zumneiros", "Hervalur",
	"Wranlar", "Sylnorin", "Beisendoral", "Daepetor", "Dorlar", "Norgeiros", "Naelamin",
	"Fargolor", "Dorlamin", "Vavalur", "Theven", "Ologolor", "Zumzumin", "Waeshice", "Carxalim"
];

gt.Const.Companions.SpookNames <- [
	"Criozhar", "Shelak", "Strigrim", "Krorius", "Dagrim", "Ocraedulus", "Rivok", "Folekai",
	"Waxor", "Krivok", "Saugan", "Gerow", "Griozhul", "Prokar", "Straqir", "Izexius", "Gemien",
	"Kedulus", "Staulak", "Beigrim", "Istoughor", "Namien", "Wozhul", "Huthik", "Vuxir",
	"Cedum", "Upimien", "Chothum", "Wavras", "Houlak", "Braghor", "Crozius", "Ludulus",
	"Stequr", "Drolazar", "Caudum", "Nogrim", "Bibrum", "Waekhar", "Ridhur", "Bouthum",
	"Xeqir", "Acrazad", "Verius", "Atiozhul", "Lebrum", "Faevras", "Kroxor", "Bakras",
	"Ceithik", "Vremon", "Withik", "Adiokras", "Edrapent", "Mauthum", "Lodan", "Gerius",
	"Taezor", "Caxius", "Nupent", "Yorius", "Brelazar", "Shizhar", "Otazad", "Mozhul",
	"Apekar", "Vrizad", "Dikhar", "Edabrum", "Mazius", "Dithik", "Tarael", "Vaelekai",
	"Sazius", "Hicular", "Belak", "Gozhar", "Afatic", "Tazhul", "Prethum", "Procular",
	"Hezar", "Shozar", "Vraughor", "Paekar", "Vizhul", "Veghor", "Rouxius", "Exakai",
	"Xaxor", "Achelazar", "Ecedulus", "Igrexius", "Wrurius", "Gazhul", "Greilazar",
	"Mevok", "Mezor", "Caelekai", "Wramien", "Zemien", "Tacular", "Drulazar", "Kiodum"
];
