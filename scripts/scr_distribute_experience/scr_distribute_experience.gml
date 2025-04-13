function distribute_experience(_units, _exp_amount) {
    var _eligible_units_count = array_length(_units);
    var _average_exp = 0;

    if (_eligible_units_count > 0 && _exp_amount > 0) {
        var _individual_exp = _exp_amount / _eligible_units_count;
        _average_exp = _individual_exp;
        for (var i = 0; i < _eligible_units_count; i++) {
            var _unit = _units[i][0];
            var _exp_mod = _units[i][1];
            var _exp_update_data = _unit.add_exp(_individual_exp*_exp_mod);

            var _powers_learned = _exp_update_data[1];
            if (_powers_learned > 0) {
                array_push(obj_ncombat.upgraded_librarians, _unit);
            }

        }
    }

    return _average_exp;
}
