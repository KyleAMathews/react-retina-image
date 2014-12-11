React = require('react')
RetinaImage = require '../src/index'
isRetina = require 'is-retina'

module.exports = React.createClass
  render: ->
    <div style={"max-width":'500px', margin:'0 auto'}>
      <h1>React-retina-image</h1>
      <a href="https://github.com/KyleAMathews/react-retina-image">Code on Github</a>
      <br />
      <br />
      {if isRetina() then <h2>Your screen is retina!</h2> else <h2>Your screen is not retina</h2>}

      <h3>This image has a @2x version</h3>
      <pre><code>
      {"""
      <RetinaImage src="./tower.jpg" />
        """}
      </code></pre>
      <RetinaImage src="./tower.jpg" />

      <h3>This image doesn't have a @2x version so keeps the lower resolution version</h3>
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
       checkIf2xExists=false
       width=500 />
        """}
      </code></pre>
      <RetinaImage src="./ocean.jpg" checkIf2xExists=false width=500 />

    </div>
