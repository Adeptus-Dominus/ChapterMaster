//
// SDF fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 gm_SDF_Dist_UV;			// the SDF distance value of half a pixel in UV space (takes account of texture size)

void main()
{
	vec4 texcol = texture2D( gm_BaseTexture, v_vTexcoord );
		
	vec2 coordDiffX = dFdx(v_vTexcoord);
	vec2 coordDiffY = dFdy(v_vTexcoord);
	vec2 scaledCoordDiffX = coordDiffX * gm_SDF_Dist_UV;
	vec2 scaledCoordDiffY = coordDiffY * gm_SDF_Dist_UV;
	float diffXLength = length(scaledCoordDiffX);
	float diffYLength = length(scaledCoordDiffY);		
	float spread = (diffXLength + diffYLength) * 0.5;		// get average	
	spread = min(spread, 0.5); // make sure (0.5 - spread) can't be negative

	//float spread = fwidth(texcol.a);	
	//spread = max(spread * 0.75, 0.001);		
	
	texcol.a = smoothstep(0.5 - spread, 0.5 + spread, texcol.a);			
	
	vec4 combinedcol = v_vColour * texcol;
	DoAlphaTest(combinedcol);	
			
    gl_FragColor = combinedcol;
}