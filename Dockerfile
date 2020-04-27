FROM node:lts-alpine as builder

WORKDIR /usr/app

ENV NODE_ENV production

# 使用npmrc文件配置环境
COPY .npmrc .npmrc
COPY package.json package-lock.json /usr/app/
RUN npm install
RUN rm -f .npmrc

ADD . /usr/app
RUN npm run build

FROM nginx:alpine
COPY --from=builder /usr/app/public /var/www
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
ENTRYPOINT ["nginx","-g","daemon off;"]