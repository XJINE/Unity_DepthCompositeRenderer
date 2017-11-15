using UnityEngine;

/// <summary>
/// Depth を使って 2 つの RenderTexture を合成します。
/// </summary>
[RequireComponent(typeof(Camera))]
[ExecuteInEditMode]
public class DepthCompositeRenderer : MonoBehaviour
{
    #region Field

    public Material material;

    public RenderTextureCameraWithDepth renderTextureCameraA;

    public RenderTextureCameraWithDepth renderTextureCameraB;

    #endregion Field

    #region Method

    public void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        this.material.SetTexture("_ColorTextureA", this.renderTextureCameraA.RenderTexture);
        this.material.SetTexture("_DepthTextureA", this.renderTextureCameraA.RenderTextureDepth);
        this.material.SetTexture("_ColorTextureB", this.renderTextureCameraB.RenderTexture);
        this.material.SetTexture("_DepthTextureB", this.renderTextureCameraB.RenderTextureDepth);

        Graphics.Blit(src, dest, this.material);
    }

    #endregion Method
}