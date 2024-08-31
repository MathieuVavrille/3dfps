shader_type spatial;

uniform sampler2D texture_albedo;
uniform sampler2D noise_texture; // Noise texture
uniform float speed = 0.1;
uniform float wave_scale = 0.01;
uniform vec2 center;
uniform float radius = 100.0;
uniform float bound = 100.0;

void fragment() {
	
    vec2 uv = (UV - center) * 2.0; // Scale UV to the range [-1, 1]
    float dist = length(uv);
    if (dist > radius || uv.y < -bound) {
        discard; // Discard pixels outside the semi-circle
    }
    float time = TIME * speed;

    // Generate noise-based offsets
    vec2 uv_noise = UV * 10.0;
    float noise_value = texture(noise_texture, uv_noise + vec2(time * 0.1, time * 0.1)).r;
    vec2 wave_offset = vec2(
        sin(UV.y * 10.0 + time * 2.0) * wave_scale * noise_value,
        cos(UV.x * 10.0 + time * 2.0) * wave_scale * noise_value
    );

    // Apply the noise-based wave offset to the UV coordinates
    vec2 moving_uv = UV + wave_offset;

    // Sample the texture using the modified UV coordinates
    vec4 tex_color = texture(texture_albedo, moving_uv);

    // Set the final color (Albedo)
    ALBEDO = tex_color.rgb;
}