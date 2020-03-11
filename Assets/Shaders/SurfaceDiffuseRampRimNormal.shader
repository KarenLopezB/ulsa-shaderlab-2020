shader "Custom/SurfaceDiffuseRampRimNormal"
{
    Properties
    {
        _Albedo("Albedo Color", Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white" {}
        _RimPower("Rim Power", Range(0.0, 8.0)) = 1.0 
        _NormalTex("Normal Texture", 2D) = "bump" {}
        _RampTex("Ramp Texture", 2D)="white"{}
        [HDR] _RimColor("Rim Color", Color) = (1,0,0,1)

    }
    
    SubShader
    {
        Tags
        {
          "Queue"="Geometry"
          "RenderType"="Opaque"
        }

        CGPROGRAM

        #pragma surface surf Ramp

        sampler2D _RampTex;
        sampler2D _MainTex;
        sampler2D _NormalTex;
        half3 _RimColor;
        float _RimPower;
        half4 _Albedo;     
        half4 LightingRamp(SurfaceOutput s, half3 lightDir, half atten)
            {        
                half Ndot = dot(s.Normal, lightDir);
                half diff = Ndot * 0.5 + 0.5;  
                float2 uv_RampTex = float2(diff, 0);
                half3 rampColor = tex2D(_RampTex,uv_RampTex).rgb;
                half4 c;
                c.rgb = s.Albedo * _LightColor0.rgb * rampColor * atten; 
                c.a = s.Alpha; 
                return c;       
            }

        struct Input
        {
            // float a; 
            float3 viewDir;
            float2 uv_MainTex;
            float2 uv_NormalTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Albedo.rgb; 

            float3 nVD = normalize(IN.viewDir);
            float3 NdotV = dot(nVD, o.Normal);
            half rim = 1 - saturate(NdotV);
            o.Emission = _RimColor.rgb * rim * pow(rim, _RimPower);

            fixed4 texColor = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = texColor.rgb;

            fixed4 normalColor = tex2D(_NormalTex, IN.uv_NormalTex);
            fixed3 normal = UnpackNormal(normalColor);
            o.Normal = normal;
        }

        ENDCG
    }
}