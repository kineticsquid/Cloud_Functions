#!/bin/bash
echo "Building and deploying now..."
echo "Postman to test"
echo "bx wsk action invoke utils/ghe_webhook to invoke"
echo "run bx wsk activation get -l to get last results"
echo "run bx wsk activation poll to poll for log results"

# Authenticate to Bluemix
bx api ${BLUEMIX_API_URL}
# bx plugin install Cloud-Functions -r Bluemix
bx login --apikey ${WSK_AUTH}
bx target -o kellrman@us.ibm.com -s dev

# Update the /utils/environment function
# --------------------------------------

# Define API - do this once only because there is no update, ony create and delete
# bx wsk property set --apihost openwhisk.ng.bluemix.net
# bx wsk api create /environment get /utils/ghe_webhook --response-type json

# virtualenv --system-site-packages virtualenv
virtualenv virtualenv
source virtualenv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

cp google_calendar.py __main__.py
zip -r google-calendar.zip virtualenv __main__.py credentials.json token.json
rm __main__.py
# rm -rf virtualenv

# Update utils package and environment function
bx wsk package update utils --shared yes
bx wsk action update utils/google-calendar ./google-calendar.zip --kind python:3 --web true
# rm google-calendar.zip

# Now list the package and action to confirm results
bx wsk package get utils
bx wsk action get utils/google-calendar
bx wsk action invoke utils/google-calendar --blocking  --param action test
