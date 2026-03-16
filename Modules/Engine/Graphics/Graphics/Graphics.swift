import Engine_Platform;
import Engine_Math;

@MainActor
public enum Graphics {
    internal static var ClearCallback: (Float, Float, Float, Float) -> Void = { red, green, blue, alpha in }
    internal static var SetShaderCallback: (Shader) -> Void = { shader in }
    internal static var UploadShaderBufferCallback: (ShaderBuffer) -> Void = { buffer in }
    internal static var SetViewportCallback: (Rect) -> Void = { rect in }
    internal static var SwapBuffersCallback: () -> Void = { }
    internal static var CreateWindowContextCallback: () -> WindowContext = { return WindowContext( userData: nil, initialize: { window, width, height in }, resize: { window, width, height in } ) }

    public static func Initialize(api: Int) {
        DirectXGraphics.OnInitialize()
    }
    public static func Shutdown() {
        DirectXGraphics.OnShutdown()
    }
    public static func SetShader(shader: Shader) {
        SetShaderCallback(shader)
    }
    public static func UploadShaderBuffer(data: ShaderBuffer) {
        UploadShaderBufferCallback(data)
    }
    public static func SetViewport(size: Rect) {
        SetViewportCallback(size)
    }
    public static func Clear(red : Float, green : Float, blue : Float, alpha : Float) {
        ClearCallback(red, green, blue, alpha)
    }
    public static func SwapBuffers() {
        SwapBuffersCallback()
    }
    public static func CreateWindowContext() -> WindowContext {
        return CreateWindowContextCallback()
    }
}
