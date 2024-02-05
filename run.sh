#!/usr/bin/env bash
uwsgi --http 0.0.0.0:6636 --master -p 4 -w app:app
