#!/bin/sh

# 處理自訂 SSL 憑證
if [ -d /opt/custom-certificates ]; then
  echo "Trusting custom certificates from /opt/custom-certificates."
  export NODE_OPTIONS="--use-openssl-ca $NODE_OPTIONS"
  export SSL_CERT_DIR=/opt/custom-certificates
  c_rehash /opt/custom-certificates
fi

# 啟動 n8n
if [ "$#" -gt 0 ]; then
  # 使用參數啟動
  exec n8n "$@"
else
  # 無參數啟動
  exec n8n
fi
