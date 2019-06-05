#!/bin/bash
set -ev

scp -o "StrictHostKeyChecking no" -i id_rsa -P 2222 -rv ./docs/_site/* ${DEPLOY_USER}@${DEPLOY_HOST}:~/public_html/
