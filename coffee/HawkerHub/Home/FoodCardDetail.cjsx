React       = require 'react'
UI          = require 'material-ui'
Modal       = require 'react-modal'
UITheme     = require '../Common/UITheme'
Icon        = require '../Common/MaterialIcon'
$           = require 'jquery'

Photo = React.createClass
  mixins: [UITheme]
  getInitialState: ->
    imageLoaded: false
  componentWillMount: ->
    # Fetch image Asynchronously
    url = "http://lorempixel.com/#{ 500 + Math.floor(Math.random() * 40)}/337/food/"
    image = $("<img class='u-full-width u-max-full-width u-max-full-height' />")
            .attr('src', url)
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
    <UI.CardHeader
        title="Food Name"
        subtitle="Hawker Center Newton"
        avatar="http://lorempixel.com/100/100/nature/"/>

Description = React.createClass
  mixins: [UITheme]
  render: ->
    <UI.CardText>
      Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      Donec mattis pretium massa. Aliquam erat volutpat. Nulla facilisi.
      Donec vulputate interdum sollicitudin. Nunc lacinia auctor quam sed pellentesque.
      Aliquam dui mauris, mattis quis lacus id, pellentesque lobortis odio.
    </UI.CardText>

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
          key={7}
          leftAvatar={<UI.Avatar src="images/ok-128.jpg" />}
          primaryText="Brendan Lim"
          secondaryText={
            <p>
              <span>Brunch this weekend?</span><br/>
              I&apos;ll be in your neighborhood doing errands this weekend.
                Do you want to grab brunch?
            </p>
          }
          secondaryTextLines={2} />
      </UI.List>
      <UI.TextField
        className="food-card-detail-comments-box"
        hintText="Write something...."
        multiLine={true} />
      <UI.FlatButton label="Post" primary={true} />
    </div>

module.exports = React.createClass
  mixins: [UITheme]
  getInitialState: ->
    modalIsOpen: false
  handleSubmit: -> @setState { modalIsOpen: false}
  handleCancel: -> @setState { modalIsOpen: false}
  show: -> @setState { modalIsOpen: true}
  render: ->
    <Modal className="food-card-detail"
       isOpen = { @state.modalIsOpen }
       onRequestClose = { @handleCancel }
       ref="dialog" modal={false}>
      <UI.Card>
          <div className="row">
            <div className="six columns">
              <Photo />
              <Title />
              <Description />
              <Toolbar />
            </div>
            <div className="six columns food-card-detail-comments">
              <Comments />
            </div>
          </div>
      </UI.Card>
    </Modal>
