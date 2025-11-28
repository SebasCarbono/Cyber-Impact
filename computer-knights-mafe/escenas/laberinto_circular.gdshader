shader_type spatial;
render_mode cull_disabled;

// 🎨 Paleta coherente con el shader anterior
uniform vec3 base_color : source_color = vec3(0.0, 0.025, 0.05); // azul oscuro
uniform vec3 data_color : source_color = vec3(0.0, 0.5, 0.9);    // flujo digital
uniform vec3 corruption_color : source_color = vec3(0.9, 0.1, 0.3); // corrupción IA
uniform float corruption_intensity = 0.4;
uniform float line_density = 12.0;
uniform float flow_speed = 0.1;
uniform float damage_speed = 0.3;

// 🔹 Ruido y patrones
float random(vec2 st) {
	return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
	vec2 i = floor(st);
	vec2 f = fract(st);
	float a = random(i);
	float b = random(i + vec2(1.0, 0.0));
	float c = random(i + vec2(0.0, 1.0));
	float d = random(i + vec2(1.0, 1.0));
	vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

void fragment() {
	vec2 uv = UV * 2.0;
	float t = TIME * flow_speed;

	// 🔹 Patrón del laberinto tipo cuadrícula
	vec2 grid = abs(fract(uv * line_density - 0.5) - 0.5) / fwidth(uv * line_density);
	float maze = 1.0 - min(min(grid.x, grid.y), 1.0);
	
	// 🔹 Flujo energético (como el shader anterior)
	float flow = sin(uv.x * 10.0 + t * 3.0) * 0.5 + 0.5;
	float data_flow = smoothstep(0.3, 0.8, flow);

	// 🔹 Corrupción IA (como una infección que distorsiona el color)
	float corruption_wave = noise(uv * 3.0 + vec2(TIME * damage_speed, -TIME * 0.2));
	float corruption_mask = smoothstep(0.6, 1.0, corruption_wave) * corruption_intensity;

	// 🔹 Combinación de efectos
	vec3 healthy = mix(base_color, data_color, data_flow);
	vec3 corrupted = mix(healthy, corruption_color, corruption_mask);

	// 🔹 Transiciones entre zonas sanas y corruptas
	float corruption_fade = smoothstep(0.3, 0.8, corruption_wave + sin(TIME * 0.8) * 0.2);
	vec3 final_color = mix(healthy, corrupted, corruption_fade);

	// 🔹 Resultado visual
	ALBEDO = final_color * maze;
	EMISSION = final_color * (0.4 + corruption_fade * 0.6);
}
