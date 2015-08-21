React       = require 'react'
UI          = require 'material-ui'
UITheme     = require '../Common/UITheme'
Icon        = require '../Common/MaterialIcon'
$           = require 'jquery'
{ Cell }    = require 'react-pure'

Comments = React.createClass
  mixins: [UITheme]
  render: ->
    <UI.List subheader="Comments (4)">
      <UI.ListItem
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
