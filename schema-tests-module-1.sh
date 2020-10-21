#!/bin/sh
#
# This script depends on `nodejs`, `npm`, and `ajv` which should be installed using `npm install -g ajv-cli`
#
VERSION="0.1.22"

#download interpreter if needed
if ! [ -e interpreter.jar ]; then
  curl https://repo1.maven.org/maven2/uk/modl/java-interpreter/${VERSION}/java-interpreter-${VERSION}-exe.jar > interpreter.jar
fi

# Generate test files from MODL files
success=true
for f in $(find ./tests/1 -name '*.modl'); do
  echo "Generating JSON from MODL $f..."
  out=$(java -jar interpreter.jar $f >$f.json);
  if ! [ $? = 0 ]; then
    echo "error on file $f"
    success=false
  fi
done

if [ "$success" = true ]; then
# Tests for module 1 - the Contacts module
  for f in $(find ./tests/1 -name '*.json'); do
    echo "checking $f..."
    out=$(ajv validate -s data/1/schema.json -d $f)
    if ! [ $? = 0 ]; then
      echo "error on file $f"
      success=false
    fi
  done
else
  echo "Conversion of MODL to JSON failed. Please check the logs for more details"
  exit 1
fi

#set relevant exit code
if [ "$success" = true ]; then
  echo "tests successful"
  exit 0
else
  echo "tests failed. Please check the logs for more details"
  exit 1
fi
