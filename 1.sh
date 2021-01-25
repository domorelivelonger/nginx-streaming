#Debian 9
apt install sudo -y
apt install -y libpcre3 libpcre3-dev zlib1g-dev cmake make 
apt install -y automake golang g++ gcc clang libunwind-dev golang git htop screen wget curl nano net-tools

mkdir -p /root/nginx-install/development
cd /root/nginx-install/development
sudo wget https://github.com/libgd/libgd/releases/download/gd-2.2.5/libgd-2.2.5.tar.gz
sudo tar -xvof libgd-2.2.5.tar.gz
sudo mv libgd-2.2.5.tar.gz /tmp
cd libgd-2.2.5
sudo ./configure
sudo make
sudo make install

cd /root/nginx-install/development
sudo wget http://www.maxmind.com/app/c
sudo wget https://github.com/maxmind/geoip-api-c/releases/download/v1.6.11/GeoIP-1.6.11.tar.gz
sudo tar -xvof GeoIP-1.6.11.tar.gz
sudo mv GeoIP-1.6.11.tar.gz /tmp
cd GeoIP-1.6.11
sudo ./configure
sudo make
sudo make install


cd /root/nginx-install/development
sudo wget https://github.com/ivmai/libatomic_ops/releases/download/v7.6.8/libatomic_ops-7.6.8.tar.gz
sudo tar -xvof libatomic_ops-7.6.8.tar.gz
sudo mv libatomic_ops-7.6.8.tar.gz /tmp
cd libatomic_ops-7.6.8
sudo ./configure
sudo make
sudo make install


apt install libgd-dev libwebp-dev libgd-lua libperl-dev -y
cd /root/nginx-install/development/libgd-2.2.5
sudo ./configure --with-webp
sudo make
sudo make install
