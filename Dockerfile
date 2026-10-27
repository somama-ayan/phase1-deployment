# -------- build stage ----------
FROM node:22-alpine AS builder

WORKDIR /src

COPY package.json ./

RUN if [ -f package-lock.json ]; then \
      npm ci --omit=dev; \
    else \
      npm install --omit=dev; \
    fi

# -------- runtime stage ----------
FROM node:22-alpine AS runtime

ENV NODE_ENV=production
ENV PORT=3000

WORKDIR /app

COPY --from=builder --chown=node:node /src/node_modules ./node_modules
COPY --chown=node:node package.json app.js ./

USER node

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "fetch('http://localhost:3000/health').then(r => process.exit(r.ok ? 0 : 1)).catch(() => process.exit(1))"

EXPOSE 3000

CMD ["node", "app.js"]
