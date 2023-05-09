#!/usr/bin/env bash

cd "$(dirname "$0")" || exit

# Start with step 0
SETUP_STEP=${SETUP_STEP:=0}

function call_sub_script {
  SETUP_STEP=$((SETUP_STEP + 1))
  echo "----- [Step ${SETUP_STEP}] -----"

  local script_path="$1"
  chmod +x "${script_path}"

  cd "$(dirname "${script_path}")" || exit 1

  if ! eval "./$(basename "${script_path}")"; then
    [[ "$?" -eq 1 ]] && echo "'${script_path}' failed!"
    exit "$?"
  fi

  # TODO: Use correct $0
  cd "$(dirname "$0")" || exit
}

call_sub_script ./setup/determine_os.sh
call_sub_script ./setup/oh_my_zsh.sh


