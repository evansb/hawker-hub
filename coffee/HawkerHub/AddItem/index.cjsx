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
  render: ->
    <UI.Card className="food-card add-dialog">
      <div className="row">
        <div className='six columns left-column'>
          <div className="row upload-placeholder-container">
            <Image className="u-max-full-width" src="../assets/empty-plates.png" />
          </div>
          <div className="row">
            <div className="overlay">
              <input type="text" className="new-food" placeholder="Food Name..."/>
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
    </UI.Card>
