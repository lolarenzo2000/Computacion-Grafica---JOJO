using NUnit.Framework.Internal;
using System;
using UnityEngine;
using UnityEngine.AdaptivePerformance.Provider;
using UnityEngine.Playables;
using UnityEngine.Rendering.Universal;

[Serializable]
struct Effect
{
    public GameObject assets;
    public FullScreenPassRendererFeature feature;
    public PlayableDirector director;
}

public class ChangeEffect : MonoBehaviour
{
    [SerializeField] private Effect[] effects;
    int currentEffect;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        currentEffect = 0;
        foreach (var f in effects)
        {
            DeactivatEffect(f);
            Debug.Log("Deactivated all efects");
        }
        ActivatEffect(effects[currentEffect]);

    }

    public void nextEffect()
    {
        DeactivatEffect(effects[currentEffect]);
        if (currentEffect+1 <  effects.Length)
        {
            currentEffect++;
        }
        else
        {
            currentEffect = 0;
        }
        ActivatEffect(effects[currentEffect]);
    }

    public void PrevEffect()
    {
        DeactivatEffect(effects[currentEffect]);
        if (currentEffect - 1 >= 0)
        {
            currentEffect--;
        }
        else
        {
            currentEffect = effects.Length - 1;
        }
        ActivatEffect(effects[currentEffect]);
    }

    void ActivatEffect(Effect effect)
    {
        effect.director.Play();
        effect.assets.SetActive(true);
        effect.feature.SetActive(true);        
    }

    void DeactivatEffect(Effect effect)
    {
        effect.director.Stop();
        effect.assets.SetActive(false);
        effect.feature.SetActive(false);

    }

    public void Pause()
    {        
        effects[currentEffect].director.Pause();
    }

    public void Resume()
    {
        effects[currentEffect].director.Resume();
    }
}
