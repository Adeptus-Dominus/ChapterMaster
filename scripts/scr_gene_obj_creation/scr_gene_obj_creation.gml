// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_gene_obj_creation(){
	draw_set_color(38144);
    draw_set_font(fnt_40k_30b);
    draw_set_halign(fa_center);
    draw_set_alpha(1);
    
    tooltip="";
    tooltip2="";
    obj_cursor.image_index=0;
    
    draw_text(800,80,chapter_name);


    draw_set_color(38144);
    draw_set_halign(fa_left);
    draw_text_transformed(580,118,$"Successor Chapters: {successors}",0.6,0.6,0);
    draw_set_font(fnt_40k_14b);
    
    draw_rectangle(445, 200, 1125, 202, true);
    
    draw_set_font(fnt_40k_30b);
    draw_text_transformed(503,210,"Gene-Seed Mutations",0.6,0.6,0);
    if (mutations>mutations_selected) then draw_text_transformed(585,230,$"Select {mutations-mutations_selected} More",0.5,0.5,0);
    
    var x1,y1,spac=34;
    
    if (custom<2) then draw_set_alpha(0.5);
    var mutations_defects = [
        {
            t_tip :"Anemic Preomnor",
            t_tip2: "Your Astartes lack the detoxifying gland called the Preomnor- they are more susceptible to poisons and toxins.",
            data : preomnor,
            mutation_points : 1,
        },
        {
            t_tip :"Disturbing Voice",
            t_tip2: "Your Astartes have a voice like a creaking door or a rumble.  Decreases Imperium and Imperial Guard disposition.",
            data : voice,
            mutation_points : 1,
            disposition:[[eFACTION.Imperium,-8]],
        },
        {
            t_tip :"Doomed",
            t_tip2: "Your Chapter cannot make more Astartes until enough research is generated.  Counts as four mutations.",
            data : doomed,
            mutation_points : 4,
            disposition:[[eFACTION.Imperium,-8],[6,8]],
        },
        {
            t_tip :"Faulty Lyman's Ear",
            t_tip2: "Lacking a working Lyman's ear, all deep-striked Astartes recieve moderate penalties to both attack and defense.",
            data : lyman,
            mutation_points : 1,
        },
        {
            t_tip :"Hyper-Stimulated Omophagea",
            t_tip2: "After every battle the Astartes have a chance to feast upon their fallen enemies, or seldom, their allies.",
            data : omophagea,
            mutation_points : 1,
        },
        {
            t_tip :"Hyperactive Ossmodula",
            t_tip2: "Instead of wound tissue bone is generated; Apothecaries must spend twice the normal time healing your Astartes.",
            data : ossmodula,
            mutation_points : 1,
        }, 
        {
            t_tip :"Lost Zygote",
            t_tip2: "One of the Zygotes is faulty or missing.  The Astartes only have one each and generate half the normal Gene-Seed.",
            data : zygote,
            mutation_points : 2,
        },
        {
            t_tip :"Inactive Sus-an Membrane",
            t_tip2: "Your Astartes do not have a Sus-an Membrane; they cannot enter suspended animation and recieve more casualties as a result.",
            data : membrane,
            mutation_points : 1,
        },
        {
            t_tip :"Missing Betchers Gland",
            t_tip2: "Your Astartes cannot spit acid, and as a result, have slightly less attack in melee combat.",
            data : betchers,
            mutation_points : 1,
        }, 
        {
            t_tip :"Mutated Catalepsean Node",
            t_tip2: "Your Astartes have reduced awareness when tired. Slightly less attack in ranged and melee combat.",
            data : catalepsean,
            mutation_points : 1,
        }, 
        {
            t_tip :"Oolitic Secretions",
            t_tip2: "Either by secretions or radiation, your Astartes have an unusual or strange skin color.  Decreases disposition.",
            data : secretions,
            mutation_points : 1,
            disposition:[[eFACTION.Imperium,-8]],
        },
        {
            t_tip :"Oversensitive Occulobe",
            t_tip2: "Your Astartes are no longer immune to stun grenades, bright lights, and have a massive penalty during morning battles.",
            data : occulobe,
            mutation_points : 1,
            disposition:[[eFACTION.Imperium,-8]],
        },
        {
            t_tip :"Rampant Mucranoid",
            t_tip2: "Your Astartes' Mucranoid cannot be turned off; the slime lowers most dispositions and occasionally damages their armour.",
            data : mucranoid,
            mutation_points : 1,
            disposition:[[1,-4],[eFACTION.Imperium,-8],[3,-4],[4,-4],[5,-4],[6,-4]],
        },                                                                          
    ]
    x1=450;
    y1=260;
    for (var i=0;i<array_length(mutations_defects);i++){
        mutation_data = mutations_defects[i];
        draw_sprite(spr_creation_check,mutation_data.data,x1,y1);
        if (point_and_click([x1,y1,x1+32,y1+32]) && allow_colour_click){
            cooldown=8000;
            var onceh=0;
            if (mutation_data.data){
                mutation_data.data=0;
                mutations_selected-=mutation_data.mutation_points;
                if (struct_exists(mutation_data, "disposition")){
                   for (var s=0;s<array_length(mutation_data.disposition);s++){
                        disposition[mutation_data.disposition[s][0]] -= mutation_data.disposition[s][1];
                   }
                }                
            }
            else if (!mutation_data.data) and (mutations>mutations_selected){
                mutation_data.data=1;
                mutations_selected+=mutation_data.mutation_points;
                if (struct_exists(mutation_data, "disposition")){
                   for (var s=0;s<array_length(mutation_data.disposition);s++){
                        disposition[mutation_data.disposition[s][0]] += mutation_data.disposition[s][1];
                   }
                }
            }
        }
        draw_text_transformed(x1+30,y1+4,mutation_data.t_tip,0.4,0.4,0);
        if (scr_hit(x1,y1,x1+250,y1+20)){
            tooltip=mutation_data.t_tip;
            tooltip2=mutation_data.t_tip2;
        }    
        y1+=spac
        if (i==6){
            x1=750;
            y1=260;
        }
    }
    preomnor=mutations_defects[0].data;
    voice=mutations_defects[1].data;
    doomed=mutations_defects[2].data;
    lyman=mutations_defects[3].data;
    omophagea=mutations_defects[4].data;
    ossmodula=mutations_defects[5].data;
    zygote=mutations_defects[6].data;
    membrane=mutations_defects[7].data;
    betchers=mutations_defects[8].data;
    catalepsean=mutations_defects[9].data;
    secretions = mutations_defects[10].data;
    occulobe=mutations_defects[11].data;
    mucranoid=mutations_defects[12].data;

    draw_set_alpha(1);
    
    draw_line(445,505,1125,505);
    draw_line(445,506,1125,505);
    draw_line(445,507,1125,507);
    
    draw_set_font(fnt_40k_30b);
    draw_text_transformed(444,515,"Starting Disposition",0.6,0.6,0);
    
    draw_set_font(fnt_40k_14b);
    draw_set_halign(fa_right);
    
    draw_text(650,550,string_hash_to_newline("Imperium ("+string(disposition[2])+")"));
    draw_text(650,575,string_hash_to_newline("Adeptus Mechanicus ("+string(disposition[3])+")"));
    draw_text(650,600,string_hash_to_newline("Ecclesiarchy ("+string(disposition[5])+")"));
    draw_text(650,625,string_hash_to_newline("Inquisition ("+string(disposition[4])+")"));
    if (founding!=0) then draw_text(650,650,string_hash_to_newline("Progenitor ("+string(disposition[1])+")"));
    draw_text(650,675,"Adeptus Astartes ("+string(disposition[6])+")");
    
    draw_rectangle(655,552,1150,567,1);
    draw_rectangle(655,552+25,1150,567+25,1);
    draw_rectangle(655,552+50,1150,567+50,1);
    draw_rectangle(655,552+75,1150,567+75,1);
    if (founding!=0) then draw_rectangle(655,552+100,1150,567+100,1);
    draw_rectangle(655,552+125,1150,567+125,1);
    if (disposition[2]>0) then draw_rectangle(655,552,655+(disposition[2]*4.95),567,0);
    if (disposition[3]>0) then draw_rectangle(655,552+25,655+(disposition[3]*4.95),567+25,0);
    if (disposition[5]>0) then draw_rectangle(655,552+50,655+(disposition[5]*4.95),567+50,0);
    if (disposition[4]>0) then draw_rectangle(655,552+75,655+(disposition[4]*4.95),567+75,0);
    if (disposition[1]>0) and (founding!=0) then draw_rectangle(655,552+100,655+(disposition[1]*4.95),567+100,0);
    if (disposition[6]>0) then draw_rectangle(655,552+125,655+(disposition[6]*4.95),567+125,0);
 
}