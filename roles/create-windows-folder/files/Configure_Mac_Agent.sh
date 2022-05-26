#!/bin/bash
###################################3
# Name: Configure_Mac_Agent.sh
# Purpose: Install and Configure Azure DevOps Release Agent on Mac Machine
# Developed By: MDE SRE
# Syntax: Called through Ansible role as but you can execute manually using following syntax.
#
# ./Configure_Mac_Agent.sh start --auth pat --token <TOKEN> --deploymentGroupName <DG-Name> --agent <Hostname>
#
# S.No| Version | Updated by | Updated on | Comments
# ---------------------------------------------------------------------------
# 0.1 | 0.2    | MDE SRE    | 16/2/2021  | Added shell interpreter line as other wise giving shell error through ansible.
# 0.2 | 0.3    | MDE SRE    | 16/2/2021  | Added tags for xplode prd
#
###################################
#Place this script in Downloads
Mac_Agent_CMD=$1
shift

# NOTE: Please change username as per your group_vars settings or we will add this logic in future.
TEMP_DIR=/Users/appuser/Desktop/Downloads

function Start()
{

    cd $TEMP_DIR
    echo "Downloading the Agent Package ..."
    # Latest version as on 16/2/2021
    curl -O https://vstsagentpackage.azureedge.net/agent/2.181.2/vsts-agent-osx-x64-2.181.2.tar.gz
    echo "Download Complete."
    #mkdir myagent && cd myagent
    echo "Doing untar of package..."
    tar xvfz $TEMP_DIR/vsts-agent-osx-x64-2.181.2.tar.gz
    echo "Unzip completed."
    #tar zxvf ~/Downloads/vsts-agent-osx-x64-2.171.1.tar.gz
    echo "Configuring the Agent $agent to our Deployment Group $pool ..."
    $TEMP_DIR/config.sh --unattended --url "https://dev.azure.com/microsoft" --auth pat --token $token --deploymentGroup --deploymentGroupName $deploymentGroupName --agent $agent --addDeploymentGroupTags --deploymentGroupTags "in,south,xplode,macos,ppe,hydlab" --projectName "Windows Defender"
    #$TEMP_DIR/config.sh --unattended --url "https://dev.azure.com/microsoft" --auth pat --token $token --deploymentGroup --deploymentGroupName $deploymentGroupName --agent $agent --addDeploymentGroupTags --deploymentGroupTags "us,west,xplode,macos,prd" --projectName "Windows Defender"
    echo "-- Starting the agent service in baskground..."
	  $TEMP_DIR/run.sh &
	  ./run.sh &
    echo "-- Starting the agent as a Launchd Service"
    $TEMP_DIR/svc.sh install
    # For this svc.sh to work, we need to disable SIP on the Mac VM
    $TEMP_DIR/svc.sh start
}

function Stop()
{
    "Stopping the agent as a Launchd Service"
    $TEMP_DIR/svc.sh stop
    #./svc.sh stop
    $TEMP_DIR/svc.sh uninstall
}

case $Mac_Agent_CMD in
    "start")
        while [[ $# -gt 0 ]]
            do
            option="$1"
            shift

            case $option in
                -a|--agent)
                    agent="$1"
                    if [ -z "$1" ]; then
                        error_exit "'$option' option requires an argument"
                    fi
                    shift
                    ;;
                -t|--token)
                    token="$1"
                    if [ -z "$1" ]; then
                        error_exit "'$option' requires an argument"
                    fi
                    shift
                    ;;
                -d|--deploymentGroupName)
                    deploymentGroupName="$1"
                    if [ -z "$1" ]; then
                        error_exit "'$option' requires an argument"
                    fi
                    shift
                    ;;    
                -*)
                    error_exit "Unknown option: '$option' Available options are -a, -t, -p"
                    ;;
                *)
                    error_exit "Unknown Argument. Please choose a option first"
            esac
        done
        Start;;
    "stop") 
        Stop;;
esac

exit 0