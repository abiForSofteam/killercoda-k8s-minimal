#!/bin/bash

# Verify that the learner has observed the endpoints in the ecommerce namespace
# Step 1 is an observation step — pass as long as the namespace and resources exist

kubectl get endpoints -n ecommerce &>/dev/null
if [ $? -eq 0 ]; then
  echo "done"
  exit 0
fi

exit 1
