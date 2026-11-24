target = noone;
planet = noone;
/// @type {Struct.PlanetData|undefined}
p_data = undefined;

lair = false;
arsenal = false;
gene_vault = false;

isnew = false;
forge = false;
hippo = false;
beastarium = false;
torture = false;
narcotics = false;
relic = 0;
cookery = false;
vox = false;
librarium = false;
throne = false;
stasis = false;
stasis_occupants = "";
swimming = false;


// ** Secret Lair styles **
lair_styles = [
    {
        name: "Barbarian",
        description: "Heavy on leather, hides, and trophy body parts.",
        tag: "BRB",
    },
    {
        name: "Disco",
        description: "Rainbow colored dance floor and steel rafters.",
        tag: "DIS",
    },
    {
        name: "Feudal",
        description: "Lots of stone, metal filigree, and statues.",
        tag: "FEU",
    },
    {
        name: "Gothic",
        description: "Lightly-dusty stone, mosaics, and statues throughout.",
        tag: "GTH",
    },
    {
        name: "Mechanicus",
        description: "Grates, tubes, gears, and augmented reality.",
        tag: "MCH",
    },
    {
        name: "Prospero",
        description: "Marble or sandstone surfaces and gold filigree.",
        tag: "PRS",
    },
    {
        name: "Rave Club",
        description: "Large, open area with neon or strobe lights.",
        tag: "RAV",
    },
    {
        name: "Steel",
        description: "Stainless steel surfaces and water fountains.",
        tag: "STL",
    },
    {
        name: "Utilitarian",
        description: "Plaster or concrete surfaces with carpeting.",
        tag: "UTL",
    },
];

static set_planet_data = function(_p_data){
	self.p_data = _p_data;
	target = p_data.system;
	planet = p_data.planet;
	refresh();
}

static refresh = function(){
	var planet_upgrades = p_data.upgrades;
	secret_base = p_data.has_upgrade(eP_FEATURES.SECRET_BASE));
	arsenal = p_data.has_upgrade(eP_FEATURES.ARSENAL));
	gene_vault = p_data.has_upgrade(eP_FEATURES.GENE_VAULT));
	lair_exists = gene_vault || arsenal || secret_base;
	title = "";
	if (isnew){
		title = localize("Secret Lair");
	} else {
	    if (!lair_exists) {
	        title = localize("Build");
	    } else {
	        if (secret_base) {
	            title = localize("Secret Lair");
	        } else if (arsenal) {
	            title = localize("Secret Arsenal");
	        } else if (gene_vault) {
	            title = localize("Secret Gene-Vault");
	        }
	    }
	}
	title += " {_p_data.name()}"
}