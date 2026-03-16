public enum Address {
    static public func of<T>(object : T) -> Int64 {
        return unsafeBitCast(object as AnyObject, to: Int64.self);
    }   
}