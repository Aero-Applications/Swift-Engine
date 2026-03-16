import WinSDK

import Engine_Logging;
import Engine_Utilities_Windows;

@MainActor
class DirectXGraphicsAdapter {
    var dxgiAdapter: UnsafeMutablePointer<WinSDK.IDXGIAdapter>?

    init(graphicsDevice: DirectXGraphicsDevice) {
        dxgiAdapter = graphicsDevice.createIDXGIAdapter();
    }
    isolated deinit {
        _ = dxgiAdapter?.pointee.lpVtbl.pointee.Release(dxgiAdapter)
    }
    func createIDXGIFactory() -> UnsafeMutablePointer<WinSDK.IDXGIFactory>? {
        var id: GUID = WinSDK.IID_IDXGIFactory
        var pointer : UnsafeMutableRawPointer? = nil
        let result: HRESULT = dxgiAdapter?.pointee.lpVtbl.pointee.GetParent(dxgiAdapter, &id, &pointer) ?? 0
        if (WindowsUtilities.Failed(result: result)) {
            Logger.Error(function: "DirectXGraphicsDevice.createIDXGIFactory()", cause: "DirectX won't tell me", message: "Failed to create the IDXGIFactory. Maybe the IDXGIdxgiAdapter was not created successfully")
        }
        return pointer?.assumingMemoryBound(to: IDXGIFactory.self)
    }
}