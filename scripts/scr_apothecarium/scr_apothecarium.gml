// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

#macro ARR_gene_Seed_mutations ["preomnor", "lyman", "omophagea", "ossmodula", "zygote", "betchers", "catalepsean", "occulobe","mucranoid", "membrane", "voice"];


function create_gene_seed = function(){
   gene_seed_mutations = {
            "preomnor":obj_ini.preomnor,
            "lyman":obj_ini.lyman,
            "omophagea":obj_ini.omophagea,
            "ossmodula":obj_ini.ossmodula,
            "zygote":obj_ini.zygote,
            "betchers":obj_ini.betchers,
            "catalepsean":obj_ini.catalepsean,
            "occulobe":obj_ini.occulobe,
            "mucranoid":obj_ini.mucranoid,
            "membrane":obj_ini.membrane,
            "voice":obj_ini.voice,
    };                                                      
    var mutation_names = ARR_gene_Seed_mutations;
    for (var mute = 0; mute <array_length(mutation_names); mute++){
        if (gene_seed_mutations[$ mutation_names[mute]] == 0){
            if(irandom(999)-10<obj_ini.stability){
                gene_seed_mutations[$ mutation_names[mute]] = 1;
            }
        }
    }
    return gene_seed_mutations;
}
function scr_destroy_gene_slave_batch(batch_id, recover_gene=true){
    var _cur_slave = obj_ini.gene_slaves[batch_id];
    if (revover_gene){
        gene_seed_count()+=_cur_slave.num;
        scr_add_item("Gene Pod Incubator", _cur_slave.num);
    }
    delete _cur_slave;
    array_delete(obj_ini.gene_slaves,batch_id, 1);
}

function destroy_all_gene_slaves(recover_gene=true){
    var _slave_length = array_length(obj_ini.gene_slaves);
     if (_slave_length>0){
        for (var i=_slave_length-1; i>=0; i--){
            scr_destroy_gene_slave_batch(i,recover_gene);
        }
        obj_ini.gene_slaves = [];
    }   
}

function GeneStock() constructor(chapter_mutations){
    self.chapter_mutations = chapter_mutations;
    gene_seed = [];
    static new_gene_seed(data = "none"){
        var _seed_data = data
        if (_seed_data == "none"){
            _seed_data = create_gene_seed();
        }
        array_push(gene_seed, seed_data);
    }

    static harvest_from_slave_pod = function (slave_pod){
        var _slave_num = array_length(slave_pod.num);
        var _lost_gene_slaves=0;
        if (_slave_num>0){
            slave_pod.eta--;
            if (irandom(100000)<obj_ini.stability*_slave_num){
                array_delete(slave_pod.num, array_random_index(_cur_slave.num) , 1);
                _lost_gene_slaves++;
                _slave_num--;
                scr_add_item("Gene Pod Incubator");
            }
            if (slave_pod.eta==0 && slave_pod.num>0){
                slave_pod.eta=60;
                for (var i=0;i<_slave_num;i++){
                    new_gene_seed(slave_pod.num[i]);
                }
                // color / type / text /x/y
                scr_alert("green","test-slaves",$"Test-Slave Incubators Batch {i} harvested for {_slave_num} Gene-Seed.",0,0);
            }
        }
    }
    static remove_gene_seed = function(count=1){
        _seeds = [];
        repeat(count){
            var _remove = array_random_index(gene_seed);
            var _seed = gene_seed[_remove];
            array_delete(gene_seed, _remove, 1);
            array_push(_seeds, _seed);
        }
        return _seeds;
    }
    static mechanicus_tithes = function(){
        var expected,txt="";
        var onceh=0;
        expected=max(1,round(gene_seed_count()/20));

        var mech_mad = obj_controller.faction_status[eFACTION.Mechanicus]=="War";

        if (!gene_seed_count()) or (mech_mad){
            onceh=2;
            gene_iou+=1;
            loyalty-=2;
            loyalty_hidden-=2;
            txt="No Gene-Seed for Adeptus Mechanicus tithe.  High Lords of Terra IOU increased to "+string(gene_iou)+".";
        }

        if (!mech_mad){
            if (gene_seed_count()) and (und_gene_vaults==0) and (onceh==0){
                gene_stock.remove_gene_seed(expected);
                onceh=1;

                for(var i=0; i<50; i++){
                    if (gene_seed_count()<gene_iou) and (gene_seed_count()>0) and (gene_iou>0){
                        expected+=1;
                        gene_stock.remove_gene_seed(gene_iou);

                        gene_iou-=1;
                        if (gene_iou==0) then onceh=3;
                    } else {
                        break;
                    }
                }

                if (gene_iou<0) then gene_iou=0;

                txt=string(expected)+" Gene-Seed sent to Adeptus Mechanicus for tithe.";
                if (gene_iou>0) then txt+="  IOU remains at "+string(gene_iou)+".";
                if (onceh==3) then txt+="  IOU has been payed off.";
            }

            if (gene_seed_count()>0) and (und_gene_vaults>0) and (onceh==0){
                expected=1;
                gene_stock.remove_gene_seed(expected);
                onceh=1;

                if (gene_seed_count()<gene_iou) and (gene_seed_count()>0) and (gene_iou>0){
                    expected+=1;
                    gene_stock.remove_gene_seed(1);
                    gene_iou-=1;
                    if (gene_iou==0) then onceh=3;
                }

                if (gene_iou<0) then gene_iou=0;

                txt=string(expected)+" Gene-Seed sent to Adeptus Mechanicus for tithe.";
                if (gene_iou>0) then txt+="  IOU remains at "+string(gene_iou)+".";
                if (onceh==3) then txt+="  IOU has been payed off.";
            }

            var _colour = onceh!=2 ? "green": "red";

            scr_alert(_colour,"tithes",txt,0,0);
            scr_event_log(_colour,txt);

        }
    }
}

