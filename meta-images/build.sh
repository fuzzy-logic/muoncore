#!/bin/bash

COMPONENTS=$(ls -d */)

HERE=$(pwd)


for CP in $COMPONENTS 
do
  echo "Building $CP"
  cd $CP
  ./build.sh
  cd $HERE
done

echo "Simple PaaS:  Meta Images built and locally installed."
