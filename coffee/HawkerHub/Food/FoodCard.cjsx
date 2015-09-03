React       = require 'react'
TextArea    = require 'react-textarea-autosize'
UI          = require 'material-ui'
UITheme     = require '../Common/UITheme'
Icon        = require '../Common/MaterialIcon'
$           = require 'jquery'
_           = require 'lodash'
moment      = require 'moment'

{ User, UserAction } = require '../../Entity/User'
{ FoodAction } = require '../../Entity/Food'
{ SingleFoodAction } = require '../../Entity/SingleFood'

Photo = React.createClass
  style:
    'background-image': "linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5))"
  render: ->
     <div>
       <div className="photo">
         <img ref="img" className="u-full-width u-max-full-width u-max-full-height"
              src={@props.src} />
       </div>
       <div className="overlay">
         <h1>{@props.title}</h1>
       </div>
     </div>

InfoHeader = React.createClass
  render: ->
    userLikeThis = User.id in _.map @props.likes, (like) -> like.user.providerUserId
    likes = _.filter @props.likes, (like) -> like.user.providerUserId != User.id
    samplePeople = _(@props.likes)
      .filter((like) -> like.user.providerUserId != User.id)
      .map((like) -> like.user.displayName)
      .take(3)
    if @props.likes.length is 0
      result = "0 likes"
    else
      more = @props.likes.length - samplePeople.length - (if userLikeThis then 1 else 0)
      more = if more > 0 then (" and " + more + " other people") else ""
      result = if userLikeThis then "You" else ""
      if samplePeople.size() > 0
        if result != ""
          result = [result].concat(samplePeople).join(", ")
        else
          result = samplePeople.join(", ")
      result = result + more + " like this"
    <div className="row">
      <div className="nine columns likes">
        {result}
      </div>
      <div className="three columns ago">
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
        <div className="eight columns user">
          <UI.CardHeader title={@props.name} avatar={@props.avatar} />
        </div>
        <div className="four columns toolbar">
          <Toolbar itemId={@props.itemId} likes={@props.likes} />
        </div>
      </div>
      <InfoHeader likes={@props.likes} date={@props.date} />
      <Caption text={@props.caption} />
    </div>

Description = React.createClass
  mixins: [UITheme]
  render: -> <UI.CardText> {@props.text} </UI.CardText>

LikeButton = React.createClass
  handleLike: (method) ->
    FoodAction.like { itemId: @props.itemId, key: @props.key }
    SingleFoodAction.like @props.itemId
  handleUnlike: ->
    FoodAction.unlike { itemId: @props.itemId, key: @props.key }
    SingleFoodAction.unlike @props.itemId
  render: ->
    iconName = 'favorite_border'
    handler = @handleLike
    for like in @props.likes
      if like.user.providerUserId is User.id
        iconName = 'favorite'
        handler = @handleUnlike
        break
    <Icon name={iconName} onClick={handler} />

ShareButton = React.createClass
  handleClick: ->
    config =
      method: 'share',
      href: "http://#{API_HOST}/food/#{@props.itemId}"
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
      <LikeButton itemId={@props.itemId } likes={@props.likes} />
      <ShareButton itemId={@props.itemId} />
    </UI.CardActions>

Comments = React.createClass
  mixins: [UITheme]
  render: ->
    comments = _.map @props.comments, (comment, idx) ->
      <li key={idx}>
        <strong>{comment.user.displayName}</strong>&nbsp;{comment.message}
      </li>
    <div className="comment-list">
      <ul>{comments}</ul>
    </div>

module.exports = React.createClass
  mixins: [UITheme]
  handleAddComment: ->
    commentBox = React.findDOMNode @refs.commentBox
    comment = @refs.commentBox.value
    $(commentBox).blur().val('').attr('enable', false)
    console.log @props.model.itemId
    FoodAction.addComment
      itemId: @props.model.itemId
      value: comment
  componentDidMount: ->
    commentBox = React.findDOMNode @refs.commentBox
    $(commentBox).find('textarea').each ->
      $(this).attr('enable', true)
    $(React.findDOMNode(@refs.commentBox)).keyup (e) =>
      e = e or event
      @handleAddComment() if e.keyCode is 13
      e.preventDefault()
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
        <Comments comments={@props.model.comments} />
        <div className="new-comment">
          <TextArea minRows={1} maxRows={1} ref="commentBox"
                    placeholder="Add a comment..."></TextArea>
        </div>
      </div>
    </UI.Paper>
