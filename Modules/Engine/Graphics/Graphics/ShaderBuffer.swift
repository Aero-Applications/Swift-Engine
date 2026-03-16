import Engine_Utilities;
import Engine_Logging;

@MainActor
open class ShaderBuffer {
    let size: Int;

    internal init(size: Int) {
        self.size = size
    }

    public static func Create<T>(data: T) -> ShaderBuffer {
        return DirectXConstantBuffer(data: data)
    }
    public static func Create<T>(_ unused : EmptyGenericType<T>? = nil) -> ShaderBuffer {
        return DirectXConstantBuffer(unused)
    }
    
    public func update<T>(data: T) {
        Logger.Error(function: "ShaderBuffer.update<T>(data: T)", cause: "was not implemented by the current graphics api");
    }

}