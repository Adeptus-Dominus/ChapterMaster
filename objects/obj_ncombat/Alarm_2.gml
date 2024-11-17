
player_max=player_forces;
enemy_max=enemy_forces;

instance_activate_object(obj_enunit);

if (dropping){
    squeeze_map_forces();
}


if (ally>0) and (ally_forces>0){
    if (ally=3){
        if (ally_forces>=1){
            var thata,ii,good;
            thata=instance_nearest(0,240,obj_pnunit);ii=0;good=0;
            
            //TODO refactor so that unit structs are created for ally forces
            
           /* 
            if (instance_exists(thata)){

                ii=array_length(marine_type);
                if (good>0){
                    repeat(10){
                        thata.marine_type[ii]="Techpriest";
                        thata.marine_hp[ii]=50;
                        thata.marine_ac[ii]=20;thata.marine_exp[ii]=100;
                        thata.marine_wep1[ii]="Power Axe";
                        thata.marine_wep2[ii]="Laspistol";
                        thata.marine_armour[ii]="Dragon Scales";
                        thata.marine_gear[ii]="";
                        thata.marine_mobi[ii]="Servo-arm";
                        thata.ally[ii]=true;
                        thata.marine_dead[ii]=0;
                        ii+=1;
                        thata.men+=1;
                    }
                    repeat(20){
                        thata.marine_type[ii]="Skitarii";
                        thata.marine_hp[ii]=40;
                        thata.marine_ac[ii]=10;
                        thata.marine_exp[ii]=10;
                        thata.marine_wep1[ii]="Hellgun";
                        thata.marine_wep2[ii]="";
                        thata.marine_armour[ii]="Skitarii Armour";
                        thata.marine_gear[ii]="";
                        thata.ally[ii]=true;
                        thata.marine_dead[ii]=0;ii+=1;thata.men+=1;
                    }
                }
                
                ii=0;good=0;
                repeat(50){if (good=0){ii+=1;if (thata.dudes[ii]="") and (thata.dudes_num[ii]=0) then good=ii;}}
                if (good>0){thata.dudes[ii]="Techpriest";thata.dudes_num[ii]=10;thata.dudes_vehicle[ii]=0;}
                ii=0;good=0;
                repeat(50){if (good=0){ii+=1;if (thata.dudes[ii]="") and (thata.dudes_num[ii]=0) then good=ii;}}
                if (good>0){thata.dudes[ii]="Skitarii";thata.dudes_num[ii]=20;thata.dudes_vehicle[ii]=0;}
                thata.alarm[1]=1;
            }*/
        }
    }
}






// scr_newtext();

/*if (newline!=""){
    var breaks,first_open;
    newline=scr_lines(89,newline);
    breaks=max(1,string_count("@",newline));
    first_open=liness+1;
    
    var b,f;b=first_open;f=-1;
    explode_script(newline,"@");
    f+=1;lines[b+f]=string("-"+explode[f]);
    repeat(breaks-1){f+=1;
        lines[b+f]=string(explode[f]);
    }
    liness+=string_count("@",newline);
    
    repeat(100){
        if (liness>30){scr_lines_increase(1);liness-=1;}
    }
}

newline="";*/


instance_activate_object(obj_enunit);

/* */
/*  */
