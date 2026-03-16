import WinSDK.DirectX

import Engine_Logging;
import Engine_Utilities_Windows;

@MainActor
class DirectXIndexBuffer : IndexBuffer {

    var buffer: UnsafeMutablePointer<ID3D11Buffer>!
    let indexCount: UINT;

    init(indecies: Span<UInt32>) {
        self.indexCount = UINT(indecies.count);
        self.buffer = nil

        var buffDesc: D3D11_BUFFER_DESC = WinSDK.D3D11_BUFFER_DESC()
            buffDesc.ByteWidth = self.indexCount * UINT(MemoryLayout<UInt32>.stride)
            buffDesc.BindFlags = UInt32(WinSDK.D3D11_BIND_INDEX_BUFFER.rawValue)
        
        let ptr: UnsafeRawPointer? = indecies.withUnsafeBytes { ptr in return ptr.baseAddress}

        var initData: D3D11_SUBRESOURCE_DATA = D3D11_SUBRESOURCE_DATA();
            initData.pSysMem = ptr

        let d3dDevice: DirectXDevice = DirectXGraphics.d3dDevice;
        let result: HRESULT = d3dDevice.CreateBuffer(desc: &buffDesc, subResourceData: &initData, buffer: &self.buffer)
        if (WindowsUtilities.Failed(result: result)) {
            Logger.Error(function: "DirectXIndexBuffer.init(vertecies: [T])", cause: "d3dDevice.CreateBuffer() failed")
        }
    
    }

    isolated deinit {
        _ = buffer.pointee.lpVtbl.pointee.Release(buffer);
    }
}