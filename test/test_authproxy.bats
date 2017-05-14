@test "radius auth via duo authproxy is allowed when 2fa succeeds" {
  run docker-compose run --rm auth_accept
  [[ ${output} =~ 'Received Access-Accept' ]]
}

@test "radius auth via duo authproxy is rejected when 2fa fails" {
  run docker-compose run --rm auth_reject
  [[ ${output} =~ 'Received Access-Reject' ]]
}
