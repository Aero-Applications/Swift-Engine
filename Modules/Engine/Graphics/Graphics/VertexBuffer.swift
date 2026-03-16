@MainActor
public class VertexBuffer<T> where T : BitwiseCopyable {
    public static func Create(vertecies: Span<T>) -> VertexBuffer {
        return DirectXVertexBuffer(vertecies: vertecies)
    }
}