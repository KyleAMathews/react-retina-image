React = require 'react'
isRetina = require 'is-retina'
isArray = require 'isarray'
imageExists = require 'image-exists'
path = require 'path'
assign = require 'object-assign'

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
      @setState assign @wrangleProps(nextProps), {
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
    @checkLoaded()

  componentDidUpdate: ->
    @checkForRetina()

  render: ->
    <img
      ref="img"
      {...@props}
      {...@state}
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
          @setState src: @getRetinaPath()
        else if exists
          @setState retinaImgExists: true

        @setState retinaCheckComplete: true

    # If the check isn't needed, immediately swap in the retina path
    else if isRetina() and not @props.checkIfRetinaImgExists
      @setState src: @getRetinaPath()

      @setState retinaCheckComplete: true

  # For server-rendered code, sometimes images will already be loaded by the time
  # this module mounts.
  # http://stackoverflow.com/a/1977898
  checkLoaded: ->
    el = @refs.img.getDOMNode()

    unless el.complete
      return false

    if el.naturalWidth is 0
      return false

    # No other way to disprove it's loaded so we'll assume it's ok.
    @handleOnLoad()


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
      @setState src: @getRetinaPath()

  getRetinaPath: ->
    if @state.srcIsArray
      return @props.src[1]
    else
      basename = path.basename(@props.src, path.extname(@props.src))
      basename = basename + @props.retinaImageSuffix + path.extname(@props.src)
      src = @props.src.replace(path.basename(@props.src), basename)
      return src
