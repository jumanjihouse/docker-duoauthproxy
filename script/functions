smitty() {
  echo; echo
  echo -e "[INFO] $@"
  "$@"
}

err() {
  echo "[ERROR] $@" >&2
  exit 1
}

git_dir=$(git rev-parse --show-toplevel)
[[ $(pwd) = $git_dir ]] && : || err Please run these scripts for the root of the repo
