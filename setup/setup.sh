#!/usr/bin/env bash

BASE_PATH="$(dirname "$(realpath "$0")")"
cd "${BASE_PATH}" || exit

SCRIPTS_PATH="scripts"
PREV_STEP_FILE="PREV_STEP"

if [[ -f "${PREV_STEP_FILE}" ]]; then
  potential_step="$(cat "${PREV_STEP_FILE}")"

  if [[ "${potential_step}" =~ ^[0-9]+$ ]]; then
    PREV_STEP="${potential_step}"
    echo "INFO: Continuing with step ${PREV_STEP}"
    echo ""
  fi
fi
PREV_STEP="${PREV_STEP:=0}"

function call_sub_script {
  echo "----- [Step $2: $1] -----"

  # Script name is:
  # " " replaced with "_"
  # lowercase
  # special characters removed
  script_name="${1// /_}"
  script_name="${script_name,,}"
  script_name="${script_name//[^a-z_]/}"
  script_name="${script_name}.sh"

  if [[ ! -f "./${SCRIPTS_PATH}/${script_name}" ]]; then
    echo "Script '${script_name}' not found!" && exit 1
  fi

  cd "${SCRIPTS_PATH}" || exit 1

  chmod +x "${script_name}"

  if ! eval "./${script_name}"; then
    [[ "$?" -eq 1 ]] && echo "'$1' failed!"
    echo "$2" > "../${PREV_STEP_FILE}"
    exit "$?"
  fi

  echo "Done!"
  echo ""

  cd "${BASE_PATH}" || exit
}


STEPS=(
  "Determine OS"
  "Setup OS"
  "(Oh My) Zsh"
  "Setup Git"
)

for step_num in "${!STEPS[@]}"; do
  step_name="${STEPS[${step_num}]}"

  # Step 0 (Determine OS) should always be executed
  if [[ "${step_num}" -lt "${PREV_STEP}" && "${step_num}" != 0 ]]; then
    continue
  fi

  call_sub_script "${step_name}" "${step_num}"
done





