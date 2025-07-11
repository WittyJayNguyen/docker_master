FROM node:18-alpine

# Install system dependencies
RUN apk add --no-cache \
    git \
    python3 \
    make \
    g++

# Set working directory
WORKDIR /app

# Install global packages
RUN npm install -g @vue/cli create-vue npm-check-updates

# Create user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

# Copy package files (will be overridden by volume mount)
COPY package*.json ./

# Install dependencies
RUN npm install

# Change ownership
RUN chown -R nextjs:nodejs /app
USER nextjs

# Expose ports
EXPOSE 3000 5173 8080

# Default command
CMD ["npm", "run", "dev"]
