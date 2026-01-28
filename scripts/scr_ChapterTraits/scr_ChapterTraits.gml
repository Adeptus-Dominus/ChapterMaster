function ChapterTrait(_id, _name, _description, _points_cost, _meta = []) constructor{

    id = _id;
    name = _name;
    description = _description;
    points = _points_cost;
    disabled = false;
    meta = _meta;

    static add_meta = function(){
        for (var i=0;i<array_length(meta);i++){
            array_push(obj_creation.chapter_trait_meta, meta[i]);
        }
        show_debug_message_advanced($"Meta updated, added: {meta}, all meta: {obj_creation.chapter_trait_meta}");

    }
    static remove_meta = function(){
        for (var i=0;i<array_length(meta);i++){
            var len = array_length(obj_creation.chapter_trait_meta);
            for (var s=0;s<len;s++){
                if (obj_creation.chapter_trait_meta[s]==meta[i]){
                    array_delete(obj_creation.chapter_trait_meta, s, 1);
                    s--;
                    len--;
                }
            }
        }
        show_debug_message_advanced($"Meta updated, removed: {meta}, all meta: {obj_creation.chapter_trait_meta}");
    }

    static print_meta = function(){
        if(array_length(meta) ==0){
            return "None";
        } else {
            return string_join_ext(", ", meta);
        }
    }

}

function Advantage(_id, _name, _description, _points_cost) : ChapterTrait(_id, _name, _description, _points_cost) constructor {

    static add = function(slot){
        show_debug_message_advanced($"Adding adv {name} to slot {slot} for points {points}");
        obj_creation.adv[slot] = name;
        obj_creation.adv_num[slot] = id;
        obj_creation.points+=points;
        add_meta();
    }
    static remove = function(slot){
        show_debug_message_advanced($"removing adv {name} from slot {slot} for points {points}");
        obj_creation.adv[slot] = "";
        obj_creation.points-=points;
        obj_creation.adv_num[slot]=0;
        remove_meta();
    }

    static disable = function(){
        var is_disabled= false;
        for (var i=0;i<array_length(meta);i++){
            if (array_contains(obj_creation.chapter_trait_meta, meta[i])){
                is_disabled = true;
            }
        }
        if(obj_creation.points + points > obj_creation.maxpoints){
            is_disabled = true;
        }
        return is_disabled;
    }

}
function Disadvantage(_id, _name, _description, _points_cost) : ChapterTrait(_id, _name, _description, _points_cost) constructor {

    static add = function(slot){
        show_debug_message_advanced($"Adding disadv {name} to slot {slot} for points {points}");
        obj_creation.dis[slot] = name;
        obj_creation.dis_num[slot] = id;
        obj_creation.points-=points;
        add_meta();
    }

    static remove = function(slot){
        show_debug_message_advanced($"Removing disadv {name} from slot {slot} for points {points}");
        obj_creation.dis[slot] = "";
        obj_creation.points+=points;
        obj_creation.dis_num[slot]=0;
        remove_meta();
    }

    static disable = function(){
        var is_disabled= false;
        for (var i=0;i<array_length(meta);i++){
            if (array_contains(obj_creation.chapter_trait_meta, meta[i])){
                is_disabled = true;
            }
        }
        return is_disabled;
    }
}