bash
cd /root/nginx-install/development/nginx-1.16.1
patch -p01 < ../quiche/extras/nginx/nginx-1.16.patch

./configure \
--with-compat --add-dynamic-module=../ngx_brotli \
--with-stream \
--with-threads \
--prefix=/etc/nginx \
--build="Nginx-Enabled-Http/3" \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_v3_module \
--with-openssl=../quiche/deps/boringssl \
--with-quiche=../quiche \
--add-module=../nginx-rtmp-module \
--sbin-path=/usr/sbin/nginx \
--lock-path=/var/run/nginx.lock \
--conf-path=/etc/nginx/nginx.conf \
--pid-path=/run/nginx.pid \
--with-pcre=../pcre-8.43 \
--with-zlib=../zlib-1.2.11 \
--add-module=../nginx-vod-module \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--user=nginx \
--group=nginx \
--with-http_auth_request_module \
 --with-http_degradation_module \
--with-http_geoip_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_image_filter_module \
--with-http_mp4_module \
--with-http_perl_module \
--with-http_realip_module \
--with-http_secure_link_module \
--with-http_slice_module \
--with-http_ssl_module \
--with-http_stub_status_module \
--with-stream_ssl_module \
--with-stream



make -j12
make modules
make install 
