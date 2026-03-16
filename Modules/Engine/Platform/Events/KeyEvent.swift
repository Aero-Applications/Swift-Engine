
public enum KeyAction {
    case Press
    case Release
}

public enum Key : UInt32 {
    
    case LeftSuper = 1073742051
    // case LeftCommand = LeftSuper
    // case LeftWindows = LeftSuper
    
    case RightSuper = 1073742055
    // case RightCommand = RightSuper
    // case RightWindows = RightSuper
    
    case LeftShift = 1073742049
    case LeftControl = 1073742048
    case LeftAlt = 1073742050
    // case LeftOption = LeftAlt
    
    case RightShift = 1073742053
    case RightControl = 1073742052
    case RightAlt = 1073742054
    // case RightOption = RightAlt
    
    case F1 = 1073741882
    case F2 = 1073741883
    case F3 = 1073741884
    case F4 = 1073741885
    case F5 = 1073741886
    case F6 = 1073741887
    case F7 = 1073741888
    case F8 = 1073741889
    case F9 = 1073741890
    case F10 = 1073741891
    case F11 = 1073741892
    case F12 = 1073741893
    
    case Left = 1073741904
    case Right = 1073741903
    case Up = 1073741906
    case Down = 1073741905
    
    case CapsLock = 1073741881
    
    case Return = 13
    case Escape = 27
    case BackSpace = 8
    case Tab = 9
    case Space = 32
    case ExclamationMark = 33
    case QuotationMark = 34
    case Hash = 35
    case Dollar = 36
    case Percent = 37
    case Ampersand = 38
    case SingleQuote = 39
    case LeftParentheses = 40
    case RightParentheses = 41
    case Asterisk = 42
    case Plus = 43
    case Comma = 44
    case Minus = 45
    case Period = 46
    case Slash = 47
    case BackSlash = 92
    case OpeningBracket = 91
    case ClosingBracket = 93
    case Zero = 48
    case One = 49
    case Two = 50
    case Three = 51
    case Four = 52
    case Five = 53
    case Six = 54
    case Seven = 55
    case Eight = 56
    case Nine = 57
    case Colon = 58
    case Semicolon = 59
    case LessThanSymbol = 60
    case Equals = 61
    case GreaterThanSymbol = 62
    case QuestionMark = 63
    case At = 64
    case A = 97
    case B = 98
    case C = 99
    case D = 100
    case E = 101
    case F = 102
    case G = 103
    case H = 104
    case I = 105
    case J = 106
    case K = 107
    case L = 108
    case M = 109
    case N = 110
    case O = 111
    case P = 112
    case Q = 113
    case R = 114
    case S = 115
    case T = 116
    case U = 117
    case V = 118
    case W = 119
    case X = 120
    case Y = 121
    case Z = 122
};

@MainActor
public struct KeyEvent {
    public let action : KeyAction
    public let keycode : UInt32
    public let window : Window

    public init(action : KeyAction, keycode : UInt32, window : Window) {
        self.action = action
        self.keycode = keycode
        self.window = window
        self.resolveModifier(keycode);
    }

    private func resolveModifier(_ keycode: UInt32) {
        if (self.action == KeyAction.Press) {
            switch (keycode) {
                case Key.RightAlt.rawValue: Event.ActiveModifiers.add(modifier: Modifier.Alt);
                case Key.RightSuper.rawValue: Event.ActiveModifiers.add(modifier: Modifier.Super);
                case Key.RightShift.rawValue: Event.ActiveModifiers.add(modifier: Modifier.Shift);
                case Key.RightControl.rawValue: Event.ActiveModifiers.add(modifier: Modifier.Control);
                    
                case Key.LeftAlt.rawValue: Event.ActiveModifiers.add(modifier: Modifier.Alt);
                case Key.LeftSuper.rawValue: Event.ActiveModifiers.add(modifier: Modifier.Super);
                case Key.LeftShift.rawValue: Event.ActiveModifiers.add(modifier: Modifier.Shift);
                case Key.LeftControl.rawValue: Event.ActiveModifiers.add(modifier: Modifier.Control);
                default: return;
            }
        } else {
            switch (keycode) {
                case Key.RightAlt.rawValue: Event.ActiveModifiers.remove(modifier: Modifier.Alt);
                case Key.RightSuper.rawValue: Event.ActiveModifiers.remove(modifier: Modifier.Super);
                case Key.RightShift.rawValue: Event.ActiveModifiers.remove(modifier: Modifier.Shift);
                case Key.RightControl.rawValue: Event.ActiveModifiers.remove(modifier: Modifier.Control);
                    
                case Key.LeftAlt.rawValue: Event.ActiveModifiers.remove(modifier: Modifier.Alt);
                case Key.LeftSuper.rawValue: Event.ActiveModifiers.remove(modifier: Modifier.Super);
                case Key.LeftShift.rawValue: Event.ActiveModifiers.remove(modifier: Modifier.Shift);
                case Key.LeftControl.rawValue: Event.ActiveModifiers.remove(modifier: Modifier.Control);
                default: return;
            }
        }
    }

    public func getModifiers() -> Modifiers {
        return Event.ActiveModifiers
    }
}