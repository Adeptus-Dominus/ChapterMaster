// Sets up the images for each system and planet
if (global.load>0){
    sprite_index=spr_star;
    if (star=="orange1") then image_index=0;
    if (star=="orange2") then image_index=1;
    if (star=="red") then image_index=2;
    if (star=="white1") then image_index=3;
    if (star=="white2") then image_index=4;
    if (star=="blue") then image_index=5;
    if (vision==1) then image_alpha=1;
    if (vision==0) then image_alpha=0;
    exit;
}
// Sets up transparency of system image
if (name!=""){
    if (planets==0) and (image_alpha!=0.33){
        image_alpha=0.33;
    } else if (planets!=0) and (image_alpha==0.33){
        image_alpha=1;
    }

}
// Sets up warp storm image
if (storm>0){
    storm_image++;
} else {
    storm_image=0;
}
// Checks if they are dead planets, then sets up image
if (is_dead_star()) then image_alpha=0.33;

// Sets up enemy ai beheaviour
if (ai_a>=0){
    ai_a--;
    if (ai_a==0){
        try{
            scr_enemy_ai_a();
        } catch(_exception){
            handle_exception(_exception);
        }
    }
}
if (ai_b>=0){
    ai_b--;
    if (ai_b==0){
        try{
            scr_enemy_ai_b();
        } catch(_exception){
            handle_exception(_exception);
        }
    }
}
if (ai_c>=0){
    ai_c--;
    if (ai_c==0){
        try{
            scr_enemy_ai_c();
        } catch(_exception){
            handle_exception(_exception);
        }
    }
}
if (ai_d>=0){
    ai_d--;
    if (ai_d==0){
        try{
            scr_enemy_ai_d();
        } catch(_exception){
            handle_exception(_exception);
        }
    }
}
if (ai_e>=0){
    ai_e--;
    if (ai_e==0){
        try{
            scr_enemy_ai_e();
        } catch(_exception){
            handle_exception(_exception);
        }
    }
}