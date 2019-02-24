#!/bin/sh
sed -i -e "s/instance_name : \"searx\"/instance_name : \"${INSTANCE_NAME}\"/g" \
       -e "s/autocomplete : \"\"/autocomplete : \"${AUTOCOMPLETE}\"/g" \
       -e "s/language : \"en-US\"/language : \"${LANGUAGE}\"/g" \
       -e "s/base_url : False/base_url : ${BASE_URL}/g" \
       -e "s/image_proxy : False/image_proxy : ${IMAGE_PROXY}/g" \
       -e "s/ultrasecretkey/$(openssl rand -hex 16)/g" \
       -e "s/default_locale : \"\"/default_locale : \"${DEFAULT_LOCALE}\"/g" \
       /usr/local/searx/searx/settings.yml

exec su-exec $UID:$GID /sbin/tini -- python3 /usr/local/searx/searx/webapp.py
