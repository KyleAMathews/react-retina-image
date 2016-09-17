React = require 'react'
ReactDOM = require 'react-dom'
Examples = require './examples'

# Rendering components directly into document.body is discouraged,
# since its children are often manipulated by third-party scripts and browser extensions.
# This may lead to subtle reconciliation issues.
containerEl = document.createElement('DIV')
document.body.appendChild(containerEl)
ReactDOM.render(<Examples />, containerEl)
