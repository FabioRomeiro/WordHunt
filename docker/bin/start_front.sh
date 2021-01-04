#!/bin/bash
cd /app/frontend
API_MOCK=1 npm run build
pm2 serve ./dist -i 2 --name=vue -l /tmp/vue.log
pm2 logs
