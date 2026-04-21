if (last_turn_check == obj_controller.turn) {
    exit;
}
var _same_navy = navy == other.navy;
if (other.owner == self.owner && _same_navy) {
    if (!((action_x == other.action_x) && (action_y == other.action_y))) {
        exit;
    }

    if ((trade_goods != "") && (other.trade_goods != "") && !fleet_has_cargo("colonize") && !fleet_has_cargo("colonize", other)) {
        if ((action_x == other.action_x) && (action_y == other.action_y) && !fleet_has_cargo("ork_warboss") && !fleet_has_cargo("ork_warboss", other)) {
            if ((string_count("!", trade_goods) > 0) && (string_count("!", other.trade_goods) > 0)) {
                if (id > other.id) {
                    merge_fleets(other.id, self.id);
                }
            }
        }
    }
}
last_turn_check = obj_controller.turn;
