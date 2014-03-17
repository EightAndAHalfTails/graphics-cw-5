#version 150 compatibility

in vec3 origin, dir, point; 
out vec4 outcolour;

uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;

#define USE_OWN_GEOMETRY 0

const int raytraceDepth = 42;
const int numSpheres = 6;

struct Ray
{
  vec3 origin;
  vec3 dir;
};
struct Sphere
{
  vec3 centre;
  float radius;
  vec3 colour;
};
struct Plane
{
  vec3 point;
  vec3 normal;
  vec3 colour;
};

struct Intersection
{
  float t;
  vec3 point;     // hit point
  vec3 normal;     // normal
  int hit;
  vec3 colour;
};

const vec3 lightPos = vec3(6,4,3);

void sphere_intersect(Sphere sph,  Ray ray, inout Intersection intersect)
{
  //////////////////////////////////////
  //TODO Exercise 5
  //calculate the intersection ray-sphere here
  vec3 d = ray.dir;
  vec3 dp = ray.origin - sph.centre;
  float r = sph.radius;

  float disc = dot(d, dp)*dot(d, dp) - length(dp)*length(dp) + r*r;
  if(disc > 0) // check for intersections
    {
      float mu1 = dot(-d, dp) + sqrt( disc );
      float mu2 = dot(-d, dp) - sqrt( disc );
      float mu = min( max(mu1, 0), max(mu2, 0) );
      if(mu>0 && (mu < intersect.t || intersect.hit == 0))
	{
	  intersect.t = mu;
	  intersect.point = ray.origin + mu * ray.dir;
	  intersect.normal = normalize(intersect.point - sph.centre);
	  intersect.hit = 1;
	  intersect.colour = sph.colour;
	}
    }
  //////////////////////////////////////
}

void plane_intersect(Plane pl, Ray ray, inout Intersection intersect)
{
  //////////////////////////////////////
  //TODO Exercise 5
  //calculate the intersection ray-plane here
  //generate a checkerboard pattern
  vec3 p0 = ray.origin;
  vec3 p1 = pl.point;
  vec3 n = pl.normal;
  vec3 d = ray.dir;

  float denom = dot(d, n);
  if(denom != 0)
    {
      float mu = -dot((p0-p1), n)/denom;
      if(mu>0 && (intersect.hit == 0 || mu < intersect.t))
	{
	  intersect.t = mu;
	  intersect.point = ray.origin + intersect.t * ray.dir;
	  intersect.normal = pl.normal;
	  intersect.hit = 1;
	  intersect.colour = (int(floor(intersect.point.x*2))%2 == int(floor(intersect.point.z*2))%2) ? pl.colour : vec3(0, 0, 0);
	}
    }
  //////////////////////////////////////
}

Sphere sphere[numSpheres];
Plane plane;
void Intersect(Ray r, inout Intersection i)
{
  //////////////////////////////////////
  //TODO Exercise 5
  //test the ray for intersections with all objects
  i.hit = 0;

  plane_intersect(plane, r, i);
  for(int j = 0; j<numSpheres; j++)
    {
      sphere_intersect(sphere[j], r, i);
    }
  //////////////////////////////////////

}

int seed = 0;
float rnd()
{
  //////////////////////////////////////
  // you may use pseudo random number 
  // generator this to account for numerical errors
  // however, you don't need to
  seed = int(mod(float(seed)*1364.0+626.0, 509.0));
  return float(seed)/509.0;
}

