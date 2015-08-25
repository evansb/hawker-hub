React       = require 'react'
UI          = require 'material-ui'
UITheme     = require '../Common/UITheme'
Icon        = require '../Common/MaterialIcon'
$           = require 'jquery'

Photo = React.createClass
  mixins: [UITheme]
  getInitialState: ->
    imageLoaded: false
  componentWillMount: ->
    # Fetch image Asynchronously
    image = $("<img class='u-full-width u-max-full-width' />").attr('src', @props.url)
    image.load =>
      @setState { imageLoaded: true }
      $(React.findDOMNode(@refs.picture)).html image
  render: ->
    <div className="food-card-detail-image-container">
      <div ref="picture">
        { <UI.CircularProgress mode="indeterminate" /> unless @state.imageLoaded }
      </div>
    </div>

Title = React.createClass
  mixins: [UITheme]
  render: ->
    <UI.CardHeader title={@props.text}
       avatar="http://lorempixel.com/100/100/nature/"/>

Description = React.createClass
  mixins: [UITheme]
  render: -> <UI.CardText> {@props.text} </UI.CardText>

Toolbar = React.createClass
  mixins: [UITheme]
  render: ->
    <UI.CardActions>
      <Icon name="favorite_border"/>
      <Icon name="add"/>
      <Icon name="share"/>
    </UI.CardActions>

Comments = React.createClass
  mixins: [UITheme]
  render: ->
    <div>
      <UI.List subheader="Comments (4)">
        <UI.ListItem
          key={0}
          leftAvatar={<UI.Avatar src="images/ok-128.jpg" />}
          disabled={true}
          primaryText="Brendan Lim"
          secondaryText={
            <p>
              <span>Brunch this weekend?</span><br/>
              I&apos;ll be in your neighborhood doing errands this weekend.
                Do you want to grab brunch?
            </p>
          }
          secondaryTextLines={2} />
        <UI.ListItem
          className="food-card-detail-comments-box"
          key={8}
          leftAvatar={<UI.Avatar src="images/ok-128.jpg" />}
          secondaryText={
              <textarea></textarea>
          }
          secondaryTextLines={2} />
      </UI.List>
    </div>

module.exports = React.createClass
  mixins: [UITheme]
  getInitialState: ->
    modalIsOpen: false
  handleSubmit: -> @setState { modalIsOpen: false}
  handleCancel: -> @setState { modalIsOpen: false}
  render: ->
    <UI.Card>
        <div className="row">
          <div className="six columns">
            <Photo url={@props.model.photoURL}/>
            <Title text={@props.model.itemName}/>
            <Description text={@props.model.caption} />
            <Toolbar />
          </div>
          <div className="six columns food-card-detail-comments">
            <Comments />
          </div>
        </div>
    </UI.Card>
