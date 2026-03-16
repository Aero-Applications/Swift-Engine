import WinSDK

import Engine_Logging;
import Engine_Utilities_Windows;

@MainActor
class DirectXDeviceContext {
    var context: UnsafeMutablePointer<WinSDK.ID3D11DeviceContext>? = nil

    init() {

    }

    isolated deinit {
        _ = context?.pointee.lpVtbl.pointee.Release(context)
    }

    func RSSetViewports(numberOfViewports: WinSDK.UINT, viewports: UnsafeMutablePointer<WinSDK.D3D11_VIEWPORT>) {
        context?.pointee.lpVtbl.pointee.RSSetViewports(context, numberOfViewports, viewports);
    }

    func ClearRenderTargetView(renderTargetView: UnsafeMutablePointer<ID3D11RenderTargetView>?, colorValues: UnsafePointer<FLOAT>?) {
        context?.pointee.lpVtbl.pointee.ClearRenderTargetView(context, renderTargetView, colorValues)
    }
    func ClearDepthStencilView(depthStencilView: UnsafeMutablePointer<ID3D11DepthStencilView>?, flags : UInt32, arg1 : FLOAT, arg2 : UInt8) {
        context?.pointee.lpVtbl.pointee.ClearDepthStencilView(context, depthStencilView, flags, arg1, arg2);
    }

    func OMSetRenderTargets(numberOfViews : UInt32, renderTargetView : inout UnsafeMutablePointer<ID3D11RenderTargetView>?, depthStencilView: UnsafeMutablePointer<ID3D11DepthStencilView>?) {
        context?.pointee.lpVtbl.pointee.OMSetRenderTargets(context, numberOfViews, &renderTargetView, depthStencilView);
    }

    func IASetInputLayout(layout: UnsafeMutablePointer<ID3D11InputLayout>?) {
        context?.pointee.lpVtbl.pointee.IASetInputLayout(context, layout)
    }
    func IASetVertexBuffers(startSlot: UINT, numBuffers: UINT, vertexBuffers: UnsafePointer<UnsafeMutablePointer<ID3D11Buffer>?>?, strides: UnsafePointer<UINT>?, offsets: UnsafePointer<UINT>?) {
        context?.pointee.lpVtbl.pointee.IASetVertexBuffers(context, startSlot, numBuffers, vertexBuffers, strides, offsets)
    }
    func IASetIndexBuffer(indexBuffer: UnsafeMutablePointer<ID3D11Buffer>?, format: WinSDK.DXGI_FORMAT, offset: UINT) {
        context?.pointee.lpVtbl.pointee.IASetIndexBuffer(
            context,
            indexBuffer,
            format, 
            offset
        )
    }
    func IASetPrimitiveTopology(topology: D3D11_PRIMITIVE_TOPOLOGY) {
        context?.pointee.lpVtbl.pointee.IASetPrimitiveTopology(context, topology)
    }


	func VSSetShader(vertexShader: UnsafeMutablePointer<ID3D11VertexShader>?, classInstance: UnsafePointer<UnsafeMutablePointer<ID3D11ClassInstance>?>?, classInstanceCount: UINT) {
        context?.pointee.lpVtbl.pointee.VSSetShader(context, vertexShader, classInstance, classInstanceCount)
    }
	func PSSetShader(pixelShader: UnsafeMutablePointer<ID3D11PixelShader>?, classInstance: UnsafePointer<UnsafeMutablePointer<ID3D11ClassInstance>?>?, classInstanceCount: UINT) {
        context?.pointee.lpVtbl.pointee.PSSetShader(context, pixelShader, classInstance, classInstanceCount)
    }

    func VSSetConstantBuffers(startSlot: UINT, numBuffers: UINT, constantBuffers: UnsafePointer<UnsafeMutablePointer<ID3D11Buffer>?>?) {
        context?.pointee.lpVtbl.pointee.VSSetConstantBuffers(context, startSlot, numBuffers, constantBuffers)
    }

    func PSSetConstantBuffers(startSlot: UINT, numBuffers: UINT, constantBuffers: UnsafePointer<UnsafeMutablePointer<ID3D11Buffer>?>?) {
        context?.pointee.lpVtbl.pointee.PSSetConstantBuffers(context, startSlot, numBuffers, constantBuffers)
    }

    func UpdateSubresource(destinationResource: UnsafeMutablePointer<ID3D11Resource>, destinationSubresource: UINT, destinationBox: UnsafePointer<D3D11_BOX>?, 
                           sourceData: UnsafeRawPointer, sourceRowPitch: UINT, sourceDepthPitch: UINT ) {
        context?.pointee.lpVtbl.pointee.UpdateSubresource(
            context,
            destinationResource, destinationSubresource, destinationBox,
            sourceData, sourceRowPitch, sourceDepthPitch
        )
    }
    func Draw(vertexCount: UINT, startVertexIndex: UINT) {
        context?.pointee.lpVtbl.pointee.Draw(context, vertexCount, startVertexIndex);
    }
    func DrawIndexed(indexCount: UINT, startIndexLocation: UINT, baseVertexLocation: INT) {
        context?.pointee.lpVtbl.pointee.DrawIndexed(context, indexCount, startIndexLocation, baseVertexLocation);
    }
    func FinishCommandList(restoreDeferredContextState: WindowsBool, list: UnsafeMutablePointer<UnsafeMutablePointer<ID3D11CommandList>?>?) -> HRESULT {
        return context?.pointee.lpVtbl.pointee.FinishCommandList(context, restoreDeferredContextState, list) ?? 0
    }
    func ExecuteCommandList(list: UnsafeMutablePointer<ID3D11CommandList>?, restoreContextState: WindowsBool) {
        context?.pointee.lpVtbl.pointee.ExecuteCommandList(context, list, restoreContextState)
    }

}