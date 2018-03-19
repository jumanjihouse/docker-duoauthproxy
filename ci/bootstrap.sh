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

  if ! command -v pre-commit &> /dev/null; then
    # Install for just this user. Does not need root.
    pip install --user -Iv --compile --no-cache-dir pre-commit
  fi
}

add_upstream_git_remote() {
  if ! git remote show upstream &> /dev/null; then
    smitty git remote add upstream https://github.com/jumanjihouse/docker-duoauthproxy.git
  fi
}

run_precommit() {
  echo '---> run pre-commit'

  # http://pre-commit.com/#pre-commit-run
  readonly DEFAULT_PRECOMMIT_OPTS="--all-files --verbose"

  # Allow user to override our defaults by setting an env var.
  readonly PRECOMMIT_OPTS="${PRECOMMIT_OPTS:-$DEFAULT_PRECOMMIT_OPTS}"

  # shellcheck disable=SC2086
  pre-commit run ${PRECOMMIT_OPTS}
}

check_whitespace() {
  local -i RC=1
  local output
  echo '---> whitespace'

  # This command identifies whitespace errors and leftover conflict markers.
  # It works only on committed files, so we have to warn on dirty git tree.
  output="$(git diff-tree --check "$(git hash-object -t tree /dev/null)" HEAD)"
  readonly output

  if [[ -z "${output}" ]]; then
    RC=0
    echo OK
  else
    err Found whitespace errors. See below.
    echo "${output}" >&2
  fi

  if is_git_dirty; then
    echo 'Git repo has uncommitted changes; recommend to commit and re-run tests.'
    git status
  fi

  return ${RC}
}

is_git_dirty() {
  [[ -n "$(git diff --shortstat)" ]]
}

main
