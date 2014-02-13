#version 150 compatibility

uniform vec4 ambientColor;
uniform vec4 diffuseColor;
uniform vec4 specularColor;
uniform float specularExponent;

out vertexData
{
	vec3 pos;
	vec3 normal;
	vec4 color;
}vertex;

void main()
{
	vertex.pos = vec3(gl_ModelViewMatrix * gl_Vertex);
	vertex.normal = normalize(gl_NormalMatrix * gl_Normal);
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;  
	vertex.color = vec4(1.0,0.0,0.0,1.0);

	//exercise 2.1 Gouraud shading
	//not required here but implemented for illustration reasons
	if(false)
	{
		vec3 v = vertex.pos;
		vec3 N = vertex.normal;
		vec3 L = normalize(gl_LightSource[0].position.xyz - v);
		vec3 E = normalize(-v);
		vec3 R = normalize(reflect(-L,N)); 
		float distance = length(gl_LightSource[0].position.xyz - v);
		float attenuation = 1.0 / (gl_LightSource[0].constantAttenuation
			+ gl_LightSource[0].linearAttenuation * distance
			+ gl_LightSource[0].quadraticAttenuation * distance * distance);

		vec4  ambient = ambientColor;
		vec4  diffuse = attenuation * clamp( diffuseColor * max(dot(N,L), 0.0)  , 0.0, 1.0 ) ;
		vec4  spec = attenuation * clamp ( specularColor * pow(max(dot(R,E),0.0),0.3*specularExponent) , 0.0, 1.0 );

		vertex.color = ambient + diffuse + spec;
	}

}