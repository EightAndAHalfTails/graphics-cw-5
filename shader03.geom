//////////////////////////////////////////////////////
//shader03.geom shows what was necessary to get all points
//+ the bonus
//check out the solution by Rory Allford in shader03_Allford_Rory.geom

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
// exercise 3 solution
float rnd(vec2 x)
{
	int n = int(x.x * 40.0 + x.y * 6400.0);
	n = (n << 13) ^ n;
	return 1.0 - float( (n * (n * n * 15731 + 789221) + 1376312589) & 0x7fffffff) / 1073741824.0;
}

void produceVertex(float s, float t, vec4 v0, vec4 v01, vec4 v02, vec3 n0, vec3 n01, vec3 n02, int i)
{
	vec4 v = v0 + s*v01 + t*v02;
	vec3 n = n0 + s*n01 + t*n02;
	frag.vpos = v.xyz;
	frag.normal = normalize(n);
	frag.color = vertices[i].color;
	float disp = rnd(v.xy)/15.0;
	gl_Position = v + vec4(frag.normal * disp * sin(time), 1.0); //bonus task
	//gl_Position = v;
	EmitVertex();
}
///////////////////////////////
void main()
{
	///////////////////////////////
	//TODO implement exercise 3 here
	int i,j;
	vec4 v0 = gl_PositionIn[0];
	vec4 v01 = (gl_PositionIn[1] - gl_PositionIn[0]);
	vec4 v02 = (gl_PositionIn[2] - gl_PositionIn[0]);

	vec3 n0 = vertices[0].normal;
	vec3 n01 = (vertices[1].normal - vertices[0].normal);
	vec3 n02 = (vertices[2].normal - vertices[0].normal);

	int numLayers = 1 << level;
	float ds = 1.0 / float(numLayers);
	float dt = 1.0 / float(numLayers);

	float t = 0.0;
	for (i = 0 ; i < numLayers ; i++) {
		float s = 0.0;
		for (j = 0 ; j < numLayers-i ; j++) {
			produceVertex(s, t, v0, v01, v02, n0, n01, n02, j);
			produceVertex(s, t+dt, v0, v01, v02, n0, n01, n02, j);
			s += ds;
		}
		produceVertex(s, t, v0, v01, v02, n0, n01, n02, i);
		t += dt;
		EndPrimitive();
	}
	///////////////////////////////
	//pass though for exercise
	/*
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
	*/
}
