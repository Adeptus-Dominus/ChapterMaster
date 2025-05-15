

if (obj_controller.menu!=my_menu) and (my_menu=12.1) then obj_controller.fest_repeats=0;
if (obj_controller.menu!=my_menu) then instance_destroy();

/*




option[1]="Great Feast";
option[2]="Tournament";
option[3]="Deathmatch";
option[4]="Commision Relic";
option[5]="Imperial Mass";
option[6]="Cult Sermon";
dro=instance_create(xx+1064,yy+126,obj_dropdown_sel);dro.target="event_type";
            dro=instance_create(xx+1100,yy+184,obj_dropdown_sel);dro.target="event_loc";
            dro=instance_create(xx+1088,yy+271,obj_dropdown_sel);dro.target="event_lavish";
            dro=instance_create(xx+1041,yy+385,obj_dropdown_sel);dro.target="event_display";
            dro=instance_create(xx+1041,yy+443,obj_dropdown_sel);dro.target="event_repeat";


*/



if (target="event_type"){
    with(obj_controller){
        fest_cost=0;
        
        /*
        option[2]="Tournament";
        option[3]="Deathmatch";
        */
        
        if (fest_type="Great Feast"){
            fest_cost=fest_lav*20;if (fest_lav=0) then fest_cost=20;
            if (fest_locals>0) then fest_cost+=20*fest_locals;
            var tt;tt=fest_cost;
            if (fest_feature1=0) then fest_cost=0;
            if (fest_feature2>0) then fest_cost+=round(tt/2);
            if (fest_feature3>0) then fest_cost+=tt;
        }
        if (fest_type="Tournament") or (fest_type="Deathmatch"){
            fest_cost=fest_lav*20;if (fest_lav=0) then fest_cost=20;
            if (fest_locals>0) then fest_cost+=20*fest_locals;
            var tt;tt=fest_cost;
            
            if (fest_feature2>0) then fest_cost+=30;
            if (fest_type="Tournament") and (fest_feature3>0) then fest_cost+=100;
            
            /*if (fest_feature1=0) then fest_cost=0;
            if (fest_feature2>0) then fest_cost+=round(tt/2);
            if (fest_feature3>0) then fest_cost+=tt;*/
        }
        if (fest_type="Chapter Relic"){
            if (fest_feature1=1) then fest_cost=800;
            if (fest_feature2=1) then fest_cost=650;
            if (fest_feature3=1) then fest_cost=300;
            fest_cost+=(fest_lav*20);if (fest_lav=0) then fest_cost+=20;
        }
        if (fest_type="Imperial Mass"){
            fest_cost=fest_lav*40;if (fest_lav=0) then fest_cost=40;
            if (fest_locals>0) then fest_cost+=40*fest_locals;
            var tt;tt=fest_cost;
            if (fest_feature2>0) then fest_cost+=100;
            if (fest_feature3>0) then fest_cost+=50;
        }
        if (fest_type="Chapter Sermon"){
            fest_cost=fest_lav*20;if (fest_lav=0) then fest_cost=20;
            if (fest_locals>0) then fest_cost+=20*fest_locals;
            var tt;tt=fest_cost;
            if (fest_feature2>0) then fest_cost+=round(tt/2);
            if (fest_feature3>0) then fest_cost+=tt;
        }
        if (fest_type="Triumphal March"){
            fest_cost=fest_lav*10;if (fest_lav=0) then fest_cost=10;
            if (fest_locals>0) then fest_cost+=10*fest_locals;
            var tt;tt=fest_cost;
            if (fest_feature1>0) then fest_cost+=tt;
        }
        
        if (fest_cost>0) and (fest_repeats>1) then fest_cost=fest_cost*fest_repeats;
    }
}
if (target="event_honor"){
    if (option_selected>0) then obj_controller.fest_honoring=option_id[option_selected];
    if (option_selected=0) then obj_controller.fest_honoring=0;
}



if (target="event_loc") and (determined_planets=0){
    // Fill out the options for planets
    
    var coo,ide,q;
    coo=-1;ide=0;q=0;
    
    repeat(11){
        coo+=1;ide=0;
        
        repeat(300){ide+=1;
            if (obj_ini.role[coo][ide]!=obj_ini.role[100][6]) and (obj_ini.role[coo][ide]!="Venerable "+string(obj_ini.role[100][6])) and (obj_ini.TTRPG[coo][ide].planet_location>0){
                var stahp,first_open;stahp=0;q=0;first_open=0;
                
                repeat(100){
                    if (stahp=0){q+=1;
                        if (star[q]="") and (first_open=0) then first_open=q;
                        if (star[q]=obj_ini.loc[coo][ide]) and (star_planet[q]=obj_ini.TTRPG[coo][ide].planet_location){
                            stahp=1;star_mahreens[q]+=1;
                        }
                    }
                }
                if (stahp=0){
                    star[first_open]=obj_ini.loc[coo][ide];
                    star_planet[first_open]=obj_ini.TTRPG[coo][ide].planet_location;
                    star_marheens[first_open]=1;
                }
            }
        }
    }
    
    determined_planets=1;
}





