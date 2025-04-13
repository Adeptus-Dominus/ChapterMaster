#macro MAX_STC_PER_SUBCATEGORY 6
#macro DEFAULT_TOOLTIP_VIEW_OFFSET 32
#macro DEFAULT_LINE_GAP -1
#macro LB_92 "############################################################################################"
#macro DATE_TIME_1 $"{current_day}-{current_month}-{current_year}-{format_time(current_hour)}{format_time(current_minute)}{format_time(format_time(current_second))}"
#macro DATE_TIME_2 $"{current_day}-{current_month}-{current_year}|{format_time(current_hour)}:{format_time(current_minute)}:{format_time(current_second)}"
#macro DATE_TIME_3 $"{current_day}-{current_month}-{current_year} {format_time(current_hour)}:{format_time(current_minute)}:{format_time(current_second)}"
#macro TIME_1 $"{format_time(current_hour)}:{format_time(current_minute)}:{format_time(current_second)}"
#macro CM_GREEN_COLOR #34bc75
#macro CM_RED_COLOR #bf4040

enum luck {
    bad = -1,
    neutral = 0,
    good = 1
}
enum GOD_MISSION {
    artifact
}
enum INQUISITION_MISSION {
    purge,
    inquisitor,
    spyrer,
    artifact,
    tomb_world,
    tyranid_organism,
    ethereal
}
enum MECHANICUS_MISSION {
    bionics,
    land_raider,
    mars_voyage,
    necron_study
}
enum EVENT {
    //good
    space_hulk,
    promotion,
    strange_building,
    sororitas,
    rogue_trader,
    inquisition_mission,
    inquisition_planet,
    mechanicus_mission,
    //neutral
    strange_behavior,
    fleet_delay,
    harlequins,
    succession_war,
    random_fun,
    //bad
    warp_storms,
    enemy_forces,
    crusade,
    enemy,
    mutation,
    ship_lost,
    chaos_invasion,
    necron_awaken,
    fallen,
    //end
    none
}
