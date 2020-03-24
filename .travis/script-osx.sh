#!/bin/sh

XCPRETTY='xcpretty -f `xcpretty-travis-formatter`'

cmake --build . | $XCPRETTY
cmake --install . | $XCPRETTY

