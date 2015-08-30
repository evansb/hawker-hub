React      = require 'react'
Modal      = require 'react-modal'
Image      = require 'react-retina-image'
UI         = require 'material-ui'
UITheme    = require '../Common/UITheme'
Icon       = require '../Common/MaterialIcon'
TextArea   = require 'react-textarea-autosize'

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

UploadToFB = React.createClass
  mixins: [UITheme]
  render: ->
    <UI.Checkbox name="upload_fb" value="upload_fb" label="Share on Facebook"/>

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
    <UI.Card className="add-dialog">
      <div className="row">
        <div className='six columns left-column'>
          <div className="row upload-placeholder-container">
            <Image className="u-max-full-width" src="../assets/empty-plates.png" />
          </div>
          <div className="row">  
            <input type='text' className='food-name' placeholder='Food Name' />
          </div>
        </div>
        <div className='six columns right-column'>
          <TextArea placeholder='Describe more about this menu...' minRows={3} ></TextArea>
          <div className="row buttons">
            <div className="six columns">
              <UploadToFB />
            </div>
            <ConfirmButton onTouchTap={@handleCancel} />
          </div>
        </div>
      </div>
    </UI.Card>
