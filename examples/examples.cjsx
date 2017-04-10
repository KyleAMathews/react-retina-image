React = require('react')
RetinaImage = require '../src/index'
isRetina = require 'is-retina'
_ = require 'underscore'

module.exports = class Examples extends React.Component
  constructor: (props) ->
    super props
    @state =
      picsArray: [
        './tower.jpg'
        './path.jpg'
        './ocean.jpg'
      ]
      picIndex: 0

  render: ->
    <div style={"maxWidth":'500px', margin:'0 auto'}>
      <h1>React-retina-image</h1>
      <a href="https://github.com/KyleAMathews/react-retina-image">Code on Github</a>
      <br />
      <br />
      {if isRetina() then <h2>Your screen is retina!</h2> else <h2>Your screen is not retina</h2>}

      {if isRetina()
        <h3>This image loaded its retina version after checking if it exists</h3>
       else
        <h3>This image won't load its retina version</h3>
      }
      <pre><code>
      {"""
      <RetinaImage src="./tower.jpg" />
        """}
      </code></pre>
      <RetinaImage src="./tower.jpg" />

      <h3>This image doesn't have a @2x version so stays at its lower resolution version</h3>
      <pre><code>
      {"""
      <RetinaImage src="./path.jpg" />
        """}
      </code></pre>
      <RetinaImage src="./path.jpg" />

      <h3>If you know there's a retina image available, you can disable the check.</h3>
      <pre><code>
      {"""
      <RetinaImage
       src="./ocean.jpg"
       checkIfRetinaImgExists=false
       width=500 />
        """}
      </code></pre>
      <RetinaImage src="./ocean.jpg" checkIfRetinaImgExists=false width=500 />

      <h3>If you don't have predictable names for the retina and non-retina
      versions of images, you can simply pass in an array of images as src where
      the first src is the non-retina version and the second is the retina version.
      </h3>
      <pre><code>
      {"""
      <RetinaImage
       src={["./houses.jpg", "./bigger-version-of-houses.jpg"]} />
        """}
      </code></pre>
      <RetinaImage
        style={{width: 500}}
        src={["./houses.jpg", "./bigger-version-of-houses.jpg"]}
      />

      <h3>For testing updates. Click on the image and it'll cycle forward
      through pictures</h3>
      <pre><code>
      {"""
      <RetinaImage
       style={{width: 500}}
       onClick={@cyclePics}
       src={@state.picsArray[@state.picIndex]} />
        """}
      </code></pre>
      <RetinaImage
        style={{width: 500}}
        onClick={@cyclePics}
        src={@state.picsArray[@state.picIndex]} />

    </div>

  cyclePics: =>
    newIndex = @state.picIndex + 1
    if newIndex > 2
      newIndex = 0

    @setState picIndex: newIndex
