React       = require 'react'
UI          = require 'material-ui'
UITheme     = require '../Common/UITheme'
Icon        = require '../Common/MaterialIcon'
$           = require 'jquery'
_           = require 'lodash'
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

UserHeader = React.createClass
  mixins: [UITheme]
  render: ->
    <div>
      <div className="row">
        <div className="six columns user">
          <UI.CardHeader title={@props.text}
                         avatar={@props.avatar} />
        </div>
        <div className="six columns toolbar">
          <Toolbar />
        </div>
      </div>
      <div className="row">
        <UI.CardText>{@props.caption}</UI.CardText>
      </div>
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
        key={idx} leftAvatar={<UI.Avatar src={UserStore.getProfilePicture()} />}
        secondaryText={ <textarea></textarea> }
        secondaryTextLines={2} />
    newComment =
      <UI.ListItem className="comments-box"
          key={comments.length}
          leftAvatar={<UI.Avatar src={UserStore.getProfilePicture()} />}
          secondaryText={ <textarea></textarea> }
          secondaryTextLines={2} />
    comments.push newComment
    <div>
      <UI.List subheader="Comments (0)">
        {comments}
      </UI.List>
    </div>

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
        <UserHeader text={@props.model.user.displayName}
                    avatar={authorPicture}
                    caption={@props.model.caption} />
        <Comments comment={@props.model.comments}/>
      </div>
    </UI.Paper>
