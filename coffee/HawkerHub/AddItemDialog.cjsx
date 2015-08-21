React      = require 'react'
{Cell}     = require 'react-pure'
UITheme    = require './Common/UITheme'
Icon       = require './Common/MaterialIcon'
UI         = require 'material-ui'

CancelButton = React.createClass
  mixins: [UITheme]
  render: ->
    <Icon name="close" onClick={@props.onClick} />

CameraButton = React.createClass
  mixins: [UITheme]
  render: ->
    <Icon name="photo_camera" onClick={@props.onClick} overrideColor="grey" />

FileUploadButton = React.createClass
  mixins: [UITheme]
  render: ->
    <Icon name="cloud_upload" onClick={@props.onClick} overrideColor="grey" />

ConfirmButton = React.createClass
  mixins: [UITheme]
  render: ->
    <Icon name="check" onClick={@props.onClick}overrideColor="green" />

module.exports = React.createClass
  mixins: [UITheme]
  handleSubmit: -> @refs.dialog.dismiss()
  handleCancel: -> @refs.dialog.dismiss()
  getInitialState: ->
    actions: [
      <ConfirmButton onClick={@handleCancel} />
      <CancelButton onClick={@handleCancel} />,
    ]
  show: -> @refs.dialog.show()
  render: ->
    <UI.Dialog ref="dialog" actions={@state.actions} modal={false}>
      <Cell className="add-dialog">
        <Cell size='1/2'>
          <Cell>
            <UI.TextField
                hintText="Food Name"
                floatingLabelText="Food Name" />
          </Cell>
          <Cell>
            <UI.TextField
                hintText="Stall Name"
                floatingLabelText="Stall Name" />
          </Cell>
          <Cell>
            <UI.CircularProgress mode="indeterminate" size={0.4} />
            <small>Detecting your location</small>
          </Cell>
        </Cell>
        <Cell size='1/2'>
          <img src="../assets/upload_picture.png" width="100%" />
          <CameraButton onTouchTap={@handleCancel} />
          <FileUploadButton onTouchTap={@handleCancel} />
        </Cell>
      </Cell>
    </UI.Dialog>
