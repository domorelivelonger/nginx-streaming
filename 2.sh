echo "====================================================================================
Build Openssl TLS 1.3
===================================================================================="
cd /root/nginx-install/development
git clone --depth 1 -b openssl-quic-draft-23 https://github.com/tatsuhiro-t/openssl
cd openssl
./config enable-tls1_3 --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared zlib
make -j4
make -j4 install_sw
rm -rf /usr/sbin/openssl
ln -s /usr/local/ssl/sbin/openssl /usr/sbin/


echo "====================================================================================
Build quiche
===================================================================================="
cd /root/nginx-install/development
git clone --recursive https://github.com/cloudflare/quiche

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Boringssl build
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
cd /root/nginx-install/development/quiche/deps/boringssl
mkdir build
cd build
cmake ..
make -j4

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Brotli build
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
cd /root/nginx-install/development
git clone https://github.com/google/ngx_brotli.git
cd ngx_brotli && git submodule update --init

cd /root/nginx-install/development
curl -O https://nginx.org/download/nginx-1.16.1.tar.gz
tar -xzvf nginx-1.16.1.tar.gz
cd nginx-1.16.1




