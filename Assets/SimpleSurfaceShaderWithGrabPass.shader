Shader "Custom/SimpleSurfaceShaderWithGrabPass"
{
    Properties
    {
        _Color      ("Color",        Color     ) = (1,1,1,1)
        _MainTex    ("Albedo (RGB)", 2D        ) = "white" {}
        _Glossiness ("Smoothness",   Range(0,1)) = 0.5
        _Metallic   ("Metallic",     Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Transparent+1"
        }
        GrabPass
        {
            "_GrabTex"
        }

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows vertex:vert
        #pragma target 3.0

        // CAUTION:
        // The variable names starting with 'uv' are processed specially by Unity.
        // This can cause inexplicable errors.
        // For example, if you name a variable 'uv_GrabTex' in the format of 'uv_MainTex', the error will occur.

        struct Input
        {
            float2 mainUV : TEXCOORD0;
            float4 grabUV : TEXCOORD1;
        };

        sampler2D _MainTex;
        sampler2D _GrabTex;

        float4 _Color;
        float  _Glossiness;
        float  _Metallic;

        void vert(inout appdata_full v, out Input o)
        {
            o.mainUV = v.texcoord;
            o.grabUV = ComputeGrabScreenPos(UnityObjectToClipPos(v.vertex));
        }

        void surf (Input i, inout SurfaceOutputStandard o)
        {
            float4 color     = tex2D    (_MainTex, i.mainUV) * _Color;
            float4 colorGrab = tex2Dproj(_GrabTex, i.grabUV);

            o.Albedo     = colorGrab;
            o.Metallic   = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha      = color.a;
        }

        ENDCG
    }

    FallBack "Diffuse"
}