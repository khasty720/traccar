#!/bin/sh

# This script is used to run the Traccar server.    

echo "Starting Traccar server..."
# Check if the .env file exists and load environment variables
if [ -f .env ]; then
    echo "Loading environment variables from .env file..."
    # In a shell script, use single $ instead of double $$
    export $(cat .env | grep -v ^# | xargs)
    CONFIG_USE_ENVIRONMENT_VARIABLES="true" java -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=*:5005 -jar target/tracker-server.jar ./conf/traccar.xml
else
    echo ".env file not found. Using default environment variables."
    java -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=*:5005 -jar target/tracker-server.jar ./conf/traccar.xml
fi
