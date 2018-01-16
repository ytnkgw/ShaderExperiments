Shader "Hidden/SceneDepthEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DepthPower("Depth Power", Range(1, 5)) = 1
	}
	SubShader
	{
		// No culling or depth
		// Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			fixed _DepthPower;
			sampler2D _CameraDepthTexture;

			fixed4 frag (v2f_img i) : COLOR
			{
				float d = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv.xy));
				d = pow(Linear01Depth(d), _DepthPower);
				
				return d;
			}
			ENDCG
		}
	}
}
