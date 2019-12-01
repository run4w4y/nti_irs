`trik.image.Pixel`
================

Explanation:
------------
Class representing a pixel for the usage inside of the ImageTools class.

Methods:
--------
### `new(x, y, ?limX, ?limY): Void`
Class constructor.
#### Arguments:
- `x: Int`. X coordinate.
- `y: Int`. Y coordinate.
- `?limX: Int`. Constraints for the coordinate on the axis X. Optional.
- `?limY: Int`. Constraints for the coordinate on the axis Y. Optional.

### `add(pixel): Pixel`
Sums and returns coordinates of the this and given pixels.
#### Arguments:
- `pixel: Pixel`. Pixel that needs to be added to this one.


Fields:
-------
### `x: Int`
X coordinate of the pixel
### `y: Int`
Y coordinate of the pixel
### `constraintsX: Null<Int>`
Constraints for the coordinates of the pixel on the X axis. Will be `null` if no constraints were set.
### `constraintsY: Null<Int>`
Constraints for the coordinates of the pixel on the Y axis. Will be `null` if no constraints were set.