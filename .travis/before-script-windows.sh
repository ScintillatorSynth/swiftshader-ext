#!/bin/bash

# TODO: Brittle. Path found by case-insensitive grepping the Chocolatey install log for python3. This could easily break
# if/when chocolatey decides to change this path. Chocolatey ignores any provided path.
cmake -DPYTHON_EXECUTABLE=/c/Python38/python.exe ..
