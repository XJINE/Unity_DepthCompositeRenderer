Shader "CompositeShader"
{
    Properties
    {
        _ColorTextureA("ColorTextureA", 2D) = "white" {}
        _DepthTextureA("DepthTextureB", 2D) = "white" {}
        _ColorTextureB("ColorTextureA", 2D) = "white" {}
        _DepthTextureB("DepthTextureB", 2D) = "white" {}

        // NOTE:
        // テクスチャ B の左下からのオフセットとスケールです。
        // (x, y, width, height) で指定します。
        // (0, 0, 1, 0.6) のとき、左下の座標 (0, 0) から始まり、
        // A に対して幅 100%, 高さ 60 % のテクスチャとして合成します。
        // 一般的には (0, 0, 1, 1) の設定のままで良いです。

        _OffsetScaleB("OffsetScaleB", Vector) = (0, 0, 1, 1)
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

            float4 _OffsetScaleB;

            fixed4 frag(v2f_img input) : SV_Target
            {
                float2 bCoord = input.uv;
                bCoord.x = (bCoord.x - _OffsetScaleB.x) * (1 / _OffsetScaleB.z);
                bCoord.y = (bCoord.y - _OffsetScaleB.y) * (1 / _OffsetScaleB.w);

                float4 colorA = tex2D(_ColorTextureA, input.uv);
                float  depthA = tex2D(_DepthTextureA, input.uv);
                float4 colorB = tex2D(_ColorTextureB, bCoord.xy);
                float  depthB = tex2D(_DepthTextureB, bCoord.xy);

                return (input.uv.x < _OffsetScaleB.x)
                    || (input.uv.y < _OffsetScaleB.y)
                    || (_OffsetScaleB.x + _OffsetScaleB.z < input.uv.x)
                    || (_OffsetScaleB.y + _OffsetScaleB.w < input.uv.y) ?
                        colorA : (depthA > depthB ? colorA : colorB);
            }

            ENDCG
        }
    }
}