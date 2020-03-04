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
            half4 _Albedo;

            #pragma surface surf Lambert

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