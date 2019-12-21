package trik.robot;

class Script {
    public function quit():Void {
        untyped __js__("script.quit()");
    }

    public function random(from:Int, to:Int):Int {
        return untyped __js__("script.random({0}, {1})", from, to);
    }

    public function readAll(filename:String):Array<String> {
        return untyped __js__("script.readAll({0})", filename);
    }

    public function removeFile(filename:String):Void {
        untyped __js__("script.removeFile({0})", filename);
    }

    public function run():Void {
        untyped __js__("script.run()");
    }

    public function system(command:String):Void {
        untyped __js__("script.system({0})", command);
    }

    public function time():Int {
        return untyped __js__("script.time()");
    }

    // skipped function script.timer because that would be too bothersome to deal with class QTimer

    public function wait(duration:Int) {
        return untyped __js__("script.wait({0})", duration);
    }

    public function writeToFile(filename:String, content:String) {
        return untyped __js__("script.writeToFile({0}, {1})", filename, content);
    }

    public function new():Void {}
}