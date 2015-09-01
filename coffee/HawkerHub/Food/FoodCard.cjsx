React       = require 'react'
TextArea    = require 'react-textarea-autosize'
UI          = require 'material-ui'
UITheme     = require '../Common/UITheme'
Icon        = require '../Common/MaterialIcon'
$           = require 'jquery'
_           = require 'lodash'
moment      = require 'moment'

{ User, UserAction } = require '../../Entity/User'

Overlay = React.createClass
  render: -> <h1>{@props.text}</h1>

Photo = React.createClass
  style:
    'background-image': "linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5))"
  render: ->
     <div>
       <div className="photo">
         <img className="u-full-width" src={@props.src} />
       </div>
       <div className="overlay">
        <Overlay text={@props.title} />
       </div>
     </div>

InfoHeader = React.createClass
  render: ->
    <div className="row">
      <div className="two columns likes">
        {@props.likes.length} likes
      </div>
      <div className="ten columns ago">
        {moment(@props.date).fromNow()}
      </div>
    </div>

Caption = React.createClass
  mixins: [UITheme]
  render: ->
    <div className="row">
      <UI.CardText>{@props.text}</UI.CardText>
    </div>

Header = React.createClass
  mixins: [UITheme]
  render: ->
    <div>
      <div className="row">
        <div className="six columns user">
          <UI.CardHeader title={@props.name} avatar={@props.avatar} />
        </div>
        <div className="six columns toolbar">
          <Toolbar itemId={@props.itemId} />
        </div>
      </div>
      <InfoHeader likes={@props.likes} date={@props.date} />
      <Caption text={@props.caption} />
    </div>

Description = React.createClass
  mixins: [UITheme]
  render: -> <UI.CardText> {@props.text} </UI.CardText>

LoveButton = React.createClass
  render: ->
    <Icon name="favorite_border" />

ShareButton = React.createClass
  handleClick: ->
    config =
      method: 'share',
      href: "http://#{API_HOST}/#/food/#{@props.itemId}"
    FB.ui config, (response) ->
      if (response && !response.error_code)
        console.log('Posting completed.');
      else
        console.log('Error while posting.');

  render: ->
    <Icon name="share" onClick={@handleClick} />

Toolbar = React.createClass
  mixins: [UITheme]
  render: ->
    <UI.CardActions>
      <LoveButton itemId={@props.itemId }/>
      <ShareButton itemId={@props.itemId} />
    </UI.CardActions>

Comments = React.createClass
  mixins: [UITheme]
  render: ->
    comments = _.map @props.comments, (comment, idx) ->
      <UI.ListItem className="comments-box"
        secondaryText={ <textarea></textarea> }
        secondaryTextLines={2} />
    <UI.List>{comments}</UI.List>

module.exports = React.createClass
  mixins: [UITheme]
  getInitialState: ->
    modalIsOpen: false
  handleSubmit: -> @setState { modalIsOpen: false}
  handleCancel: -> @setState { modalIsOpen: false}
  componentDidMount: ->
    $(React.findDOMNode(@refs.left)).imagefit
      mode: 'outside'
      force: 'true'
      halign: 'center'
      valign: 'middle'
  render: ->
    authorId = @props.model.user.providerUserId
    authorPicture = "https://graph.facebook.com/v2.4/#{authorId}/picture"
    <UI.Paper zDepth={1} className="row food-card">
      <div ref="left" className="six columns left-column">
        <Photo title={@props.model.itemName} src={@props.model.photoURL} />
      </div>
      <div className="six columns right-column">
        <Header name={@props.model.user.displayName}
                avatar={authorPicture}
                caption={@props.model.caption}
                date={@props.model.addedDate}
                likes={@props.model.likes}
                itemId={@props.model.itemId} />
        <Comments comment={@props.model.comments} />
        <div className="new-comment">
          <TextArea minRows={1} placeholder="Add a comment..."></TextArea>
        </div>
      </div>
    </UI.Paper>
