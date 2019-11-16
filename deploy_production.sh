#!/bin/bash
#
# Usage: 
#  - Provide your SSH private key as the first argument to this script.
# 
# Sample Call
# $ ./deploy_production ~/.ssh/id_rsa

set -ev

chmod 600 $1

# via SSH -- kept for posterity
###################################
# scp -o "StrictHostKeyChecking no" \
# 	-i $1 \
# 	-P 2222 \
# 	-rv ./docs/_site/* \
# 	${DEPLOY_USER}@${DEPLOY_HOST}:~/public_html/

rsync -e "ssh -p 2222 -i $1 -o StrictHostKeyChecking=no" \
	--delete-after \
	-rvc ./docs/_site/* \
	${DEPLOY_USER}@${DEPLOY_HOST}:~/public_html/