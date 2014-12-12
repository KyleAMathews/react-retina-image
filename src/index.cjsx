React = require 'react'
isRetina = require 'is-retina'
imageExists = require 'image-exists'
path = require 'path'

module.exports = React.createClass
  displayName: 'RetinaImage'

  propTypes:
    src: React.PropTypes.string.isRequired
    checkIfRetinaImgExists: React.PropTypes.bool
    retinaImageSuffix: React.PropTypes.string
    handleOnLoad: React.PropTypes.func

  getDefaultProps: ->
    checkIfRetinaImgExists: true
    forceOriginalDimensions: true
    retinaImageSuffix: '@2x'
    handleOnLoad: ->

  componentDidMount: ->
    if isRetina() and @props.checkIfRetinaImgExists
      imageExists @getRetinaPath(), (exists) =>
        # If original image has loaded already (we have to wait so we know
        # the original image dimensions), then set the retina image path.
        if exists and @state?.imgLoaded
          @swapSrc @getRetinaPath()
        else
          @setState retinaImgExists: true
    # If the check isn't needed, immediately swap in the retina path
    else if isRetina() and not @props.checkIfRetinaImgExists
      @swapSrc @getRetinaPath()

  render: ->
    props = @props
    # Don't override passed in width/height.
    if @state?.width and not @props.width?
      props.width = @state.width
    if @state?.height and not @props.height?
      props.height = @state.height

    <img ref="img" {...@props} onLoad={@handleOnLoad} />

  handleOnLoad: (e) ->
    # Customers of component might care when the image loads.
    @props.handleOnLoad(e)

    if @props.forceOriginalDimensions
      @setState {
        width: @refs.img.getDOMNode().clientWidth
        height: @refs.img.getDOMNode().clientHeight
      }

    @setState imgLoaded: true

    # If the retina image check has already finished, set the 2x path.
    if @state?.retinaImgExists
      @swapSrc getRetinaPath()

  getRetinaPath: ->
    basename = path.basename(@props.src, path.extname(@props.src))
    basename = basename + @props.retinaImageSuffix + path.extname(@props.src)
    src = @props.src.replace(path.basename(@props.src), basename)
    return src

  swapSrc: (src) ->
    @refs.img.getDOMNode().src = src
