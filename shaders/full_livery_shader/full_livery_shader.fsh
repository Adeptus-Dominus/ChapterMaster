uniform vec3 left_leg_lower;
uniform vec3 left_leg_upper;
uniform vec3 left_leg_knee;
uniform vec3 right_leg_lower;
uniform vec3 right_leg_upper;
uniform vec3 right_leg_knee;
uniform vec3 metallic_trim;
uniform vec3 right_trim;
uniform vec3 left_trim;
uniform vec3 left_chest;
uniform vec3 main_colour;
uniform vec3 right_chest;
uniform vec3 left_thorax;
uniform vec3 right_thorax;
uniform vec3 left_pauldron;
uniform vec3 right_pauldron;
uniform vec3 left_head;
uniform vec3 right_head;
uniform vec3 left_muzzle;
uniform vec3 right_muzzle;
uniform vec3 left_arm;
uniform vec3 right_arm;
uniform vec3 left_hand;
uniform vec3 right_hand;
uniform vec3 eye_lense;
uniform vec3 right_backpack;
uniform vec3 left_backpack;
uniform vec3 company_marks;
uniform vec3 robes_colour_replace;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;


vec3 light_or_dark(vec3 m_colour, float shade){
  return vec3((m_colour.r * shade) + 0.01, m_colour.g * shade, m_colour.b * shade);
}

void main()
{
    vec4 col = texture2D(gm_BaseTexture, v_vTexcoord);
   if (col.rgb == vec3(0.0,0.0, 128.0/255.0).rgb){
     col.rgb = left_head.rgb;
   };
    if (col.rgb == vec3(181.0/255.0,0.0, 255.0/255.0).rgb){
        col.rgb = right_backpack.rgb;
    };    
    if (col.rgb == vec3(104.0/255.0,0.0, 168.0/255.0).rgb){
        col.rgb = left_backpack.rgb;
    };
   if (col.rgb == vec3(0.0,0.0, 1.0).rgb){
         col.rgb = right_head.rgb;
    };
     if (col.rgb == vec3(128.0/255.0,64.0/255.0, 1.0).rgb){
         col.rgb = left_muzzle.rgb;
    };
     if (col.rgb == vec3(64.0/255.0,128.0/255.0, 1.0).rgb){
         col.rgb = right_muzzle.rgb;
    };
     if (col.rgb == vec3(0.0,1.0, 0.0).rgb){
        col.rgb = eye_lense.rgb;
    };
     if (col.rgb == vec3(1.0,20.0/255.0, 147.0/255.0).rgb){
        col.rgb = right_chest.rgb;
    };
     if (col.rgb == vec3(128.0/255.0,0.0, 128.0/255.0).rgb){
        col.rgb = left_chest.rgb;
    };
     if (col.rgb == vec3(0.0,128.0/255.0, 128.0/255.0).rgb){
        col.rgb = right_trim.rgb;
    };
     if (col.rgb == vec3(1.0,128.0/255.0, 0.0).rgb){
        col.rgb = left_trim.rgb;
    };
     if (col.rgb == vec3(135.0/255.0,130.0/255.0, 188.0/255.0).rgb){
        col.rgb = metallic_trim.rgb;
    };
     if (col.rgb == vec3(1.0,1.0, 1.0).rgb){
        col.rgb = right_pauldron.rgb;
    };
     if (col.rgb == vec3(1.0,1.0, 0.0).rgb){
        col.rgb = left_pauldron.rgb;
    };
     if (col.rgb == vec3(0.0/255.0,128.0/255.0, 0.0/255.0).rgb){
        col.rgb = right_leg_upper.rgb;
    };
     if (col.rgb == vec3(255.0/255.0,112.0/255.0, 170.0/255.0).rgb){
        col.rgb = left_leg_upper.rgb;
    };
     if (col.rgb == vec3(1.0,0.0, 0.0).rgb){
        col.rgb = left_leg_knee.rgb;
    };
     if (col.rgb == vec3(128.0/255.0,0.0/255.0, 0.0/255.0).rgb){
        col.rgb = left_leg_lower.rgb;
    };
     if (col.rgb == vec3(214.0/255.0,194.0/255.0, 255.0/255.0).rgb){
        col.rgb = right_leg_knee.rgb;
    };
     if (col.rgb == vec3(165.0/255.0,84.0/255.0, 24.0/255.0).rgb){
        col.rgb = right_leg_lower.rgb;
    };
     if (col.rgb == vec3(138.0/255.0,218.0/255.0, 140.0/255.0).rgb){
        col.rgb = right_arm.rgb;
    };
     if (col.rgb == vec3(46.0/255.0,169.0/255.0, 151.0/255.0).rgb){
        col.rgb = right_hand.rgb;
    };
     if (col.rgb == vec3(1.0,230.0/255.0, 140.0/255.0).rgb){
        col.rgb = left_arm.rgb;
    } ;
     if (col.rgb == vec3(1.0,160.0/255.0, 112.0/255.0).rgb){
        col.rgb = left_hand.rgb;
    };
    if (col.rgb == vec3(128.0/255.0,128.0/255.0,0.0)){
      col.rgb = company_marks.rgb;
    };

     vec3 robes_colour_base = vec3(201.0 / 255.0, 178.0 / 255.0, 147.0 / 255.0);
     vec3 robes_highlight = vec3(230.0 / 255.0, 203.0 / 255.0, 168.0 / 255.0);
     vec3 robes_darkness = vec3(189.0 / 255.0, 167.0 / 255.0, 138.0 / 255.0);
     vec3 robes_colour_base_2 = vec3(169.0 / 255.0, 150.0 / 255.0, 123.0 / 255.0);
     vec3 robes_highlight_2 = vec3(186.0 / 255.0, 165.0 / 255.0, 135.0 / 255.0);
     vec3 robes_darkness_2 = vec3(148.0 / 255.0, 132.0 / 255.0, 108.0 / 255.0);
      if (col.rgb == robes_colour_base.rgb || col.rgb == robes_colour_base_2.rgb) {
         col.rgb = light_or_dark(robes_colour_replace , 1.0).rgb;
      };
      if (col.rgb == robes_highlight.rgb || col.rgb == robes_highlight_2.rgb) {
         col.rgb = light_or_dark(robes_colour_replace , 1.25).rgb;
      //col.rgb = mix(robes_highlight.rgb, robes_colour_replace.rgb, 0.25);
      };
      if (col.rgb == robes_darkness.rgb || col.rgb == robes_darkness_2.rgb) {
      //col.rgb = vec3(col.r*0.8, col.g*0.8, col.b*0.8).rgb;
      //col.rgb = robes_colour_replace.rgb;
      //col.rgb = mix(robes_darkness.rbg, robes_colour_replace.rgb, 0.25);
         col.rgb = light_or_dark(robes_colour_replace , 0.75).rgb;
      };

    gl_FragColor = v_vColour * col;

}
