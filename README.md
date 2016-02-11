# homebridge-docker
Trying to control Domoticz via Apple Siri voice control.

Docker image running homebridge.

## Building it
`docker build -t my_homebridge .`

## Running it
`docker run --net=host -d -p 51826:51826 my_homebridge /root/run.sh`

## TODO:
- iOS still not able to detect homebridge, looks like a WLAN issue.
