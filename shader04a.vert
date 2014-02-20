#version 150 compatibility

// Exercise 4: TODO extend the IO structures and shaders
// with texture access functionality
// integrate texture illumination
// use gl_MultiTexCoord0 for initial texture coordinates

uniform vec4 ambientColor;
uniform vec4 diffuseColor;
uniform vec4 specularColor;
uniform float specularExponent;

//TODO
//Exercise 4a: extend the IO structures with texture coordinates
out vertexData
{
	vec3 pos;
	vec3 normal;
	vec4 color;
}vertex;

/////////////

void main()
{
	vertex.pos = vec3(gl_ModelViewMatrix * gl_Vertex);
	vertex.normal = normalize(gl_NormalMatrix * gl_Normal);
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;  
	vertex.color = vec4(1.0,0.0,0.0,1.0);

	//TODO
	//Exercise 4a: get texture coordiantes from gl_MultiTexCoord0


}