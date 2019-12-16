package src.range;

@:forward
abstract Range(Array<Int>) {
    public function new(start:Int, end:Int, ?step:Int) {
        if (step == null) 
            if (start < end) step = 1;
            else step = -1;
        else
            if (start < end && step < 0)
                throw "start is smaller than end and step is negative";
            else if (start > end && step > 0)
                throw "start is bigger than end and step is positive";
            else if (step == 0)
                throw "step cant be zero";
        
        this = [start];
        if (start < end)
            while (start + step < end)
                this.push(start += step);
        else
            while (start + step > end)
                this.push(start += step);
    }
}