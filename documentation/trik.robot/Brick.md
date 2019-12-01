`trik.robot.Brick`
================

Explanation:
------------
Class for accessing anything related to the TRIK controller, e.g. motors, sensors, camera.
Currently missing JS bindings: `LineSensor` object, `getStillImage` function.

Methods:
--------
### `new(): Void`
Class constructor.

### `encoder(port): Encoder`
Returns ecnoder on the given port.
#### Arguments:
- `port: String`. Encoder port.

### `motor(port): Motor`
Returns motor on the given port.
#### Arguments:
- `port: String`. Motor port.

### `colorSensor(port): ColorSensor`
Returns `ColorSensor` object initialized on the given camera port.
#### Arguments:
- `port: String`. Camera port.

### `playSound(filename): Void`
Plays audio file with the given filename.
#### Arguments:
- `filename: String`. Name of the audio file that needs to be played.

### `say(phrase): Void`
Say out loud the given phrase.
#### Arguments:
- `phrase: String`. The phrase that needs to be said.

### `sensor(port): Sensor`
Returns sensor on the given port.
#### Arguments:
- `port: String`. Sensor port.

### `stop(): Void`
Stops program execution.

### `objectSensor(port): ObjectSensor`
Returns `ObjectSensor` object initialized on the given camera port.
#### Arguments:
- `port: String`. Camera port.

### `getPhoto(): Image<RGBColor>`
Returns an image took from the camera.


Fields:
-------
### `accelerometer: Accelerometer`
`Accelerometer` object, which allows accessing the on-board accelerometer.
### `battery: Battery`
`Battery` object, which allows accessing the on-board battery.
### `display: DisplayHigher`
`DisplayHigher` object, which allows accessing the on-board display.
### `keys: KeysHigher`
`KeysHigher` object, which allows accessing the on-board keys.
### `led: Led`
`Led` object, which allows accessing the on-board led.
### `gyroscope: Gyroscope`
`GyroscopeHigher` object, which allows accessing the on-board gyroscope.