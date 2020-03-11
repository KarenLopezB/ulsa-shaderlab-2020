shader "Custom/SurfaceDiffuseRampTexture"
{
    Properties
    {
        _Albedo("Albedo Color", Color)=(1,1,1,1)
        _RampTex("Ramp Texture", 2D)="white"{}

    }
    
    SubShader
    {
        Tags
        {
          "Queve"="Geometry"
          "RenderType"="Opaque"
        }

        CGPROGRAM
        #pragma surface surf Ramp
         sampler2D _RampTex;
         half4 _Albedo;      //entrada s  //direcciondeluz    atenuacion
         half4 LightingRamp(SurfaceOutput s, half3 lightDir, half atten)
         {         //canales de la superficie de un modelo
             half Ndot = dot(s.Normal, lightDir);
             half diff = Ndot * 0.5 + 0.5;  //PARA QUE SE ESNCUENTR ENTRE -1 Y 1, SIEMPRE...potencia 
             float2 uv_RampTex = float2(diff, 0);
             half3 rampColor = tex2D(_RampTex,uv_RampTex).rgb;
              half4 c;
             c.rgb = s.Albedo * _LightColor0.rgb * rampColor * atten; 
             c.a = s.Alpha; 
             return c; 
                      
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