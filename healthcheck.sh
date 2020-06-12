#!/bin/bash

web_ui_result=$(curl -I http://localhost:8761 -s -o /dev/null -w "%{http_code}")
if [[ $web_ui_result -eq 200 ]]; then
    exit 0
else
    exit 1
fi
