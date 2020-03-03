Shader "Custom/SurfaceDiffuseCombination"
{
    Properties
    {
        _Albedo("Albedo Color", Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white" {}
        _NormalTex("Normal Texture", 2D) = "bump" {}
        _NormalStrength("Normal Strength", Range(-5, 5)) = 1
        [HDR] _RimColor("Rim Color", Color) = (1,0,0,1)
        _RimPower("Rim Power", Range(0.0, 8.0)) = 1.0 
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }

        CGPROGRAM

        fixed3 _Albedo;
        sampler2D _MainTex;
        sampler2D _NormalTex;
        float _NormalStrength;
        half3 _RimColor;
        float _RimPower;

        #pragma surface surf Lambert

            struct Input
            {
                float3 viewDir;
                float2 uv_MainTex;
                float2 uv_NormalTex;
            };

            void surf (Input IN, inout SurfaceOutput o)
            {
                //half4 texColor = tex2D(_MainTex, IN.uv_MainTex);
                //o.Albedo = _Albedo * texColor.rgb;

                fixed3 texColor = tex2D(_MainTex, IN.uv_MainTex);
                o.Albedo = texColor * _Albedo;
                fixed4 normalColor = tex2D(_NormalTex, IN.uv_NormalTex);
                fixed3 normal = UnpackNormal(normalColor);
                normal.z = normal.z / _NormalStrength;
                o.Normal = normalize(normal);

                //fixed4 texColor = tex2D(_MainTex, IN.uv_MainTex);
                //o.Albedo = texColor.rgb;

                //fixed4 normalColor = tex2D(_NormalTex, IN.uv_NormalTex);
                //fixed3 normal = UnpackNormal(normalColor);
                //o.Normal = normal;
                
                float3 nVD = normalize(IN.viewDir);
                float3 NdotV = dot(nVD, o.Normal);
                half rim = 1 - saturate(NdotV);
                o.Emission = _RimColor.rgb * rim * pow(rim, _RimPower);
            }

        ENDCG
    }
}