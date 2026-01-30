if (pulsing > 0) {
    if (other.shields > 0) {
        other.shields -= 0.35;
    }
    if (other.shields <= 0) {
        other.hp -= 0.35;
    }
}
