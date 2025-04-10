#!/bin/bash


# Function to display help message .
# This function helps to print the example commands and usage.
show_help() {
    echo "Example: build_docker_image Dockerfile kla:0.0.1 /home/kla/app"
    echo "Example: copy_prerequisites 10.0.0.2 /local/path /remote/path"
    echo "Example: run_docker_container 10.0.0.2 kla:0.0.1 -d -p 8080:80"
}

# This function runs when user passes --help
if [[ "$1" == "--help" ]]; then
  show_help
  exit 0
fi


# Function to build a Docker image based on user parameters.
# This function uses the parameters passed during execution and performs multiple checks to determine the required action.
# If the user provides a remote host name or IP, it connects to the remote machine and creates a Docker container there.
# Otherwise, it builds the container locally.

build_docker_image() {
    # Assigning Parameters to local Variable
    local dockerfile="$1"
    local tag="$2"
    local location="$3"
    local remotemachine="$4"

    # Condition to check the required parameter are passed during execution
    # if not it will exit from the script and print help command
    if ! [ "$dockerfile" ] || ! [ "$tag" ] || ! [ "$location" ]; then
        echo "Error: Missing or incorrect parameters."
        echo "Please run --help as a parameter to know the usage"
        return 1
    fi
    # If the parameter has a remotemachine details , it will connect to the machine and build docker container in it.
    # else it will build it in local machine
    if [ -n "$remotemachine" ]; then
        ssh "$remotemachine" "docker build -t $tag -f $dockerfile $location"
    else
        docker build -t "$tag" -f "$dockerfile" "$location"
    fi
}

# Function to copy prerequisites to a remote machine based on user parameters.
# This function uses the parameters passed during the execution and copy the files to the remote machine destination.
copy_prerequisites() {
    # Assigning Parameters to local Variable
    local remotemachine="$1"
    local path="$2"
    local destination="$3"

    # Condition to check the required parameter are passed during execution
    # if not it will exit from the script and print help command
    if ! [ "$remotemachine" ] || ! [ "$path" ] || ! [ "$destination" ]; then
        echo "Error: Missing or incorrect parameters."
        echo "Please run --help as a parameter to know the usage"
        return 1
    fi

    #Copying files to destination.
    scp -r "$path" "$remotemachine:$destination"
}

# Function to run a Docker container based on user parameters passed during the execution.
# It takes image name, container name, port, environment variable, volume as a parameter value.
# And run docker docker container in a remote machine if remote machine details are passed or else it will run it locally.
run_docker_container() {
    # Assigning Parameters to local Variable
    local remotemachine="$1"
    local image="$2"


    # Condition to check the required parameter are passed during execution
    # if not it will exit from the script and print help command
    if   [ -z "$image" ]; then
        echo "Error: Missing or incorrect parameters."
        echo "Please run --help as a parameter to know the usage"
        return 1
    fi

    # It will remove the first two parameters and store the rest of the parameters as docker arguments.
    # Arguments will be used to run docker command.
    shift 2
    local options="$@"

    # If the parameter has a remotemachine details , it will connect to the machine and run docker container in it.
    # else it will run it in local machine.
    if [ -n "$remotemachine" ]; then
      ssh "$remotemachine" docker run "$options" "$image"
    else
    docker run "$options" "$image"
    fi
}

