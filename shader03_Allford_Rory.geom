//////////////////////////////////////////////////////
//This is the solution by Rory Allford. 
//It was not required to do it in this way but it shows
//nicely what's possible
//shader03.geom shows what was necessary to get all points
//+ the bonus

#version 150 compatibility
#extension GL_ARB_geometry_shader4 : enable

#define WINDOWS 0

#if WINDOWS
layout (triangles) in;
layout (triangle_strip, max_vertices = 80) out;
#else
layout (max_vertices = 80) out;
#endif


//*********************************************************************
// Simplex Noise (Ken Perlin)
// Description : Array and textureless GLSL 2D simplex noise function.
//      Author : Ian McEwan, Ashima Arts.
//     License : Distributed under the MIT License.
//
vec3 mod289(vec3 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec2 mod289(vec2 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec3 permute(vec3 x) { return mod289(((x*34.0)+1.0)*x); }

float snoise(vec2 v)
  {
  const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                      0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                     -0.577350269189626,  // -1.0 + 2.0 * C.x
                      0.024390243902439); // 1.0 / 41.0
// First corner
  vec2 i  = floor(v + dot(v, C.yy) );
  vec2 x0 = v -   i + dot(i, C.xx);

// Other corners
  vec2 i1;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;

// Permutations
  i = mod289(i); // Avoid truncation effects in permutation
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
		+ i.x + vec3(0.0, i1.x, 1.0 ));
  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
  m = m*m ; m = m*m ;

// Gradients: 41 points uniformly over a line, mapped onto a diamond.
// The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)
  vec3 x = 2.0 * fract(p * C.www) - 1.0; vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5); vec3 a0 = x - ox;

// Normalise gradients implicitly by scaling m
// Approximation of: m *= inversesqrt( a0*a0 + h*h );
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

// Compute final noise value at P
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}
//*********************************************************************


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

////////////////////////
// Emit a vertex
// Using barycentric coordinates
// uvw to interpolate attribs
void UVWEmitVertex(vec4 uvw, mat4 cam_pos, mat4 world_pos, mat4 normals, mat4 colors)
{
    // view independent seed
    vec2 seed = (gl_ModelViewMatrixInverse * (world_pos * uvw)).xy;
    // periodic animation
    float t = sin(0.31830988618 * time);

    // perlin noise displacement in eye space
    vec4 displacement = normals * uvw *  (snoise(seed * t) * 0.1 * t);

    // Interpolate normals + colors
    frag.normal = vec3(normals * uvw);
    frag.color = colors * uvw;
    // Interpolate vertex position and displace
    frag.vpos = vec3(world_pos * uvw + displacement);
    gl_Position = cam_pos * uvw + gl_ProjectionMatrix * displacement;

    EmitVertex();
}
///////////////////////////////
void main()
{       
    int num_strips = int(pow(2.0,max(level,0)));
    float num_strips_f = float(num_strips);

    int i;

    // PRE: gl_in has GL_TRIANGLES layout
    int i_Max = gl_in.length() - gl_in.length()%3;
    // ASSERT: i_Max == gl_in.length()

    for(i = 0; i < i_Max; i+=3)
    {
        mat4 cam_pos = mat4(
            gl_in[i].gl_Position,
            gl_in[i+1].gl_Position,
            gl_in[i+2].gl_Position,
            vec4(0));
        mat4 world_pos = mat4(
            vec4(vertices[i].pos,1),
            vec4(vertices[i+1].pos,1),
            vec4(vertices[i+2].pos,1),
            vec4(0));
        mat4 normals = mat4(
            vec4(vertices[i].normal,0),
            vec4(vertices[i+1].normal,0),
            vec4(vertices[i+2].normal,0),
            vec4(0));
        mat4 colors = mat4(
            vertices[i].color,
            vertices[i+1].color,
            vertices[i+2].color,
            vec4(0));

        /*
            The following patten of iteration emits the smallest
            possible number of triangle strips
            (though not necessarily the smallest number of vertices)

            Subdivides to level 3 with max_vertices >= 80
        */

        int cur_strip = 0;
        for (cur_strip=0; cur_strip<num_strips; cur_strip++)
        {
            int U = num_strips - cur_strip;
            int V = cur_strip + 1;
            int W = -1;
            bool b = true;

            while(b || U>0)
            {
                if (b) {
                    V--;
                    W++;
                    b = false;
                } else {
                    U--;
                    V++;
                    b = true;
                }
                vec4 uvw = vec4(
                    float(U) / num_strips_f,
                    float(V) / num_strips_f,
                    float(W) / num_strips_f,
                    0);
                UVWEmitVertex(uvw,cam_pos,world_pos,normals,colors);
            }

            EndPrimitive(); // End of current triangle strip
        }
    }
	
}

