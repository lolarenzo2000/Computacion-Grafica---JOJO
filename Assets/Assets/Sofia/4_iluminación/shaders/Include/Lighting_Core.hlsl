// tipos-------------------

//float a; // numero decimal de punto flotante 32 bits
//half b; //float a la mitad, decimal de punto flotante 16 bits


// tipos empaquetados-----------------
//vectores
//float2 a2; // vector2 de floats (32bits)
//half2 b2; // vector2 de halfs (16b)
//float3 a3;//vector3
//float4 a4;//vector4
//matrices solo matrices cuadradas hasta 4x4
//float2x2 a2x2;
//half2x2 b2x2;
//float3x3 a3x3;
//float4x4 a4x4;
//arrays
//float fArray[5];

// tipos especiales de hlsl
//Texture2D<float> red;
//StructuredBuffer<float> nombre;



//Include guard
#ifndef LIGHTING_CORE
#define LIGHTING_CORE
//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

void GetMainLight_float(float3 positionWS, out float3 directionWS, out float3 color, out float shadowAttenuation) //es necesario para unity copiar el _float depende de si se va a usar float, float2, etc
{
    #if defined(SHADERGRAPH_PREVIEW)
    directionWS = normalize(float3(1, 1, -1));
    color = 1; //pone el numero si es uno solo, en las tres componentes, asume que ese es el valor para las 3 componentes
    shadowAttenuation = 1;
    
    #else
    Light l = GetMainLight();
    directionWS = l.direction;
    color = l.color;
    shadowAttenuation = l.shadowAttenuation;
    
    
    #endif
}

void SimpleLightingAdditional_float(float2 UVSS, float3 normalWS, float3 viewDirWS, float3 positionWS, float roughness, 
                                    out float3 lit)
{
    #if defined(SHADERGRAPH_PREVIEW)
    lit=0;
   
    #else
    uint additionalLightCount = GetAdditionalLightsCount();
    
    #ifdef USE_CLUSTER_LIGHT_LOOP
    InputData inputData = (InputData)0;
    inputData.normalizedScreenSpaceUV = UVSS;
    inputData.positionWS = positionWS;
    inputData.normalWS = normalWS;
    
    #endif
    lit = 0;
    
    LIGHT_LOOP_BEGIN(additionalLightCount)

    Light light = GetAdditionalLight(lightIndex, positionWS, shadowMask:1);
    
    float lambert = max(dot(light.direction, normalWS), 0);
    
    float3 h = normalize(viewDirWS + light.direction);
    float blinnPhong = max(dot(h, normalWS), 0);
    float specularPower = lerp(200, 1, roughness);
    float specularCoefficient = pow(1 - roughness, 2);
    
    float3 diffuse = lambert * light.color * light.distanceAttenuation * light.shadowAttenuation;
    float3 specular = pow(blinnPhong, specularPower) * light.color * light.distanceAttenuation * light.shadowAttenuation;
    lit += diffuse + specular;
    
    LIGHT_LOOP_END_
    
    #endif

}

void BlinnPhongAdditional_float(float2 UVSS, float3 normalWS, float3 viewDirWS, float3 positionWS, float roughness,
                                    out float3 lit)
{
#if defined(SHADERGRAPH_PREVIEW)
    lit=0;
   
#else
    uint additionalLightCount = GetAdditionalLightsCount();
    
#ifdef USE_CLUSTER_LIGHT_LOOP
    InputData inputData = (InputData)0;
    inputData.normalizedScreenSpaceUV = UVSS;
    inputData.positionWS = positionWS;
    inputData.normalWS = normalWS;
    
#endif
    lit = 0;
    
    LIGHT_LOOP_BEGIN(additionalLightCount)

    Light light = GetAdditionalLight(lightIndex, positionWS, shadowMask:
    1);
    
    //float lambert = max(dot(light.direction, normalWS), 0);
    
    float3 h = normalize(viewDirWS + light.direction);
    float blinnPhong = max(dot(h, normalWS), 0);
    float specularPower = lerp(200, 1, roughness);
    float specularCoefficient = pow(1 - roughness, 2);
    
    //float3 diffuse = lambert * light.color * light.distanceAttenuation * light.shadowAttenuation;
    float3 specular = pow(blinnPhong, specularPower) * light.color * light.distanceAttenuation * light.shadowAttenuation;
    lit += specular;
    
    LIGHT_LOOP_END_
    
#endif

}

#endif