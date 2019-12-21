package sequence;

import haxe.macro.Expr;


class Sequence {
    public static macro function sequence(separator:Expr, actions:Array<Expr>) {
        var result:Array<Expr> = [];
        for (index in 0...actions.length) {
            result.push(actions[index]);
            if (index != actions.length - 1) 
                result.push(separator);
        }
        return macro $b{result};
    }
}