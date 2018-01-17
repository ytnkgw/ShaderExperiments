Shader "Hidden/NightVisionEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_VignetteTex("Vignette Texture", 2D) = "white" {}
		_ScanLineTex("Scan Line Texture", 2D) = "white" {}
		_NoiseTex("Noise Texture", 2D) = "white" {}
		_NoiseXSpeed("Noise X Speed", Float) = 100.0
		_NoiseYSpeed("Noise Y Speed", Float) = 100.0
		_ScanLineTileAmount("Scan Line Tile Amount", Float) = 4.0
		_NightVisionColor("Night Vision Color", Color) = (1, 1, 1, 1)
		_Contrast("Contrast", Range(0, 4)) = 2
		_Brightness("Brightness", Range(0, 2)) = 1
		_RandomValue("Random Value", Float) = 0
		_distortion("Distortion", Float) = 0.2
		_scale("Scale (Zoom)", Float) = 0.8
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
			#include "Cg/MyLib.cginc"
			
			uniform sampler2D _MainTex;
			uniform sampler2D _VignetteTex;
			uniform sampler2D _ScanLineTex;
			uniform sampler2D _NoiseTex;
			fixed4 _NightVisionColor;
			fixed _Contrast;
			fixed _ScanLineTileAmount;
			fixed _Brightness;
			fixed _RandomValue;
			fixed _NoiseXSpeed;
			fixed _NoiseYSpeed;
			fixed _distortion;
			fixed _scale;

			fixed4 frag (v2f_img i) : COLOR
			{
				// Get render texture
				half2 distortedUV = barrelDistortion(i.uv, _distortion, _scale);
				fixed4 renderTex = tex2D(_MainTex, distortedUV);
				fixed4 vignetteTex = tex2D(_VignetteTex, i.uv);

				// Get scan line
				half2 scanLinesUV = half2(
					i.uv.x * _ScanLineTileAmount,
					i.uv.y * _ScanLineTileAmount);
				fixed4 scanLineTex = tex2D(_ScanLineTex, scanLinesUV);

				// Get noise texture
				half2 noiseUV = half2(
					i.uv.x + (_RandomValue * _SinTime.z * _NoiseXSpeed),
					i.uv.y + (_RandomValue * _SinTime.z * _NoiseYSpeed));
				fixed4 noiseTex = tex2D(_NoiseTex, noiseUV);

				// Get luminosity
				fixed lum = dot(fixed3(0.299, 0.587, 0.114), renderTex.rgb);
				lum += _Brightness;

				// Conbine all the layers
				//fixed4 finalColor = (lum * 2) + _NightVisionColor;
				fixed4 finalColor = (lum * 2) * _NightVisionColor;
				finalColor = pow(finalColor, _Contrast);
				finalColor *= vignetteTex;
				finalColor *= scanLineTex * noiseTex;

				return finalColor;
			}
			ENDCG
		}
	}
}
