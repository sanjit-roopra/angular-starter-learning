FROM node:14-alpine as start
RUN apk add chromium
ENV NODE_ENV=development
ENV CHROME_BIN=/usr/bin/chromium-browser
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
RUN npm ci --cache ~/.npm --prefer-offline

FROM start as builder
WORKDIR /usr/src/app
COPY . .
RUN npm run build

FROM nginx:alpine as runtime
COPY --from=builder /usr/src/app/dist/angular-starter /usr/share/nginx/html
EXPOSE 80