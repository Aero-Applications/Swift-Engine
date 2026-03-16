#if os(Windows)
import WinSDK

public enum WindowsUtilities {
    public static func Succeeded(result : WinSDK.HRESULT) -> Bool {
        return result >= 0;
    }
    public static func Failed(result : WinSDK.HRESULT) -> Bool {
        return result < 0;
    }

    public static func LoWord(_ lparam : WinSDK.LPARAM) -> WinSDK.WORD {
        return WinSDK.WORD(truncatingIfNeeded: lparam);
    }

    public static func HiWord(_ lparam : WinSDK.LPARAM) -> WinSDK.WORD{
        return WinSDK.WORD(truncatingIfNeeded: ((WinSDK.DWORD(lparam) >> 16) & 0xFFFF))
    }

    public static func LoWord(_ wparam : WinSDK.WPARAM) -> WinSDK.WORD {
        return WinSDK.WORD(truncatingIfNeeded: wparam);
    }

    public static func HiWord(_ wparam : WinSDK.WPARAM) -> WinSDK.WORD{
        return WinSDK.WORD(truncatingIfNeeded: ((WinSDK.DWORD(wparam) >> 16) & 0xFFFF))
    }

    public static func GetXLParam(_ lparam : WinSDK.LPARAM) -> Int32 {
        return Int32(Int16(truncatingIfNeeded: LoWord(lparam)))
    }
    public static func GetYLParam(_ lparam : WinSDK.LPARAM) -> Int32 {
        return Int32(Int16(truncatingIfNeeded: HiWord(lparam)))
    }
    public static func GetWheelDeltaWParam(_ wparam : WinSDK.WPARAM) -> Int32 {
        return Int32(Int16(truncatingIfNeeded: HiWord(wparam)))
    }
}
#endif