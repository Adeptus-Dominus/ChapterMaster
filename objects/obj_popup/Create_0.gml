type = 0;
size = 2;
y_scale = 1;
sprite_index = spr_popup_medium;

// Popup windows draw in Draw GUI; hide the automatic instance sprite.
image_alpha = 0;
image_speed = 0;
image_wid = 0;
image_hei = 0;
image = "";

master_crafted = 0;
hide = false;
if (instance_exists(obj_controller)) {
    if (obj_controller.popup_master_crafted != 0) {
        master_crafted = obj_controller.popup_master_crafted;
    }
}
title = "";
fancy_title = 0;
text_center = 0;
text = "";
text2 = "";
reset_popup_options();
pathway = "";
option1enter = false;
option2enter = false;
option3enter = false;
option4enter = false;
pop_data = {};
amount = 0;
save = 0;
loc = "";
planet = 0;
estimate = 0;
mission = "";
old_tags = "";
giveto = 0;
inq_hide = 0;
ma_co = 0;
ma_id = 0;
manag = 0;
fallen = 0;
ship_lost = 0;
battle_special = 0;
owner = 0;
tab = 1;
woopwoopwoop = 0;
press = -1;
reset = 0;
demand = 0;

options = [];

add_option = method(self, add_option);
replace_options = method(self, replace_options);

entered_option = -1;

subtype = 0;

company = 0;
target_comp = -1;
target_role = -1;
unit_role = "";
units = 0;
min_exp = 0;
cooldown = 20;
all_good = 0;
prev_selected = 0;

if (instance_exists(obj_controller)) {
    obj_controller.cooldown = 8000;
}
number = 0;
company_promote_data = [
    {
        exp: 0,
    },
    //index 0 = draw x, 1 = draw y, 2 = exp requirement for company
    {
        exp: 100,
    }, //1st company
    {
        exp: 65,
    },
    {
        exp: 65,
    },
    {
        exp: 65,
    },
    {
        exp: 65,
    },
    {
        exp: 45,
    },
    {
        exp: 45,
    },
    {
        exp: 35,
    },
    {
        exp: 25,
    },
    {
        exp: 15,
    }, //10th company
];

promote_roles = [];

