#version 150 compatibility
#extension GL_ARB_geometry_shader4 : enable

#define WINDOWS1

#if WINDOWS
layout (triangles) in;
layout (triangle_strip) out;
#endif

layout (max_vertices = 72) out;

const float pi = 3.14159265359;

////////////////
uniform vec4 ambientColor;
uniform vec4 diffuseColor;
uniform vec4 specularColor;
uniform float specularExponent;

uniform int level;
uniform float time;

in vertexData
{
	vec3 pos;
	vec3 normal;
	vec4 color;
}vertices[];

out fragmentData
{
	vec3 vpos;
	vec3 normal;
	vec4 color;
}frag;   


///////////////////////////////
// exercise 3 random helper function for bonus 3.1
float rnd(vec2 x)
{
	int n = int(x.x * 40.0 + x.y * 6400.0);
	n = (n << 13) ^ n;
	return 1.0 - float( (n * (n * n * 15731 + 789221) + 1376312589) & 0x7fffffff) / 1073741824.0;
}


///////////////////////////////
void main()
{
	///////////////////////////////
	// TODO replace the geometry pass-through 
	// shader in the following with exercise 3
	// you can also add a function to produce new vertices

	int i;
	for(i = 0; i < gl_in.length(); i++)
	{
		frag.vpos = vertices[i].pos;
		frag.normal = vertices[i].normal;
		frag.color = vertices[i].color;
		gl_Position = gl_in[i].gl_Position;
		EmitVertex();
	}
	EndPrimitive();
}
