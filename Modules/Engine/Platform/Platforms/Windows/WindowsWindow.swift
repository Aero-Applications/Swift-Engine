#if os(Windows)

import WinSDK
import Foundation

import Engine_Extensions;
import Engine_Utilities;
import Engine_Logging;
import Engine_Utilities_Windows;

@MainActor
func procedure(windowHandle : WinSDK.HWND?, message : WinSDK.UINT, firstParameter : WinSDK.WPARAM, secondParameter : WinSDK.LPARAM) -> WinSDK.LRESULT {

    let myWindow: WindowsWindow? = WindowsWindow.WindowByHandle[windowHandle]

    guard let window = myWindow else { return DefWindowProcW(windowHandle, message, firstParameter, secondParameter); }

    switch (message) {
        case UINT(WinSDK.WM_CLOSE): PostQuitMessage(0); myWindow?.open = false;
        case UINT(WinSDK.WM_DESTROY): PostQuitMessage(0); myWindow?.open = false;
        case UINT(WinSDK.WM_QUIT): PostQuitMessage(0); myWindow?.open = false;
        case UINT(WinSDK.WM_SIZE): window.resize(width: WindowsUtilities.LoWord(secondParameter), height: WindowsUtilities.HiWord(secondParameter));
        case UINT(WinSDK.WM_KEYDOWN): do {
            let control = 17
            let shift = 16
            let superkey = 91
            let keycode : UInt32 = if (firstParameter == control) {
                Key.LeftControl.rawValue
            } else if (firstParameter == shift) {
                Key.LeftShift.rawValue
            } else if (firstParameter == superkey) {
                Key.LeftSuper.rawValue
            } else {
                UInt32(truncatingIfNeeded: firstParameter)
            }
            window.eventHandler.keyPressed(
                event: KeyEvent(action: KeyAction.Press, keycode: keycode, window: window)
            );
        }
        case UINT(WinSDK.WM_KEYUP): do {
                        let control = 17
            let shift = 16
            let superkey = 91
            let keycode : UInt32 = if (firstParameter == control) {
                Key.LeftControl.rawValue
            } else if (firstParameter == shift) {
                Key.LeftShift.rawValue
            } else if (firstParameter == superkey) {
                Key.LeftSuper.rawValue
            } else {
                UInt32(truncatingIfNeeded: firstParameter)
            }
            window.eventHandler.keyReleased(
                event: KeyEvent(action: KeyAction.Release, keycode: keycode, window: window)
            );
        }
        case UINT(WinSDK.WM_MOUSEMOVE): do {
            // sadly @const is not yet a feature. But one day I will uncomment all of these;
            // @const let MK_CONTROL: UInt64 = 0x0008 // The CTRL key is down.
            /*@const*/ let MK_LBUTTON: UInt64 = 0x0001 // The left mouse button is down.
            /*@const*/ let MK_MBUTTON: UInt64 = 0x0010 // The middle mouse button is down.
            /*@const*/ let MK_RBUTTON: UInt64 = 0x0002 // The right mouse button is down.
            // @const let MK_SHIFT: UInt64 = 0x0004 // The SHIFT key is down.
            // @const let MK_XBUTTON1: UInt64 = 0x0020 // The XBUTTON1 is down.
            // @const let MK_XBUTTON2: UInt64 = 0x0040 // The XBUTTON2 is down.            
            let x : Float = Float(WindowsUtilities.GetXLParam(secondParameter));
            let y : Float = Float(WindowsUtilities.GetYLParam(secondParameter));
            let button = if ((firstParameter & MK_LBUTTON) == MK_LBUTTON) {
                MouseButton.Left
            } else if ((firstParameter & MK_RBUTTON) == MK_RBUTTON) {
                MouseButton.Right
            } else if ((firstParameter & MK_MBUTTON) == MK_MBUTTON) {
                MouseButton.Middle
            } else {
                MouseButton.None
            }
            if (button != MouseButton.None){
                window.eventHandler.mouseDragged(
                    event: MouseEvent(action: MouseAction.Drag, x: x, y: y, button: button, window: window)
                );
            } else {
                window.eventHandler.mouseMoved(
                    event: MouseEvent(action: MouseAction.Move, x: x, y: y, button: button, window: window)
                );
            }
        };
        case UINT(WM_MOUSEWHEEL): do {
            let x : Float = Float(WindowsUtilities.GetXLParam(secondParameter));
            let y : Float = Float(WindowsUtilities.GetYLParam(secondParameter));
            let delta : Float = Float(WindowsUtilities.GetWheelDeltaWParam(firstParameter)) / 120.0
            window.eventHandler.mouseScrolled(
                event: ScrollEvent(x: x, y: y, delta: delta, window: window)
            );
        }
        case UINT(WM_LBUTTONDOWN): do {
            let x : Float = Float(WindowsUtilities.GetXLParam(secondParameter));
            let y : Float = Float(WindowsUtilities.GetYLParam(secondParameter));
            window.eventHandler.mousePressed(
                event: MouseEvent(action: MouseAction.Press, x: x, y: y, button: MouseButton.Left, window: window)
            );
        }
        case UINT(WM_RBUTTONDOWN): do {
            let x : Float = Float(WindowsUtilities.GetXLParam(secondParameter));
            let y : Float = Float(WindowsUtilities.GetYLParam(secondParameter));
            window.eventHandler.mousePressed(
                event: MouseEvent(action: MouseAction.Press, x: x, y: y, button: MouseButton.Right, window: window)
            );
        }
        case UINT(WM_MBUTTONDOWN): do {
            let x : Float = Float(WindowsUtilities.GetXLParam(secondParameter));
            let y : Float = Float(WindowsUtilities.GetYLParam(secondParameter));
            window.eventHandler.mousePressed(
                event: MouseEvent(action: MouseAction.Press, x: x, y: y, button: MouseButton.Middle, window: window)
            );
        }
        case UINT(WM_LBUTTONUP): do {
            let x : Float = Float(WindowsUtilities.GetXLParam(secondParameter));
            let y : Float = Float(WindowsUtilities.GetYLParam(secondParameter));
            window.eventHandler.mouseReleased(
                event: MouseEvent(action: MouseAction.Release, x: x, y: y, button: MouseButton.Left, window: window)
            );
        }
        case UINT(WM_RBUTTONUP): do {
            let x : Float = Float(WindowsUtilities.GetXLParam(secondParameter));
            let y : Float = Float(WindowsUtilities.GetYLParam(secondParameter));
            window.eventHandler.mouseReleased(
                event: MouseEvent(action: MouseAction.Release, x: x, y: y, button: MouseButton.Right, window: window)
            );
        }
        case UINT(WM_MBUTTONUP): do {
            let x : Float = Float(WindowsUtilities.GetXLParam(secondParameter));
            let y : Float = Float(WindowsUtilities.GetYLParam(secondParameter));
            window.eventHandler.mouseReleased(
                event: MouseEvent(action: MouseAction.Release, x: x, y: y, button: MouseButton.Middle, window: window)
            );
        }
        default: break
    }
    return DefWindowProcW(windowHandle, message, firstParameter, secondParameter)
}

