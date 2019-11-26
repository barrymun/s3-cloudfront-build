#!/bin/bash
if [ -z "$1" ]
  then
    echo "s3 bucket name cannot be an empty string"
    exit 1
fi
if [ -z "$2" ]
  then
    echo "distribution id cannot be an empty string"
    exit 1
fi
s3cmd del "s3://$1" --recursive --force
npm run build
rm build/.DS_Store
s3cmd sync ./build/ "s3://$1"
aws cloudfront create-invalidation --distribution-id $2 --paths "/*"
rm -rf build
