public enum Modifier : Int32 {
    case Control = 0b0001
    case Super = 0b0010
    case Alt = 0b0100
    case Shift = 0b1000
}

public struct Modifiers {
    var shifts : Int32 = 0
    var controls : Int32 = 0
    var supers : Int32 = 0
    var alts : Int32 = 0
    mutating func add(modifier: Modifier) {
        switch (modifier) {
            case Modifier.Control: controls += 1
            case Modifier.Super: supers += 1
            case Modifier.Alt: alts += 1
            case Modifier.Shift: shifts += 1
        }
    }
    mutating func remove(modifier: Modifier) {
        switch (modifier) {
            case Modifier.Control:
                if (controls > 0) {
                    controls -= 1
                }
            case Modifier.Super:
                if (supers > 0) {
                    supers -= 1
                }
            case Modifier.Alt:
                if (alts > 0) {
                    alts -= 1
                }
            case Modifier.Shift:
                if (shifts > 0) {
                    shifts -= 1
                }
        }
    }
    func has(modifier: Modifier) -> Bool {
        switch (modifier) {
            case Modifier.Control: return controls > 0
            case Modifier.Super: return supers > 0
            case Modifier.Alt: return alts > 0
            case Modifier.Shift: return shifts > 0
        }
    }
    func toString() -> String {
        var string = "";
        if self.controls > 0 {
            string.append(string.isEmpty ? "'Control'" : ", 'Control'")
        }
        if self.supers > 0 {
            string.append(string.isEmpty ? "'Super'" : ", 'Super'")
        }
        if self.alts > 0 {
            string.append(string.isEmpty ? "'Alt'" : ", 'Alt'")
        }
        if self.shifts > 0 {
            string.append(string.isEmpty ? "'Shift'" : ", 'Shift'")
        }
        return string;
    }
}

@MainActor
struct Event {
    static var ActiveModifiers : Modifiers = Modifiers()
}