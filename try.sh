#!/bin/bash

if grep -v ^d "students" >/dev/null; then
  echo "Non-empty result"
else
  echo "Empty result"
fi