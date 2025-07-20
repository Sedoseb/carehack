FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy source files (except node_modules, thanks to .dockerignore)
COPY . .

# Build the app
RUN npm run build

FROM nginx:alpine

# Clear default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy the build output to nginx folder
COPY --from=builder /app/dist/public /usr/share/nginx/html

# Fix permissions (optional)
RUN chmod -R 755 /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
