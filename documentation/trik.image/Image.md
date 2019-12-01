`trik.image.Image<C>`
===================

Explanation:
------------
Abstract generic class representing an image. Type `C` stands for the color type of image. Example:
```haxe
var image = new Image<RGBColor>([[]]);
```

Methods:
--------
### `new(pixels): Void`
Class constructor.
#### Arguments:
- `pixels: Array<Array<C>>`. Represents pixels of an image.

### `get(index): Array<C>`
Returns a row of pixels by the given `index`. You also can use `[]` operator instead of this method.
#### Argumetns:
- `index: Int`. Index of the row that needs to be returned. 

### `set(index, value): Void`
Sets the `value` row on the given `index`. You also can use `[]` operator instead of this method.
#### Arguments:
- `index: Int`. Index of the row that needs to be changed.
- `value: Array<C>`. Value that needs to be set.
