import WinSDK.DirectX

import Engine_Logging;
import Engine_Utilities_Windows;

@MainActor
class DirectXGraphics3D {
    
    static func OnInitialize() -> Void { 
        Graphics3D.RenderMeshCallback = Self.RenderMesh;
    }   

    static func OnShutdown()-> Void {

    }

    static func RenderMesh(mesh: Mesh) {
        let dxVertexBuffer: DirectXVertexBuffer<Mesh.Vertex> = mesh.vertecies as! DirectXVertexBuffer;
        var vertexStride: UINT = UINT(MemoryLayout<Mesh.Vertex>.stride);
        var vertexBuffer: UnsafeMutablePointer<ID3D11Buffer>? = dxVertexBuffer.buffer;
        var vertexOffset: UINT = 0;

        let dxIndexBuffer: DirectXIndexBuffer = mesh.indecies as! DirectXIndexBuffer;
        let indexBuffer: UnsafeMutablePointer<ID3D11Buffer>? = dxIndexBuffer.buffer;

        DirectXGraphics.context.IASetVertexBuffers(startSlot: 0, numBuffers: 1, vertexBuffers: &vertexBuffer, strides: &vertexStride, offsets: &vertexOffset);
        DirectXGraphics.context.IASetIndexBuffer(indexBuffer: indexBuffer, format: DXGI_FORMAT_R32_UINT, offset: 0);
        DirectXGraphics.context.IASetPrimitiveTopology(topology: WinSDK.D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
        DirectXGraphics.context.DrawIndexed(indexCount: dxIndexBuffer.indexCount, startIndexLocation: 0, baseVertexLocation: 0);
    }
}