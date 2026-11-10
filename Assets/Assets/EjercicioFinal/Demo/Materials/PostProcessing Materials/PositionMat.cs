using UnityEngine;

[ExecuteInEditMode]
public class PositionMat : MonoBehaviour
{
    [SerializeField] private Material targetMaterial;
    public string materialProperty;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Evaluate()
    {
        targetMaterial?.SetVector(materialProperty, transform.position);
    }
    // Update is called once per frame
    void Update()
    {
        Evaluate();
    }
}
