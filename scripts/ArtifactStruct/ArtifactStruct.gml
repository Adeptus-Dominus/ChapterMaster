/// @desc Blueprint for a single artifact. All data access goes through getters/setters; fields are private (__) or read-only (artifact_id).
/// @param {String} _type_name Base type name (e.g. "Power Fist")
/// @param {Array<String>} _tags
/// @param {Real} _identification_timer Turns remaining until identification
/// @param {String} _location_name Storage location (star name or "")
/// @param {Real} _ship_id Ship array index (-1 = not on a ship)
function ArtifactStruct(_type_name = "", _tags = [], _identification_timer = 0, _location_name = "", _ship_id = -1) constructor {
    // ###### Public ######
    static __next_id = 0;

    artifact_id = __next_id++;

    // ###### Private ######
    __type = "";
    __type_name = _type_name;
    __custom_name = "";
    __description = "";
    __custom_description = "";
    __tags = _tags;
    __identification_timer = _identification_timer;

    // TODO: Refactor bearer into using unit struct instead; save/load may be problematic
    /// @type {Array<Real>|Undefined}
    __bearer = undefined;

    // TODO: I hate how the entire location system is handled, refactor it one day, future me, please
    /// System name or ship name
    __location_name = _location_name;

    /// Ship array index (-1 = not on a ship, 0+ = ship index)
    __ship_id = _ship_id;

    // #######################
    // ###### Constants ######
    // #######################

    static TAG_DESCRIPTIONS = {
        "RUNE": "Several glowing runes have been carved along its surfaces.",
        "SCOPE": "An extremely finely crafted scope, with several lenses, sits on top.",
        "DUB": "Rather than a single power fist there is a matching pair of two.",
        "ADAMANTINE": "All ceremite on the weapon has been substituted for polished adamantium.",
        "VOI": "The weapon is black as night, with green, pulsing veins of an unknown energy.",
        "CHB": "The striking surface has been replaced with a very powerful chainblade.",
        "UFL": "A promethium flamethrower has been built in to the bottom of the weapon.",
        "GOLD": "It is decorated with gold filigree.",
        "GLOW": "It glows with an eery, soft blue color.",
        "UBOLT": "A bolter has been integrated.",
        "ART": "Much of the armour is made up of finely articulated plates, neatly interlocking.",
        "SPIKES": "A multitude of spikes, of varying sizes, adorn it.",
        "DRA": "Several areas of the armour have been patched over with Drake scales.",
        "PUR": "It has many crude purity seals.",
        "SUP": "It has been carved with such intricate detail that the facets are uncountable.",
        "SAL": "An emblem of a Fire Drake is embossed on the cover.",
        "BUR": "Small, non-burning flames lick across the surface.",
        "BIG": "It is of unusually large size.",
        "SOO": "It has a soothing appearance.",
        "MASK": "It is shaped and contorted into a Fearsome Mask.",
        "SKRE": "While on it lets out a tormented scream.",
        "SILENT": "Somehow it is completely silent in operation.",
        "GOR": "The arms are especially lengthy and massively strong.",
        "TENTACLES": "Instead of a single arm it is made up of many smaller tentacles.",
        "CRU": "Many parts of the device are crumbling apart and cracking from old age.",
        "SKU": "It is fashioned to resemble a massive pile of skulls of all races and ages.",
        "FAL": "It resembles an angel, fallen with broken wings, a sad look on its face.",
        "MIN": "The top panel seemingly writhes with motion, the geometric shapes blinding to behold.",
        "GOAT": "It resembles a bipedal goat with odd skin blemishes and four small horns.",
        "THI": "Carved on top is a strange creature with elongated limbs and small head.",
        "SPE": "The statue is of a man with no eyes, ears, or nose.  The teeth are rotted and mishappen.",
        "DYI": "The statue is of an angel, sagging against a spear which has pierced its heart.",
        "JUM": "It resembles a scene of small children with large heads happily jumping into a pit of magma.",
        "CHE": "The statue resembles a fat grinx which smiles and looks outward with a malicious gaze.",
        "HU": "It is built in the likeness of an attractive human female.",
        "RO": "It is squat and fat, though tall, and has simple utilitarian limbs.",
        "SHI": "The device is covered in a thin layer of gold, which glitters and shines.",
        "JAD": "The machine is built out of a type of jade, pure black, with many veins of green.",
        "BRO": "The machine is made out of a strange bronze material that seems impossibly durable.",
        "MINOR": "It is more crude and utilitarian than one might expect from an artifact.",
    };

    static NOT_EQUIPPABLE = [
        "Statue",
        "Casket",
        "Chalice",
        "Robot",
        "Tome",
    ];

    static HERETICAL_TAGS = [
        "daemonic",
        "chaos_gift",
        "chaos",
    ];

    static FACTION_VALUE_PER_TAG = 2;

    static FACTION_TAGS_IMPERIUM = [
        "PUR",
        "ADAMANTINE",
        "GLOW",
        "CHB",
        "UFL",
        "UBOLT",
        "DUB",
    ];
    static FACTION_TAGS_MECHANICUS = [
        "PUR",
        "RO",
        "CRU",
    ];
    static FACTION_TAGS_INQUISITION = ["PUR"];
    static FACTION_TAGS_ECCLESIARCHY = [
        "PUR",
        "ART",
        "GOLD",
    ];
    static FACTION_TAGS_ELDAR = [
        "SUP",
        "ART",
        "JAD",
        "SILENT",
        "SCOPE",
    ];
    static FACTION_TAGS_ORK = [];
    static FACTION_TAGS_TAU = [
        "SUP",
        "ART",
        "BIG",
        "SOO",
        "SCOPE",
    ];
    static FACTION_TAGS_TYRANIDS = [];
    static FACTION_TAGS_CHAOS = [];
    static FACTION_TAGS_NECRONS = [];

    static FACTION_PREFERENCES = [
        [],
        [],
        FACTION_TAGS_IMPERIUM,
        FACTION_TAGS_MECHANICUS,
        FACTION_TAGS_INQUISITION,
        FACTION_TAGS_ECCLESIARCHY,
        FACTION_TAGS_ELDAR,
        FACTION_TAGS_ORK,
        FACTION_TAGS_TAU,
        FACTION_TAGS_TYRANIDS,
        FACTION_TAGS_CHAOS,
        FACTION_TAGS_CHAOS,
        FACTION_TAGS_TYRANIDS,
        FACTION_TAGS_NECRONS,
    ];

    static DEMON_SUMMON_THRESHOLD = 60;
    static DEMON_SUMMON_ENEMIES = 10;

    static DAEMON_CORRUPTION_MAX = 12;
    static DAEMON_WARNING_COOLDOWN = 8;

    // ############################
    // ###### Public Methods ######
    // ############################

    /// @desc Returns a plain struct with save-compatible key names
    /// @returns {Struct} serializable artifact data
    static to_json = function() {
        var _json = {
            artifact_id: artifact_id,
            type_name: __type_name,
            tags: __tags,
            identification_timer: __identification_timer,
            location_name: __location_name,
            ship_id: __ship_id,
            bearer: is_struct(__bearer) ? __bearer.uid : "",
            custom_name: __custom_name,
            custom_description: __custom_description,
        };

        return _json;
    };

    /// @desc Restores state from save data. Reads both the to_json() shape
    /// @param {Struct} data
    static from_json = function(data) {
        artifact_id = data.artifact_id;
        __type_name = data.type_name ?? "";
        __tags = data.tags ?? [];
        __identification_timer = data.identification_timer ?? 0;
        __location_name = data.location_name ?? "";
        __ship_id = data.ship_id ?? -1;
        __bearer = data.bearer == "" ? undefined : fetch_unit_uid(data.bearer);
        __custom_name = data.custom_name ?? "";
        __custom_description = data.custom_description ?? "";

        // Invalidate so it recomputes
        __type = "";
        __description = "";
    };

    /// @desc Decrements the identification countdown by one turn.
    static tick_identification = function() {
        if (__identification_timer > 0) {
            __identification_timer--;
        }
    };

    /// @desc Destroys the artifact. Daemonic artifacts destroyed while on a ship may trigger a demon summoning battle.
    /// @returns {Undefined}
    static destroy_artifact = function() {
        if (has_tag("daemonic")) {
            var _resolved = __resolve_location();
            if (_resolved.ship_id > -1) {
                var demonSummonChance = roll_dice_chapter(1, 100, "high");

                if ((demonSummonChance <= DEMON_SUMMON_THRESHOLD) && (obj_ini.ship_carrying[_resolved.ship_id] > 0)) {
                    instance_deactivate_all_safe();
                    instance_activate_object(obj_star);

                    /// @type {Asset.GMObject.obj_ncombat}
                    var _combat = instance_create_depth(0, 0, 0, obj_ncombat);
                    _combat.battle_special = "ship_demon";
                    _combat.formation_set = 1;
                    _combat.enemy = DEMON_SUMMON_ENEMIES;
                    _combat.battle_id = _resolved.ship_id;

                    instance_deactivate_object(obj_star);
                    setup_battle_formations();
                    scr_ship_battle(_resolved.ship_id, 999);
                    main_map_defaults();
                }
            }
        }
    };

    /// @desc Unequips this artifact from its bearer, clearing the appropriate equipment slot.
    static unequip_from_unit = function() {
        if (!is_equipped()) {
            return;
        }

        var _type = get_type();

        var _unit = __bearer;
        if (!is_struct(_unit)) {
            __bearer = undefined;
            return;
        }

        switch (_type) {
            case "weapon":
                if (_unit.weapon_one(true) == artifact_id) {
                    _unit.update_weapon_one("", false, true);
                } else if (_unit.weapon_two(true) == artifact_id) {
                    _unit.update_weapon_two("", false, true);
                }

                break;
            case "gear":
                if (_unit.gear(true) == artifact_id) {
                    _unit.update_gear("", false, true);
                }

                break;
            case "armour":
                if (_unit.armour(true) == artifact_id) {
                    _unit.update_armour("", false, true);
                }

                break;
            case "mobility":
                if (_unit.mobility_item(true) == artifact_id) {
                    _unit.update_mobility_item("", false, true);
                }

                break;
        }
    };

    /// @desc Equips this artifact on a unit; daemonic/chaos artifacts also apply corruption.
    /// @param {Struct.TTRPG_stats} unit
    /// @param {Real} slot Weapon slot: 1 = weapon two, otherwise weapon one.
    static equip_on_unit = function(unit, slot = 0) {
        var _item = get_type();
        var _result = false;

        if (_item == "mobility") {
            _result = unit.update_mobility_item(artifact_id);
        } else if (_item == "gear") {
            _result = unit.update_gear(artifact_id);
        } else if (_item == "armour") {
            _result = unit.update_armour(artifact_id);
        } else if (_item == "weapon") {
            if (slot == 1) {
                _result = unit.update_weapon_two(artifact_id);
            } else {
                _result = unit.update_weapon_one(artifact_id);
            }
        }

        if (_result != "complete") {
            return;
        }

        if (has_tag("daemonic") || has_tag("chaos")) {
            unit.corruption += irandom(DAEMON_CORRUPTION_MAX);
            if (role_compare(unit, eROLE.CHAPTERMASTER)) {
                /// @type {Asset.GMObject.obj_popup}
                var pip = instance_create(0, 0, obj_popup);
                pip.title = "Daemon Artifacts";
                pip.text = "Some artifacts, like the one you now wield, are a blasphemous union of the Materium's matter and the Immaterium's spirit, containing the essence of a bound daemon.  While they may offer great power, and enhanced perception, they are known to whisper poisonous lies to the wielder.  The path to damnation begins with good intentions, and many times artifacts such as these have been the cause.";
                pip.image = "";
                pip.cooldown = DAEMON_WARNING_COOLDOWN;
                obj_controller.cooldown = DAEMON_WARNING_COOLDOWN;
            }
        }
    };

    /// @desc Returns whether the artifact can be equipped on a unit (i.e. its type is not device-only).
    /// @returns {Bool} true if the artifact is equippable.
    static is_equippable = function() {
        return !array_contains(NOT_EQUIPPABLE, __type_name);
    };

    /// @desc Returns whether the artifact can currently be identified: it must be at the home world or on a ship at the home world or a Battle Barge.
    /// @returns {Bool} true if identification is possible.
    static is_identifiable = function() {
        var _resolved = __resolve_location();
        if (_resolved.location_name == obj_ini.home_name) {
            return true;
        }

        if (_resolved.ship_id > -1) {
            if (obj_ini.ship_location[_resolved.ship_id] == obj_ini.home_name) {
                return true;
            }

            if (obj_ini.ship_class[_resolved.ship_id] == "Battle Barge") {
                return true;
            }
        }

        return false;
    };

    /// @param {String} wanted_tag
    /// @returns {Bool} true if the artifact has the given tag.
    static has_tag = function(wanted_tag) {
        return array_contains(__tags, wanted_tag);
    };

    /// @param {Array<String>} wanted_tags
    /// @returns {Bool} true if the artifact has any of the given tags.
    static has_any_tag = function(wanted_tags) {
        for (var i = 0; i < array_length(wanted_tags); i++) {
            if (has_tag(wanted_tags[i])) {
                return true;
            }
        }

        return false;
    };

    /// @desc Returns whether the artifact carries heretical taint; inquisition-tagged artifacts are exempt.
    /// @returns {Bool} true if the artifact is heretical.
    static is_heretical = function() {
        if (has_tag("inq")) {
            return false;
        }

        return has_any_tag(HERETICAL_TAGS);
    };

    /// @desc Returns the artifact's value toward a faction's tag preferences.
    /// @param {Real} faction Faction index into FACTION_PREFERENCES.
    /// @returns {Real} The total preference value.
    static get_faction_value = function(faction) {
        if (faction < 0 || faction >= array_length(FACTION_PREFERENCES)) {
            LOGGER.warning("Warning: Faction index out of range. Defaulting to empty preferences.");
            return 0;
        }

        var _value = 0;
        var _tags = FACTION_PREFERENCES[faction];
        var _len = array_length(_tags);

        for (var i = 0; i < _len; i++) {
            if (has_tag(_tags[i])) {
                _value += FACTION_VALUE_PER_TAG;
            }
        }

        return _value;
    };

    /// @desc Returns whether this artifact is currently equipped on a unit.
    /// Derived from the bearer field (single source of truth).
    /// @returns {Bool} true if bearer is a valid unit reference array.
    static is_equipped = function() {
        return is_struct(__bearer);
    };

    // ###### Getters ######

    /// @desc Returns the effective location string: the ship name if on a ship, otherwise the location name.
    /// @returns {String} Ship name or location name.
    static get_location_string = function() {
        var _resolved = __resolve_location();
        if (_resolved.ship_id > -1) {
            return obj_ini.ship[_resolved.ship_id];
        } else {
            return _resolved.location_name;
        }
    };

    /// @desc Returns the equipment type ("weapon", "armour", "gear", "mobility", or "device"), caching the result.
    /// @returns {String} The equipment type.
    static get_type = function() {
        if (__type != "") {
            return __type;
        }

        __type = "device";
        if (struct_exists(global.gear[$ "armour"], __type_name)) {
            __type = "armour";
        } else if (struct_exists(global.gear[$ "mobility"], __type_name)) {
            __type = "mobility";
        } else if (struct_exists(global.gear[$ "gear"], __type_name)) {
            __type = "gear";
        } else if (struct_exists(global.weapons, __type_name)) {
            __type = "weapon";
        } else if (array_contains(NOT_EQUIPPABLE, __type_name)) {
            __type = "device";
        }

        return __type;
    };

    /// @desc Returns the cached static description (without bearer info).
    /// Falls back to custom_description if set, or regenerates if cache is empty.
    /// @returns {String} The descriptive text (static part only).
    static get_description = function() {
        var _custom_desc = string(__custom_description);

        if (_custom_desc != "") {
            return _custom_desc;
        }

        if (__description == "") {
            __generate_description();
        }

        return __description;
    };

    /// @desc Returns the bearer text if the artifact is currently equipped on a unit.
    /// @returns {String} The bearer possession text, or empty string if not equipped.
    static get_bearer_text = function() {
        if (is_equipped()) {
            if (is_struct(__bearer)) {
                return $"It is currently in the possession of {__bearer.name_role()}.";
            }
        }

        return "";
    };

    /// @desc Returns the base type name (e.g. "Power Fist").
    /// @returns {String} The base type name (e.g. "Power Fist").
    static get_type_name = function() {
        return __type_name;
    };

    /// @desc Returns the display name.
    /// @returns {String} custom_name if set, otherwise the base type name.
    static get_display_name = function() {
        if (__custom_name != "") {
            return __custom_name;
        }

        return __type_name;
    };

    /// @desc Returns the custom name.
    /// @returns {String} The custom name, or "" if the artifact was not renamed.
    static get_custom_name = function() {
        return __custom_name;
    };

    /// @desc Returns the custom description.
    /// @returns {String} The custom description, or "" if none was set.
    static get_custom_description = function() {
        return __custom_description;
    };

    /// @desc Returns the artifact's tags.
    /// @returns {Array<String>} The tags array. Returns the live reference, not a copy.
    static get_tags = function() {
        return __tags;
    };

    /// @desc Returns the identification countdown.
    /// @returns {Real} Turns remaining until identification (countdown); 0 or negative means identified.
    static get_identification_timer = function() {
        return __identification_timer;
    };

    /// @desc Effective location string: the bearer's location while equipped, otherwise the storage location.
    /// @returns {String} Location string (star name or "").
    static get_location_name = function() {
        return __resolve_location().location_name;
    };

    /// @desc Effective ship index: the bearer's ship while equipped, otherwise the storage ship index.
    /// @returns {Real} Ship array index, or -1 if not on a ship.
    static get_ship_id = function() {
        return __resolve_location().ship_id;
    };

    /// @desc Raw stored ship index, used while unequipped or as a fallback when the bearer cannot be resolved.
    /// @returns {Real} Stored ship array index, or -1.
    static get_stored_ship_id = function() {
        return __ship_id;
    };

    /// @desc Returns the bearer reference.
    /// @returns {Array|undefined} [company, marine_number] of the bearer, or undefined if unequipped.
    static get_bearer = function() {
        return __bearer;
    };

    // ###### Setters ######

    /// @desc Sets the custom name.
    /// @param {String} value
    static set_custom_name = function(value) {
        __custom_name = value;
    };

    /// @desc Sets the custom description.
    /// @param {String} value
    static set_custom_description = function(value) {
        __custom_description = value;
    };

    /// @desc Sets the tags, invalidating the cached description.
    /// @param {Array<String>} value
    static set_tags = function(value) {
        __tags = value;
        __description = "";
    };

    /// @desc Sets the identification countdown.
    /// @param {Real} value
    static set_identification_timer = function(value) {
        __identification_timer = value;
    };

    /// @desc Sets the storage location name.
    /// @param {String} value
    static set_location_name = function(value) {
        __location_name = value;
    };

    /// @desc Sets the stored ship index.
    /// @param {Real} value
    static set_sid = function(value) {
        __ship_id = value;
    };

    /// @desc Sets the bearer reference.
    /// @param {Array|undefined} value [company, marine_number] or undefined.
    static set_bearer = function(value) {
        __bearer = value;
    };

    /// @desc Unequips the artifact by clearing its bearer reference.
    /// Stamps the bearer's current location as the storage location (drop in place).
    static clear_bearer = function() {
        var _bearer_loc = __bearer_location();
        if (_bearer_loc != undefined) {
            __ship_id = _bearer_loc.ship_id;
            __location_name = _bearer_loc.location_name;
        }

        __bearer = undefined;
    };

    // #############################
    // ###### Private Methods ######
    // #############################

    /// @desc Returns the bearer's current location while equipped, or undefined.
    /// @returns {Struct|undefined} {ship_id, location_name} or undefined when unequipped or the unit is missing.
    static __bearer_location = function() {
        if (!is_equipped()) {
            return undefined;
        }
        if (!is_struct(__bearer)) {
            return undefined;
        }

        //TODO unpgrade to use marine_location method of unit struct

        if ((__bearer.ship_location > -1) && (__bearer.ship_location < array_length(obj_ini.ship))) {
            return {
                ship_id: __bearer.ship_location,
                location_name: obj_ini.ship[__bearer.ship_location],
            };
        }

        return {
            ship_id: -1,
            location_name: __bearer.location_string ?? "",
        };
    };

    /// @desc Resolves the artifact's effective location: bearer-derived while equipped, raw storage otherwise.
    /// @returns {Struct} {ship_id, location_name}
    static __resolve_location = function() {
        var _bearer_loc = __bearer_location();
        if (_bearer_loc != undefined) {
            return _bearer_loc;
        }

        return {
            ship_id: __ship_id,
            location_name: __location_name,
        };
    };

    /// @desc Concatenates the descriptions of all known visual tags.
    /// @returns {String} The concatenated tag description text.
    static __assign_text_from_tag_match = function() {
        var _return_text = "";
        var _len = array_length(__tags);

        for (var i = 0; i < _len; i++) {
            var _tag = __tags[i];
            if (struct_exists(TAG_DESCRIPTIONS, _tag)) {
                _return_text += TAG_DESCRIPTIONS[$ _tag];
            }
        }

        return _return_text;
    };

    /// @desc Generates and caches the static description
    static __generate_description = function() {
        var _final_description = "";
        var _mission_text = "";
        var _aesthetic_text = __assign_text_from_tag_match();
        var _extra_text = "";
        var _taint_text = "";

        if (get_type() != "armour") {
            _mission_text = $"This artifact is a {__type_name}";
        } else {
            _mission_text = $"This artifact is {__type_name}";
        }

        if (has_tag("inq")) {
            _mission_text += ", entrusted by the Inquisition.\n";
        } else if (has_tag("chaos_gift")) {
            _mission_text = $"This artifact is a {__type_name} gifted by the Chaos Lord.";
        } else {
            _mission_text += ".\n";
        }

        if (__type_name == "Power Fist" && has_tag("CHB")) {
            _extra_text += "The addition of a chainblade has turned it into a chainfist.";
        }

        if (has_tag("chaos")) {
            _taint_text = "It bears the taint of Chaos.";
        }

        if (has_tag("daemonic")) {
            _taint_text = "It is infested with a Daemonic entity. Destroying it, may cause the entity to materialize.";
        }

        _final_description = _mission_text;
        if (_aesthetic_text != "") {
            _final_description += $"  {_aesthetic_text}";
        }

        if (_extra_text != "") {
            _final_description += $"  {_extra_text}";
        }

        if (_taint_text != "") {
            _final_description += $"  {_taint_text}";
        }

        __description = _final_description;
    };

    // Generate the static description eagerly at construction time
    __generate_description();
}
