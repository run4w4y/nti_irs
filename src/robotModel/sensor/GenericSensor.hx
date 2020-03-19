package robotModel.sensor;


interface GenericSensor<T:Float> {
    public function read():T;
}