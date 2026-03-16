import WinSDK.DirectX

import Engine_Graphics_RenderTarget;

import Engine_Logging;
import Engine_Platform;
import Engine_Math;
import Engine_Utilities_Windows;

@MainActor
class DirectXGraphics {
    static var d3dDevice: DirectXDevice!
    static var context: DirectXDeviceContext!

    static var dxgiDevice: DirectXGraphicsDevice!
    static var dxgiAdapter: DirectXGraphicsAdapter!
    static var dxgiFactory: DirectXGraphicsFactory!

    static func OnInitialize() -> Void { 

        WinSDK.CoInitialize(nil)

        d3dDevice = DirectXDevice()
        context = d3dDevice.context

        dxgiDevice = DirectXGraphicsDevice(directXDevice: d3dDevice)
        dxgiAdapter = DirectXGraphicsAdapter(graphicsDevice: dxgiDevice)
        dxgiFactory = DirectXGraphicsFactory(graphicsAdapter: dxgiAdapter)

        Graphics.ClearCallback = Self.Clear;
        Graphics.SetViewportCallback = Self.SetViewport;
        Graphics.CreateWindowContextCallback = Self.CreateWindowContext;
        Graphics.SwapBuffersCallback = Self.SwapBuffers;
        Graphics.SetShaderCallback = Self.SetShader;
        Graphics.UploadShaderBufferCallback = Self.UploadShaderBuffer;

        DirectXGraphics3D.OnInitialize()
    }   

    static func OnShutdown()-> Void {
        DirectXGraphics3D.OnShutdown()
    }

    static func Clear (red : Float, green : Float, blue : Float, alpha : Float) -> Void {
        let window: WindowsWindow = RenderTarget.Current as! WindowsWindow;
        
        let values : [Float] = [red, green, blue, alpha]

        let swapChain: DirectXSwapChain? = window.context.userData as! DirectXSwapChain?

        guard let swapChain else {
            Logger.Error(function: "DirectXGraphics.Clear()", cause: "Window context was not a DirectX context", message: "Window.context was created for another render api.");
            return
        }

        var renderTargetView: UnsafeMutablePointer<ID3D11RenderTargetView>? = swapChain.renderTargetView
        let depthStencilView: UnsafeMutablePointer<ID3D11DepthStencilView>? = swapChain.depthStencilView

        Self.context.ClearRenderTargetView(renderTargetView: renderTargetView, colorValues: values)
        Self.context.ClearDepthStencilView(depthStencilView: depthStencilView, flags: UInt32(WinSDK.D3D11_CLEAR_DEPTH.rawValue | WinSDK.D3D11_CLEAR_STENCIL.rawValue), arg1: 1, arg2: 0);
        Self.context.OMSetRenderTargets(numberOfViews: 1, renderTargetView: &renderTargetView, depthStencilView: depthStencilView);
    }

    public static func CreateWindowContext() -> WindowContext {
        let swapChain: DirectXSwapChain! = DirectXSwapChain();
        return WindowContext(
            userData: swapChain,
            initialize: { window, width, height in 
                swapChain.initialize(config: SwapchainConfig(window: window, width: width, height: height)) 
            },
            resize: { window, width, height in 
                swapChain.reloadBuffers(width: width, height: height) 
            },
        )
    }

    static func SwapBuffers() -> Void {
        let window: WindowsWindow = RenderTarget.Current as! WindowsWindow

        let swapchain: DirectXSwapChain? = window.context.userData as! DirectXSwapChain?
        swapchain?.Present(0, 0)
    }

    static func SetShader(shader: Shader) {
        let dxShader: DirectXShader = shader as! DirectXShader
        context.IASetInputLayout(layout: dxShader.layout);
	    context.VSSetShader(vertexShader: dxShader.vs, classInstance: nil, classInstanceCount: 0);
	    context.PSSetShader(pixelShader: dxShader.ps, classInstance: nil, classInstanceCount: 0);
    }
    
    static func SetViewport(size: Rect) {
        var vp: D3D11_VIEWPORT = D3D11_VIEWPORT(
            TopLeftX: size.x,
            TopLeftY: size.y, 
            Width: size.width, 
            Height: size.height, 
            MinDepth: 0.0, 
            MaxDepth: 1.0
        );
        context.RSSetViewports(numberOfViewports: 1, viewports: &vp);
    }

    static func UploadShaderBuffer(buffer: ShaderBuffer) {
        let constantBuffer: DirectXConstantBuffer = buffer as! DirectXConstantBuffer
        context.VSSetConstantBuffers(startSlot: 0, numBuffers: 1, constantBuffers: &constantBuffer.buffer) // seperate me
        context.PSSetConstantBuffers(startSlot: 0, numBuffers: 1, constantBuffers: &constantBuffer.buffer) // seperate me
    }


};