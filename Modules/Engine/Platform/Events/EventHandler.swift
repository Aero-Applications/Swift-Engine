public protocol EventHandler {
    func keyPressed(event: KeyEvent);
    func keyReleased(event: KeyEvent);
    func mousePressed(event: MouseEvent);
    func mouseReleased(event: MouseEvent);
    func mouseMoved(event: MouseEvent);
    func mouseDragged(event: MouseEvent);
    func mouseScrolled(event: ScrollEvent);
}
