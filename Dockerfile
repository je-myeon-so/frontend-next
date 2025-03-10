FROM node:22.14.0-alpine as build-stage
WORKDIR /app
COPY package*.json ./

# Yarn is already installed
RUN npm install
COPY . .
RUN npm run build

# production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/out /usr/share/nginx/html

# copy the custom nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
