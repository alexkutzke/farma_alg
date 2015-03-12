#!/bin/bash

bin/timeout3 -t ${1} ssh exec_jail@localhost ${2} < ${3} | head -c 1MB > ${4}

exit ${PIPESTATUS[0]}
