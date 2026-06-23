type = 0;
target_gear = -1;
tab = 1;
badname = 0;

rows = 0;

picker = new ColourPicker(20, 550, 350);
picker.disable_textures = true;
start_colour = -1;

tooltip = "";
tooltip2 = "";
item_name = [];
role_names_all = "";

type_names = {
    "1": "Primary Color",
    "2": "Secondary Color",
    "3": "Pauldron 1 Color",
    "4": "Pauldron 2 Color",
    "5": "Trim Color",
    "6": "Lens Color",
    "7": "Weapon Color",
    "sgt_helm_primary": "Sgt Helm Primary",
    "sgt_helm_secondary": "Sgt Helm Secondary",
};

type_fields = [
    "",
    "main_color",
    "secondary_color",
    "left_pauldron",
    "right_pauldron",
    "main_trim",
    "lens_color",
    "weapon_color",
];

possible_custom_roles = [
    [
        "chapter_master",
        eROLE.CHAPTERMASTER,
    ],
    [
        "honour_guard",
        eROLE.HONOURGUARD,
    ],
    [
        "veteran",
        eROLE.VETERAN,
    ],
    [
        "terminator",
        eROLE.TERMINATOR,
    ],
    [
        "captain",
        eROLE.CAPTAIN,
    ],
    [
        "dreadnought",
        eROLE.DREADNOUGHT,
    ],
    [
        "champion",
        eROLE.CHAMPION,
    ],
    [
        "tactical",
        eROLE.TACTICAL,
    ],
    [
        "devastator",
        eROLE.DEVASTATOR,
    ],
    [
        "assault",
        eROLE.ASSAULT,
    ],
    [
        "ancient",
        eROLE.ANCIENT,
    ],
    [
        "scout",
        eROLE.SCOUT,
    ],
    [
        "chaplain",
        eROLE.CHAPLAIN,
    ],
    [
        "apothecary",
        eROLE.APOTHECARY,
    ],
    [
        "techmarine",
        eROLE.TECHMARINE,
    ],
    [
        "librarian",
        eROLE.LIBRARIAN,
    ],
    [
        "sergeant",
        eROLE.SERGEANT,
    ],
    [
        "veteran_sergeant",
        eROLE.VETERANSERGEANT,
    ],
];

slot_arrays = [
    "wep1", // eEQUIPMENT_SLOT.WEAPON_ONE
    "wep2", // eEQUIPMENT_SLOT.WEAPON_TWO
    "armour", // eEQUIPMENT_SLOT.ARMOUR
    "gear", // eEQUIPMENT_SLOT.GEAR
    "mobi", // eEQUIPMENT_SLOT.MOBILITY
];
