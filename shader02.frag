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
		//TODO add your code here


		////////////////////////////
        }

        if(shader == 3)
	{
		////////////////////////////
		//exercise 2.3 toon shading
		//TODO add your code here

		
		////////////////////////////
        }

	gl_FragColor = outcol;
}
