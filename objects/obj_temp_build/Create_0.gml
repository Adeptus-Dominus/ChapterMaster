target = noone;
planet = noone;
/// @type {Struct.PlanetData|undefined}
p_data = undefined;

window_x = 25;
window_y = 165;

/// @type {Struct.PurchaseButton|undefined}
build_lair_button = undefined;
/// @type {Struct.PurchaseButton|undefined}
build_arsenal_button = undefined;
/// @type {Struct.PurchaseButton|undefined}
build_gene_vault_button = undefined;
/// @type {Struct.UnitButtonObject|undefined}
back_button = undefined;

lair = false;
arsenal = false;
gene_vault = false;
secret_base = false;
lair_exists = false;
title = "";

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

set_planet_data = function(_p_data) {
    p_data = _p_data;
    target = p_data.system;
    planet = p_data.planet;
    refresh();
};

refresh = function() {
    secret_base = p_data.has_upgrade(eP_FEATURES.SECRET_BASE);
    arsenal = p_data.has_upgrade(eP_FEATURES.ARSENAL);
    gene_vault = p_data.has_upgrade(eP_FEATURES.GENE_VAULT);
    lair_exists = gene_vault || arsenal || secret_base;

    title = "";
    if (isnew) {
        title = localize("Secret Lair");
    } else if (!lair_exists) {
        title = localize("Build");
    } else if (secret_base) {
        title = localize("Secret Lair");
    } else if (arsenal) {
        title = localize("Secret Arsenal");
    } else if (gene_vault) {
        title = localize("Secret Gene-Vault");
    }

    title += $" {p_data.name()}";

    build_lair_button = new PurchaseButton({
        x1: window_x + 300,
        y1: window_y + 45,
        set_width: true,
        w: 100,
        label: "Build",
        font: fnt_40k_14,
        color: c_black,
    }, 1000);
    build_lair_button.bind_method = function() {
        isnew = true;
        refresh();
    };

    build_arsenal_button = new PurchaseButton({
        x1: window_x + 300,
        y1: window_y + 110,
        set_width: true,
        w: 100,
        label: "Build",
        font: fnt_40k_14,
        color: c_black,
    }, 1500);
    build_arsenal_button.bind_method = function() {
        p_data.add_upgrade(eP_FEATURES.ARSENAL);
        refresh();
    };

    build_gene_vault_button = new PurchaseButton({
        x1: window_x + 300,
        y1: window_y + 175,
        set_width: true,
        w: 100,
        label: "Build",
        font: fnt_40k_14,
        color: c_black,
    }, 4000);
    build_gene_vault_button.bind_method = function() {
        p_data.add_upgrade(eP_FEATURES.GENE_VAULT);
        refresh();
    };

    back_button = new UnitButtonObject({
        x1: window_x + 252,
        y1: window_y + 388,
        set_width: true,
        w: 120,
        label: "Back",
        font: fnt_40k_30b,
        color: c_black,
        bind_scope: id,
        bind_method: function() {
            obj_controller.menu = eMENU.DEFAULT;
        },
    });
};
