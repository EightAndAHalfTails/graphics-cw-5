#version 330
#extension GL_ARB_separate_shader_objects : enable

layout(location = 0) in vec3 vertexPosition_modelspace;

out vec2 textureUV;

void main(){
	//nothing to be done here
	gl_Position =  vec4(vertexPosition_modelspace,1);
	textureUV = (vertexPosition_modelspace.xy+vec2(1,1))/2.0;
}