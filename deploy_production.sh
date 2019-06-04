#!/bin/bash
set -ev

pwd

sshpass -p "${DEPLOY_PASSWORD}" scp -P 2222 -rv ./docs/_site/* ${DEPLOY_USER}@${DEPLOY_HOST}:~/public_html/
