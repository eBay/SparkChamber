#! /bin/bash

which -s xcpretty
XCPRETTY_INSTALLED=$?

SPARKKIT_TEST_CMD="xcodebuild -workspace SparkWorkspace.xcworkspace -scheme SparkKit -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 6S,OS=10.0' CODE_SIGN_IDENTITY='' CODE_SIGNING_REQUIRED=NO -enableCodeCoverage YES clean test"

if [[ $TRAVIS || $XCPRETTY_INSTALLED == 0 ]]; then
  eval "${SPARKKIT_TEST_CMD} | xcpretty"
else
  eval "$SPARKKIT_TEST_CMD"
fi
