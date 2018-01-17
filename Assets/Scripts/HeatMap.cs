using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HeatMap : MonoBehaviour
{
    public Vector3[] positions;
    public float[] radiuses;
    public float[] intensities;
    public Material material;

    private void Start()
    {
        material.SetInt("_Points_Length", positions.Length);
        for (int i = 0; i < positions.Length; i++)
        {
            material.SetVector("_Points" + i.ToString(), positions[i]);
            Vector2 property = new Vector2(radiuses[i], intensities[i]);
            material.SetVector("_Properties" + i.ToString(), property);
        }
    }

    private void OnDisable()
    {
        for (int i = 0; i < positions.Length; i++)
        {
            Debug.Log(material.GetVector("_Properties" + i.ToString()));
            //material.SetVector("_Points" + i.ToString(), positions[i]);
            //Vector2 property = new Vector2(radiuses[i], intensities[i]);
            //material.SetVector("_Properties" + i.ToString(), property);
        }
    }
}
