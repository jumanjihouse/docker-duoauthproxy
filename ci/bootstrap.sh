#!/bin/bash
set -eEu
set -o pipefail

################################################################################
# Bootstrap local dev environment.
################################################################################

# Import smitty.
. ci/functions.sh

main() {
  install_precommit
  add_upstream_git_remote
  fetch_upstream
}

trap finish EXIT

finish() {
  declare -ri RC=$?
  if [[ ${RC} -eq 0 ]]; then
    echo "$0 OK" >&2
  else
    echo "[ERROR] $0" >&2
  fi
}

install_precommit() {
  echo '---> install pre-commit'

  python_path="$(python -c "import site; print(site.USER_BASE)")"
  readonly python_path

  if ! grep -q "${python_path}/bin" <(env | grep PATH); then
    export PATH="${PATH}:${python_path}/bin"
  fi

  if ! command -v pre-commit &>/dev/null; then
    # Install for just this user. Does not need root.
    pip install --user -Iv --compile --no-cache-dir pre-commit
  fi
}

add_upstream_git_remote() {
  if ! git remote show upstream &>/dev/null; then
    smitty git remote add upstream https://github.com/jumanjihouse/docker-duoauthproxy.git
  fi
}

fetch_upstream() {
  git fetch upstream
}

run_precommit() {
  echo '---> run pre-commit'

  # http://pre-commit.com/#pre-commit-run
  readonly DEFAULT_PRECOMMIT_OPTS="--all-files --hook-stage manual"

  # Allow user to override our defaults by setting an env var.
  readonly PRECOMMIT_OPTS="${PRECOMMIT_OPTS:-$DEFAULT_PRECOMMIT_OPTS}"

  # shellcheck disable=SC2086
  pre-commit run ${PRECOMMIT_OPTS}
}

main
