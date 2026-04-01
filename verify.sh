#!/bin/bash

kubectl get pod nginx-pod &> /dev/null

if [ $? -ne 0 ]; then
  echo "Pod nginx-pod not found"
  exit 1
fi

STATUS=$(kubectl get pod nginx-pod -o jsonpath='{.status.phase}')

if [ "$STATUS" != "Running" ]; then
  echo "Pod is not running !"
  exit 1
fi

echo "Success: Pod is running"
exit 0
