#ifndef MY_CG_INCLUDE
#define MY_CG_INCLUDE

fixed4 _MyColor;

inline fixed4 LightingHalfLambert(SurfaceOutput s, fixed3 lightDir, fixed atten)
{
    fixed diff = max(0, dot(s.Normal, lightDir));
    diff = (diff + 0.5) * 0.5;

    fixed4 c;
    c.rgb = s.Albedo * _LightColor0.rgb * ((diff * _MyColor.rgb) * atten);
    c.a = s.Alpha;
    return c;
}

// Get lens distortion UV
// See http://www.ssontech.com/content/lensalg.htm
float2 barrelDistortion(float2 coord, fixed distortion, fixed scale)
{
	float2 h = coord.xy - float2(0.5, 0.5);
	float r2 = h.x * h.x + h.y * h.y;
	float f = 1.0 + r2 * (distortion * sqrt(r2));

    return f * scale * h + 0.5;
}

#endif

