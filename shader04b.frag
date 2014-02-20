#version 330 core

//simplified IO structures, no geometry shader any more
in vec2 textureUV;
out vec3 color;

//this is the texture of the framebuffer object
uniform sampler2D renderedTexture;

const float sampleDist = 0.3;

void main(){

	//this is one fragment of the framebuffer texture the main programme renders 
	color = texture( renderedTexture, textureUV).xyz;

	//////////////////////////////////////
	//TODO Exercise 5
	//implement a simple image based blur here
	//modify color accordingly

	//////////////////////////////////////
}
