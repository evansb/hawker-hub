$             = require 'jquery'
HawkerHub     = require './HawkerHub'
{UserAction}  = require './Entity/User'

require './Entity/Facebook'

# Inject React Tap Event
injectTapEventPlugin = require 'react-tap-event-plugin'
injectTapEventPlugin()

# Install Imagefit JQuery plugin
window['jQuery'] = $
require '../vendor/jquery.imagefit.min'

# Load application entitity.
require './Entity/App'

# Render the main view.
$(-> HawkerHub.render document.body)
