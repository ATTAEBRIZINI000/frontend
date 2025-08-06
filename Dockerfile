# Builder stage
FROM node:22-alpine3.21 AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build

# Production stage
FROM node:22-alpine3.21 AS production

WORKDIR /app

# Install serve to host the static files
RUN npm install -g serve

# Copy the built Vite files
COPY --from=builder /app/dist ./dist

EXPOSE 4000

# Serve the static files
CMD ["serve", "-s", "dist", "-l", "4000"]
