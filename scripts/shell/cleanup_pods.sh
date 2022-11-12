#!/bin/bash

namespace=$1
pods_no=$(kubectl get pods -n $namespace --no-headers | grep -iv "running" | wc -l)

printf "$pods_no pods in $namespace will be deleted\n"
for pod in $(kubectl get pods -n $namespace -o custom-columns=":metadata.name" --no-headers)
do
    if [ $(kubectl get pod $pod -n $namespace -o jsonpath="{.status.phase}") != "Start" ]; then
        kubectl delete pod $pod -n $namespace;
    fi
done