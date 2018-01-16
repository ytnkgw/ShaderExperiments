Shader "Hidden/OldFilmEffect"
{
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_VignetteTex("Vignette Texture", 2D) = "white" {}
		_ScratchesTex("Scratches Texture", 2D) = "white" {}
		_DustTex("Dust Texture", 2D) = "white" {}
		_SepiaColor("Sepia Color", Color) = (1, 1, 1, 1)
		_EffectAmount("Old Film Effect Amount", Range(0, 1)) = 1.0
		_VignetteAmount("Vignette Opacity", Range(0, 1)) = 1.0
		_ScratchesYSpeed("Scratches Y Speed", Float) = 10.0 
		_ScratchesXSpeed("Scratches X Speed", Float) = 10.0
		_dustYSpeed("Dust Y Speed", Float) = 10.0
		_dustXSpeed("Dust X Speed", Float) = 10.0
		_RandomValue("Random Value", Float) = 1.0
		_Contrast("Contrast", Float) = 3.0
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _VignetteTex;
			uniform sampler2D _ScratchesTex;
			uniform sampler2D _DustTex;
			fixed4 _SepiaColor;
			fixed _EffectAmount;
			fixed _VignetteAmount;
			fixed _ScratchesYSpeed;
			fixed _ScratchesXSpeed;
			fixed _dustYSpeed;
			fixed _dustXSpeed;
			fixed _RandomValue;
			fixed _Contrast;

			fixed4 frag (v2f_img i) : COLOR
			{
				// Render Tex
				half2 distortedUV = barrelDistortion(i.uv);
				distortedUV = half2(i.uv.x, i.uv.y + (_RandomValue * _SinTime.z * 0.005));
				fixed4 renderTex = tex2D(_MainTex, i.uv);

				// Vignette tex
				fixed vignetteTex = tex2D(_VignetteTex, i.uv);

				// Scratches Tex
				half2 scratchesUV = half2(
					i.uv.x + (_RandomValue * (_SinTime.z * _ScratchesXSpeed)),
					i.uv.y + (_RandomValue * (_Time.x * _ScratchesYSpeed))
				);
				fixed4 scratchesTex = tex2D(_ScratchesTex, scratchesUV);

				// Dust Tex
				half2 dustUV = half2(
					i.uv.x + (_RandomValue * (_SinTime.z * _dustXSpeed)),
					i.uv.y + (_RandomValue * (_SinTime.z * _dustYSpeed)),
				);
				fixed4 dustTex = tex2D(_DustTex, dustUV);

				// Set Luminosity
				fixed lum = dot(fixed3(0.299, 0.587, 0.114), renderTex, rgb);

				fixed4 finalColor = lum + lerp(_SepiaColor, SepiaColor + fixed4(0.1f, 0.1f, 0.1f, 1.0f), _RandomValue);
				finalColor = pow(finalColor, _Contrast);

				// 
			}
			ENDCG
		}
	}
}