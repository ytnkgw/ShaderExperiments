using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RadiusModifier : MonoBehaviour {

    public Material radiusMaterial;
    public float radius = 1;
    public Color color = Color.white;


	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        radiusMaterial.SetVector("_Center", transform.position);
        radiusMaterial.SetFloat("_Radius", radius);
        radiusMaterial.SetColor("_RadiusColor", color);
	}
}
