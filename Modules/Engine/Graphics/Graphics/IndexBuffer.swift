@MainActor
class IndexBuffer {
    public static func Create(indecies: Span<UInt32>) -> IndexBuffer {
        return DirectXIndexBuffer(indecies: indecies)
    }
}