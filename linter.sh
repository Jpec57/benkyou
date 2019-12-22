#!/usr/bin/env bash

MAX_LINT=67
MAX_HINT=2

output=$(dartanalyzer --options analysis_options.yaml . | tail -1)
lint=$(echo "$output" | cut -d " " -f1)
hint=$(echo "$output" | cut -d " " -f4)

if [[ ( "$hint" > ${MAX_HINT} && "$lint" > ${MAX_LINT} ) ]] ; then
    echo "Too many errors $hint/${MAX_HINT} hints and $lint/${MAX_LINT} lints."
    exit 1
fi

if [[ ( "$lint" > ${MAX_LINT} ) ]] ; then
    echo "Too many lint errors: $lint/${MAX_LINT} "
    exit 1

fi

if [[ ( "$hint" > ${MAX_HINT} ) ]] ; then
    echo "Too many hint errors: $hint/${MAX_HINT}"
    exit 1
fi