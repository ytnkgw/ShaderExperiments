Shader "CookbookShaders/MobileFriendly" {
	Properties {
		_MainTex("Base (RGB)", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf SimpleLambert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _NormalMap;

		struct Input {
			float2 uv_MainTex;
			float2 uv_NormalMap;
		};

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		inline float4 LightingSimpleLambert(SurfaceOutput s, float3 lightDir, float atten) {
			float diff = max(0, dot(s.Normal, lightDir));

			float4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * (diff * atten * 2);
			c.a = s.Alpha;
			return c;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			float4 c = tex2D(_MainTex, IN.uv_MainTex);

			o.Albedo = c.rgb;
			o.Alpha = c.a;
			o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
		}
		ENDCG
	}
	FallBack "Diffuse"
}
