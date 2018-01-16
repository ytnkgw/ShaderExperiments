Shader "CookbookShaders/NormalMapShader" {
	Properties {
		_MainTint("Diffuse Tint", Color) = (1,1,1,1)
		_NormalTex("Normal Map", 2D) = "bump" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types // S
		#pragma surface surf Lambert 

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _NormalTex;
		float4 _MainTint;

		struct Input {
			float2 uv_NormalTex;
		};

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutput o) {
			float3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
			o.Normal = normalMap.xyz;

			// Albedo comes from a texture tinted by color
			fixed4 c = _MainTint;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
