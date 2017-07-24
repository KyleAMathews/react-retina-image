react-retina-image
==================

React component for serving high-resolution images to devices with retina displays

## Demo
http://kyleamathews.github.io/react-retina-image/

## Install
`npm install react-retina-image`

## Usage

Available props:

* `checkIfRetinaImgExists` — test if retina image exists before swapping
  it in. If you're sure there's a retina image available, it's safe to
set this to false. Defaults to true.
* `forceOriginalDimensions` — sets width/height of retina image to
  original image. Note, this doesn't work if `checkIfRetinaImgExists` is set to
false as then the original image is never loaded. In this case you'll
need to set the width manually either as a prop or using css. Defaults to true.
* `retinaImageSuffix` — defaults to `@2x` but you can change this if you
  use a different naming convention.
* `onLoad` — handle the image onLoad event.
* `onError` — handle the image onError event.
* `src` — string or array for the image srcs. [See the
  demo](http://kyleamathews.github.io/react-retina-image/) for examples
of how to format your src string or array.

```javascript
var React = require('react');
var RetinaImage = require('react-retina-image');

React.createClass({
  render: function () {
    <RetinaImage src="./images/balloon.jpg" checkIfRetinaImgExists=false />
  }
});

// Can also pass in array of srcs.
React.createClass({
  render: function () {
    <RetinaImage
       src={["./images/balloon.jpg", "./images/bigger-balloon.jpg"]} />
  }
});
```

## Attribution
This component is largely a port of
[retina.js](http://imulus.github.io/retinajs/) to React.js