@MainActor
public class WindowsWindow : Window {
    static let CLASS_NAME: [WinSDK.WCHAR] = String("SWIFT_WINDOW").echoWide
    static let STYLE: UINT = 0; 
    static var WindowByHandle: [WinSDK.HWND? : WindowsWindow] = [:]

    public let handle: HWND?
    
    public var open: Bool = true

    public override var x : Float {
        get {
            var rect : WinSDK.RECT = WinSDK.RECT()
            WinSDK.GetWindowRect(handle, &rect)
            return Float(rect.left)
        }
        set {
            var rect : WinSDK.RECT = WinSDK.RECT()
            WinSDK.GetWindowRect(handle, &rect)

            WinSDK.SetWindowPos(handle, nil, Int32(newValue), rect.top, rect.right - rect.left, rect.bottom - rect.top, 0)
        }
    }

    public override var y : Float {
        get {
            var rect : WinSDK.RECT = WinSDK.RECT()
            WinSDK.GetWindowRect(self.handle, &rect)
            return Float(rect.top)
        }
        set {
            var rect : WinSDK.RECT = WinSDK.RECT()
            WinSDK.GetWindowRect(handle, &rect)

            WinSDK.SetWindowPos(handle, nil, rect.left, Int32(newValue), rect.right - rect.left, rect.bottom - rect.top, 0)

        }
    }

    public override var width : Float {
        get { 
            var rect : WinSDK.RECT = WinSDK.RECT()
            WinSDK.GetWindowRect(self.handle, &rect)
            return Float(rect.right - rect.left)
        }
        set {
            var rect : WinSDK.RECT = WinSDK.RECT()
            WinSDK.GetWindowRect(handle, &rect)

            WinSDK.SetWindowPos(handle, nil, rect.left, rect.top, Int32(newValue), rect.bottom - rect.top, 0)
        }
    }

