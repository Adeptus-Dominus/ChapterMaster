

/*if (obj_ncombat.enemy=1){
    repeat(10){
        if (!collision_point(x-10,y,obj_pnunit,0,1)) and (!collision_point(x-10,y,obj_enunit,0,1)){
            move_unit_block("west");
        }
    }
}*/




exit;


if (dudes_num[1]=0) and (men=0){
    instance_destroy();
    exit;
}


/*show_message("Weapons in Column "+string(x/10)+"
"+string(wep_num[1])+"x "+string(wep[1])+": ATT"+string(att[1])+" ARP"+string(apa[1])+" ammo:"+string(ammo[1])+"
"+string(wep_num[2])+"x "+string(wep[2])+": ATT"+string(att[2])+" ARP"+string(apa[2])+" ammo:"+string(ammo[2])+"
"+string(wep_num[3])+"x "+string(wep[3])+": ATT"+string(att[3])+" ARP"+string(apa[3])+" ammo:"+string(ammo[3])+"
"+string(wep_num[4])+"x "+string(wep[4])+": ATT"+string(att[4])+" ARP"+string(apa[4])+" ammo:"+string(ammo[4])+"
"+string(wep_num[5])+"x "+string(wep[5])+": ATT"+string(att[5])+" ARP"+string(apa[5])+" ammo:"+string(ammo[5])+"
"+string(wep_num[6])+"x "+string(wep[6])+": ATT"+string(att[6])+" ARP"+string(apa[6])+" ammo:"+string(ammo[6])+"
"+string(wep_num[7])+"x "+string(wep[7])+": ATT"+string(att[7])+" ARP"+string(apa[7])+" ammo:"+string(ammo[7])+"
"+string(wep_num[8])+"x "+string(wep[8])+": ATT"+string(att[8])+" ARP"+string(apa[8])+" ammo:"+string(ammo[8])+"
"+string(wep_num[9])+"x "+string(wep[9])+": ATT"+string(att[9])+" ARP"+string(apa[9])+" ammo:"+string(ammo[9])+"
"+string(wep_num[10])+"x "+string(wep[10])+": ATT"+string(att[10])+" ARP"+string(apa[10])+" ammo:"+string(ammo[10]));


show_message("1: "+string(dudes[1])+" "+string(dudes_num[1])+" "+string(dudes_hp[1])+"
2: "+string(dudes[2])+" "+string(dudes_num[2])+" "+string(dudes_hp[2])+"
3: "+string(dudes[3])+" "+string(dudes_num[3])+" "+string(dudes_hp[3])+"
4: "+string(dudes[4])+" "+string(dudes_num[4])+" "+string(dudes_hp[4])+"
5: "+string(dudes[5])+" "+string(dudes_num[5])+" "+string(dudes_hp[5])+"
6: "+string(dudes[6])+" "+string(dudes_num[6])+" "+string(dudes_hp[6]));

*/



/* */
/*  */
