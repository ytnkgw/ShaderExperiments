Shader "CookbookShaders/GlassEffect"
{
	Properties
	{
		_MainColor("Color", Color) = (1, 1, 1, 1)
		_MainTex("Base (RGB) Trans (A)", 2D) = "white" {}
		_BumpMap("Noise texture", 2D) = "bump" {}
		_Magnitude("Magnitude", Range(0, 1)) = 0.05
	}
	SubShader
	{
		Tags { "Queue" = "Transparent" "IngnoreProjecttor" = "True" "RenderType" = "Opaque" }
		LOD 100

		GrabPass {}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _GrabTexture;

			float4 _MainColor;
			sampler2D _MainTex;
			sampler2D _BumpMap;
			float _Magnitude;
			
			struct vertInput
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct vertOutput
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float4 uvgrab : TEXCOORD1;
			};
			
			vertOutput vert (vertInput v)
			{
				vertOutput o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				o.uvgrab = ComputeGrabScreenPos(o.vertex);
				return o;
			}
			
			// frag functino
			half4 frag(vertOutput i) : COLOR
			{
				half4 mainColour = tex2D(_MainTex, i.texcoord);

				half4 bump = tex2D(_BumpMap, i.texcoord);
				half2 distortion = UnpackNormal(bump).rg;

				i.uvgrab.xy += distortion * _Magnitude;

				fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
				return col * _MainColor;
			}
			ENDCG
		}
	}
}
