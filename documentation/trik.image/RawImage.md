`trik.image.RawImage`
================

Explanation:
------------
Abstract over the `Image<RGB24Color>` type. 

Methods:
--------

### `new(rawPhoto): Void`
Class constructor.
#### Arguments:
- `rawPhoto: String`. String returned by the trik.robot.Brick.getPhoto function.

### `toImage(): Image<RGBColor>`
Converts RawImage instance to the image with RGB color scheme.