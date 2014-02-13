#version 150 compatibility

uniform vec4 ambientColor;
uniform vec4 diffuseColor;
uniform vec4 specularColor;
uniform float specularExponent;
uniform int shader;

in fragmentData
{
	vec3 pos;
	vec3 normal;
	vec4 color;
}frag;

///////////////

void main()
{
        vec4 outcol = frag.color;

        if(shader == 2)
        {
		////////////////////////////
		//exercise 2.2 Phong shading
		//TODO enter your code here
                vec3 v = frag.pos;
		vec3 N = frag.normal;
		vec3 L = normalize(gl_LightSource[0].position.xyz - v);
		vec3 E = normalize(-v);
		vec3 R = normalize(reflect(-L,N));  
		float distance = length(gl_LightSource[0].position.xyz - v);
		float attenuation = 1.0 / (gl_LightSource[0].constantAttenuation
			+ gl_LightSource[0].linearAttenuation * distance
			+ gl_LightSource[0].quadraticAttenuation * distance * distance);

		vec4  ambient = ambientColor;

		vec4 diffuse = attenuation * clamp( diffuseColor * max(dot(N,L), 0.0), 0.0, 1.0 ) ;
		vec4 spec = attenuation * clamp ( specularColor * pow(max(dot(R,E),0.0),0.3*specularExponent) , 0.0, 1.0 );

		
                outcol  = ambient + diffuse + spec;
		////////////////////////////
        }

        if(shader == 3)
	{
		////////////////////////////
		//exercise 2.3 toon shading
		//TODO enter your code here
		float intensity;
		vec3 v = frag.pos;
		vec3 n;
		vec4 color;
		vec3 lightDir = normalize(vec3(gl_LightSource[0].position.xyz) - v);

		n = normalize(frag.normal);
		intensity = max(dot(lightDir,n),0.0); 

		if (intensity > 0.98)
			color = vec4(0.8,0.8,0.8,1.0);
		else if (intensity > 0.5)
			color = vec4(0.8,0.4,0.4,1.0);	
		else if (intensity > 0.25)
			color = vec4(0.6,0.2,0.2,1.0);
		else
			color = vec4(0.1,0.1,0.1,1.0);		

		outcol = color;
		////////////////////////////
        }

	gl_FragColor = outcol;
}
