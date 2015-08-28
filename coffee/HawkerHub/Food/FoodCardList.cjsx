$        = require 'jquery'
_        = require 'lodash'
React    = require 'react'
Image    = require 'react-retina-image'
Layout   = (require 'react-grid-layout').Responsive
UI       = require 'material-ui'
InfiniteScroll = (require 'react-infinite-scroll')(React)
UITheme  = require '../Common/UITheme'
Icon     = require '../Common/MaterialIcon'
FoodCard = require './FoodCard'
{ FoodAction, FoodStore } = require '../../Entity/Food'

ShowMore = React.createClass
  render: ->
    <div className="show-more">
      <Icon onClick={@props.onClick} name="expand_more" />
    </div>

ProgressBar = React.createClass
  render: ->
    <div className="loading-spinner">
      <UI.CircularProgress mode="indeterminate" size={2} />
    </div>

module.exports = React.createClass
  mixins: [UITheme]
  getInitialState: ->
    items: []
    isInfiniteLoading: false
  componentWillMount: ->
    FoodStore.listen (event) =>
      switch event.name
        when 'fetched'
          items = @state.items.concat event.value
          @setState { items }
  handleInfiniteLoad: ->
    if @state.isInfiniteLoading
      @props.fetch(@state.items.length)
  componentDidMount: ->
    @props.fetch(@state.items.length)
  render: ->
    items = _.map @state.items, (value, idx) =>
      <FoodCard key={idx} model={value}
                handleMoreClick={@props.handleMoreClick} />
    loader =
      if @state.isInfiniteLoading
        <ProgressBar />
      else
        <ShowMore onClick={=> @setState { isInfiniteLoading: true} }/>
    <div className="limit-width food-card-container">
      <InfiniteScroll loadMore={@handleInfiniteLoad}
                      hasMore={true} loader={loader}
                      threshold={100}>
        {items}
      </InfiniteScroll>
    </div>
