FROM nginx:alpine
COPY html/filter.html /var/sites/highlight/sng3d/
COPY html/highlight.html /var/sites/highlight/sng3d/
COPY html/highlight2.html /var/sites/highlight/sng3d/
COPY html/highlight-text.html /var/sites/highlight/sng3d/
COPY html/testpage.html /var/sites/highlight/sng3d/
COPY nginx/conf/nginx-server.conf /etc/nginx/conf.d/default.conf
