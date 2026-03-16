import Engine_Logging;

import Engine_Graphics_RenderTarget;

@MainActor
public class Window : RenderTarget {
    public var x : Float { get {-1} set { Logger.Error(function: "Window.x", cause: "Window.x is not implemented for the current platform") } }
    public var y : Float { get {-1} set { Logger.Error(function: "Window.y", cause: "Window.y is not implemented for the current platform") } }
    public var width : Float { get {-1} set { Logger.Error(function: "Window.width", cause: "Window.width is not implemented for the current platform") } }
    public var height : Float { get {-1} set { Logger.Error(function: "Window.height", cause: "Window.height is not implemented for the current platform") } }
    public var layerManager: LayerManager = LayerManager()
    public let eventHandler : EventHandler
    public let context : WindowContext!;

    init(eventHandler: EventHandler, context: WindowContext) {
        self.eventHandler = eventHandler
        self.context = context
        
        super.init()
    }

    public func pollEvents() -> Void { Logger.Error(function: "Window.pollEvents()", cause: "Window.pollEvents() is not implemented for the current platform") }
    public func isOpen() -> Bool { Logger.Error(function: "Window.isOpen()", cause: "Window.isOpen() is not implemented for the current platform"); return false; }
}

@MainActor
public func CreateWindow(eventHandler: EventHandler, context: WindowContext) -> Window {
    return WindowsWindow(eventHandler: eventHandler, context: context);
}