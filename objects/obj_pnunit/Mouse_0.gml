
/*show_message("Engaged "+string(engaged)+"
"+string(dudes_num[1])+"x "+string(dudes[1])+"
"+string(dudes_num[2])+"x "+string(dudes[2])+"
"+string(dudes_num[3])+"x "+string(dudes[3])+"
"+string(dudes_num[4])+"x "+string(dudes[4])+"
"+string(dudes_num[5])+"x "+string(dudes[5])+"
"+string(dudes_num[6])+"x "+string(dudes[6])+"
"+string(dudes_num[7])+"x "+string(dudes[7])+"
"+string(dudes_num[8])+"x "+string(dudes[8])+"
"+string(dudes_num[9])+"x "+string(dudes[9])+"
"+string(dudes_num[10])+"x "+string(dudes[10]));
*/


/*show_message("Engaged "+string(engaged)+"
"+string(wep_num[1])+"x "+string(wep[1])+": ATT"+string(att[1])+" ARP"+string(apa[1])+" solo:"+string(wep_solo[1])+"
"+string(wep_num[2])+"x "+string(wep[2])+": ATT"+string(att[2])+" ARP"+string(apa[2])+" solo:"+string(wep_solo[2])+"
"+string(wep_num[3])+"x "+string(wep[3])+": ATT"+string(att[3])+" ARP"+string(apa[3])+" solo:"+string(wep_solo[3])+"
"+string(wep_num[4])+"x "+string(wep[4])+": ATT"+string(att[4])+" ARP"+string(apa[4])+" solo:"+string(wep_solo[4])+"
"+string(wep_num[5])+"x "+string(wep[5])+": ATT"+string(att[5])+" ARP"+string(apa[5])+" solo:"+string(wep_solo[5])+"
"+string(wep_num[6])+"x "+string(wep[6])+": ATT"+string(att[6])+" ARP"+string(apa[6])+" solo:"+string(wep_solo[6])+"
"+string(wep_num[7])+"x "+string(wep[7])+": ATT"+string(att[7])+" ARP"+string(apa[7])+" solo:"+string(wep_solo[7])+"
"+string(wep_num[8])+"x "+string(wep[8])+": ATT"+string(att[8])+" ARP"+string(apa[8])+" solo:"+string(wep_solo[8])+"
"+string(wep_num[9])+"x "+string(wep[9])+": ATT"+string(att[9])+" ARP"+string(apa[9])+" solo:"+string(wep_solo[9])+"
"+string(wep_num[10])+"x "+string(wep[10])+": ATT"+string(att[10])+" ARP"+string(apa[10])+" solo:"+string(wep_solo[10]));

*/

/*var blarg;blarg=wep;
show_message(blarg);*/


/*show_message("Engaged "+string(engaged)+"
"+string(dudes_num[1])+"x "+string(dudes[1])+"
"+string(dudes_num[2])+"x "+string(dudes[2])+"
"+string(dudes_num[3])+"x "+string(dudes[3])+"
"+string(dudes_num[4])+"x "+string(dudes[4])+"
"+string(dudes_num[5])+"x "+string(dudes[5])+"
"+string(dudes_num[6])+"x "+string(dudes[6])+"
"+string(dudes_num[7])+"x "+string(dudes[7])+"
"+string(dudes_num[8])+"x "+string(dudes[8])+"
"+string(dudes_num[9])+"x "+string(dudes[9])+"
"+string(dudes_num[10])+"x "+string(dudes[10])+"
"+string(dudes_num[11])+"x "+string(dudes[11])+"
"+string(dudes_num[12])+"x "+string(dudes[12])+"
"+string(dudes_num[13])+"x "+string(dudes[13])+"
"+string(dudes_num[14])+"x "+string(dudes[14])+"
"+string(dudes_num[15])+"x "+string(dudes[15])+"
"+string(dudes_num[16])+"x "+string(dudes[16]));*/

var i=0;
repeat(50){i+=1;
    if (marine_type[i]!="") then show_message(string(i)+", "+string(marine_type[i])+", HP: "+string(marine_hp[i]));
}

