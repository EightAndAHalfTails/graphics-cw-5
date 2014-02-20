#version 150 compatibility
#extension GL_ARB_geometry_shader4 : enable

#define WINDOWS 0

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

//TODO
//Exercise 4a: extend the IO structures with texture coordinates
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


void main()
{
		//TODO
		//Exercise 4a: forward texture coordinates to fragment shader
		int i;
		for(i = 0; i < gl_in.length(); i++)
		{
			gl_Position = gl_in[i].gl_Position;
			frag.vpos = vertices[i].pos;
			frag.normal = vertices[i].normal;
			frag.color = vertices[i].color;
			
			EmitVertex();
		}
		EndPrimitive();

}
