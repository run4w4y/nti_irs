package trik.color;

enum Color {
    Red; DarkRed;
    Green; DarkGreen;
    Blue; DarkBlue;
    Cyan; DarkCyan;
    Magenta; DarkMagenta;
    Yellow; DarkYellow;
    Grey; DarkGrey; LightGrey;
    Black;
    White;
    RGB(r:Int, g:Int, b:Int);
    HSV(h:Float, s:Float, v:Float);
    RGB24(value:Int);
    Mono(value:Int);
}