Shader "CookbookShaders/ToonSample" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_CelShadingLevels("Cel Shading Level", Float) = 0
		_RampTex("Ramp", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf CustomLambert //Toon

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _RampTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		half _CelShadingLevels;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		// Custom LightingFunction Lambert
		half4 LightingSimpleLambert(SurfaceOutput s, half3 lightDir, half atten) {
			half NdotL = dot(s.Normal, lightDir);
			half4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten * 1);
			c.a = s.Alpha;
			return c;
		}

		// Toon lighting model
		fixed4 LightingToon(SurfaceOutput s, fixed3 lightDir, fixed atten) {
			half NdotL = dot(s.Normal, lightDir);
			NdotL = tex2D(_RampTex, fixed2(NdotL, 0.5));

			fixed4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * NdotL * atten;
			c.a = s.Alpha;

			return c;
		}

		half4 LightingCustomLambert(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
			half NdotL = dot(s.Normal, lightDir);
			half cel = floor(NdotL * _CelShadingLevels) / (_CelShadingLevels - 0.5);

			half4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * cel * atten;
			c.a = s.Alpha;

			return c;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = _Color.rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
