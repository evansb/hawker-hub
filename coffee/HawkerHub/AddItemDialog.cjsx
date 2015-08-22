React      = require 'react'
Modal      = require 'react-modal'
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
    <div className="row add-dialog">
      <UI.Dialog ref="dialog" actions={@state.actions} modal={false}>
          <div size='eight columns'>
            <img src="../assets/upload_picture.png" width="100%" />
            <CameraButton onTouchTap={@handleCancel} />
            <FileUploadButton onTouchTap={@handleCancel} />
          </div>
          <div size='four columns'>
            <div>
              <UI.TextField
                  hintText="Food Name"
                  floatingLabelText="Food Name" />
            </div>
            <div>
              <UI.TextField
                  hintText="Stall Name"
                  floatingLabelText="Stall Name" />
            </div>
            <div>
              <UI.CircularProgress mode="indeterminate" size={0.4} />
              <small>Detecting your location</small>
            </div>
          </div>

      <ConfirmButton onClick={@handleCancel} />
      <CancelButton onClick={@handleCancel} />,
      </UI.Dialog>
    </div>
###
    <Modal className="food-card-detail"
       isOpen = { @state.modalIsOpen }
       onRequestClose = { @handleCancel }
       ref="dialog" modal={false}>
      <UI.Card>
          <div className="row">
            <div className="six columns">
              <Photo />
              <Title />
              <Description />
              <Toolbar />
            </div>
            <div className="six columns food-card-detail-comments">
              <Comments />
            </div>
          </div>
      </UI.Card>
    </Modal>
###
