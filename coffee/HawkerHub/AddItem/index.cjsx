$          = require 'jquery'
React      = require 'react'
Modal      = require 'react-modal'
Image      = require 'react-retina-image'
UI         = require 'material-ui'
UITheme    = require '../Common/UITheme'
Icon       = require '../Common/MaterialIcon'
TextArea   = require 'react-textarea-autosize'

ConfirmButton = React.createClass
  mixins: [UITheme]
  render: ->
    <Icon name="check" onClick={@props.onClick} overrideColor="green" />

UploadToFB = React.createClass
  mixins: [UITheme]
  render: ->
    <UI.Checkbox name="upload_fb" value="upload_fb" label="Share"/>

module.exports = React.createClass
  mixins: [UITheme]
  getInitialState: ->
    imageSrc: "../assets/empty-plates.png"
    inputHasBg: true
  triggerUpload: ->
    $(React.findDOMNode(@refs.fileInput)).trigger 'click'
  imageIsLoaded: (e) ->
    $(React.findDOMNode(this)).imagefit
      mode: 'outside'
      force: 'true'
      halign: 'center'
      valign: 'middle'
    @setState { imageSrc: e.target.result, inputHasBg: false }
  getInputStyle: ->
    background: if (@state.inputHasBg) then 'rgba(255,255,255, 0.1)' else 'none'
  handleSubmit: (e) -> e.preventDefault()
  handleFile: (self) -> (e) ->
    reader = new FileReader()
    file = e.target.files[0]
    reader.onload = self.imageIsLoaded
    reader.readAsDataURL file
  render: ->
    <UI.Card className="food-card add-dialog">
      <form onSubmit={-> } encType="multipart/form-data">
        <div className="row">
          <div className='six columns left-column'>
            <div onClick={@triggerUpload}
                 className="row upload-placeholder-container">
              <input ref="fileInput" type='file' style={{display: 'none'}}
                     onChange={@handleFile(this)} />
              <img className="u-max-full-width" src={@state.imageSrc} />
            </div>
            <div className="row">
              <div className="overlay">
                <input type="text" className="new-food"
                       style={@getInputStyle()}
                       placeholder="Food Name..."/>
              </div>
            </div>
          </div>
          <div className='six columns right-column'>
            <TextArea placeholder='Describe more about this menu...' minRows={3} >
            </TextArea>
            <div className="row">
              <div className="eight columns toggle">
                <UI.Toggle name="upload_fb" value="upload_fb"
                           labelPosition="right"
                           label="Share to Facebook"/>
              </div>
              <div className="four columns buttons">
                <UI.FlatButton label="Post" />
              </div>
            </div>
          </div>
        </div>
      </form>
    </UI.Card>
