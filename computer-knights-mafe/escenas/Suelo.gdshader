shader_type spatial;
render_mode cull_disabled;

// 🎨 Colores y estilo
uniform vec3 base_color : source_color = vec3(0.0, 0.02, 0.04);  // fondo oscuro
uniform vec3 data_color : source_color = vec3(0.0, 0.5, 0.9);    // flujo corrompido
uniform float emission_strength = 0.5;

// ⚙️ Control de flujo
uniform float line_density = 60.0;
uniform float line_thickness = 0.015;
uniform float flow_speed = 0.008;        // movimiento muy lento
uniform float wave_amplitude = 0.03;     // amplitud de ondas corruptas
uniform float wave_frequency = 6.0;      // frecuencia de ondas
uniform float flicker_intensity = 0.06;  // parpadeo tenue
uniform float corruption_speed = 0.5;    // controla la propagación de corrupción

// 🖤 Textura del laberinto (blanco = pared, negro = pasillo)
uniform sampler2D maze_texture;

// Función aleatoria
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// Ruido tipo corrupción
float corruption(vec2 st) {
    return sin(st.x*10.0 + st.y*15.0 + TIME*corruption_speed) * 0.5;
}

void fragment() {
    vec2 uv = UV;

    // Leer textura del laberinto
    float maze_mask = texture(maze_texture, uv).r; // 1 = pared, 0 = pasillo
    float mask = 1.0 - maze_mask; // 1 = pasillo

    // Distorsión de flujo corrupto
    float wave = sin(uv.x * wave_frequency + TIME * flow_speed) * wave_amplitude;
    uv.y += wave;

    // Corrupción aleatoria que afecta horizontalmente
    uv.x += corruption(uv) * 0.02;

    // Patrón de líneas
    float lines = smoothstep(0.0, line_thickness, fract(uv.y * line_density));

    // Parpadeo sutil tipo “vida corrupta”
    float flicker = (0.5 + 0.5*sin(TIME*3.0 + random(floor(uv*30.0))*6.28)) * flicker_intensity;

    // Fragmentos que se desvanecen y reaparecen
    float vanish = step(0.4, fract(TIME*0.7 + uv.x*10.0 + uv.y*15.0));
    lines *= vanish;

    // Aplicar máscara del laberinto
    lines *= mask;

    // Color final
    vec3 color = mix(base_color, data_color, lines + flicker);
    
    ALBEDO = color;
    EMISSION = color * emission_strength * (lines + flicker);
}
