using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class NightVisionEffect : BaseImageEffect
{

    #region Variables
    [Range(0.0f, 4.0f)]
    public float contrast = 2.0f;
    [Range(0.0f, 2.0f)]
    public float brightness = 1.0f;
    public Color nightVisionColor = Color.white;

    public Texture2D vignetteTexture;

    public Texture2D scanLineTexture;
    public float scanLineTileAmount = 4.0f;

    public Texture2D nightVisionNoise;
    public float noiseXSpeed = 100.0f;
    public float noiseYSpeed = 100.0f;

    [Range(-1.0f, 1.0f)]
    public float distortion = 0.2f;
    [Range(0.0f, 3.0f)]
    public float scale = 0.8f;

    private float randomValue = 0.0f;
    #endregion

    #region Propaties
    #endregion

    #region UnityLifeCycle
    private void Update()
    {
        randomValue = Random.Range(-1.0f, 1.0f);

        // Check shader values
        //Debug.Log("_NightVisionColor : " + material.GetColor("_NightVisionColor"));
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (curShader != null)
        {
            material.SetFloat("_Contrast", contrast);
            material.SetFloat("_Brightness", brightness);
            material.SetColor("_NightVisionColor", nightVisionColor);
            material.SetFloat("_RandomValue", randomValue);
            material.SetFloat("_distortion", distortion);
            material.SetFloat("_scale", scale);

            if (vignetteTexture)
            {
                material.SetTexture("_VignetteTex", vignetteTexture); 
            }

            if (scanLineTexture)
            {
                material.SetTexture("_ScanLineTex", scanLineTexture);
                material.SetFloat("_ScanLineTileAmount", scanLineTileAmount);
            }

            if (nightVisionNoise)
            {
                material.SetTexture("_NoiseTex", nightVisionNoise);
                material.SetFloat("_NoiseXSpeed", noiseXSpeed);
                material.SetFloat("_NoiseYSpeed", noiseYSpeed);
            }

            Graphics.Blit(source, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
    #endregion
}
