﻿Shader "CookbookShaders/StandardDiffuse3" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_Specular ("Specular", Color) = (1,1,1,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		struct Input {
			float2 uv_MainTex;
		};
		fixed4 _Color;
		fixed4 _Specular;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		// Speclar setting
		void surf(Input IN, inout SurfaceOutputStandard o) {
			o.Alpha = _Color.rgb;
			//o.Specular = _Specular.rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
