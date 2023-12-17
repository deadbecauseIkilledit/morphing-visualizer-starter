varying vec2 vUv;
varying float vPattern;
uniform float uAudioFrequency;
uniform float uTime;

// ------------------------------------------------


struct Color {
    vec3 c;
    float position;
};

/* ** COLOR_RAMP macro by Arya Ross -> based on Blender's ColorRamp Node in the shading tab
Color[?] cs -> array of c stops that can have any length
float factor -> the position that you want to know the c of -> [0, 1]
vec3 finalColor -> the final c based on the factor 

Line 5 Of The Macro:
// possibly is bad for performance 
index = isInBetween ? i : index; \

Taken From: https://stackoverflow.com/a/26219603/19561482 
index = int(mix(float(index), float(i), float(isInBetween))); \
*/
#define COLOR_RAMP(cs, factor, finalColor) { \
    int index = 0; \
    for(int i = 0; i < cs.length() - 1; i++){ \
       Color currentColor = cs[i]; \
       bool isInBetween = currentColor.position <= factor; \
       index = int(mix(float(index), float(i), float(isInBetween))); \
    } \
    Color currentColor = cs[index]; \
    Color nextColor = cs[index + 1]; \
    float range = nextColor.position - currentColor.position; \
    float lerpFactor = (factor - currentColor.position) / range; \
    finalColor = mix(currentColor.c, nextColor.c, lerpFactor); \
} \

// ------------------------------------------------



void main() {
    float time = uTime * (1.0 + uAudioFrequency);


    vec3 color;
    
    vec3 mainColor = mix(vec3(0.2, 0.3, 0.9), vec3(0.4, 1.0, 0.3), uAudioFrequency);
    
    mainColor.r  *= 0.9 + sin(time) / 3.2;
    mainColor.g *= 1.1 + cos(time / 2.0) / 2.5;
    mainColor.b *= 0.8 + cos(time / 5.0) / 4.0;

    mainColor.rgb += 0.1;



    Color[4] colors = Color[](
        Color(vec3(1), 0.0),
        Color(vec3(1), 0.01),
        Color(mainColor, 0.01),
        Color(vec3(1.01, 0.05, 0.2), 1.0)
    );

    COLOR_RAMP(colors, vPattern, color);

    gl_FragColor = vec4(color, 1);
}