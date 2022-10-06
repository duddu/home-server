FROM nginx:1.23.1-alpine

ENV TZ=Europe/London

RUN touch /var/run/nginx.pid && \
    chown nginx:nginx /var/run/nginx.pid && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /usr/share/nginx

COPY nginx.conf /etc/nginx/nginx.conf

USER nginx