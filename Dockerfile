FROM nginx:alpine

RUN adduser -D -g 'www' desafio-jackexperts

COPY ./TIMELINE.md /home/desafio-jackexperts

COPY ./custom_nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/cache/nginx /var/run /var/log/nginx /var/temp/nginx && \
chown -R desafio-jackexperts /var/cache/nginx /var/run /var/log/nginx /var/temp/nginx

RUN chown -R desafio-jack /usr/share/nginx/html

WORKDIR /usr/share/nginx/html

USER desafio-jackexperts

EXPOSE 8080

CMD [ "nginx", "-g", "daemon off;"]