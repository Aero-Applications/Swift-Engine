#if os(Windows)

import WinSDK

extension Array where Array.Element == WCHAR {

  public init(engineFrom string: String) {
    self = string.withCString(encodedAs: UTF16.self) { buffer in
      Array<WCHAR>(unsafeUninitializedCapacity: string.utf16.count + 1) {
        wcscpy_s($0.baseAddress, $0.count, buffer)
        $1 = $0.count
      }
    }
  }

}

extension String {

  public init(engineFrom wide: [WCHAR]) {
    self = wide.withUnsafeBufferPointer { array in
      String(decodingCString: array.baseAddress!, as: UTF16.self)
    }
  }

}

extension String {

  public var engineWide: [WCHAR] {
    return Array<WCHAR>(engineFrom: self)
  }
  
}

#endif