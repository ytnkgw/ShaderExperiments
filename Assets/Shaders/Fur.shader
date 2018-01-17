Shader "Custom/Fur" {
	Properties {
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0

		_FurLength("Fur Length", Range(0.0002, 1)) = 0.25
		_Cutoff("Alpha Cutoff", Range(0, 1)) = 0.5
		_CutoffEnd("Alpha Cutoff End", Range(0, 1)) = 0.5
		_EdgeFade("Edge Fade", Range(0, 1)) = 0.4
		_Gravity("Gravity direction", Vector) = (0, 0, 1, 0)
		_GravityStrength("Gravity Strength", Range(0, 1)) = 0.25
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
		#define FUR_MULTIPLIER 0.05
		#pragma target 3.0

		fixed4 _Color;
		sampler2D _MainTex;
		half _Glossiness;
		half _Metallic;

		uniform float _FurLength;
		uniform float _Cutoff;
		uniform float _CutoffEnd;
		uniform float _EdgeFade;
		uniform fixed3 _Gravity;
		uniform fixed3 _GravityStrength;

		void vert(inout appdata_full v)
		{
			fixed3 direction = lerp(
				v.normal,
				_Gravity * _GravityStrength + v.normal * (1 - _GravityStrength),
				FUR_MULTIPLIER);
			v.vertex.xyz += direction * _FurLength * FUR_MULTIPLIER * v.color.a;
		}

		struct Input {
			float2 uv_MainTex;
			float3 viewDir;
		};

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;

			o.Alpha = step(lerp(_Cutoff, _CutoffEnd, FUR_MULTIPLIER), c.a);

			float alpha = 1 - (FUR_MULTIPLIER * FUR_MULTIPLIER);
			alpha += dot(IN.viewDir, o.Normal) - _EdgeFade;

			o.Alpha *= alpha;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
