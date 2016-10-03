#! /bin/bash

which -s xcpretty
XCPRETTY_INSTALLED=$?

SPARKCHAMBER_TEST_CMD="xcodebuild -workspace SparkWorkspace.xcworkspace -scheme SparkChamber -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 6S,OS=10.0' clean build test"

if [[ $TRAVIS || $XCPRETTY_INSTALLED == 0 ]]; then
  eval "${SPARKCHAMBER_TEST_CMD} | xcpretty"
else
  eval "$SPARKCHAMBER_TEST_CMD"
fi
