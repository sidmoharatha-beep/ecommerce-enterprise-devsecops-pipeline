FROM node:20-alpine AS builder

WORKDIR /app

COPY app/package*.json ./
RUN npm ci --ignore-scripts --no-audit --no-fund

COPY app/ ./
RUN npm run build 2>/dev/null || true

FROM node:20-alpine AS runtime

ENV NODE_ENV=production
ENV PORT=3000

RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

WORKDIR /app

COPY --from=builder --chown=appuser:appgroup /app/package*.json ./
COPY --from=builder --chown=appuser:appgroup /app/node_modules ./node_modules
COPY --from=builder --chown=appuser:appgroup /app/server.js ./
COPY --from=builder --chown=appuser:appgroup /app/routes ./routes
COPY --from=builder --chown=appuser:appgroup /app/frontend ./frontend
COPY --from=builder --chown=appuser:appgroup /app/lib ./lib
COPY --from=builder --chown=appuser:appgroup /app/models ./models
COPY --from=builder --chown=appuser:appgroup /app/data ./data
COPY --from=builder --chown=appuser:appgroup /app/config ./config
COPY --from=builder --chown=appuser:appgroup /app/i18n ./i18n

USER appuser

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/ || exit 1

CMD ["node", "server.js"]
