$          = require 'jquery'
App        = require 'ampersand-app'
React      = require 'react'
Modal      = require 'react-modal'
Image      = require 'react-retina-image'
UI         = require 'material-ui'
UITheme    = require '../Common/UITheme'
Icon       = require '../Common/MaterialIcon'
TextArea   = require 'react-textarea-autosize'
{UserAction} = require '../../Entity/User'
{FoodAction} = require '../../Entity/Food'
{User} = require '../../Entity/User'

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
    imageSrc: "../assets/empty-plates@2x.jpg"
    inputHasBg: true
    dataURI: null
  triggerUpload: ->
    $(React.findDOMNode(@refs.fileInput)).trigger 'click'
  imageIsLoaded: (e) ->
    $(React.findDOMNode(this)).imagefit
      mode: 'outside'
      force: true
      halign: 'center'
      valign: 'middle'
    @setState { imageSrc: e.target.result, inputHasBg: false }
  componentDidMount: -> UserAction.watch()
  getInputStyle: ->
    background: if (@state.inputHasBg) then '#f1f1f1' else 'rgba(0,0,0,0.5)'
    color: if (!@state.inputHasBg) then 'white' else '#B92B27'
  handleSubmit: (e) ->
    e.preventDefault()
    formData = new FormData()
    formData.append 'photoData', @refs.fileInput.getDOMNode().files[0]
    uploadPhoto = ->
      $.ajax
        type: 'POST'
        url: App.urlFor 'item/photo'
        data: formData
        contentType: false
        processData: false
        success: (data) -> postImage data.photoURL
        error: (e) ->
          postImage 'http://hawkerhub.quanyang.me/api/v1/item/photo/ID-100180410.jpg'
    postImage = (photoURL) =>
      FoodAction.create
        itemName: React.findDOMNode(@refs.foodName).value
        photoURL: photoURL
        caption: @refs.caption.value
        latitude: User.latitude
        longtitude: User.longitude
    uploadPhoto()

  handleFile: (self) -> (e) ->
    reader = new FileReader()
    file = e.target.files[0]
    reader.onload = self.imageIsLoaded
    reader.readAsDataURL file
  render: ->
    <UI.Card className="food-card add-dialog">
      <form onSubmit={@handleSubmit} encType="multipart/form-data">
        <div className="row">
          <div className='six columns left-column'>
            <div onClick={@triggerUpload}
                 className="row upload-placeholder-container">
              <input ref="fileInput" type='file' style={{display: 'none'}}
                     onChange={@handleFile(this)} />
              <img className="u-max-full-width" src={@state.imageSrc} />
            </div>
            <div className="row">
              <div className="overlay overlay-add-item">
                <input type="text" className="new-food"
                       ref="foodName"
                       style={@getInputStyle()}
                       placeholder="Click to Edit Name..."/>
              </div>
            </div>
          </div>
          <div className='six columns right-column'>
            <TextArea ref="caption"
                      placeholder='Describe more about this menu...' minRows={3} >
            </TextArea>
            <div className="row">
              <div className="eight columns toggle">
                <UI.Toggle name="upload_fb" value="upload_fb"
                           labelPosition="right"
                           label="Share to Facebook"/>
              </div>
              <div className="four columns buttons">
                <UI.FlatButton label="Post" type="submit"/>
              </div>
            </div>
          </div>
        </div>
      </form>
    </UI.Card>
