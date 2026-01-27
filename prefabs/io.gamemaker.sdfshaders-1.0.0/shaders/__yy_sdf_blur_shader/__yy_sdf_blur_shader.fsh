//
// SDF (with blur) fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// SDF values are measured from 0 (at the outer edge) to 1 which is the innermost point that can be represented
uniform vec2 gm_SDF_Blur_MinMax;			// the range across which to filter the SDF
uniform vec4 gm_SDF_Blur_Col;				// the colour tint of the blurred text

void main()
{
	vec4 texcol = texture2D( gm_BaseTexture, v_vTexcoord );	
	vec4 currcol = gm_SDF_Blur_Col;
		
	currcol.a *= smoothstep(gm_SDF_Blur_MinMax.x, gm_SDF_Blur_MinMax.y, texcol.a);		
	
	vec4 combinedcol = v_vColour * currcol;
	DoAlphaTest(combinedcol);	

    gl_FragColor = combinedcol;
}
