FROM duoauthproxy-common

ADD duoauthproxy.tgz /
ADD authproxy.cfg /etc/duoauthproxy/authproxy.cfg
ENTRYPOINT ["/opt/duoauthproxy/bin/authproxy"]
CMD ["-c", "/etc/duoauthproxy/authproxy.cfg"]
