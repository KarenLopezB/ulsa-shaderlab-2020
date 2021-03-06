Shader "Custom/SurfaceDiffuseCustomLambert"
{
    Properties
    {
        _Albedo("Albedo Color", Color) = (1,1,1,1)
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }

        CGPROGRAM

            #pragma surface surf Lambert

            // Light model diffuse (Lambert)

            half4 LightingCustomLambert(SurfaceOutput s, half3 lightDir, half atten)
            {
                half NdotL = dot (s.Normal, lightDir);
                half4 c; // c porque la luz en fisica se representa con la letra c
                c.rgb = s.Albedo * _LightColor0.rgb /* .rgb porque se trae el color consigo */ * (NdotL * atten);
                c.a = s.Alpha;
                return c;
            }

            half4 _Albedo;

            struct Input
            {
                float2 uv_MainTex;
            };

            void surf (Input IN, inout SurfaceOutput o)
            {
                o.Albedo = _Albedo;
            }

        ENDCG
    }
}

// float <32 bits>, half <16 bits>, fixed <1,0>, int <64 bits>