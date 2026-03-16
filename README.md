# Swift Engine

This is a project to test the viability of swift in real time applications on Windows.

The idea is simple: 
    
    Write a simple DirectX Application that does nothing but render a triangle and process key / mouse events.

# Building

This code used to build, in Swift 5.10, but I upgraded to swift 6.3, and when the hundreds of new compiler errors settled, the compiler crashed. Now I do not even know if the code will run when Swift fixes the crashes, because all the Swift concurrency errors made me rearchitect a few things. Any one who understands why the compiler is crashing, or anything I'm doing wrong in this example code, that could be improved, please leave an issue.

# A Little Warning

I understand annotating everything with '@MainActor' isn't solving problems the right, or concurrent way, I just needed the compile errors to go away long enough to verify that the code still runs.