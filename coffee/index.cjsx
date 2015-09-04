$             = require 'jquery'
HawkerHub     = require './HawkerHub'

# Setup Facebook API
require './Entity/Facebook'

# Inject React Tap Event
injectTapEventPlugin = require 'react-tap-event-plugin'
injectTapEventPlugin()

# Install JQuery plugins
window['jQuery'] = $
require '../vendor/jquery.imagefit.min'

# Load application entity.
require './Entity/App'

# Render the main view.
$(-> HawkerHub.render document.body)
