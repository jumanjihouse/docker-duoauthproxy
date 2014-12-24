# https://www.duosecurity.com/docs/authproxy_reference#installation
dev_tools="
gcc
make
openssl-devel
patch
python-devel
tar
which
"

yum -y install $dev_tools; yum clean all

# Build and install authproxy.
cd /root
tar xzf duoauthproxy-latest-src.tgz
cd duoauthproxy*
export PYTHON=$(which python)
make
cd duoauthproxy-build
patch -p0 < /root/install.patch
./install
