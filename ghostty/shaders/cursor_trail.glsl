// Cursor trail: when the cursor jumps at least MIN_JUMP_CELLS cells, draw a
// tapered streak from the old position that shrinks into the new one.
// Cursor rects are vec4(x, y, w, h) in pixels with (x, y) at the top-left
// corner and y measured from the bottom of the screen.

const float DURATION = 0.18;        // seconds for the trail to collapse
const float MIN_JUMP_CELLS = 4.0;   // ignore moves shorter than this
const float OPACITY = 0.3;  

float easeOutCubic(float t) {
    float u = 1.0 - t;
    return 1.0 - u * u * u;
}

// Distance to a segment a->b whose radius tapers from ra (at a) to rb (at b).
float sdTaperedSegment(vec2 p, vec2 a, vec2 b, float ra, float rb) {
    vec2 pa = p - a;
    vec2 ba = b - a;
    float h = clamp(dot(pa, ba) / max(dot(ba, ba), 1e-4), 0.0, 1.0);
    return length(pa - ba * h) - mix(ra, rb, h);
}

vec2 rectCenter(vec4 r) {
    return vec2(r.x + r.z * 0.5, r.y - r.w * 0.5);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    fragColor = texture(iChannel0, uv);

    vec4 cur = iCurrentCursor;
    vec4 prev = iPreviousCursor;

    // A bar/underline cursor is too thin to measure a cell width from, so fall
    // back to half the cell height (typical monospace aspect ratio).
    float cellW = cur.z > cur.w * 0.3 ? cur.z : cur.w * 0.5;
    float cellH = max(cur.w, 1.0);

    vec2 curC = rectCenter(cur);
    vec2 prevC = rectCenter(prev);
    vec2 jump = (curC - prevC) / vec2(cellW, cellH);
    if (length(jump) < MIN_JUMP_CELLS) return;

    float t = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);
    if (t >= 1.0) return;

    // Tail chases the head; the whole streak fades as it collapses.
    vec2 tail = mix(prevC, curC, easeOutCubic(t));
    float headR = cellH * 0.5;
    float tailR = cellH * 0.15;
    float d = sdTaperedSegment(fragCoord, curC, tail, headR, tailR);

    float edge = smoothstep(1.0, -1.0, d);
    float alpha = edge * OPACITY * (1.0 - t);

    vec3 color = iCurrentCursorColor.rgb;
    fragColor.rgb = mix(fragColor.rgb, color, alpha);
}
