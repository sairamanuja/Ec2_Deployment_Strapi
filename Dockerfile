FROM node:20-alpine

RUN apk add --no-cache build-base gcc autoconf automake libtool pkgconfig python3

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build

EXPOSE 1337

ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=1337

CMD ["npm", "start"]
