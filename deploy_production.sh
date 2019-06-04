#!/bin/bash
set -ev

sshpass -p "${DEPLOY_PASSWORD}" \
	scp -rv -P 2222 \
	_site/* \
	${DEPLOY_USER}@${DEPLOY_HOST}:~/public_html/
