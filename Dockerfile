FROM node:20-alpine AS build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .

ARG VITE_API_URL
ARG VITE_WS_URL
ARG VITE_REFRESH_INTERVAL_MS=240000
ARG VITE_REFRESH_SKEW_MS=60000
ARG VITE_GOOGLE_CLIENT_ID

ENV VITE_API_URL=$VITE_API_URL \
    VITE_WS_URL=$VITE_WS_URL \
    VITE_REFRESH_INTERVAL_MS=$VITE_REFRESH_INTERVAL_MS \
    VITE_REFRESH_SKEW_MS=$VITE_REFRESH_SKEW_MS \
    VITE_GOOGLE_CLIENT_ID=$VITE_GOOGLE_CLIENT_ID

RUN npm run build

FROM nginx:1.28-alpine AS runtime

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://127.0.0.1/ || exit 1
