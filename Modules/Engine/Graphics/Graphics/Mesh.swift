import Engine_Math;

@MainActor
public class Mesh {
    public struct Vertex : BitwiseCopyable { 
        public let x : Float32, y : Float32, z : Float32 
        public init(_ vec: Vec3) {
            self.x = vec.x; self.y = vec.y; self.z = vec.z;
        }
    }
    let vertecies: VertexBuffer<Vertex>
    let indecies: IndexBuffer 

    public init(vertecies: Span<Vertex>, indecies: Span<UInt32>) {
        self.vertecies = VertexBuffer.Create(vertecies: vertecies)
        self.indecies = IndexBuffer.Create(indecies: indecies)
    }
}