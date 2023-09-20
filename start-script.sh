#!/bin/bash

PARAMS=`cat /params.out`
/docker-entrypoint.sh ${PARAMS} --restart-epoch $RESTART_EPOCH --drain-time-s 10 -l debug --parent-shutdown-time-s 15