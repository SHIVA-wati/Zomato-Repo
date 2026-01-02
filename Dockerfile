# # Use Node.js 16 slim as the base image
# FROM node:20-alpine As dev

# # Set the working directory
# WORKDIR /app

# # Copy package.json and package-lock.json to the working directory
# COPY package*.json ./

# # Install dependencies
# RUN npm install

# # Copy the rest of the application code
# COPY . .



# FROM dev As final

# # Build the React app
# RUN npm run build --production

# # Expose port 3000 (or the port your app is configured to listen on)
# EXPOSE 3000

# # Start your Node.js server (assuming it serves the React app)
# CMD ["npm", "start"]




# ---------- Build stage ----------
FROM node:20-bookworm-slim AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build

# ---------- Runtime stage ----------
FROM nginx:1.27-alpine

# Remove default nginx config
RUN rm -rf /usr/share/nginx/html/*

# Copy build output
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

