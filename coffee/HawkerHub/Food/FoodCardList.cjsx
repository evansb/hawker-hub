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
{ FilterStore } = require '../../Entity/Filter'
{ UserStore } = require '../../Entity/User'

ShowMore = React.createClass
  render: ->
    if !@props.hasNoMore
      <div className="show-more">
        <Icon onClick={@props.onClick} name="expand_more" />
      </div>
    else
      <div></div>

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
    filter: null
    firstTimeFetch: true
    hasNoMore: false
  componentWillMount: ->
    FilterStore.listen (filter) =>
      filter.init()
      @setState
        firstTimeFetch: true
        items: []
        filter: filter
        hasNoMore: false
        isInfiniteLoading: false
    FoodStore.listen (event) =>
      switch event.name
        when 'fetched'
          items = @state.items.concat event.value
          @setState { firstTimeFetch: false, items }
        when 'fetched_search'
          items = @state.items.concat event.value
          @setState { firstTimeFetch: false, isInfiniteLoading: false, items, hasNoMore: true }
        when 'created'
          @setState { items: [event.value].concat @state.items }
        when 'changed'
          items = @state.items
          items[event.key] = event.value
          @setState { items }
        when 'empty'
          @setState { hasNoMore: true }
  fetch: -> @state.filter.fn @state.items.length
  handleInfiniteLoad: -> if @state.isInfiniteLoading then @fetch()
  render: ->
    items = _.map @state.items, (value, idx) =>
      <FoodCard key={idx} model={value} />
    loader =
      if (!@state.hasNoMore && (@state.isInfiniteLoading || @state.firstTimeFetch))
        <ProgressBar />
      else if (!@state.hasNoMore)
        <ShowMore onClick={=> @setState { isInfiniteLoading: true} }/>
      else
        <div></div>
    <div className="limit-width food-card-container">
      <InfiniteScroll loadMore={@handleInfiniteLoad}
                      hasMore={!@props.singleView && !@state.hasNoMore}
                      loader={loader}
                      threshold={100}>
        {items}
      </InfiniteScroll>
    </div>
