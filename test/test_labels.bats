@test "ci-build-url label is present" {
  run docker inspect \
      -f '{{ index .Config.Labels "io.github.jumanjiman.ci-build-url" }}' \
      duoauthproxy
  [[ ${output} =~ circleci.com ]]
}