function gene_seed_count(){
    return array_length(obj_controller.gene_stock.gene_seed);
}

function add_new_gene_slave(){
    if (gene_seed_count()>0) and (obj_ini.zygote==0) {
        var _added = false;
        if (array_length(obj_ini.gene_slaves)){
            var _last_set = obj_ini.gene_slaves[array_length(obj_ini.gene_slaves)-1];
            if (_last_set.turn == obj_controller.turn){
                _last_set.num = array_concat(_last_set.num,obj_controller.gene_stock.remove_gene_seed(1));
                _added=true;
            }
        }
        if (!_added){
            array_push(obj_ini.gene_slaves, {
                num : obj_controller.gene_stock.remove_gene_seed(1),
                eta : 120,
                harvested_once : false,
                turn : obj_controller.turn,
                assigned_apothecaries : [],
            });
        }
        scr_add_item("Gene Pod Incubator", -1);
    }
}

function scr_apothecarium(){
	draw_sprite(spr_rock_bg, 0, xx, yy);

    draw_set_alpha(0.75);
    draw_set_color(0);
    draw_rectangle(xx + 326 + 16, yy + 66, xx + 887 + 16, yy + 818, 0);
    draw_set_alpha(1);
    draw_set_color(c_gray);
    draw_rectangle(xx + 326 + 16, yy + 66, xx + 887 + 16, yy + 818, 1);
    draw_line(xx + 326 + 16, yy + 426, xx + 887 + 16, yy + 426);

    draw_set_alpha(0.75);
    draw_set_color(0);
    draw_rectangle(xx + 945, yy + 66, xx + 1580, yy + 818, 0);
    draw_set_alpha(1);
    draw_set_color(c_gray);
    draw_rectangle(xx + 945, yy + 66, xx + 1580, yy + 818, 1);

    if (menu_adept = 0) {
        scr_image("advisor", 1, xx + 16, yy + 43, 310, 828);
        // draw_sprite(spr_advisors,1,xx+16,yy+43);
        if (global.chapter_name = "Space Wolves") then scr_image("advisor", 11, xx + 16, yy + 43, 310, 828);
        // draw_sprite(spr_advisors,11,xx+16,yy+43);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(xx + 336 + 16, yy + 66, "Apothecarium", 1, 1, 0);
        draw_text_transformed(xx + 336 + 16, yy + 100, "Master of the Apothecarion " + string(obj_ini.name[0, 3]), 0.6, 0.6, 0);
        draw_set_font(fnt_40k_14);
    }
    if (menu_adept = 1) {
        // draw_sprite(spr_advisors,0,xx+16,yy+43);
        scr_image("advisor", 0, xx + 16, yy + 43, 310, 828);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(xx + 336 + 16, yy + 40, "Apothecarium", 1, 1, 0);
        draw_text_transformed(xx + 336 + 16, yy + 100, $"Adept {obj_controller.adept_name}", 0.6, 0.6, 0);
        draw_set_font(fnt_40k_14);
    }

    blurp = "Milord, I come with a report.  Our Chapter currently boasts " + string(temp[36]) + " " + string(obj_ini.role[100, 15]) + " working on a variety of things, from field-duty to research to administrative duties.  ";

    if (training_apothecary = 0) then blurp += "Our Brothers are currently not assigned to train further " + string(obj_ini.role[100, 15]) + "; no more can be trained until Apothcarium funds are increased.";
    //
    if (training_apothecary > 0) then blurp += "Our Brothers assigned to the training of future " + string(obj_ini.role[100, 15]) + "s have taken up a ";
    if (training_apothecary >= 1 && training_apothecary <= 6){
        var _recruit_rates = ARR_recruitment_rates;
        blurp += _recruit_rates[training_apothecary];
    }
    if (training_apothecary > 0){
        blurp += " pace and expect to graduate an additional " + string(obj_ini.role[100, 15]) + " in ";
        var training_points_values = ARR_apothecary_training_tiers;
        eta = floor((47 - apothecary_recruit_points) / training_points_values[training_apothecary]) + 1;
        blurp += string(eta) + " months.";
    }
    // 

    // 

    var _gene_count = gene_seed_count();
    if (_gene_count <= 0) then blurp += $"##My lord, our stocks of gene-seed are empty.  It would be best to have some come mechanicus tithe.##Further training of Neophytes is halted until our stocks replenish.";
    if (_gene_count > 0) and(_gene_count <= 10) then blurp += $"##My Brother {obj_ini.role[100, 15]}s assigned to the gene-vault have informed me that our stocks are nearly gone.  They only number {_gene_count}; this includes those recently recovered from our fallen comerades-in-arms.";
    if (_gene_count > 10) then blurp += $"##My Brother {obj_ini.role[100, 15]}s assigned to the gene-vault have informed me that our stocks of gene-seed currently number {_gene_count}.  This includes those recently recovered from our fallen comerades-in-arms.";
    if (_gene_count > 0) then blurp += $"##The stocks are stable and show no sign of mutation.";

    if (menu_adept = 1) {
        var _recruit_pace = ARR_recruitment_pace;
        blurp = "Your Chapter contains " + string(temp[36]) + " " + string(obj_ini.role[100, 15]) + ".##";
        blurp += "Training of further " + string(obj_ini.role[100, 15]) + "s";
        if (training_apothecary >= 0 && training_apothecary <= 6) then blurp += _recruit_pace[training_apothecary];
        if (training_apothecary > 0) then blurp += "  The next " + string(obj_ini.role[100, 15]) + " is expected in " + string(eta) + " months.";
        blurp += $"##You have {_gene_count} gene-seed stocked.";
    }

    draw_text_ext(xx + 336 + 16, yy + 130, string_hash_to_newline(string(blurp)), -1, 536);

    var blurp2 = "";
    var _slave_length = array_length(obj_ini.gene_slaves);
    if (!obj_ini.zygote) {
        if (obj_controller.marines + gene_seed_count() <= 300) and(_slave_length = 0) {
            blurp2 = "Our Chapter is disasterously low in number- it is strongly advised that we make use of test-slaves to breed new gene-seed.  Give me the word andwe can begin installing gestation pods.";
        }
        else if (obj_controller.marines + gene_seed_count() > 300) and(_slave_length = 0) {
            blurp2 = "Our Chapter is capable of using test-slaves to breed new gene-seed.  Should our number of astartes ever plummet this may prove a valuable method of rapidly bringing our chapter back up to size.";
        }
        else if (_slave_length > 0) {
            blurp2 = "Our Test-Slave Incubators are working optimally.  As soon as a batch fully matures a second progenoid gland they will be harvested and prepared for use.";
        }
    }
    if (obj_ini.zygote = 1) then blurp2 = "Unfortunantly we cannot make use of Test-Slave Incubators.  Due to our missing Zygote any use of gestation pods is ultimately useless- no new gene-seed may be grown, no matter how long we wait.";

    draw_set_halign(fa_center);
    draw_set_color(c_gray);
    draw_set_font(fnt_40k_30b);
    draw_text_transformed(xx + 622, yy + 440, "Test-Slave Incubators", 0.6, 0.6, 0);
    draw_set_halign(fa_left);
    draw_set_color(c_gray);
    draw_set_font(fnt_40k_14);
    draw_text_ext(xx + 336 + 16, yy + 477, string_hash_to_newline(string(blurp2)), -1, 536);

    ;
    var _slave_index_shown = 0;
    var _cur_slave;
    for (var i = 0; i < _slave_length; i++) { // TODO why go through all batches if we can only display 10?
        if (obj_ini.gene_slaves[i].num > 0 && _slave_index_shown < 10) {
            _slave_index_shown++;
            _cur_slave = obj_ini.gene_slaves[i];
            draw_text(xx + 336 + 16, yy + 513 + (_slave_index_shown * 20), $"Batch {_slave_index_shown}" );
            draw_text(xx + 336 + 16.5, yy + 513.5 + (_slave_index_shown * 20), $"Batch {_slave_index_shown}");
            draw_text(xx + 536, yy + 513 + (_slave_index_shown * 20), $"Eta: {_cur_slave.eta} months");
            draw_text(xx + 756, yy + 513 + (_slave_index_shown * 20), $"{_cur_slave.num} pods");
        }
    }
    draw_set_alpha(1);
    if (gene_seed_count() <= 0) or(obj_ini.zygote = 1) then draw_set_alpha(0.5);
    draw_set_color(c_gray);
    draw_set_color(c_black);
    if (scr_item_count("Gene Pod Incubator")){
        if (point_and_click(draw_unit_buttons([xx + 411, yy + 793],"Add Test-Slave",[0.75,0.75],c_green))){
            add_new_gene_slave();
        }
    } else {
        if (scr_hit(draw_unit_buttons([xx + 411, yy + 793],"Add Test-Slave",[0.75,0.75],c_grey))){
            tooltip_draw("No available Gene Pod Incubators, Build more Gene Pod Incubators in the forge");
        }
    }

    draw_set_alpha(1);
    if (_slave_length <= 0){
        draw_set_alpha(0.5);
    }
    draw_set_color(c_gray);
    draw_rectangle(xx + 659, yy + 788, xx + 838, yy + 811, 0);
    draw_set_color(c_black);
    var _destroy_button = draw_unit_buttons([xx + 664, yy + 793], "Destroy All Incubators", [0.75,0.75],c_red);
    if (_slave_length > 0 && scr_hit(_destroy_button)) {
        draw_set_alpha(0.2);
        draw_set_color(c_gray);
        draw_rectangle(xx + 659, yy + 788, xx + 838, yy + 811, 0);
        if (point_and_click(_destroy_button)){
            if (_slave_length>0){
                for (var i=_slave_length-1; i>=0; i--){
                    scr_destroy_gene_slave_batch(i);
                }
                obj_ini.gene_slaves = [];
            }
        }
    }
    draw_set_alpha(1);
}