$        = require 'jquery'
_        = require 'lodash'
React    = require 'react'
Image    = require 'react-retina-image'
UI       = require 'material-ui'
InfiniteScroll = (require 'react-infinite-scroll')(React)
UITheme  = require '../Common/UITheme'
Icon     = require '../Common/MaterialIcon'
FoodCard = require './FoodCard'
{ FoodAction, FoodStore } = require '../../Entity/Food'
{ Filter, FilterStore } = require '../../Entity/Filter'
{ UserStore } = require '../../Entity/User'

ShowMore = React.createClass
  render: ->
    <div className="show-more">
      <Icon onClick={@props.onClick} name="expand_more" />
    </div>

ProgressBar = React.createClass
  render: ->
    <div className="loading-spinner">
      <img src="../../../../assets/food_loading@2x.gif" />
    </div>

module.exports = React.createClass
  mixins: [UITheme]
  getInitialState: ->
    items: []
    isInfiniteLoading: false
    firstTimeFetch: true
    activeFilter: null
  componentWillMount: ->
    FilterStore.listen (newFilter) =>
      @fetchInit newFilter
      @setState
        firstTimeFetch: true
        activeFilter: newFilter
        items: []
        isInfiniteLoading: false
    FoodStore.listen (event) =>
      switch event.name
        when 'fetched'
          items = @state.items.concat event.value
          @setState { firstTimeFetch: false, items }
        when 'created'
          @setState { items: [event.value].concat @state.items }  
  fetch: -> @state.activeFilter.fn @state.items.length
  fetchInit: (useFilter) ->
    if (useFilter) then useFilter.init() else @state.activeFilter.init()
  handleInfiniteLoad: ->
    if (@state.isInfiniteLoading) then @fetch()
  render: ->
    items = _.map @state.items, (value, idx) =>
      <FoodCard key={idx} model={value}
                handleMoreClick={@props.handleMoreClick} />
    loader =
      if (@state.isInfiniteLoading || @state.firstTimeFetch)
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
