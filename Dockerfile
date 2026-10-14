FROM nginx:stable-alpine
ARG SITE_FILE=index.html
COPY website/assets/ /usr/share/nginx/html/assets/
COPY website/${SITE_FILE} /usr/share/nginx/html/index.html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
