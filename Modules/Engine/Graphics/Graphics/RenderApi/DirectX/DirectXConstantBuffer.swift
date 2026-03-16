import WinSDK.DirectX

import Engine_Logging;
import Engine_Utilities;
import Engine_Utilities_Windows;

@MainActor
class DirectXConstantBuffer : ShaderBuffer {

    var buffer: UnsafeMutablePointer<ID3D11Buffer>!
    
    @MainActor
    init<T>(data: T) {
        var copy: T = data;
        let size: Int = MemoryLayout<T>.stride
        self.buffer = nil

        var buffDesc: D3D11_BUFFER_DESC = WinSDK.D3D11_BUFFER_DESC()
            buffDesc.ByteWidth = UINT(size)
            buffDesc.BindFlags = UInt32(WinSDK.D3D11_BIND_CONSTANT_BUFFER.rawValue)

        var initData: D3D11_SUBRESOURCE_DATA = D3D11_SUBRESOURCE_DATA();
            initData.pSysMem = withUnsafeBytes(of: &copy, { pointer in 
                return pointer.baseAddress
            })

        let d3dDevice: DirectXDevice = DirectXGraphics.d3dDevice;
        let result: HRESULT = d3dDevice.CreateBuffer(desc: &buffDesc, subResourceData: &initData, buffer: &self.buffer)
        if (WindowsUtilities.Failed(result: result)) {
            Logger.Error(function: "DirectXConstantBuffer.init(data: T)", cause: "d3dDevice.CreateBuffer() failed")
        }

        super.init(size: size)
    }
    init<T>(_ unused : EmptyGenericType<T>? = nil) {
        let size: Int = MemoryLayout<T>.stride
        self.buffer = nil

        var buffDesc: D3D11_BUFFER_DESC = WinSDK.D3D11_BUFFER_DESC()
        buffDesc.ByteWidth = UINT(size)
        buffDesc.BindFlags = UInt32(WinSDK.D3D11_BIND_CONSTANT_BUFFER.rawValue)
        buffDesc.Usage = WinSDK.D3D11_USAGE_DYNAMIC

        let d3dDevice: DirectXDevice = DirectXGraphics.d3dDevice;
        let result: HRESULT = d3dDevice.CreateBuffer(desc: &buffDesc, subResourceData: nil, buffer: &self.buffer)
        if (WindowsUtilities.Failed(result: result)) {
            Logger.Error(function: "DirectXConstantBuffer.init(data: T)", cause: "d3dDevice.CreateBuffer() failed")
        }
        
        super.init(size: size)
    }

    isolated deinit {
        _ = buffer.pointee.lpVtbl.pointee.Release(buffer);
    }

    public override func update<T>(data: T) {
        var copy = data;
        let d3dContext: DirectXDeviceContext = DirectXGraphics.d3dDevice.context;

        d3dContext.UpdateSubresource(

            destinationResource: self.buffer.withMemoryRebound(to: ID3D11Resource.self, capacity: 1, { pointer in return pointer }), 
            destinationSubresource: 0, destinationBox: nil, 

            sourceData: withUnsafePointer(to: &copy, { ptr in return ptr }),
            sourceRowPitch: UINT(self.size), sourceDepthPitch: 0
            
        );

    }

}