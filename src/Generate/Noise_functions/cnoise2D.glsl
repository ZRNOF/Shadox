// ref: https://github.com/stegu/webgl-noise/blob/master/src/classicnoise2D.glsl

/*
	GLSL textureless classic 2D noise "cnoise".
	Author:  Stefan Gustavson (stefan.gustavson@liu.se)
	Version: 2011-08-22

	Many thanks to Ian McEwan of Ashima Arts for the
	ideas for permutation and gradient selection.

	Copyright (c) 2011 Stefan Gustavson. All rights reserved.
	Distributed under the MIT license. See LICENSE file.
	https://github.com/stegu/webgl-noise

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

float cnoise(vec2 P) {
	vec4 Pi = floor(P.xyxy)+vec4(0.0, 0.0, 1.0, 1.0);
	vec4 Pf = fract(P.xyxy)-vec4(0.0, 0.0, 1.0, 1.0);
	Pi = mod289(Pi);
	vec4 ix = Pi.xzxz;
	vec4 iy = Pi.yyww;
	vec4 fx = Pf.xzxz;
	vec4 fy = Pf.yyww;

	vec4 i = permute(permute(ix)+iy);

	vec4 gx = fract(i*(1.0/41.0))*2.0-1.0;
	vec4 gy = abs(gx)-0.5;
	vec4 tx = floor(gx+0.5);
	gx = gx-tx;

	vec2 g00 = vec2(gx.x, gy.x);
	vec2 g10 = vec2(gx.y, gy.y);
	vec2 g01 = vec2(gx.z, gy.z);
	vec2 g11 = vec2(gx.w, gy.w);

	vec4 norm = taylorInvSqrt(vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
	g00 *= norm.x;
	g01 *= norm.y;
	g10 *= norm.z;
	g11 *= norm.w;

	float n00 = dot(g00, vec2(fx.x, fy.x));
	float n10 = dot(g10, vec2(fx.y, fy.y));
	float n01 = dot(g01, vec2(fx.z, fy.z));
	float n11 = dot(g11, vec2(fx.w, fy.w));

	vec2 fade_xy = fade(Pf.xy);
	vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
	float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
	return 2.3*n_xy;
}

float pnoise(vec2 P, vec2 rep) {
	vec4 Pi = floor(P.xyxy)+vec4(0.0, 0.0, 1.0, 1.0);
	vec4 Pf = fract(P.xyxy)-vec4(0.0, 0.0, 1.0, 1.0);
	Pi = mod(Pi, rep.xyxy);
	Pi = mod289(Pi);
	vec4 ix = Pi.xzxz;
	vec4 iy = Pi.yyww;
	vec4 fx = Pf.xzxz;
	vec4 fy = Pf.yyww;

	vec4 i = permute(permute(ix)+iy);

	vec4 gx = fract(i*(1.0/41.0))*2.0-1.0;
	vec4 gy = abs(gx)-0.5;
	vec4 tx = floor(gx+0.5);
	gx = gx-tx;

	vec2 g00 = vec2(gx.x, gy.x);
	vec2 g10 = vec2(gx.y, gy.y);
	vec2 g01 = vec2(gx.z, gy.z);
	vec2 g11 = vec2(gx.w, gy.w);

	vec4 norm = taylorInvSqrt(vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
	g00 *= norm.x;
	g01 *= norm.y;
	g10 *= norm.z;
	g11 *= norm.w;

	float n00 = dot(g00, vec2(fx.x, fy.x));
	float n10 = dot(g10, vec2(fx.y, fy.y));
	float n01 = dot(g01, vec2(fx.z, fy.z));
	float n11 = dot(g11, vec2(fx.w, fy.w));

	vec2 fade_xy = fade(Pf.xy);
	vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
	float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
	return 2.3*n_xy;
}