// TODO: connect this logic with the other_manage_data() to reduce verboseness;
get_unit_promotion_options = function() {
    var _role_data = obj_ini.player_role_data;
    var _company_units = collect_company(target_comp);
    var spec = 0;
    promote_roles = [];
    // this area does the required exp for roles per company
    if (unit_role == _role_data[eROLE.TECHMARINE].role) {
        //techmarine
        array_push(promote_roles, {
            name: _role_data[eROLE.TECHMARINE].role,
            exp: 5,
            role_id: eROLE.TECHMARINE,
        });
        spec = 1;
    } else if (unit_role == _role_data[eROLE.APOTHECARY].role) {
        //apothecary
        array_push(promote_roles, {
            name: _role_data[eROLE.APOTHECARY].role,
            exp: 5,
            role_id: eROLE.APOTHECARY,
        });
        spec = 1;
    } else if (unit_role == _role_data[eROLE.CHAPLAIN].role && _role_data[eROLE.CHAPLAIN].available_to_player) {
        //chaplain
        array_push(promote_roles, {
            name: _role_data[eROLE.CHAPLAIN].role,
            exp: 5,
            role_id: eROLE.CHAPLAIN,
        });
        spec = 1;
    } else if (unit_role == _role_data[eROLE.LEXICANUM].role) {
        array_push(promote_roles, {
            name: _role_data[eROLE.LIBRARIAN].role,
            exp: 125,
            role_id: eROLE.LIBRARIAN,
        });
        spec = 1;
        array_push(promote_roles, {
            name: _role_data[eROLE.CODICIERY].role,
            exp: 80,
            role_id: eROLE.CODICIERY,
        });
    } else if (unit_role == _role_data[eROLE.CODICIERY].role) {
        array_push(promote_roles, {
            name: _role_data[eROLE.LIBRARIAN].role,
            exp: 125,
            role_id: eROLE.LIBRARIAN,
        });
        spec = 1;
    }
    if (target_comp > 0 && target_comp <= 10 && spec == 0) {
        if (units == 1) {
            //all captains are equalish
            var _singles = [
                {
                    role: eROLE.CAPTAIN,
                    exp: 80,
                },
                {
                    role: eROLE.ANCIENT,
                    exp: company_promote_data[target_comp].exp + 10,
                },
                {
                    role: eROLE.CHAMPION,
                    exp: company_promote_data[target_comp].exp + 10,
                },
            ];
            for (var s = 0; s < array_length(_singles); s++) {
                var _r_data = _singles[s];
                if (!_company_units.has_role(_r_data.role)) {
                    array_push(promote_roles, {
                        name: _role_data[_r_data.role].role,
                        exp: _r_data.exp,
                        role_id: _r_data.role,
                    });
                }
            }
            array_push(promote_roles, {
                name: _role_data[eROLE.DREADNOUGHT].role, //dreadnought
                exp: 200,
                role_id: eROLE.DREADNOUGHT,
            });
        }

        if (obj_controller.command_set[2] == 1) {
            if (array_contains([2, 3, 4, 5, 6, 7], target_comp)) {
                array_push(promote_roles, {
                    name: _role_data[eROLE.TACTICAL].role, //tacts
                    exp: company_promote_data[target_comp].exp,
                    role_id: eROLE.TACTICAL,
                });
            }

            if (array_contains([2, 3, 4, 5, 8], target_comp)) {
                array_push(promote_roles, {
                    name: _role_data[eROLE.ASSAULT].role, //assualts
                    exp: company_promote_data[target_comp].exp,
                    role_id: eROLE.ASSAULT,
                });
            }

            if (array_contains([2, 3, 4, 5, 9], target_comp)) {
                array_push(promote_roles, {
                    name: _role_data[eROLE.DEVASTATOR].role, //devs
                    exp: company_promote_data[target_comp].exp,
                    role_id: eROLE.DEVASTATOR,
                });
            }

            if (target_comp == 1) {
                array_push(promote_roles, {
                    name: _role_data[eROLE.TERMINATOR].role, //terminators
                    exp: 100,
                    role_id: eROLE.TERMINATOR,
                });
            }

            if (target_comp == 10) {
                array_push(promote_roles, {
                    name: _role_data[eROLE.SCOUT].role, //scouts
                    exp: company_promote_data[target_comp].exp,
                    role_id: eROLE.SCOUT,
                });
            }

            if (target_comp == 1) {
                array_push(promote_roles, {
                    name: _role_data[eROLE.VETERAN].role, //veterans
                    exp: 100,
                    role_id: eROLE.VETERAN,
                });
            }
        } else {
            array_push(promote_roles, {
                name: _role_data[eROLE.TACTICAL].role, //tacts
                exp: 0,
                role_id: eROLE.TACTICAL,
            });

            array_push(promote_roles, {
                name: _role_data[eROLE.ASSAULT].role, //assualts
                exp: 0,
                role_id: eROLE.ASSAULT,
            });

            array_push(promote_roles, {
                name: _role_data[eROLE.DEVASTATOR].role, //devs
                exp: 0,
                role_id: eROLE.DEVASTATOR,
            });

            array_push(promote_roles, {
                name: _role_data[eROLE.TERMINATOR].role, //terminators
                exp: 100,
                role_id: eROLE.TERMINATOR,
            });

            array_push(promote_roles, {
                name: _role_data[eROLE.SCOUT].role, //scouts
                exp: 0,
                role_id: eROLE.SCOUT,
            });

            array_push(promote_roles, {
                name: _role_data[eROLE.VETERAN].role, //veterans
                exp: 0,
                role_id: eROLE.VETERAN,
            });
        }
    }
    if ((target_comp == 0 || target_comp > 10) && (spec == 0)) {
        array_push(promote_roles, {
            name: _role_data[eROLE.HONOURGUARD].role, //honor guard
            exp: (obj_controller.command_set[2] == 0) ? 0 : 140,
            role_id: eROLE.HONOURGUARD,
        });
    }
};

req_armour = "";
req_armour_num = 0;
have_armour_num = 0;
req_gear = "";
req_gear_num = 0;
have_gear_num = 0;
req_wep1 = "";
req_wep1_num = 0;
have_wep1_num = 0;
req_wep2 = "";
req_wep2_num = 0;
have_wep2_num = 0;
req_mobi = "";
req_mobi_num = 0;
have_mobi_num = 0;

o_wep1 = "";
o_wep2 = "";
o_armour = "";
o_gear = "";
o_mobi = "";
n_wep1 = "";
n_wep2 = "";
n_armour = "";
n_gear = "";
n_mobi = "";
a_wep1 = "";
a_wep2 = "";
a_armour = "";
a_gear = "";
a_mobi = "";
n_good1 = 1;
n_good2 = 1;
n_good3 = 1;
n_good4 = 1;
n_good5 = 1;
sel1 = 0;
sel2 = 0;
sel3 = 0;
sel4 = 0;
sel5 = 0;
warning = "";
item_name = [];
