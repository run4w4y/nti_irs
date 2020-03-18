package;

import haxe.macro.Context;
import haxe.macro.Expr;

using Lambda;
using haxe.macro.ExprTools;


class Build {
    macro public static function build():Array<Field> {
        var localClass = Context.getLocalClass();
        
        if (localClass == null)
            return null;
        
        var fields = Context.getBuildFields();
        
        for (field in fields) {
            switch (field.kind) {
                case FFun(f):
                    var isAffected = field.meta.map(function (a) return a.name).has(":updateFrequency");
                    var args = if (isAffected)
                            field.meta.filter(function (a) return a.name == ":updateFrequency")[0].params
                        else
                            null;

                    isAffected = isAffected && args != null && f.expr != null;
                    if (!isAffected) 
                        continue;
                    
                    var storageName = 'prev${field.name}';
                    fields.push({
                        name: storageName,
                        access: [ Access.APrivate, Access.AStatic ],
                        kind: FieldType.FVar(f.ret, macro $v{ 0 }),
                        pos: Context.currentPos()
                    });

                    var timeName = 'time${field.name}';
                    fields.push({
                        name: timeName,
                        access: [ Access.APrivate, Access.AStatic ],
                        kind: FieldType.FVar(macro:Int, macro $e{ args[0] }),
                        pos: Context.currentPos()
                    });

                    f.expr = Context.parse('{
                        var read = function () ${ f.expr.toString() };

                        if (untyped __js__("script.time()") - $timeName >= ${ args[0].toString() })
                            $storageName = read();
                        
                        return $storageName;
                    }', Context.currentPos());
                case _:
                    continue;
            }
        }

        return fields;
    } 

    macro public static function buildReal():Array<Field> {
        var localClass = Context.getLocalClass();

        if (localClass == null)
            return null;

        var fields = Context.getBuildFields();

        for (field in fields) {
            switch (field.kind) {
                case FFun(f):
                    var isAffected = field.meta.map(function (a) return a.name).has(":inputFrom");
                    var args = if (isAffected)
                            field.meta.filter(function (a) return a.name == ":inputFrom")[0].params
                        else
                            null;
                    
                    isAffected = isAffected && args != null && f.expr != null;
                    if (!isAffected) 
                        continue;

                    var input = Context.definedValue(args[0].getValue());
                    f.expr = Context.parse('{
                        return "$input";
                    }', Context.currentPos());
                case _:
                    continue;
            }
        }

        return fields;
    }
}