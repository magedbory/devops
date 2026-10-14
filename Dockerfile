FROM nginx:alpine

COPY ./index.githtml /usr/share/nginx/html/index.html
COPY ./README.md /usr/share/nginx/html/README.md

EXPOSE 80

