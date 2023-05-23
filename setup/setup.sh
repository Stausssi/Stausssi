#!/usr/bin/env bash

BASE_PATH="$(dirname "$(realpath "$0")")"
cd "${BASE_PATH}" || exit

SCRIPTS_PATH="scripts"
PREV_STEP_FILE="PREV_STEP"

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
  ./"${script_name}"
  return_code="$?"

  if [[ "${return_code}" -gt 0 ]]; then
    case "${return_code}" in
      1)  echo "'$1' failed!";;
      2)  echo "$2" > "../${PREV_STEP_FILE}";;
      3)  echo "$(("$2" + 1))" > "../${PREV_STEP_FILE}";;
      *)  echo "Unknown exit code: ${return_code}";;
    esac

    exit ${return_code}
  fi

  echo "$2" > "../${PREV_STEP_FILE}"
  echo "Done!"
  echo ""
  cd "${BASE_PATH}" || exit
}

# Setup directories
if [[ ! -d configs/backup ]]; then
  mkdir configs/backup
fi
if [[ ! -d scripts/logs ]]; then
  mkdir scripts/logs
fi

# Determine the OS
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

STEPS=(
  "Setup OS"
  "(Oh My) Zsh"
  "Setup Git"
  "Install Software"
)

if [[ -f "${PREV_STEP_FILE}" ]]; then
  potential_step="$(cat "${PREV_STEP_FILE}")"

  if [[ "${potential_step}" =~ ^[0-9]+$ ]]; then
    PREV_STEP="${potential_step}"
    echo "INFO: Continuing with step ${PREV_STEP}"
  fi
fi
PREV_STEP="${PREV_STEP:=0}"

echo ""

for step_num in "${!STEPS[@]}"; do
  step_name="${STEPS[${step_num}]}"

  if [[ "${step_num}" -lt "${PREV_STEP}" ]]; then
    continue
  fi

  call_sub_script "${step_name}" "${step_num}"
done





