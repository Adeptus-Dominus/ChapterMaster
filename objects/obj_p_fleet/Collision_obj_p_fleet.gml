if ((other.x == self.x) && (other.y == self.y) && (action == "") && (other.action == "") && (other.owner == eFACTION.PLAYER)) {
    if (other.id > self.id) {
        merge_player_fleets(other.id, self.id);
    }
}
