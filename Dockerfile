# Use official Node.js LTS image for better stability
FROM node:18-slim

# Set working directory
WORKDIR /app/medusa

# Copy package files first for better caching of dependencies
COPY package.json yarn.lock ./

# Install Python and required packages
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Medusa CLI globally
RUN yarn global add @medusajs/medusa-cli

# Install project dependencies
COPY . .
RUN yarn install

# Build the project
RUN yarn build

# Run database migrations and start server
CMD medusa migrations run && yarn start
