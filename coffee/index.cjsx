$           = require 'jquery'
HawkerHub   = require './HawkerHub'

# Inject React Tap Event
injectTapEventPlugin = require 'react-tap-event-plugin'
injectTapEventPlugin()

# Load application entitites.
require './Entity/App'

# Render the main view.
$(-> HawkerHub.render document.body)
