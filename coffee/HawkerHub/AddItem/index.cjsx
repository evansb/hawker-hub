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
{FoodAction, FoodStore} = require '../../Entity/Food'
{User, UserStore, UserAction} = require '../../Entity/User'
{LocationStore, LocationAction} = require '../../Entity/Location'

ConfirmButton = React.createClass
  mixins: [UITheme]
  render: ->
    <Icon name="check" onClick={@props.onClick} overrideColor="green" />

UploadToFB = React.createClass
  mixins: [UITheme]
  render: ->
    <UI.Checkbox name="upload_fb" value="upload_fb" label="Share"/>

LocationDetector = React.createClass
  mixins: [UITheme]
  getInitialState: ->
    address: 'Unknown Address'
    locationDetermined: false
  componentWillMount: ->
    UserAction.watch (e) ->
      LocationAction.geocode
        id: 'addItem'
        lat: User.latitude
        long: User.longitude
    LocationStore.listen (event) =>
      if event.id is 'addItem' && event.status is 'success'
        @setState { address: event.address, locationDetermined: true }
  render: ->
    <div className="row">
      <div className="one columns">
        <UI.FontIcon className="material-icons">place</UI.FontIcon>
      </div>
      <div className="eleven columns">
        { if !(@state.locationDetermined)
            "Detecting your location..."
          else
            @state.address
        }
      </div>
    </div>

module.exports = React.createClass
  mixins: [UITheme]
  getInitialState: ->
    imageSrc: "../assets/empty-plates@2x.jpg"
    inputHasBg: true
    dataURI: null
    isUploading: false
    imageContainerValid: true
    nameValid: true
    captionValid: true
    inputValidation: ""
  triggerUpload: ->
    $(React.findDOMNode(@refs.fileInput)).trigger 'click'
  imageIsLoaded: (e) ->
    $(React.findDOMNode(this)).imagefit
      mode: 'outside'
      force: true
      halign: 'center'
      valign: 'middle'
    @setState { imageSrc: e.target.result, inputHasBg: false }
  componentWillMount: ->
    FoodStore.listen (e) =>
      if e.name is 'created'
        @setState {isUploading: false}
  componentDidMount: ->
    $(React.findDOMNode(this)).slideDown 'slow'
  getInputStyle: ->
    background: if (@state.inputHasBg) then '#f1f1f1' else 'rgba(0,0,0,0.5)'
    color: if (!@state.inputHasBg) then 'white' else '#B92B27'
    border: if (@state.nameValid) then 'none' else 'solid 3px #B92B27'
  validateInput: (callback) ->
    condition1 = !@state.inputHasBg
    condition2 = React.findDOMNode(@refs.foodName).value.trimLeft().length > 0
    condition3 = @refs.caption.value.trimLeft().length > 0
    @setState { imageContainerValid: condition1, nameValid: condition2, captionValid: condition3 }
    condition1 && condition2 && condition3
  handleSubmit: (e) ->
    e.preventDefault()
    if !@validateInput() then return
    formData = new FormData()
    formData.append 'photoData', @refs.fileInput.getDOMNode().files[0]
    @setState { isUploading: true }
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
        shareToFacebook: @refs.shareToggle.isToggled()
        latitude: User.latitude
        longtitude: User.longitude
    uploadPhoto()
  handleFile: (self) -> (e) ->
    reader = new FileReader()
    file = e.target.files[0]
    if (typeof file isnt 'undefined')
      reader.onload = self.imageIsLoaded
      reader.readAsDataURL file
  redify: (valid) ->
    invalidBorder = { border: '3px solid #B92B27' }
    if !valid then invalidBorder else {}
  render: ->
    <UI.Card className="food-card add-dialog">
      <form onSubmit={@handleSubmit} encType="multipart/form-data">
        <div className="row">
          <div style={@redify(@state.imageContainerValid)}
               className='six columns left-column'>
            <div onClick={@triggerUpload}
                 className="row upload-placeholder-container">
              <input ref="fileInput" type='file' style={{display: 'none'}}
                     onChange={@handleFile(this)} />
              <img className="u-max-full-width" src={@state.imageSrc} />
            </div>
            <div className="row">
              <div className="overlay overlay-add-item">
                <input style={@getInputStyle()}
                       type="text" className="new-food"
                       maxLength={35} ref="foodName"
                       placeholder="Click to Edit Name..."/>
              </div>
            </div>
          </div>
          <div className='six columns right-column'>
            <TextArea ref="caption" style={@redify(@state.captionValid)}
                      placeholder='Describe more about this menu...'
                      minRows={3} maxLength={255}>
            </TextArea>
            <LocationDetector />
            <div className="row">
              <div className="eight columns toggle">
                <UI.Toggle name="upload_fb" value="upload_fb"
                           labelPosition="right" ref="shareToggle"
                           label="Share to Facebook"/>
              </div>
              <div className="four columns buttons">
                <UI.FlatButton
                  label="Post"
                  type="submit"/>
              </div>
            </div>
          </div>
        </div>
      </form>
      { if @state.isUploading then <UI.LinearProgress mode="indeterminate" /> }
    </UI.Card>
