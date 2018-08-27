#!/bin/bash

cd ../creds
tar -czf credentials.tar.gz cluster gcloud-service-key.json
travis encrypt-file credentials.tar.gz
mv -f credentials.tar.gz.enc ../
