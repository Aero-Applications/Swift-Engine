public enum ShaderType {
    case Vertex;
    case Fragment;
}

@MainActor
public class Shader {
    public static func Create(filePath : String) -> Shader {
        return DirectXShader(filePath: filePath)
    }
}