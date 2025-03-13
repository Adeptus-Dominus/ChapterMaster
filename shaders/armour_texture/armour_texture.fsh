//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 v_vMaskCoord;

uniform vec3 replace_colour;
uniform sampler2D armour_texture;

uniform int blend;
uniform vec3 blend_colour;


vec3 light_or_dark(vec3 m_colour, float shade){

  return vec3((m_colour.r * shade) + 0.001, m_colour.g * shade, m_colour.b * shade);
}
void main()
{
    vec4 col = texture2D(gm_BaseTexture, v_vTexcoord);
     if (col.rgb != replace_colour.rgb){
         col.a = 0.0;
      }
    if (col.rgb == replace_colour.rgb){
      col = texture2D(armour_texture, v_vMaskCoord);
      if (col.a != 0.0){
            vec4 col_orig = texture2D(gm_BaseTexture, v_vTexcoord);
            if (blend == 1){
               col.rgb = col.rgb * blend_colour.rgb;
            }
            if (col_orig.a==(128.0/255.0)){
               col.rgb = light_or_dark(col.rgb, 1.2);
               col.a = 1.0;
            }
      
            if (col_orig.a==(60.0/255.0)){
               col.rgb = light_or_dark(col.rgb, 1.4);
               col.a = 1.0;
            }         
      
      
            if (col_orig.a==(215.0/255.0)){
               col.rgb = light_or_dark(col.rgb,0.6);
               col.a = 1.0;
            }         
      
            if (col_orig.a==(160.0/255.0)){
               col.rgb = light_or_dark(col.rgb, 0.8);
               col.a = 1.0;
            }              
          }
          if (col.a == 0.0){
            col = texture2D(gm_BaseTexture, v_vTexcoord);
          }
       }

    gl_FragColor = v_vColour * col;
    //gl_FragColor = v_vColour * (background_col*texture2D(gm_BaseTexture, v_vTexcoord));
}
