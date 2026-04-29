FROM node:20-alpine

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN corepack enable

WORKDIR /app

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY patches ./patches
COPY server/package.json ./server/package.json

RUN pnpm install --filter server... --frozen-lockfile

COPY server ./server

RUN pnpm --filter server build

WORKDIR /app/server

ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000

CMD ["pnpm", "start:prod"]
