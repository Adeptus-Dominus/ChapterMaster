
var i, minhp, maxhp;

function determine_ship_class_health(class_array){
    var _total_percent = 0
    for (var i=0;i<array_length(class_array); i++){
        var _ship = fetch_ship(class_array[i]);
        _total_percent+=_ship.ship_hp_percentage();
    }
    return max(_total_percent/array_length(class_array),0);
}
capital_health = determine_ship_class_health(capital_num);
frigate_health = determine_ship_class_health(frigate_num);
escort_health = determine_ship_class_health(escort_num);




