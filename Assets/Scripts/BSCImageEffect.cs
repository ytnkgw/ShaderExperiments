using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BSCImageEffect : BaseImageEffect
{
    #region Variables
    public float brightnessAmount = 1.0f;
    public float saturationAmount = 1.0f;
    public float contrastAmount = 1.0f;
    #endregion

    #region Propaties
    #endregion

    private void Update()
    {
        brightnessAmount = Mathf.Clamp(brightnessAmount, 0.0f, 2.0f);
        saturationAmount = Mathf.Clamp(saturationAmount, 0.0f, 2.0f);
        contrastAmount = Mathf.Clamp(contrastAmount, 0.0f, 3.0f);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (curShader != null)
        {
            material.SetFloat("_BrightnessAmount", brightnessAmount);
            material.SetFloat("_SatAmount", saturationAmount);
            material.SetFloat("_ConAmount", contrastAmount);

            Graphics.Blit(source, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }

}
