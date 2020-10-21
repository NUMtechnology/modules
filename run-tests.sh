#!/bin/sh
#script that downloads an interpreter and checks all the MODL files

VERSION="0.1.22"

#download interpreter
curl https://repo1.maven.org/maven2/uk/modl/java-interpreter/${VERSION}/java-interpreter-${VERSION}-exe.jar > interpreter.jar

#check the files with the interpreter
success=true
for f in $(find ./data -name '*.txt'); do
  echo "checking $f...";
  out=$(java -jar interpreter.jar $f);
  if ! [ $? = 0 ]; then
    echo "error on file $f";
    success=false;
  fi
done

#delete interpreter file (don't need it anymore)
rm interpreter.jar

#set relevant exit code
if [ "$success" = true ]; then
  echo "tests successful";
  exit 0;
else
  echo "tests failed. Please check the logs for more details";
  exit 1;
fi