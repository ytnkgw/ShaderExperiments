using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OverlayEffect : BaseImageEffect
{
    #region Variables
    public Texture2D blendTexture;
    public float blendOpacity = 1.0f;
    #endregion

    #region Propaties
    #endregion


    private void Update()
    {
        // To set range
        blendOpacity = Mathf.Clamp(blendOpacity, 0.0f, 1.0f);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (curShader != null)
        {
            material.SetTexture("_BlendTex", blendTexture);
            material.SetFloat("_Opacity", blendOpacity);

            Graphics.Blit(source, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}
