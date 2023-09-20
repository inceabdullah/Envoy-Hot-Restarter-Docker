#!/bin/bash

echo "${@}" > /params.out
exec /opt/envoy/restarter/hot-restarter.py /start-script.sh
