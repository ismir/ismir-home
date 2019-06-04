#!/bin/bash
set -ev

pwd

sshpass -p "${DEPLOY_PASSWORD}" \
	scp -rv -P 2222 \
	docs/_site/* \
	${DEPLOY_USER}@${DEPLOY_HOST}:~/public_html/
