#!/bin/bash
# *** avoid s3cmd
# ref: https://stackoverflow.com/a/10406356
# and: https://petersmith.org/blog/2017/05/31/mime-types-on-asw-s3/
if [ -z "$1" ]
  then
    echo "s3 bucket name cannot be an empty string"
    exit 1
fi
if [ -z "$2" ]
  then
    echo "cloudfront distribution id cannot be an empty string"
    exit 1
fi
npm run build
rm build/.DS_Store
aws s3 rm --recursive "s3://$1"  # delete the contents of the bucket
aws s3 sync ./build/ "s3://$1"
aws cloudfront create-invalidation --distribution-id $2 --paths "/*"
rm -rf build
