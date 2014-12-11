React = require 'react'
isRetina = require 'is-retina'
imageExists = require 'image-exists'
path = require 'path'

module.exports = React.createClass
  displayName: 'RetinaImage'

  getInitialState: ->
    if isRetina() and not @props.checkIf2xExists
      src: @get2xPath()
    else
      src: @props.src

  propTypes:
    src: React.PropTypes.string.isRequired
    checkIf2xExists: React.PropTypes.bool
    retinaImageSuffix: React.PropTypes.string
    handleOnLoad: React.PropTypes.func

  getDefaultProps: ->
    checkIf2xExists: true
    forceOriginalDimensions: true
    retinaImageSuffix: '@2x'
    handleOnLoad: ->

  componentWillMount: ->
    if isRetina() and @props.checkIf2xExists
      imageExists(@get2xPath(), (exists) =>
        # If original image has loaded already (we have to wait so we know
        # the original image dimensions), then set the retina image path.
        if exists and @state.imgLoaded
          @setState src: @get2xPath()
        else
          @setState retinaImgExists: true
      )

  render: ->
    props = @props
    # Don't override passed in width/height.
    if @state.width and not @props.width?
      props.width = @state.width
    if @state.height and not @props.height?
      props.height = @state.height

    <img ref="img" {...@props} src={@state.src} onLoad={@handleOnLoad} />

  handleOnLoad: (e) ->
    # Customers of component might care when the image loads.
    @props.handleOnLoad(e)

    # This is generally you want unless manually controlling width.
    if @props.forceOriginalDimensions
      @setState {
        width: @refs.img.getDOMNode().clientWidth
        height: @refs.img.getDOMNode().clientHeight
      }

    @setState imgLoaded: true

    # If the retina image check has already finished, set the 2x path.
    if @state.retinaImgExists
      @setState src: get2xPath()

  get2xPath: ->
    basename = path.basename(@props.src, path.extname(@props.src))
    basename = basename + @props.retinaImageSuffix + path.extname(@props.src)
    src = @props.src.replace(path.basename(@props.src), basename)
    return src
