cd /root/nginx-install/development
git clone https://github.com/arut/nginx-rtmp-module.git
git clone https://github.com/kaltura/nginx-vod-module.git

wget https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz
tar xvfz pcre-8.43.tar.gz
cd pcre-8.43
./configure --prefix=/usr/local/pcre/8_43 --enable-jit
make
make install

cd /root/nginx-install/development
wget https://www.zlib.net/zlib-1.2.11.tar.gz
tar zxvf zlib-1.2.11.tar.gz
cd zlib-1.2.11
./configure --prefix=$HOME/local/prior
make
make install


apt-get install -y git build-essential ffmpeg libpcre3 libpcre3-dev libssl-dev zlib1g-dev
apt install -y libswscale-dev libavcodec-dev libavfilter-dev libxml2-dev
