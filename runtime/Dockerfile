FROM duoauthproxy-common

# Use ADD, not COPY, to keep image small.
ADD duoauthproxy.tgz /

COPY authproxy.cfg /etc/duoauthproxy/authproxy.cfg
USER duo
ENTRYPOINT ["/opt/duoauthproxy/bin/authproxy"]
CMD ["-c", "/etc/duoauthproxy/authproxy.cfg"]
