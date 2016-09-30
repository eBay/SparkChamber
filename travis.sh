#! /bin/bash

TEST_CMD="xcodebuild -workspace SparkWorkspace.xcworkspace -scheme SparkKit -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 6S,OS=10.0' build test"

which -s xcpretty
XCPRETTY_INSTALLED=$?

if [[ $TRAVIS || $XCPRETTY_INSTALLED == 0 ]]; then
  eval "${TEST_CMD} | xcpretty"
else
  eval "$TEST_CMD"
fi
