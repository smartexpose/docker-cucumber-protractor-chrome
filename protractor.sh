#!/bin/bash

if [ "$1" = "--help" ]; then
        echo ""
        echo "Epiclabs Testrunner -- Handles protractor e2e tests"
        echo "Copyright (c) Epic Labs 2017. All rights reserved."
        echo ""
        echo "Usage:"
        echo "docker run -it --volume .../site/portal/frontend:/tests epiclabs/testrunner (protractor options)"
        echo "options:"
        echo "--specs {pathtotest} Run only one test file"
        echo "--baseUrl {url} URL to be tested"
        echo " Whatever other protractor parameter you want to pass"
        echo ""

        echo "Examples:"
        echo "docker run -it --volume .../site/portal/frontend:/tests epiclabs/testrunner --baseUrl http://madlab.epiclabs.io/"
        echo "docker run -it --volume .../site/portal/frontend:/tests epiclabs/testrunner --baseUrl http://madlab.epiclabs.io/ --specs /tests/features/your.feature"
fi

# Start selenium server and trash the verbose error messages from webdriver
node_modules/webdriver-manager/bin/webdriver-manager  update 2>/dev/null &
node_modules/webdriver-manager/bin/webdriver-manager  start 2>/dev/null &
# Wait 3 seconds for port 4444 to be listening connections
while ! nc -z 127.0.0.1 4444; do sleep 3; done
node_modules/.bin/protractor  "$@" --disableChecks
node_modules/webdriver-manager/bin/webdriver-manager shutdown
#Now force shut
pkill -f webdriver-manager 2>/dev/null &
pkill -f "test-type=webdriver" 2>/dev/null &
