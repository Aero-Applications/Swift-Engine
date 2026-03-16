import WinSDK.DirectX;

import Engine_Logging;
import Engine_Utilities_Windows;

@MainActor
class DirectXShaderStage {
    var blob: UnsafeMutablePointer<ID3DBlob>? = UnsafeMutablePointer<WinSDK.ID3DBlob>(nil)

    init(filepath: String, entryPointName: String, type: ShaderType) {
        // let sourceCode = try! String(contentsOfFile: filepath);// open file and read contents here
        let sourceCode = filepath

        var errorBlob: UnsafeMutablePointer<ID3DBlob>? = UnsafeMutablePointer<WinSDK.ID3DBlob>(nil)

        let result = D3DCompile(
            /*pSrcData:*/ sourceCode.cString(using: String.Encoding.utf8),
            /*SrcDataSize:*/ SIZE_T(sourceCode.count),
            /*pSourceName:*/ filepath.cString(using: String.Encoding.utf8),
            /*pDefines:*/ nil,
            /*pInclude:*/ nil,
            /*pEntrypoint:*/ entryPointName.cString(using: String.Encoding.utf8),
            /*pTarget:*/ type == ShaderType.Vertex ? "vs_5_0" : "ps_5_0",
            /*Flags1:*/ 0, 
            /*Flags2:*/ 0,
            /*ppCode:*/ &blob, 
            /*ppErrorMsgs:*/ &errorBlob
        )

        if (WindowsUtilities.Failed(result: result)) {
            let error: String = String(cString: Array<UInt8>(
                    UnsafeBufferPointer<UInt8>(
                        start: errorBlob?.pointee.lpVtbl.pointee.GetBufferPointer(errorBlob)?.assumingMemoryBound(to: UInt8.self), 
                        count: Int(errorBlob?.pointee.lpVtbl.pointee.GetBufferSize(errorBlob) ?? 0)
                    )
                )
            )
            Logger.Error(function: "DirectXShaderStage.init()", cause: "D3DCompile() failed with error: \(error)")
        } else if let errorBlob: UnsafeMutablePointer<ID3DBlob> = errorBlob {
            let error: String = String(cString: Array<UInt8>(
                    UnsafeBufferPointer<UInt8>(
                        start: errorBlob.pointee.lpVtbl.pointee.GetBufferPointer(errorBlob)?.assumingMemoryBound(to: UInt8.self), 
                        count: Int(errorBlob.pointee.lpVtbl.pointee.GetBufferSize(errorBlob))
                    )
                )
            )
            Logger.Error(function: "DirectXShaderStage.init()", cause: "D3DCompile() succeded with warnings: \(error)")
        }

        _ = errorBlob?.pointee.lpVtbl.pointee.Release(errorBlob)
    }

    func getData() -> (data: UnsafeMutableRawPointer?, size: SIZE_T) {
        return (
            data : blob?.pointee.lpVtbl.pointee.GetBufferPointer(blob),
            size : blob?.pointee.lpVtbl.pointee.GetBufferSize(blob) ?? 0
        )
    }

    isolated deinit {
        _ = blob?.pointee.lpVtbl.pointee.Release(blob)
    }

}

@MainActor
class DirectXShader : Shader {
    var vs: UnsafeMutablePointer<ID3D11VertexShader>!;
	var ps: UnsafeMutablePointer<ID3D11PixelShader>!;
    var layout: UnsafeMutablePointer<ID3D11InputLayout>!;

    init(filePath : String) {        
        let src: String = """
            cbuffer VS_CONSTANT_BUFFER : register(b0) {
                float4x4 VS_PROJECTION;
                float4x4 VS_VIEW;
                float4x4 VS_MODEL;
            };

            struct VSInput { 
                float3 position : POSITION0; 
            };

            struct VSOutput { 
                float4 position : SV_Position; 
                float3 color : COLOR0; 
            };

            VSOutput VSMain(VSInput input) {
                VSOutput output;
                output.position = mul(
                    mul(
                        mul(
                            float4(input.position.xyz, 1.0f),
                            VS_MODEL
                        ),
                        VS_VIEW
                    ),
                    VS_PROJECTION
                );
                output.color = float3(1.0f, 0.5f, 0.0f);
                return output;
            }
            float4 PSMain(VSOutput input) : SV_Target {
                return float4(input.color.xyz, 1.0f);
                //return float4(0.0f, 1.0f, 1.0f, 1.0f);
            }
        """

        let vertexStage: DirectXShaderStage = DirectXShaderStage(filepath: src, entryPointName: "VSMain", type: ShaderType.Vertex)
        let fragmentStage: DirectXShaderStage = DirectXShaderStage(filepath: src, entryPointName: "PSMain", type: ShaderType.Fragment)

        let inputElements: [WinSDK.D3D11_INPUT_ELEMENT_DESC] = [
            WinSDK.D3D11_INPUT_ELEMENT_DESC(
                SemanticName: StaticString("POSITION").utf8Start.withMemoryRebound(to: Int8.self, capacity: 9, { ptr in return ptr}), 
                SemanticIndex: 0,
                Format: WinSDK.DXGI_FORMAT_R32G32B32_FLOAT, 
                InputSlot: 0, 
                AlignedByteOffset: 0, 
                InputSlotClass: WinSDK.D3D11_INPUT_PER_VERTEX_DATA, 
                InstanceDataStepRate: 0
            )
        ]

        Logger.Info(message: "\(String(cString: inputElements[0].SemanticName!)):\(inputElements[0].SemanticIndex)")

        let d3dDevice: DirectXDevice = DirectXGraphics.d3dDevice

        let vsData: (data: UnsafeMutableRawPointer?, size: SIZE_T) = vertexStage.getData();
        let psData: (data: UnsafeMutableRawPointer?, size: SIZE_T) = fragmentStage.getData();

		var result: HRESULT = d3dDevice.CreateInputLayout(inputElements: inputElements, elementCount: UINT(inputElements.count), shaderByteCodeData: vsData.data, shaderByteCodeSize: vsData.size, layout: &self.layout)
        if (WindowsUtilities.Failed(result: result)){
            Logger.Error(function: "DirectXShader.init()", cause: "Failed to create ID3D11InputLayout")
        }
		result = d3dDevice.CreateVertexShader(shaderByteCodeData: vsData.data, shaderByteCodeSize: vsData.size, classLinkage: nil, shader: &self.vs)
        if (WindowsUtilities.Failed(result: result)){
            Logger.Error(function: "DirectXShader.init()", cause: "Failed to create ID3D11VertexShader")
        }
		result = d3dDevice.CreatePixelShader(shaderByteCodeData: psData.data, shaderByteCodeSize: psData.size, classLinkage: nil, shader: &self.ps)
        if (WindowsUtilities.Failed(result: result)){
            Logger.Error(function: "DirectXShader.init()", cause: "Failed to create ID3D11PixelShader")
        }

    }

    isolated deinit {
        _ = vs.pointee.lpVtbl.pointee.Release(vs)
        _ = ps.pointee.lpVtbl.pointee.Release(ps)
        _ = layout.pointee.lpVtbl.pointee.Release(layout)
    }
}