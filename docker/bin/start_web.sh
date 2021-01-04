#!/bin/bash
uwsgi --ini /app/uwsgi.ini --processes=$UWSGI_PROCESSES
cd /app/frontend
npm run build
pm2 serve ./dist -i 2 --name=vue -l /tmp/vue.log
cd /app
./manage.py collectstatic --no-input
./manage.py migrate --no-input
tail -f /dkdata/uwsgi.log
