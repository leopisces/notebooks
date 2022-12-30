FROM nginx:latest

RUN mkdir /app
COPY docs/.vuepress/dist/ /app

COPY nginx.conf /etc/nginx/nginx.conf
