FROM node:10-alpine
WORKDIR /opt/app
COPY package.json ./
COPY ./ ./
RUN npm install
EXPOSE 3000
CMD [ "npm", "run", "start" ]
