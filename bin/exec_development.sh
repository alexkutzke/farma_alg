#!/bin/bash

bin/timeout3 -t ${1} ${2} < ${3} | head -c 10000 > ${4}

exit ${PIPESTATUS[0]}
