start_authproxy() {
  api_host=$1
  ikey=$2
  skey=$3

  # Create a data container.
  docker rm -f authproxy-config &> /dev/null || :
  docker run --name authproxy-config -v /etc/duoauthproxy --entrypoint=true duoauthproxy
  docker run --volumes-from authproxy-config alpine:3.3 sed -i "s/RADIUSD_IP/${radiusd_ip}/g" /etc/duoauthproxy/authproxy.cfg
  docker run --volumes-from authproxy-config alpine:3.3 sed -i "s/API_HOST/${api_host}/g" /etc/duoauthproxy/authproxy.cfg
  docker run --volumes-from authproxy-config alpine:3.3 sed -i "s/IKEY/${ikey}/g" /etc/duoauthproxy/authproxy.cfg
  docker run --volumes-from authproxy-config alpine:3.3 sed -i "s/SKEY/${skey}/g" /etc/duoauthproxy/authproxy.cfg

  # Start duoauthproxy.
  caps="
    --cap-drop=all
    --cap-add=setgid
    --cap-add=setuid
  "
  docker run -d --read-only ${caps} --name duoauthproxy --volumes-from authproxy-config duoauthproxy

  max_sleep=5
  rc=1
  while [[ $max_sleep -gt 0 ]]; do
    max_sleep=$(( $max_sleep - 1 ))
    sleep 1
    docker logs duoauthproxy | grep -ohi 'init complete' && rc=0
    [[ $rc -eq 0 ]] && break
  done
  return $rc
}
