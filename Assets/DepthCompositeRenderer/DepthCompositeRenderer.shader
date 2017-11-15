Shader "CompositeShader"
{
    Properties
    {
        _ColorTextureA("ColorTextureA", 2D) = "white" {}
        _DepthTextureA("DepthTextureB", 2D) = "white" {}
        _ColorTextureB("ColorTextureA", 2D) = "white" {}
        _DepthTextureB("DepthTextureB", 2D) = "white" {}
    }
    SubShader
    {
        Cull   Off
        ZWrite Off
        ZTest  Always

        Pass
        {
            CGPROGRAM

            #include "UnityCG.cginc"
            #pragma vertex vert_img
            #pragma fragment frag

            sampler2D _ColorTextureA;
            sampler2D _DepthTextureA;
            sampler2D _ColorTextureB;
            sampler2D _DepthTextureB;

            fixed4 frag(v2f_img input) : SV_Target
            {
                float4 colorA = tex2D(_ColorTextureA, input.uv);
                float  depthA = tex2D(_DepthTextureA, input.uv);
                float4 colorB = tex2D(_ColorTextureB, input.uv);
                float  depthB = tex2D(_DepthTextureB, input.uv);

                return depthA > depthB ? colorA : colorB;
            }

            ENDCG
        }
    }
}