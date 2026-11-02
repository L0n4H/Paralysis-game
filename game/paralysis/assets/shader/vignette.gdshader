shader_type canvas_item;

// Variable de stress transmise depuis GDScript (de 0.0 à 100.0)
uniform float stress : hint_range(0.0, 100.0) = 0.0;
uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

// Rayons d'assombrissement
uniform float max_radius : hint_range(0.0, 2.0) = 0.8;  // Vision normale au calme
uniform float min_radius : hint_range(0.0, 2.0) = 0.25; // Vision très restreinte en panique
uniform float softness : hint_range(0.01, 1.0) = 0.45;  // Fondu du dégradé

void fragment() {
    // Calcul de la distance de chaque pixel par rapport au centre de l'écran
    vec2 uv = UV - vec2(0.5);
    float dist = length(uv);

    // Conversion du stress (0-100) en un facteur de 0.0 à 1.0
    float stress_factor = stress / 100.0;

    // Réduction du rayon de vision plus le stress augmente
    float radius = mix(max_radius, min_radius, stress_factor);

    // Application du dégradé doux sur les bords
    float alpha = smoothstep(radius - softness, radius + softness, dist);

    COLOR = vec4(vignette_color.rgb, alpha * vignette_color.a);
}