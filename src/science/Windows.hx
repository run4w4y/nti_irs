package science;

import Math.*;


class Windows {
    public static function blackman(windowSize:Int):Array<Float> {
        if (windowSize <= 0) 
            return [];
        if (windowSize == 1)
            return [1];

        return [for (n in 0...windowSize) 
            .42 - .5*cos(2*PI*n / (windowSize - 1)) + .08*cos(4*PI*n / (windowSize - 1))
        ];
    }

    public static function bartlett(windowSize:Int):Array<Float> {
        if (windowSize <= 0) 
            return [];
        if (windowSize == 1)
            return [1];
        
        return [for (n in 0...windowSize)
            2/(windowSize - 1)*((windowSize - 1)/2 - abs(n - (windowSize - 1) / 2))
        ];
    }

    public static function hamming(windowSize:Int):Array<Float> {
        if (windowSize <= 0) 
            return [];
        if (windowSize == 1)
            return [1];
        
        return [for (n in 0...windowSize)
            .54 - .46*cos(2*PI*n / (windowSize - 1))
        ];
    }

    public static function hanning(windowSize:Int):Array<Float> {
        if (windowSize <= 0) 
            return [];
        if (windowSize == 1)
            return [1];
        
        return [for (n in 0...windowSize)
            .5 - .5*cos(2*PI*n / (windowSize - 1))
        ];
    }
}