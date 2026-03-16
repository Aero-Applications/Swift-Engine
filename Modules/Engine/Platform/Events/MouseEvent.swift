
public enum MouseAction {
    case Press
    case Release
    case Move
    case Drag
}

public enum MouseButton {
    case None
    case Left
    case Right
    case Middle
}

@MainActor
public struct MouseEvent {
    static var LastX : Float = 0
    static var LastY : Float = 0

    static var X : Float = 0
    static var Y : Float = 0

    public let action : MouseAction
    public let button : MouseButton
    public let window : Window

    public init(action : MouseAction, x: Float, y: Float, button: MouseButton, window : Window) {
        Self.LastX = Self.X
        Self.LastY = Self.Y
        Self.X = x
        Self.Y = y
        self.action = action
        self.button = button
        self.window = window
    }

    public func getXVelocity() -> Float {
        return Self.X - Self.LastX
    }

    public func getYVelocity() -> Float {
        return Self.Y - Self.LastY
    }

    public func getModifiers() -> Modifiers {
        return Event.ActiveModifiers
    }
}