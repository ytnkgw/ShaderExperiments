// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/HeatMap"
{
	Properties
	{
		_HeatTex("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "Queue"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 pos : POSITION;
			};

			struct v2f
			{
				float4 pos : POSITION;
				fixed3 worldPos : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.pos);
				o.worldPos = mul(unity_ObjectToWorld, v.pos).xyz;
				return o;
			}

			uniform int _Points_Length = 0;
			uniform float3 _Points[20]; // (x, y, z) = position
			uniform float2 _Properties[20]; // x = radius, y = intensity
			sampler2D _HeatTex;
			
			half4 frag (v2f v) : COLOR
			{
				half h = 0;
				for (int i = 0; i < _Points_Length; i++)
				{
					half di = distance(v.worldPos, _Points[i].xyz);

					half ri = _Properties[i].x;
					half hi = 1 - saturate(di / ri);

					h += hi * _Properties[i].y;
				}

				h = saturate(h);
				half4 color = tex2D(_HeatTex, fixed2(h, 0.5));
				return color;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}
