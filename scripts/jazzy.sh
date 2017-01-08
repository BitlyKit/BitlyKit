#!/bin/sh

jazzy -m BitlyKit \
-a "Brennan Stehling" \
-u https://github.com/BitlyKit/BitlyKit \
-g https://github.com/BitlyKit/BitlyKit \
--github-file-prefix https://github.com/BitlyKit/BitlyKit/blob/1.0.0 \
--module-version 1.0.0 \
-r https://github.com/BitlyKit/BitlyKit/ \
-x -project,Bitly.xcodeproj,-scheme,BitlyKit-iOS \
-c
