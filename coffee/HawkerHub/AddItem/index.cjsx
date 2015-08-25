React      = require 'react'
Modal      = require 'react-modal'
Image      = require 'react-retina-image'
UI         = require 'material-ui'
UITheme    = require '../Common/UITheme'
Icon       = require '../Common/MaterialIcon'

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
        <div className="row title">
          <h3>Upload a New Item</h3>
        </div>
        <div className="row">
          <div className='six columns'>
            <div className="row upload-placeholder-container">
              <Image className="u-max-full-width" src="../assets/empty-plates.png" />
            </div>
          </div>
          <div className='six columns'>
            <div>
              <UI.TextField
                  className="food-name"
                  hintText="Food Name" />
            </div>
            <div>
              <UI.TextField
                  hintText="Caption"
                  multiLine={true} />
            </div>
          </div>
        </div>
        <div className="row buttons">
          <CameraButton onTouchTap={@handleCancel} />
          <FileUploadButton onTouchTap={@handleCancel} />
          <ConfirmButton />
        </div>
      </UI.Card>
    </Modal>
