FROM nginx:alpine


# RUN adduser -D -g 'www' desafio-jackexperts
ARG USER_ID=1001
ARG GROUP_ID=1001

RUN addgroup -g ${GROUP_ID} desafio-jackexperts && \
    adduser -D -u ${USER_ID} -G desafio-jackexperts desafio-jackexperts

COPY ./custom_nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/cache/nginx /var/run /var/log/nginx /var/temp/nginx && \
    chown -R desafio-jackexperts /var/cache/nginx /var/run /var/log/nginx /var/temp/nginx

RUN chown -R desafio-jackexperts /usr/share/nginx/html

WORKDIR /usr/share/nginx/html

USER desafio-jackexperts

EXPOSE 8080

CMD [ "nginx", "-g", "daemon off;"]