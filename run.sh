#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR
. $SCRIPT_DIR/.venv/bin/activate
$SCRIPT_DIR/.venv/bin/uwsgi --http 0.0.0.0:6636 --master -p 4 -w app:app --uid user
