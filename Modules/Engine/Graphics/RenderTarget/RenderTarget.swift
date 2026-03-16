@MainActor
open class RenderTarget {
    @MainActor
    public private(set) static var Current : RenderTarget? = nil

    public init() {}

    open func becomeRenderTarget() -> Void {}
    open func renounceRenderTarget() -> Void {}

    public static func setCurrent(target: RenderTarget) {
        Current?.renounceRenderTarget()
        Current = target;
        Current?.becomeRenderTarget()
    }
}