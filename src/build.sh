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

yum -y install $dev_tools

useradd duo

# Build and install authproxy.
cd /root
tar xzf duoauthproxy-latest-src.tgz
cd duoauthproxy*
export PYTHON=$(which python)
make
cd duoauthproxy-build
patch -p0 < /root/install.patch
./install

to_remove="
gcc
openssl-devel
python-devel
cloog-ppl
cpp
keyutils-libs-devel
krb5-devel
libcom_err-devel
libselinux-devel
libsepol-devel
mpfr
ppl
zlib-devel
"
yum -y remove $to_remove

yum clean all
