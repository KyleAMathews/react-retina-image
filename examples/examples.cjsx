{crel} = require "teact"
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
    crel("div", {"style": ("maxWidth":'500px', margin:'0 auto')},
      crel("h1", null, "React-retina-image"),
      crel("a", {"href": "https://github.com/KyleAMathews/react-retina-image"}, "Code on Github"),
      crel("br", null),
      crel("br", null),
      (if isRetina() then crel("h2", null, "Your screen is retina!") else crel("h2", null, "Your screen is not retina")),

      (if isRetina()
        crel("h3", null, "This image loaded its retina version after checking if it exists")
       else
        crel("h3", null, "This image won\'t load its retina version")
      ),
      crel("pre", null, crel("code", null,
      ("""
      <RetinaImage src="./tower.jpg" />
        """)
      )),
      crel(RetinaImage, {"src": "./tower.jpg"}),

      crel("h3", null, "This image doesn\'t have a @2x version so stays at its lower resolution version"),
      crel("pre", null, crel("code", null,
      ("""
      <RetinaImage src="./path.jpg" />
        """)
      )),
      crel(RetinaImage, {"src": "./path.jpg"}),

      crel("h3", null, "If you know there\'s a retina image available, you can disable the check."),
      crel("pre", null, crel("code", null,
      ("""
      <RetinaImage
       src="./ocean.jpg"
       checkIfRetinaImgExists=false
       width=500 />
        """)
      )),
      crel(RetinaImage, {"src": "./ocean.jpg", "checkIfRetinaImgExists": false, "width": 500}),

      crel("h3", null, """If you don\'t have predictable names for the retina and non-retina
      versions of images, you can simply pass in an array of images as src where
      the first src is the non-retina version and the second is the retina version.
"""),
      crel("pre", null, crel("code", null,
      ("""
      <RetinaImage
       src={["./houses.jpg", "./bigger-version-of-houses.jpg"]} />
        """)
      )),
      crel(RetinaImage, { \
        "style": ({width: 500}),  \
        "src": (["./houses.jpg", "./bigger-version-of-houses.jpg"])
      }),

      crel("h3", null, """For testing updates. Click on the image and it\'ll cycle forward
      through pictures"""),
      crel("pre", null, crel("code", null,
      ("""
      <RetinaImage
       style={{width: 500}}
       onClick={@cyclePics}
       src={@state.picsArray[@state.picIndex]} />
        """)
      )),
      crel(RetinaImage, { \
        "style": ({width: 500}),  \
        "onClick": (@cyclePics),  \
        "src": (@state.picsArray[@state.picIndex])})

    )

  cyclePics: =>
    newIndex = @state.picIndex + 1
    if newIndex > 2
      newIndex = 0

    @setState picIndex: newIndex
