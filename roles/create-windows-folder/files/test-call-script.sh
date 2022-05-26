#!/bin/bash
########################################
# Name: test-call-script.sh
# Purpose: Used to manually test Configure_Mac_Agent.sh script
#NOTE: Replace correct token, DG Name and Agent hostname before use.
########################################

./Configure_Mac_Agent.sh start --auth pat --token <TOKEN> --deploymentGroupName prd-md-xplat-xplode-pipelinedg-us-west-0 --agent $VMName