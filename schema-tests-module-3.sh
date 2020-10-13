#
# This script depends on `nodejs`, `npm`, and `ajv` which should be installed using `npm install -g ajv-cli`
#

# Tests for module 3 - the Images module
success=true
for f in $(find ./tests/3 -name '*.json'); do
  echo "checking $f..."
  out=$(ajv validate -s data/3/schema.json -d $f)
  if ! [ $? = 0 ]; then
    echo "error on file $f"
    success=false
  fi
done

#set relevant exit code
if [ "$success" = true ]; then
  echo "tests successful"
  exit 0
else
  echo "tests failed. Please check the logs for more details"
  exit 1
fi
