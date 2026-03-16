import WinSDK

import Engine_Logging;
import Engine_Utilities_Windows;

@MainActor
class DirectXGraphicsDevice {
    var dxgiDevice: UnsafeMutablePointer<WinSDK.IDXGIDevice>?

    init(directXDevice: DirectXDevice) {
        dxgiDevice = directXDevice.createIDXGIDevice()
    }
    isolated deinit {
        _ = dxgiDevice?.pointee.lpVtbl.pointee.Release(dxgiDevice)
    }

    func createIDXGIAdapter() -> UnsafeMutablePointer<IDXGIAdapter>? {
        var pointer: UnsafeMutableRawPointer? = nil
        var id: GUID = IID_IDXGIAdapter
        let result: HRESULT = dxgiDevice?.pointee.lpVtbl.pointee.GetParent(dxgiDevice, &id, &pointer) ?? 0
        if (WindowsUtilities.Failed(result: result)) {
            Logger.Error(function: "DirectXGraphicsDevice.createIDXGIAdapter()", cause: "DirectX won't tell me", message: "Failed to create the IDXGIAdapter. Maybe the IDXGIDevice was not created successfully")
        }
        return pointer?.assumingMemoryBound(to: WinSDK.IDXGIAdapter.self)
    }
}