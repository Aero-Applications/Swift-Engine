import Engine_Core;

@MainActor
func main() {
    print("\n***********************************");
    print("Entered the Application Entry Point");
    print("***********************************\n");

    let app: Application = Application();
    app.window.layerManager.add(layer: AppLayer())
    app.run();

    print("\n***********************************");
    print("Program terminated with exit code 0");
    print("***********************************\n");
}
main();