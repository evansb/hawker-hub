React      = require 'react'
Modal      = require 'react-modal'
Image      = require 'react-retina-image'
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
  handleSubmit: -> @setState { modalIsOpen: false }
  handleCancel: -> @setState { modalIsOpen: false }
  getInitialState: ->
    modalIsOpen: false
    actions: [
      <ConfirmButton onClick={@handleCancel} />
      <CancelButton onClick={@handleCancel} />,
    ]
  show: -> @setState { modalIsOpen: true }
  render: ->
    <Modal className="add-dialog"
       isOpen = { @state.modalIsOpen }
       onRequestClose = { @handleCancel }
       ref="dialog" modal={false}>
      <UI.Card>
        <div className="row">
          <div className='six columns'>
            <div className="row upload-placeholder-container">
              <Image className="u-max-full-width" src="../assets/empty-plates.png" />
            </div>
            <div className="row">
              <CameraButton onTouchTap={@handleCancel} />
              <FileUploadButton onTouchTap={@handleCancel} />
            </div>
          </div>
          <div className='six columns'>
            <div>
              <UI.TextField
                  hintText="Food Name" />
            </div>
            <div>
              <UI.TextField
                  hintText="Stall Name" />
            </div>
            <div>
              <UI.TextField
                  hintText="Description"
                  multiLine={true} />
            </div>
            <div>
              <UI.CircularProgress mode="indeterminate" size={0.4} />
              <small>Detecting your location</small>
            </div>
          </div>
          <ConfirmButton onClick={@handleCancel} />
          <CancelButton onClick={@handleCancel} />
        </div>
      </UI.Card>
    </Modal>
