
adduser --system --shell /bin/false --no-create-home --disabled-login --disabled-password --gecos "nginx user" --group nginx

echo "++++++++++++++++++++++++++++++++++++++++++++
copy directory
++++++++++++++++++++++++++++++++++++++++++++"
rm -rf /etc/nginx
mkdir /etc/nginx
rm -rf /usr/sbin/nginx
mkdir /etc/nginx/certs
mkdir /etc/nginx/conf.d
mkdir /etc/nginx/sites-enabled
mkdir /etc/nginx/sites-available
mkdir /etc/nginx/modules
mkdir /var/log/nginx
ln -s /usr/local/nginx/sbin/nginx /usr/sbin/
cp -r /usr/local/nginx/conf/* /etc/nginx
rm -rf /etc/nginx/nginx.conf
cp objs/*.so /etc/nginx/modules
chmod 644 /etc/nginx/modules/*.so

echo "+++++++++++++++++++++++++++++++++++++++++++
enable systemd nginx
+++++++++++++++++++++++++++++++++++++++++++"
cat >/lib/systemd/system/nginx.service <<EOL
[Unit]
Description=Nginx - With Boringssl and http3
Documentation=https://nginx.org/en/docs/
After=network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target
[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t -c /etc/nginx/nginx.conf
ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s TERM $MAINPID
[Install]
WantedBy=multi-user.target
EOL


echo "+++++++++++++++++++++++++++++++++++++++++++
Create default nginx configuration
+++++++++++++++++++++++++++++++++++++++++++"
cat >/etc/nginx/sites-available/default <<EOL
server {
       listen 80 default_server;
       listen [::]:80 default_server;
       server_name _;
       root /var/www/html;
       index index.php index.html index.htm index.nginx-debian.html;
       location / {
               try_files $uri $uri/ =404;
       }
}
EOL

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/certs/private.key -out /etc/nginx/certs/cert.crt


cat >/etc/nginx/sites-available/default-http3 <<EOL
server {
        # Enable QUIC and HTTP/3.
        listen 443 quic reuseport;
        # Enable HTTP/2 (optional).
        listen 443 ssl http2;
        
        ssl_certificate      /etc/nginx/certs/cert.crt;
        ssl_certificate_key  /etc/nginx/certs/private.key;
        # Enable all TLS versions (TLSv1.3 is required for QUIC).
        ssl_protocols TLSv1.2 TLSv1.3;
        # Add Alt-Svc header to negotiate HTTP/3.
        add_header alt-svc 'h3-23=":443"; ma=86400';
}
EOL
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/default-http3 /etc/nginx/sites-enabled/

cat >/etc/nginx/conf.d/proxy.conf <<EOL
proxy_redirect          off;
client_max_body_size    10m;
client_body_buffer_size 128k;
proxy_connect_timeout   90;
proxy_send_timeout      90;
proxy_read_timeout      90;
proxy_buffers           32 4k;
EOL



cat >/etc/nginx/nginx.conf <<EOL
user       www-data;  
worker_processes  auto;  
error_log  /var/log/nginx/error.log crit;
pid        /var/run/nginx.pid;
worker_rlimit_nofile 8192;
load_module /etc/nginx/modules/ngx_http_brotli_filter_module.so;
load_module /etc/nginx/modules/ngx_http_brotli_static_module.so;
events {
  worker_connections  4096;
}
http {
  include    /etc/nginx/mime.types;
  include    /etc/nginx/conf.d/proxy.conf;
  include    /etc/nginx/fastcgi.conf;
  include    /etc/nginx/sites-enabled/*;
  default_type application/octet-stream;
  access_log   /var/log/access.log  off;
  sendfile     on;
  tcp_nopush   on;
  #brotli
  brotli on;
  brotli_static on;
  brotli_comp_level 9;
  brotli_types text/xml image/svg+xml application/x-font-ttf image/vnd.microsoft.icon application/x-font-opentype application/json font/eot application/vnd.m$
  server_names_hash_bucket_size 128;

}
EOL


systemctl daemon-reload

systemctl restart nginx

echo "====================================================================================
ALL DONE!!!
===================================================================================="

echo "+++++++++++++++++++++++++++++++++++++++++++
You can run with this command
+++++++++++++++++++++++++++++++++++++++++++
systemctl start nginx
systemctl status nginx
+++++++++++++++++++++++++++++++++++++++++++
Then check your browser
+++++++++++++++++++++++++++++++++++++++++++
http://localhost
https://localhost"

exit;

