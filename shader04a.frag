#version 150 compatibility

uniform vec4 ambientColor;
uniform vec4 diffuseColor;
uniform vec4 specularColor;
uniform float specularExponent;

//this is the 2D texture image for exercise 4a
uniform sampler2D textureImage;

//TODO
//Exercise 4a: extend the IO structures with texture coordinates
in fragmentData
{
	vec3 vpos;
	vec3 normal;
	vec4 color;
}frag;

///////////////

void main()
{
	//TODO
	//Exercise 4a:  read texture with texture2D(...) and
	//              integrate texture color into shading
	vec4 outcol = frag.color;

	// Phong shading
	vec3 v = frag.vpos;
	vec3 N = frag.normal;
	vec3 L = normalize(gl_LightSource[0].position.xyz - v);
	vec3 E = normalize(-v);
	vec3 R = normalize(reflect(-L,N));  
	float distance = length(gl_LightSource[0].position.xyz - v);
	float attenuation = 1.0 / (gl_LightSource[0].constantAttenuation
		+ gl_LightSource[0].linearAttenuation * distance
		+ gl_LightSource[0].quadraticAttenuation * distance * distance);

	vec4  ambient = outcol;

	vec4 diffuse = attenuation * clamp( diffuseColor * max(dot(N,L), 0.0), 0.0, 1.0 ) ;
	vec4 spec = attenuation * clamp ( specularColor * pow(max(dot(R,E),0.0),0.3*specularExponent) , 0.0, 1.0 );

	outcol = ambient + diffuse + spec;

	gl_FragColor = outcol;

}
