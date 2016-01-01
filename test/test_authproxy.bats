# BATS runs teardown() after every @test.
teardown() {
  docker rm -f duoauthproxy &> /dev/null || :
  docker rm -f radiusd &> /dev/null || :
}

# BATS runs setup() before every @test.
setup() {
  docker run -d --name radiusd radiusd -f -l stdout
  radiusd_ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' radiusd)
}

load functions

@test "radius auth via duo authproxy is allowed when 2fa succeeds" {
  start_authproxy $API_HOST $IKEY_ALLOW $SKEY_ALLOW
  [[ ${status} -eq 0 ]]

  ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' duoauthproxy)
  [[ -n ${ip} ]]

  run docker run --rm --net=host -t radclient -f /root/test.conf ${ip}:1812 auth foo
  [[ ${output} =~ 'Received Access-Accept' ]]
}

@test "radius auth via duo authproxy is rejected when 2fa fails" {
  start_authproxy $API_HOST $IKEY_DENY $SKEY_DENY
  [[ ${status} -eq 0 ]]

  ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' duoauthproxy)
  [[ -n ${ip} ]]

  run docker run --rm --net=host -t radclient -f /root/test.conf ${ip}:1812 auth foo
  [[ ${output} =~ 'Received Access-Reject' ]]
}
