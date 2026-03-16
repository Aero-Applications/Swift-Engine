import WinSDK

import Engine_Logging;
import Engine_Utilities_Windows;

@MainActor
class DirectXGraphicsFactory {
    var dxgiFactory: UnsafeMutablePointer<WinSDK.IDXGIFactory>?

    init(graphicsAdapter: DirectXGraphicsAdapter) {
        dxgiFactory = graphicsAdapter.createIDXGIFactory();
    }

    isolated deinit {
        _ = dxgiFactory?.pointee.lpVtbl.pointee.Release(dxgiFactory)
    }
    func CreateSwapChain(device : DirectXDevice, description: inout WinSDK.DXGI_SWAP_CHAIN_DESC, swapChain: inout UnsafeMutablePointer<WinSDK.IDXGISwapChain>?) -> HRESULT {
        var result : HRESULT = 0
        device.d3dDevice?.withMemoryRebound(to: IUnknown.self, capacity: 1) { d3dDevice in
            result = dxgiFactory?.pointee.lpVtbl.pointee.CreateSwapChain(dxgiFactory, d3dDevice, &description, &swapChain) ?? 0 
        }
        return result
    }
}