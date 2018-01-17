using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class OldFilmEffect : BaseImageEffect
{
    #region Variables
    public float oldFilmEffectAmount = 1.0f;

    public Color sepiaColor = Color.white;
    public Texture2D vignetteTexture;
    public float vignetteAmoount = 1.0f;

    public Texture2D scratchesTexture;
    public float scratchesYSpeed = 10.0f;
    public float scratchesXSpeed = 10.0f;

    public Texture2D dustTexture;
    public float dustYSpeed = 10.0f;
    public float dustXSpeed = 10.0f;

    private float randomValue;
    #endregion

    #region Propaties
    #endregion

    #region UnityLifeCycle
    private void Update()
    {
        vignetteAmoount = Mathf.Clamp01(vignetteAmoount);
        oldFilmEffectAmount = Mathf.Clamp(oldFilmEffectAmount, 0.0f, 1.5f);
        randomValue = Random.Range(-1.0f, 1.0f);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (curShader != null)
        {
            material.SetColor("_SepiaColor", sepiaColor);
            material.SetFloat("_VignetteAmount", vignetteAmoount);
            material.SetFloat("_EffectAmount", oldFilmEffectAmount);

            if (vignetteTexture)
            {
                material.SetTexture("_VignetteTex", vignetteTexture);
            }

            if (scratchesTexture)
            {
                material.SetTexture("_ScratchesTex", scratchesTexture);
                material.SetFloat("_ScratchesYSpeed", scratchesYSpeed);
                material.SetFloat("_ScratchesXSpeed", scratchesXSpeed);
            }

            if (dustTexture)
            {
                material.SetTexture("_DustTex", dustTexture);
                material.SetFloat("_dustYSpeed", dustYSpeed);
                material.SetFloat("_dustXSpeed", dustXSpeed);
                material.SetFloat("_RandomValue", randomValue);
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