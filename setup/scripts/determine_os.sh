#!/usr/bin/env bash

echo "Determining operating system..."
case "$(uname -s)" in
  Linux*)   OS=Linux;;
  Darwin*)  OS=Mac;;
esac

if [[ -n ${OS} ]]; then
  echo "Running on ${OS}!"
  export OS
else
  echo "Unable to determine operating system!"
  exit 1
fi