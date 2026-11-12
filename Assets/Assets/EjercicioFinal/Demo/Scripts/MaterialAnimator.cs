using System;
using UnityEngine;

[Serializable]
struct FloatCurve
{
    public string materialProperty;
    public AnimationCurve curve;
}


[RequireComponent(typeof(ParticleSystem))]
[ExecuteInEditMode]
public class MaterialAnimator : MonoBehaviour
{
    [SerializeField] private Material targetMaterial;

    [SerializeField] private FloatCurve[] curves;
    private ParticleSystem particles;

    private void Awake()
    {
        particles = GetComponent<ParticleSystem>();
    }

    void Evaluate()
    {
        if (curves != null)
        {
            foreach (FloatCurve curve in curves)
            {
                targetMaterial?.SetFloat(curve.materialProperty, curve.curve.Evaluate(particles.time));
            }
        }
        
    }
    // Update is called once per frame
    void Update()
    {
        Evaluate();
    }
}
