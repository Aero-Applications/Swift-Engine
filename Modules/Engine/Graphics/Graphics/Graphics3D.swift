@MainActor
public class Graphics3D {
    internal static var RenderMeshCallback : (Mesh) -> Void = { mesh in };

    public static func RenderMesh(mesh: Mesh) {
        RenderMeshCallback(mesh)
    }
}