React = require 'react'
isRetina = require 'is-retina'
isArray = require 'isarray'
imageExists = require 'image-exists'
path = require 'path'
objectAssign = require 'object-assign'

module.exports = React.createClass
  displayName: 'RetinaImage'

  propTypes:
    src: React.PropTypes.oneOfType([
      React.PropTypes.string
      React.PropTypes.array
    ]).isRequired
    checkIfRetinaImgExists: React.PropTypes.bool
    retinaImageSuffix: React.PropTypes.string
    handleOnLoad: React.PropTypes.func # Deprecated.
    onLoad: React.PropTypes.func
    onError: React.PropTypes.func

  getDefaultProps: ->
    checkIfRetinaImgExists: true
    forceOriginalDimensions: true
    retinaImageSuffix: '@2x'
    onError: ->

  componentWillReceiveProps: (nextProps) ->
    # The src has changed, null everything out.
    if nextProps.src isnt @props.src
      @setState objectAssign @wrangleProps(nextProps), {
        width: null
        height: null
        imgLoaded: null
        retinaImgExists: null
        retinaCheckComplete: null
      }

  getInitialState: ->
    @wrangleProps()

  componentDidMount: ->
    @checkForRetina()

  componentDidUpdate: ->
    @checkForRetina()

  render: ->
    props = @props

    # Don't override passed in width/height.
    if @state?.width and not @props.width?
      props.width = @state.width
    if @state?.height and not @props.height?
      props.height = @state.height

    <img
      ref="img"
      {...@props}
      src={@state.src}
      onError={@props.onError}
      onLoad={@handleOnLoad} />

  # src can be a href or an array of hrefs.
  wrangleProps: (props=@props) ->
    if isArray(props.src)
      return {
        src: props.src[0]
        srcIsArray: true
      }
    else
      return {
        src: props.src
        srcIsArray: false
      }

  checkForRetina: ->
    if @state.retinaCheckComplete then return

    if isRetina() and @props.checkIfRetinaImgExists
      imageExists @getRetinaPath(), (exists) =>
        # If original image has loaded already (we have to wait so we know
        # the original image dimensions), then set the retina image path.
        if exists and @state?.imgLoaded
          @swapSrc @getRetinaPath()
        else if exists
          @setState retinaImgExists: true

    # If the check isn't needed, immediately swap in the retina path
    else if isRetina() and not @props.checkIfRetinaImgExists
      @swapSrc @getRetinaPath()

    @setState retinaCheckComplete: true

  handleOnLoad: (e) ->
    # Customers of component might care when the image loads.
    if @props.onLoad?
      @props.onLoad(e)
    # handleOnLoad was in an earlier version (wrong name) and will be removed
    # at the next major release.
    if @props.handleOnLoad?
      @props.handleOnLoad(e)

    if @props.forceOriginalDimensions
      @setState {
        width: @refs.img.getDOMNode().clientWidth
        height: @refs.img.getDOMNode().clientHeight
      }

    @setState imgLoaded: true

    # If the retina image check has already finished, set the 2x path.
    if @state?.retinaImgExists
      @swapSrc @getRetinaPath()

  getRetinaPath: ->
    if @state.srcIsArray
      return @props.src[1]
    else
      basename = path.basename(@props.src, path.extname(@props.src))
      basename = basename + @props.retinaImageSuffix + path.extname(@props.src)
      src = @props.src.replace(path.basename(@props.src), basename)
      return src

  swapSrc: (src) ->
    @refs.img.getDOMNode().src = src
