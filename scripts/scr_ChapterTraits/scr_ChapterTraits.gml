function ChapterTrait(trait) constructor {
    effects = "";
    meta = [];
    move_data_to_current_scope(trait);
    disabled = false;


    static add_meta = function() {
        for (var i = 0; i < array_length(meta); i++) {
            array_push(obj_creation.chapter_trait_meta, meta[i]);
        }
    };

    static remove_meta = function() {
        for (var i = 0; i < array_length(meta); i++) {
            var len = array_length(obj_creation.chapter_trait_meta);
            for (var s = 0; s < len; s++) {
                if (obj_creation.chapter_trait_meta[s] == meta[i]) {
                    array_delete(obj_creation.chapter_trait_meta, s, 1);
                    s--;
                    len--;
                }
            }
        }
    };

    static print_meta = function() {
        if (array_length(meta) == 0) {
            return "None";
        } else {
            return string_join_ext(", ", meta);
        }
    };
}

function Advantage(trait) : ChapterTrait(trait) constructor {
    static id_start = 1
    LOGGER.info(id_start);
    id = id_start;
    id_start++;
    static add = function(slot) {
        obj_creation.adv[slot] = name;
        obj_creation.adv_num[slot] = id;
        obj_creation.points += points;
        add_meta();
    };

    static remove = function(slot) {
        obj_creation.adv[slot] = "";
        obj_creation.points -= points;
        obj_creation.adv_num[slot] = 0;
        remove_meta();
    };

    static disable = function() {
        var is_disabled = false;
        for (var i = 0; i < array_length(meta); i++) {
            if (array_contains(obj_creation.chapter_trait_meta, meta[i])) {
                is_disabled = true;
            }
        }
        if (obj_creation.points + points > obj_creation.maxpoints) {
            is_disabled = true;
        }
        return is_disabled;
    };
}

function Disadvantage(trait) : ChapterTrait(trait) constructor {
    static id_start = 1
    LOGGER.info(id_start);
    id = id_start;
    id_start++;
    static add = function(slot) {
        obj_creation.dis[slot] = name;
        obj_creation.dis_num[slot] = id;
        obj_creation.points -= points;
        add_meta();
    };

    static remove = function(slot) {
        obj_creation.dis[slot] = "";
        obj_creation.points += points;
        obj_creation.dis_num[slot] = 0;
        remove_meta();
    };

    static disable = function() {
        var is_disabled = false;
        for (var i = 0; i < array_length(meta); i++) {
            if (array_contains(obj_creation.chapter_trait_meta, meta[i])) {
                is_disabled = true;
            }
        }
        return is_disabled;
    };
}
