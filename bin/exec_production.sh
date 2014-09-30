#!/bin/bash

bin/timeout3 -t ${1} ssh -p 2358 exec_jail@localhost ${2} < ${3} | head -c 10MB > ${4}

exit ${PIPESTATUS[0]}
