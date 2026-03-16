
import WinSDK.DirectX
import WinSDK

import Engine_Logging;
import Engine_Platform;
import Engine_Utilities_Windows;

struct SwapchainConfig {
    let window : Window
    let width : Float
    let height : Float
}

@MainActor
class DirectXSwapChain {
    var swapChain : UnsafeMutablePointer<WinSDK.IDXGISwapChain>?
    var renderTargetView : UnsafeMutablePointer<ID3D11RenderTargetView>?
    var depthStencilView : UnsafeMutablePointer<ID3D11DepthStencilView>?

    init() {
        self.swapChain = nil
        self.renderTargetView = nil
        self.depthStencilView = nil
    }

    func initialize(config : SwapchainConfig) {


        let d3dDevice: DirectXDevice = DirectXGraphics.d3dDevice;
        let d3dWindow: WindowsWindow = config.window as! WindowsWindow
        let handle: HWND? = d3dWindow.handle

        print("Creating the DirectXSwapChain for window \(handle!)")

        var description: WinSDK.DXGI_SWAP_CHAIN_DESC = WinSDK.DXGI_SWAP_CHAIN_DESC()
        memset(&description, 0, MemoryLayout.size(ofValue: description))
        description.BufferCount = 1;
        description.BufferDesc.Width = UINT(config.width)
        description.BufferDesc.Height = UINT(config.height)
        description.BufferDesc.Format = WinSDK.DXGI_FORMAT_R8G8B8A8_UNORM
        description.BufferDesc.RefreshRate.Numerator = 60
        description.BufferDesc.RefreshRate.Denominator = 1
        description.BufferUsage = WinSDK.DXGI_USAGE_RENDER_TARGET_OUTPUT
        description.OutputWindow = handle
        description.SampleDesc.Count = 1
        description.SampleDesc.Quality = 0
        description.Windowed = true

        let result: HRESULT = DirectXGraphics.dxgiFactory.CreateSwapChain(device: d3dDevice, description: &description, swapChain: &swapChain)
        
        if (WindowsUtilities.Failed(result: result)) {
            Logger.Error(function: "DirectXSwapChain.init()", cause: "Windows failed to create the swap chain, I don't know why")
        }
    

        reloadBuffers(width: config.width, height: config.height)
    }

    isolated deinit {
        _ = swapChain?.pointee.lpVtbl.pointee.Release(swapChain)
    }

    func reloadBuffers(width : Float, height : Float) {
        print("Setting swap chain width to: '\(width)' and it's height to: '\(height)'")
        let device: DirectXDevice = DirectXGraphics.d3dDevice

        var buffer : UnsafeMutablePointer<WinSDK.ID3D11Texture2D>?
        defer {
            _ = buffer?.pointee.lpVtbl.pointee.Release(buffer)
        }
        var result : WinSDK.HRESULT = 0;
        do { // get the back buffer
            var id: GUID = WinSDK.IID_ID3D11Texture2D
            var pointer : UnsafeMutableRawPointer? = nil
            result = self.swapChain?.pointee.lpVtbl.pointee.GetBuffer(swapChain, 0, &id, &pointer) ?? 0
            buffer = pointer?.assumingMemoryBound(to: WinSDK.ID3D11Texture2D.self);
        }
        if (WindowsUtilities.Failed(result: result)) {
            Logger.Error(function: "reloadBuffers", cause: "Failed to load the memory buffer intended for creating the DirectX SwapChain's RenderTargetView")
        }
        do { // create a render target view of the back buffer
            buffer?.withMemoryRebound(to: WinSDK.ID3D11Resource.self, capacity: 1) {buffer in
                result = device.CreateRenderTargetView(buffer: buffer, description: nil, renderTargetView: &self.renderTargetView)
            }
        }
        do { // create a texture for the depth stencil view back buffer
            var description: WinSDK.D3D11_TEXTURE2D_DESC = WinSDK.D3D11_TEXTURE2D_DESC();
            memset(&description, 0, MemoryLayout<WinSDK.D3D11_TEXTURE2D_DESC>.stride)

            description.Width = width > 0 ? UInt32(width) : 1
            description.Height = height > 0 ? UInt32(height) : 1
            description.Format = WinSDK.DXGI_FORMAT_D24_UNORM_S8_UINT
            description.Usage = WinSDK.D3D11_USAGE_DEFAULT
            description.BindFlags = UInt32(WinSDK.D3D11_BIND_DEPTH_STENCIL.rawValue)
            description.MipLevels = 1
            description.SampleDesc.Count = 1
            description.SampleDesc.Quality = 0
            description.MiscFlags = 0
            description.ArraySize = 1
            description.CPUAccessFlags = 0

            result = device.CreateTexture2D(description: &description, resourceData: nil, buffer: &buffer)
        }
        if (WindowsUtilities.Failed(result: result)) {
            Logger.Error(function: "reloadBuffers", cause: "Failed create the DirectX SwapChain's RenderTargetView")
        }
        do { // create the depth stencil view
            buffer?.withMemoryRebound(to: WinSDK.ID3D11Resource.self, capacity: 1) {buffer in
                result = device.CreateDepthStencilView(buffer: buffer, description: nil, depthStencilView: &self.depthStencilView)
            }
        }
        
    }

    func Present(_ syncInterval : UInt32, _ flags : UInt32) {
        let result : HRESULT = swapChain?.pointee.lpVtbl.pointee.Present(swapChain, syncInterval, flags) ?? 0;
        if (WindowsUtilities.Failed(result: result)) {
            Logger.Error(function: "DirectXSwapChain.Present", cause: "Error presenting the directX swap chain")
        }
    }

}