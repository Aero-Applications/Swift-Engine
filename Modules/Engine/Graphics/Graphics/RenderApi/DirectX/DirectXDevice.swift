import WinSDK;

import Engine_Logging;
import Engine_Utilities_Windows;

@MainActor
class DirectXDevice {
    var d3dDevice: UnsafeMutablePointer<WinSDK.ID3D11Device>?
    var featureLevel: WinSDK.D3D_FEATURE_LEVEL = WinSDK.D3D_FEATURE_LEVEL_11_0
    var context: DirectXDeviceContext = DirectXDeviceContext()

    init() {
        let types : [WinSDK.D3D_DRIVER_TYPE] = [
            WinSDK.D3D_DRIVER_TYPE_HARDWARE,
            WinSDK.D3D_DRIVER_TYPE_SOFTWARE,
            WinSDK.D3D_DRIVER_TYPE_REFERENCE,
        ]

        var featureLevels: [WinSDK.D3D_FEATURE_LEVEL] = [
            WinSDK.D3D_FEATURE_LEVEL_11_0
        ]

        var result: WinSDK.HRESULT = 0

        for driverType: D3D_DRIVER_TYPE in types {
            result = WinSDK.D3D11CreateDevice (
                /* pAdapter: */ nil,
                /* DriverType: */ driverType,
                /* Software: */ nil,
                /* Flags: */ 0, 
                /* pFeatureLevels: */ &featureLevels[0],
                /* FeatureLevels: */ UINT(featureLevels.count), 
                /* SDKVersion: */ UINT(WinSDK.D3D11_SDK_VERSION), 
                /* ppDevice: */ &d3dDevice, 
                /* pFeatureLevel: */ &featureLevel, 
                /* ppImmediateContext: */ &context.context
            )
            if (WindowsUtilities.Succeeded(result: result)){
                break;
            } else {
                Logger.Error(function: "DirectXGraphics3D.Initialize()", cause: "DirectX wont tell me", message: "failed to create the directX d3dDevice with driver type \(driverType), maybe the driver type was not supported or DirectX Feature Level 11 was not avaliable on your GPU")
            }
        }
        if (WindowsUtilities.Failed(result: result)) {
            Logger.Error(function: "DirectXGraphics3D.Initialize()", cause: "DirectX wont tell me", message: "failed to create the directX d3dDevice with any driver type, maybe none of the driver types weresupported or DirectX Feature Level 11 was not avaliable on your GPU ")
        }
    }

    isolated deinit {
        _ = d3dDevice?.pointee.lpVtbl.pointee.Release(d3dDevice)
    }

    func createIDXGIDevice() -> UnsafeMutablePointer<WinSDK.IDXGIDevice>? {
        var id: GUID = WinSDK.IID_IDXGIDevice;
        var pointer : UnsafeMutableRawPointer? = nil;
        let result: HRESULT = d3dDevice?.pointee.lpVtbl.pointee.QueryInterface(d3dDevice, &id, &pointer) ?? 0
        if (WindowsUtilities.Failed(result: result)) {
            Logger.Error(function: "DirectXDevice.createIDXGIDevice()", cause: "DirectX wont tell me", message: "failed to create the 'DirectX Graphics Infrastructure' device. Maybe the DirectXDevice was not created succesfully.")
        }
        return pointer?.assumingMemoryBound(to: WinSDK.IDXGIDevice.self)
    }

    func CreateTexture2D(description : inout D3D11_TEXTURE2D_DESC, resourceData : UnsafePointer<D3D11_SUBRESOURCE_DATA>?, buffer : inout UnsafeMutablePointer<ID3D11Texture2D>?) -> HRESULT {
        return d3dDevice?.pointee.lpVtbl.pointee.CreateTexture2D(d3dDevice, &description, resourceData, &buffer) ?? 0
    }

    func CreateRenderTargetView(buffer : UnsafeMutablePointer<ID3D11Resource>?, description : UnsafePointer<D3D11_RENDER_TARGET_VIEW_DESC>?, renderTargetView : inout UnsafeMutablePointer<ID3D11RenderTargetView>?) -> HRESULT {
        return d3dDevice?.pointee.lpVtbl.pointee.CreateRenderTargetView(d3dDevice, buffer, description, &renderTargetView) ?? 0;
    }
    func CreateDepthStencilView(buffer : UnsafeMutablePointer<ID3D11Resource>?, description: UnsafePointer<D3D11_DEPTH_STENCIL_VIEW_DESC>?, depthStencilView : inout UnsafeMutablePointer<ID3D11DepthStencilView>?) -> HRESULT {
        return d3dDevice?.pointee.lpVtbl.pointee.CreateDepthStencilView(d3dDevice, buffer, description, &depthStencilView) ?? 0
    }
    func CreateInputLayout(inputElements : UnsafePointer<D3D11_INPUT_ELEMENT_DESC>, elementCount: UINT, shaderByteCodeData : UnsafeMutableRawPointer?, shaderByteCodeSize : SIZE_T, layout : UnsafeMutablePointer<UnsafeMutablePointer<ID3D11InputLayout>?>) -> HRESULT {
        return d3dDevice?.pointee.lpVtbl.pointee.CreateInputLayout(d3dDevice, inputElements, elementCount, shaderByteCodeData, shaderByteCodeSize, layout) ?? 0;
    }
	func CreateVertexShader(shaderByteCodeData : UnsafeMutableRawPointer?, shaderByteCodeSize : SIZE_T, classLinkage : UnsafeMutablePointer<ID3D11ClassLinkage>?, shader: UnsafeMutablePointer<UnsafeMutablePointer<ID3D11VertexShader>?>) -> HRESULT {
        return d3dDevice?.pointee.lpVtbl.pointee.CreateVertexShader(d3dDevice, shaderByteCodeData, shaderByteCodeSize, classLinkage, shader) ?? 0;
    }
	func CreatePixelShader(shaderByteCodeData : UnsafeMutableRawPointer?, shaderByteCodeSize : SIZE_T, classLinkage : UnsafeMutablePointer<ID3D11ClassLinkage>?, shader: UnsafeMutablePointer<UnsafeMutablePointer<ID3D11PixelShader>?>) -> HRESULT {
        return d3dDevice?.pointee.lpVtbl.pointee.CreatePixelShader(d3dDevice, shaderByteCodeData, shaderByteCodeSize, classLinkage, shader) ?? 0;
    }
    func CreateBuffer(desc: UnsafePointer<D3D11_BUFFER_DESC>?, subResourceData: UnsafePointer<D3D11_SUBRESOURCE_DATA>?, buffer: UnsafeMutablePointer<UnsafeMutablePointer<ID3D11Buffer>?>?) -> HRESULT {
        return d3dDevice?.pointee.lpVtbl.pointee.CreateBuffer(d3dDevice, desc, subResourceData, buffer) ?? 0;
    }
}