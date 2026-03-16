@MainActor
public struct WindowContext {
    public let userData: Any?
    public let initialize: (Window, _ width: Float, _ height: Float) -> Void
    public let resize: (Window, _ width: Float, _ height: Float) -> Void

    @MainActor 
    public init(
        userData: Any?,
        initialize: @escaping (Window, _ width: Float, _ height: Float) -> Void, 
        resize: @escaping (Window, _ width: Float, _ height: Float) -> Void
    ) { 
        self.userData = userData;
        self.initialize = initialize; 
        self.resize = resize;
    }
}