#!/bin/sh

# assume AWS role if one is provided
if [ ! -z "$AWS_ROLE" ]; then
  echo "AWS_ROLE was set, assuming the role"
  JSON=$(aws sts assume-role --role-arn "$AWS_ROLE" --role-session-name "upload-modules-files-to-S3")
  exit_code=$?
  if [ ! $exit_code = 0 ];  then
    echo "Failed to assume role, exiting with code $exit_code"
    exit $exit_code
  fi

  export AWS_ACCESS_KEY_ID=$(echo ${JSON}     | jq --raw-output ".Credentials[\"AccessKeyId\"]")
  export AWS_SECRET_ACCESS_KEY=$(echo ${JSON} | jq --raw-output ".Credentials[\"SecretAccessKey\"]")
  export AWS_SESSION_TOKEN=$(echo ${JSON}     | jq --raw-output ".Credentials[\"SessionToken\"]")
  echo "using access key id: $AWS_ACCESS_KEY_ID"
fi



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