    public override var height : Float {
        get { 
            var rect : WinSDK.RECT = WinSDK.RECT()
            WinSDK.GetWindowRect(self.handle, &rect)
            return Float(rect.bottom - rect.top)
        }
        set {
            var rect : WinSDK.RECT = WinSDK.RECT()
            WinSDK.GetWindowRect(handle, &rect)

            WinSDK.SetWindowPos(handle, nil, rect.left, rect.top, rect.right - rect.left, Int32(newValue), 0)
        }
    }
    
    override init (eventHandler: EventHandler, context: WindowContext) {
        print("Creating window on Windows.")

        let hInstance : HINSTANCE = WinSDK.GetModuleHandleW(nil)

        var windowClass: WinSDK.WNDCLASSEXW = Self.CLASS_NAME.withUnsafeBufferPointer { name in
            let cbSize: UInt32 = UInt32(MemoryLayout<WNDCLASSEX>.stride)
            let lpszClassName: UnsafePointer<WCHAR> = name.baseAddress!
            return WinSDK.WNDCLASSEXW( // this crashes in swift 6.2
                // cbSize: cbSize,
                // style: Self.STYLE, 
                // lpfnWndProc: procedure, 
                // cbClsExtra: 0, 
                // cbWndExtra: 0, 
                // hInstance: hInstance, 
                // hIcon: nil,
                // hCursor: nil,
                // hbrBackground: nil, 
                // lpszMenuName: nil, 
                // lpszClassName: lpszClassName, 
                // hIconSm: nil
            );
        }
        var classID : WinSDK.ATOM = 0
        if (!WinSDK.GetClassInfoExW(hInstance, Self.CLASS_NAME, &windowClass)) {
            classID = WinSDK.RegisterClassExW(&windowClass)
        }
        if (classID == 0){
            Logger.Error(function: "WindowsWindow.init()", cause: "WinSDK.RegisterClassExW()", message: "Failed to register the window class for WindowsWindow in the constructor thereof. No idea why.")
            handle = nil;
            super.init(eventHandler: eventHandler, context: context)
            return
        }
        var rect : WinSDK.RECT = WinSDK.RECT(left: 0, top: 0, right: 1024, bottom: 720)
        WinSDK.AdjustWindowRect(&rect, Self.STYLE, false)

        self.handle = WinSDK.CreateWindowExW(
            /* dwExStyle: */ 0,
            /* lpCLASS_NAME: */ Self.CLASS_NAME,
            /* lpWindowName: */ "title".echoWide,
            /* dwStyle: */ DWORD(WS_OVERLAPPEDWINDOW),
            /* X: */ rect.left,
            /* Y: */ rect.top,
            /* nWidth: */ rect.right - rect.left,
            /* nHeight: */ rect.bottom - rect.top,
            /* hWndParent: */ nil,
            /* hMenu: */ nil,
            /* hInstance: */ hInstance,
            /* lpParam: */ nil
        )
        super.init(eventHandler: eventHandler, context: context)
        if (self.handle == nil) {
            Logger.Error(function: "WindowsWindow.init()", cause: "CreateWindowEXW", message: "self.handle came out null after call to CreateWindowEX");
            return
        }
        // we won't be retrieving the window again this way but in case someone ever needs to we store the pointer to the window
        // we won't be retrieving it from here because swift is not good at pointers an crashes alot.
        // instead use WindowsWindow.WindowByHandle[handle];
        WinSDK.SetWindowLongPtrW(handle, GWLP_USERDATA, Address.of(object: self));
        Self.WindowByHandle[handle] = self

        ShowWindow(self.handle, WinSDK.SW_SHOW);
        UpdateWindow(self.handle);

        print("Created window with handle: \(self.handle!) on windows")

        self.context.initialize(self, self.width, self.height)
    }

    isolated deinit {
        print("Window Closed")
    }
    
    public override func pollEvents() {
        var msg : WinSDK.MSG = WinSDK.MSG();
        while (WinSDK.PeekMessageW(&msg, self.handle, 0, 0, UINT(PM_REMOVE))) {
            if (msg.message == UINT(WinSDK.WM_QUIT)) {
                open = false;
                continue
            } else {
                WinSDK.TranslateMessage(&msg)
				WinSDK.DispatchMessageW(&msg)
            }
        }        
    }

    func resize(width : UInt16, height : UInt16) {
        if (context != nil) {
            context.resize(self, Float(width), Float(height))
        }
    }

    public override func isOpen() -> Bool {
        return self.open
    }

}

#endif