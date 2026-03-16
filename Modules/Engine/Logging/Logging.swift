public class Logger {
    public static func Error(function : String, cause : String, message: String = "") {
        print("[ERROR] in Function \(function), caused by: \(cause), \(message)")
    }
    public static func Info(message: String) {
       print("[INFO]:  \(message)")
    }
}