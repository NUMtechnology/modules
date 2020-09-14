#!/bin/sh

echo "Deleting old files"
aws s3 rm s3://$MODULE_S3_BUCKET/ --recursive
exit_code=$?

# exit on failure
if [ $exit_code = 0 ];  then
  echo "Delete old files successful"
else
  echo "Delete failed. Exiting with code $exit_code"
  exit $exit_code
fi



echo "Uploading modules files with version '$IMG_NAME'"
aws s3 cp /upload/ s3://$MODULE_S3_BUCKET/ --recursive
exit_code=$?

# exit on failure
if [ $exit_code = 0 ];  then
  echo "Upload new files successful"
else
  echo "Upload new files failed. Exiting with code $exit_code"
  exit $exit_code
fi