if (target="event_public"){
    if (obj_controller.fest_warp=1) and (options!=1){option_selected=1;options=1;}
    if (obj_controller.fest_warp=0) and (options=1){options=4;}
    
    if (options>1){
        if (obj_controller.fest_type="Tournament"){option[2]="";option[3]="";options=1;}
        if (obj_controller.fest_type="Deathmatch"){option[2]="";option[3]="";options=1;}
        if (obj_controller.fest_type="Chapter Relic"){option[2]="";option[3]="";options=1;}
        if (obj_controller.fest_type="Triumphal March"){option[2]="";option[3]="";options=1;}
    }
}


if (option[1]=""){
    var ii;ii=0;
    repeat(50){ii+=1;option[ii]="";option_id[ii]=0;}

    if (target="event_type"){
        option[1]="Great Feast";option[2]="Tournament";option[3]="Deathmatch";
        option[4]="Imperial Mass";option[5]="Chapter Sermon";option[6]="Chapter Relic";
        option[7]="Triumphal March";
        options=7;option_selected=1;
    }
    if (target="event_loc"){
        var q,works,thatone;
        q=0;works=1;thatone=false;
        option[1]="None Selected";option_id[1]=-50;
        options=1;option_selected=1;
        
        // Present ship options
        if (obj_controller.fest_planet=0){
            for(q=0;q<array_length(obj_ini.ship_data);q++){
                thatone=false;
                var _ship = obj_ini.ship_data[q];
                if  (_ship.carrying){
                    works+=1;
                    option[works]=_ship.name;
                    option_id[works]=q;
                    options+=1;
                    thatone=false;
                }
            }
        }
        
        // Present planet options
        if (obj_controller.fest_planet=1){
            repeat(80){q+=1;
                if (star[q]!="") and (star_mahreens[q]>0){
                    options+=1;option_star[options]=string(star[q]);
                    option[options]=string(star[q])+" "+scr_roman(star_planet[q]);option_id[options]=star_planet[q];
                }
            }
        }
    }
    if (target="event_lavish"){
        option[1]="Humble";
        option[2]="Minor Expenses";
        option[3]="Opulent";
        option[4]="Lavish";
        option[5]="Excessive";
        option_selected=1;options=5;
    }
    if (target="event_display"){
        var q,arti_work,thatone;
        q=0;arti_work=1;thatone=false;
        option[1]="None";option_id[1]=-50;
        options=1;option_selected=1;
        
        repeat(obj_controller.artifacts){
            q+=1;thatone=false;
            
            if (obj_ini.artifact[q]="Casket") then thatone=true;
            if (obj_ini.artifact[q]="Chalice") then thatone=true;
            if (obj_ini.artifact[q]="Statue") then thatone=true;
            if (obj_ini.artifact[q]="Tome") then thatone=true;
            if (obj_ini.artifact[q]="Robot") then thatone=true;
            
            if (thatone=true){
                arti_work+=1;option[arti_work]=obj_ini.artifact[q];option_id[arti_work]=q;options+=1;thatone=false;
            }
        }
    
    
        // Other big of logic, get eligible artifacts
    }
    if (target="event_repeat"){
        option[1]="Do not repeat";
        option[2]="Repeat once";
        option[3]="Repeat twice";
        option[4]="Repeat thrice";
        option[5]="Year-long event";
        options=5;option_selected=1;
        
        if (obj_controller.fest_type="Chapter Relic"){
            options=1;option_selected=1;
        }
    }
    if (target="event_honor"){
        option[1]="No One";option_id[1]=0;
        option[2]="Yourself";option_id[2]=1;
        option[3]="Specific Company";option_id[3]=2;
        option[4]="Specific Marine";option_id[4]=3;
        option[5]="Specific Faction";option_id[5]=4;
        options=5;option_selected=1;
        
        if (obj_controller.fest_type="Imperial Mass"){
            option[1]="The Emperor";option_id[1]=5;
            options=1;option_selected=1;
        }
        if (obj_controller.fest_type="Triumphal March"){
            option[1]=global.chapter_name;option_id[1]=6;
            options=1;option_selected=1;
        }
    }
    
    if (target="event_public"){
        option[1]="No Public";
        option[2]="Nobility";
        option[3]="PDF";
        option[4]="Open Event";
        option_selected=1;options=4;
    }
}

/* */
/*  */
