package robotModel.control;

typedef MixedArguments = {
    getWallError:Void -> Int,
    getGyroError:Void -> Float,
    getEncodersError:Void -> Int,
    wallK:Float,
    gyroK:Float,
    encodersK:Float
}