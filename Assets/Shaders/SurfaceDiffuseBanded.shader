shader "Custom/SurfaceDiffuseBunded"
{
    Properties
    {
        _Albedo("Albedo Color", Color) = (1,1,1,1)
        _Steps("Steps", Range(0.0, 100.0)) = 20
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType"="Opaque"
        }

        CGPROGRAM

        #pragma surface surf Banded

        half4 _Albedo;
        half _Steps;
        half _Buffer = 256;

        half4 LightingBanded(SurfaceOutput s, half3 lightDir, half atten)
        {
            half NdotL = max(0, dot(s.Normal, lightDir));
            half lightBandsMultiplier = _Steps/256;
            half lightBandsAdditive = _Steps/2;  
            fixed bandedDiff = floor((NdotL * 256 + lightBandsAdditive) / _Steps) * lightBandsMultiplier;

            half4 c;
            c.rgb = bandedDiff * s.Albedo * _LightColor0.rgb * atten;
            c.a = s.Alpha;
            
            return c;

            //half3 lightingModel = bandedNdotL * diffuseColor;
            //float attenuation = LIGHT_ATTENUATION(i);
            //float3 attenColor = attenuation * _LightColor0.rgb;
            //float4 finalDiffuse = float4(lightingModel * attenColor,1);
            //return finalDiffuse;
        }

        struct Input
        {
            float a;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Albedo.rgb;
        }


        ENDCG
    }
}
