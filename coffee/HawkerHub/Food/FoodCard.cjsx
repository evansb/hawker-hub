React       = require 'react'
TextArea    = require 'react-textarea-autosize'
UI          = require 'material-ui'
UITheme     = require '../Common/UITheme'
Icon        = require '../Common/MaterialIcon'
$           = require 'jquery'
_           = require 'lodash'
moment      = require 'moment'

{ UserStore, UserAction } = require '../../Entity/User'

Overlay = React.createClass
  render: -> <h1>{@props.text}</h1>

Photo = React.createClass
  render: ->
    <div className="photo">
      <span className="helper"></span>
      <UI.CardMedia overlay={<Overlay text={@props.title} className="overlay" />}>
        <img className="u-full-width u-max-full-width"
            src={@props.src} />
      </UI.CardMedia>
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
          <Toolbar />
        </div>
      </div>
      <InfoHeader likes={@props.likes} date={@props.date} />
      <Caption text={@props.caption} />
    </div>

Description = React.createClass
  mixins: [UITheme]
  render: -> <UI.CardText> {@props.text} </UI.CardText>

Toolbar = React.createClass
  mixins: [UITheme]
  render: ->
    <UI.CardActions>
      <Icon name="favorite_border"/>
      <Icon name="share"/>
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
  render: ->
    authorId = @props.model.user.providerUserId
    authorPicture = "https://graph.facebook.com/v2.4/#{authorId}/picture"
    <UI.Paper zDepth={1} className="row food-card">
      <div className="six columns left-column">
        <Photo title={@props.model.itemName} src={@props.model.photoURL} />
      </div>
      <div className="six columns right-column">
        <Header name={@props.model.user.displayName}
                avatar={authorPicture}
                caption={@props.model.caption}
                date={@props.model.addedDate}
                likes={@props.model.likes} />
        <Comments comment={@props.model.comments} />
        <div className="new-comment">
          <TextArea minRows={1} placeholder="Add a comment..."></TextArea>
        </div>
      </div>
    </UI.Paper>
