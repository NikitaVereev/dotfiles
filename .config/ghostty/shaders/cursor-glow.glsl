// ═══════════════════════════════════════════════════════════════
// Cursor Glow — мягкое свечение и шлейф за курсором для Ghostty
// Файл: ~/.config/ghostty/shaders/cursor-glow.glsl
// ═══════════════════════════════════════════════════════════════
//
// Использование в конфиге:
//   custom-shader = ~/.config/ghostty/shaders/cursor-glow.glsl
//   custom-shader-animation = true

#define GLOW_COLOR vec3(0.76, 0.57, 0.95)

#define GLOW_RADIUS 0.005

#define GLOW_INTENSITY 0.5

#define PULSE_AMOUNT 0.15

#define PULSE_SPEED 2.5


void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;

    vec4 baseColor = texture(iChannel0, uv);

    vec2 cursorPos = iCurrentCursor.xy / iResolution.xy;

    float aspect = iResolution.x / iResolution.y;
    vec2 uvCorrected = vec2(uv.x * aspect, uv.y);
    vec2 cursorCorrected = vec2(cursorPos.x * aspect, cursorPos.y);

    float dist = distance(uvCorrected, cursorCorrected);

    float pulse = 1.0 + PULSE_AMOUNT * sin(iTime * PULSE_SPEED);

    float glow = exp(-dist * dist / (2.0 * GLOW_RADIUS * GLOW_RADIUS * pulse));
    glow *= GLOW_INTENSITY;

    float core = exp(-dist * dist / (2.0 * GLOW_RADIUS * GLOW_RADIUS * 0.1));
    core *= GLOW_INTENSITY * 0.3;

    vec3 glowColor = GLOW_COLOR * (glow + core);

    vec3 finalColor = baseColor.rgb + glowColor;

    finalColor = finalColor / (finalColor + vec3(1.0));
    finalColor = pow(finalColor, vec3(1.0 / 1.1));

    fragColor = vec4(finalColor, baseColor.a);
}

