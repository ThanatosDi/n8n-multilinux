ARG NODE_TAG=lts-trixie-slim

FROM node:${NODE_TAG}

ARG N8N_VERSION=latest

# 安裝必要的系統依賴和 tini
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    graphicsmagick \
    tini \
    tzdata \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 設置工作目錄
WORKDIR /home/node

# 全域安裝 n8n
RUN npm install -g n8n@${N8N_VERSION} && \
    npm cache clean --force

# 創建必要的目錄並設置權限
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node

# 複製 entrypoint 腳本
COPY --chown=node:node docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# 設置環境變數
ENV NODE_ENV=production \
    SHELL=/bin/sh

# 暴露 n8n 預設端口
EXPOSE 5678/tcp

# 切換到 node 用戶
USER node

# 設置入口點
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
