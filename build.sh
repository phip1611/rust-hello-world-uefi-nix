#!/bin/bash

set -e

EDK2_REPOSITORY_PATH="../edk2"

RED="\e[31m"
BOLD="\e[1m"
RESET="\e[0m"

# main allows us to move all function definitions to the end of the file
main() {
  #### STAGE 0: RUST BINARY
  # this build works because we have additional config
  # specified in .cargo/config.toml -> check out the comments there
  cargo build --target x86_64-unknown-uefi

  #### STAGE 1: PREREQUISITES FOR EDK2/OVMF BUILD

  require_command "cargo";
  require_command "rustc";

  # for EDK2/OVMF build
  # https://manpages.ubuntu.com/manpages/trusty/man1/iasl.1.html
  require_command "iasl";
  # https://de.wikipedia.org/wiki/Netwide_Assembler
  require_command "nasm";

  #### STAGE 2: BUILD EDK2

  # this is partly redundant to the steps in the README
  # the README.md MUST BE FOLLOWED ONCE FIRST to make sure to build everything successfully!
  # once this is done is not required it everytime but it's better to do this here too because
  #  - it doesn't cost much
  #  - make sure people read the README instead of just executing "build.sh"
  echo "Please make sure to follow the steps in the README to ${RED}properly initialize/configure the local edk2 project.${RESET}"
  require_directory $EDK2_REPOSITORY_PATH
  cd $EDK2_REPOSITORY_PATH
  make -C BaseTools
  cd OvmfPkg
  bash build.sh
}

################## all function definitions ##################

# Function that checks if a command is installed and if not aborts with a proper error message
require_command() {
  ARG=$1
  set +e
  which $ARG > /dev/null
  # check return code from previous command
  if [ $? != 0 ]
  then
    echo "${RED}The command ${BOLD}'$ARG'${RESET}${RED} must be installed on the system!${RESET}"
    exit 1
  fi
  set -e
}

require_directory() {
  DIR=$1
  # not exists
  if ! [ -d "$DIR" ]; then
    echo "${RED}The directory ${BOLD}'$DIR'${RESET}${RED} must exist and contain 'edk2'-repo (dir is repo-root)!${RESET}"
    exit 1
  fi
}

# call main
main
