FROM nginx:stable-alpine
ARG SITE_FILE=index.html
COPY website/${SITE_FILE} /usr/share/nginx/html/index.html
EXPOSE 80
