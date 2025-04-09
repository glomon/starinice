FROM node:18-slim

WORKDIR /app

COPY package.json yarn.lock ./

# Install Python (for node-gyp etc.)
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Medusa CLI globally
RUN yarn global add @medusajs/medusa-cli

# Install project dependencies
COPY . .
RUN yarn install

# Build the app
RUN yarn build

# Expose port
EXPOSE 9000

# Start server (migrate + run)
CMD medusa migrations run && yarn start
