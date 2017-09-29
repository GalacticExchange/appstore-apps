#!/usr/bin/env bash

/datameer/Datameer-5.11.14-cdh-5.7.0-mr2/bin/conductor.sh start > run_log.txt
while true; do echo hello world; sleep 1; done