vec3 computeShadow(in Intersection intersect, vec3 viewdir)
{
  //////////////////////////////////////
  //TODO Exercise 5
  //compute the shadow of the objects 
  //using additional rays
  float epsilon = 0.00001;
  Intersection i;
  i.hit = 0;
  Ray toLight;
  toLight.origin = intersect.point + epsilon * intersect.normal;
  toLight.dir = normalize(lightPos - toLight.origin);
  Intersect(toLight, i);
  if(i.hit == 0)
    {
      float lightIntensity = 20;

      float d = distance(lightPos, toLight.origin);
      float con =1.0;
      float lin =0.22;
      float quad=0.20; 
      float attenuation = 1.0 / (con + lin*d + quad*d*d);
      vec3 diffuseColour = intersect.colour;
      vec3 diffuse = lightIntensity * attenuation * diffuseColour * dot(intersect.normal, toLight.dir);

      vec3 campos = vec3(modelViewMatrix[3].xyz);
      vec3 specularColour = intersect.colour;
      vec3 r = reflect(toLight.dir, intersect.normal);
      vec3 e = normalize(viewdir);
      float specularExponent = 10;
      vec3 specular = lightIntensity * attenuation * specularColour * pow(max(dot(r, e), 0), specularExponent);
      return diffuse + specular;
    }
  else return vec3(0,0,0);
  //////////////////////////////////////
	
}

vec3 transformRayOrigin(vec3 modelSpaceVector)
{
  vec4 homo = vec4(0, 0, 0, 1.0);
  homo.xyz = modelSpaceVector;
  homo = modelViewMatrix*homo;
  return homo.xyz/homo.w;
}

vec3 transformRayDirection(vec3 modelSpaceVector)
{
  vec4 homo = vec4(0, 0, 0, 1.0);
  homo.xyz = modelSpaceVector;
  homo = homo*modelViewMatrix;
  return homo.xyz;
}

void main()
{
  // please leave the scene definition unaltered for marking reasons
  // if you add your own geometry or scene, please use USE_OWN_GEOMETRY 1
  // and implement it within preprocessor blocks 
  // #if USE_OWN_GEOMETRY
  // your scene
  // #endif //USE_OWN_GEOMETRY
  //scene definition:
  sphere[0].centre   = vec3(-2.0, 1.5, -3.5);
  sphere[0].radius   = 1.5;
  sphere[0].colour = vec3(0.8,0.8,0.8);
  sphere[1].centre   = vec3(-0.5, 0.0, -2.0);
  sphere[1].radius   = 0.6;
  sphere[1].colour = vec3(0.3,0.8,0.3);
  sphere[2].centre   = vec3(1.0, 0.7, -2.2);
  sphere[2].radius   = 0.8;
  sphere[2].colour = vec3(0.3,0.8,0.8);
  sphere[3].centre   = vec3(0.7, -0.3, -1.2);
  sphere[3].radius   = 0.2;
  sphere[3].colour = vec3(0.8,0.8,0.3);
  sphere[4].centre   = vec3(-0.7, -0.3, -1.2);
  sphere[4].radius   = 0.2;
  sphere[4].colour = vec3(0.8,0.3,0.3);
  sphere[5].centre   = vec3(0.2, -0.2, -1.2);
  sphere[5].radius   = 0.3;
  sphere[5].colour = vec3(0.8,0.3,0.8);
  plane.point = vec3(0,-0.5, 0);
  plane.normal = vec3(0, 1.0, 0);
  plane.colour = vec3(1, 1, 1);
  seed = int(mod(dir.x * dir.y * 39786038.0, 65536.0));
  //scene definition end

  outcolour = vec4(0,0,0,0);
  //////////////////////////////////////
  //TODO Exercise 5
  //implement your ray tracing algorithm here
  //don't forget to finally integrate mouse-interaction

  // cast ray
  Ray ray;
  ray.origin = transformRayOrigin(origin);
  ray.dir = normalize(transformRayDirection(dir));
  Intersection i;
  float totalLength = 0;
  int depth = 1;
  float ambiance = 0.0;
  float reflectivity = 0.5;
  do
    {
      Intersect(ray, i);
      if(i.hit == 1)
	{
	  totalLength += i.t;
	  //float f0 = 0.5;
	  //float fresnel = f0 + (1-f0)*(1-pow(max(dot(-ray.dir, i.normal), 0), 5));
	  vec3 colourHere = ambiance*i.colour + computeShadow(i, ray.dir);
	  outcolour.xyz = outcolour.xyz + colourHere*pow(reflectivity,depth);
	  
	  ray.origin = i.point + 0.00001*i.normal;
	  ray.dir = reflect(ray.dir, i.normal);
	  depth++;
	}
    }
  while(i.hit == 1 && totalLength < raytraceDepth);
}
