if ((other.x == self.x) && (other.y == self.y) && (action == "") && (other.action == "") && (other.owner == eFACTION.Player)) {
    if (other.id > self.id) {
        merge_player_fleets(other.id, self.id);
    }
}
