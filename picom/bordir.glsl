#version 330

in vec2 texcoord;
uniform sampler2D tex;
uniform float corner_radius;
uniform float time;

// vec4 border_color = vec4(0.0, 1.0, 0.0, 1.0);
vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec4 default_post_processing(vec4 c);

float distance_to_rounded_corner(vec2 tex_coord, vec2 tex_size, float radius) {
    vec2 corner_distance = min(abs(tex_coord), abs(tex_size - 1 - tex_coord));
    return min(corner_distance.x, corner_distance.y);
    return length(max(corner_distance - vec2(radius), vec2(0)));
}

float roundedRectDist(vec2 p, vec2 size, float radius) {
    // Adjust the point relative to the rounded rectangle
    vec2 q = vec2(abs(p.x - max(-size.x + radius, min(p.x, -radius))),
            abs(p.y - max(-size.y + radius, min(p.y, -radius))));

    // Compute the distance from the rounded edge
    return length(q) - radius;
}

// Returns the signed distance from pos to a rounded rectangle.
// 'pos' is a vec2 position (in pixels), where (0,0) is the top right corner.
// 'size' is a vec2 giving the full dimensions of the rectangle.
// 'r' is the border radius (in pixels).
float roundedRectSDF(vec2 pos, vec2 size, float r) {
    // Compute the center of the rectangle. Since the top-right corner is (0,0),
    // the rectangle extends from (-size.x, size.y) (bottom-left) to (0,0) (top-right).
    // Thus the center is at (-size.x/2, size.y/2).
    vec2 center = vec2(-size.x * 0.5, size.y * 0.5);

    // Shift the coordinate system so that the rectangle is centered at (0,0)
    vec2 p = pos - center;

    // Half-extents of the rectangle.
    vec2 b = size * 0.5;

    // The standard method for a rounded rectangle SDF:
    // 1. Compute q = abs(p) - b + vec2(r). This effectively shrinks the box by r.
    // 2. For points outside the box, add the distance from the point to the box.
    // 3. For points inside, we take the maximum of the two components (which will be negative).
    vec2 q = abs(p) - b + vec2(r);

    // The distance is the sum of the Euclidean distance outside the box
    // and the inside offset (if any), then subtract r.
    return length(max(q, vec2(0.0))) + min(max(q.x, q.y), 0.0) - r;
}

float distanceToRoundedRect(vec2 position, vec2 size, float radius) {
    // Translate position to the rectangle's local coordinate system (centered)
    vec2 center = vec2(-size.x * 0.5, size.y * 0.5);
    vec2 q = position - center;
    vec2 halfSize = size * 0.5;

    // Calculate signed distance to rounded rectangle
    vec2 d = abs(q) - halfSize + radius;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0) - radius;
}

vec4 add_rounded_corners(
    vec4 win_color,
    vec2 tex_coord,
    vec2 tex_size,
    float radius,
    float thickness
) {
    // radius += 5;

    vec4 border_color = vec4(hsv2rgb(vec3(
                    fract(time * 0.001 + dot(tex_coord / vec2(1920, 1080), vec2(1))),
                    1., 1.
                )), 1);

    // If we're far from corners, we just pass window texels through
    vec2 corner_distance = min(abs(tex_coord), abs(tex_size - 1 - tex_coord));

    // return vec4(vec3(distanceToRoundedRect(tex_coord, tex_size, radius)), 1);

    if (any(greaterThan(corner_distance, vec2(radius)))) {
        // return win_color;
        if (
            any(lessThan(tex_coord, vec2(thickness, thickness)))
                || any(greaterThan(tex_coord, tex_size - vec2(thickness)))
        ) {
            return border_color;
        }
        else {
            // return mix(win_color, border_color, 0.5);
            return win_color;
        }
    }

    // Distance from the closest arc center
    vec2 center_distance = min(
            abs(vec2(radius) - tex_coord),
            abs(vec2(tex_size - radius) - tex_coord)
        );

    // Do some simple anti-aliasing
    float inner_radius = radius - thickness;
    float feather = 1 / inner_radius;
    float r = length(center_distance) / inner_radius;
    float blend = smoothstep(1, 1 + feather, r);

    // vec4 border_color = texture2D(tex, vec2(0), 0);
    return mix(win_color, border_color, blend);
}

vec4 window_shader()
{
    vec2 tex_size = textureSize(tex, 0);
    vec4 c = texture2D(tex, texcoord / tex_size, 0);
    vec4 with_corners = add_rounded_corners(c, texcoord, tex_size, corner_radius, 2);
    // vec4 with_corners = add_rectangle_border(c, texcoord, tex_size, 4);
    return default_post_processing(with_corners);
}
