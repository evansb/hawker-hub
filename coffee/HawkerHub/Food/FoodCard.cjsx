React       = require 'react'
TextArea    = require 'react-textarea-autosize'
UI          = require 'material-ui'
UITheme     = require '../Common/UITheme'
Icon        = require '../Common/MaterialIcon'
$           = require 'jquery'
_           = require 'lodash'
moment      = require 'moment'

{ User, UserAction }              = require '../../Entity/User'
{ FoodAction }                    = require '../../Entity/Food'
{ LocationAction, LocationStore } = require '../../Entity/Location'
{ SingleFoodAction }              = require '../../Entity/SingleFood'

Photo = React.createClass
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
      <div className="eight columns likes">
        {result}
      </div>
      <div className="four columns ago">
        {moment(@props.date).fromNow()}
      </div>
    </div>

Header = React.createClass
  mixins: [UITheme]
  getInitialState: ->
    location: if (@props.lat && @props.long) then 'View on Map' else 'Unknown'
    locationValid: (@props.lat && @props.long)
  componentWillMount: ->
    LocationStore.listen (event) =>
      if event.id is @props.itemId && event.status is 'success'
        @setState { location: event.address, locationValid: true }
  componentDidMount: ->
    LocationAction.geocode
      id: @props.itemId
      lat: @props.lat
      long: @props.long
  render: ->
    mapUrl = "https://www.google.com/maps?q=#{@props.lat},#{@props.long}"
    if @state.locationValid
      location = (@state.location).split(',')[0]
    else
      location = "Unknown Address"
    <div>
      <div className="row">
        <div className="two columns avatar">
          <UI.Avatar src={@props.avatar} />
        </div>
        <div className="six columns user">
          <div className="row">
            <strong>{ @props.name }</strong>
          </div>
          <div className="row">
            <a href={mapUrl} target='_blank'>{ location }</a>
          </div>
        </div>
        <div className="four columns toolbar">
          <Toolbar itemId={@props.itemId} likes={@props.likes} />
        </div>
      </div>
      <InfoHeader likes={@props.likes} date={@props.date} />
    </div>

Description = React.createClass
  mixins: [UITheme]
  render: -> <div className="row caption">{@props.text}</div>

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
    comment =
      <li key={0}>
        <strong>{@props.name}</strong>&nbsp;{@props.caption}
      </li>
    comments = [comment]
    comments = comments.concat (_.map @props.comments, (comment, idx) ->
      <li key={idx + 1}>
        <strong>{comment.user.displayName}</strong>&nbsp;{comment.message}
      </li>)
    <div className="comment-list">
      <ul>{comments}</ul>
    </div>

module.exports = React.createClass
  mixins: [UITheme]
  handleAddComment: ->
    commentBox = React.findDOMNode @refs.commentBox
    comment = @refs.commentBox.value
    $(commentBox).blur().val('').attr('enable', false)
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
    <div>
      <UI.Paper zDepth={1} className="row food-card">
        <div ref="left" className="six columns left-column">
          <Photo title={@props.model.itemName} src={@props.model.photoURL} />
        </div>
        <div className="six columns right-column">
          <Header name={@props.model.user.displayName}
                  avatar={authorPicture}
                  date={@props.model.addedDate}
                  likes={@props.model.likes}
                  itemId={@props.model.itemId}
                  caption={@props.model.caption}
                  lat={@props.model.latitude}
                  long={@props.model.longtitude} />
          <Comments comments={@props.model.comments}
                    name={@props.model.user.displayName}
                    caption={@props.model.caption} />
          <div className="new-comment">
            <TextArea minRows={1} maxRows={1} ref="commentBox"
                      placeholder="Add a comment..."></TextArea>
          </div>
        </div>
      </UI.Paper>
    </div>
