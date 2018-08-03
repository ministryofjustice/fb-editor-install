#!/usr/bin/env bash

NODEMINVERSION="10.6.0"
NODEINSTALLVERSION="10.7.0"
NODE=$(command -v node)
NODEVERSION=''
if [ "$NODE" != "" ]; then
  NODEVERSION=$(node --version | tr -d v)
fi
export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # try loading NVM from ~/.nvm
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh" # try loading NVM from /usr/local/opt
NVM=$(command -v nvm)
BREW=$(command -v brew)

# echo $NVM
# echo $BREW
# echo $NODE
# echo $NODEVERSION
# exit 0

vercomp () {
  if [[ $1 == $2 ]]
  then
    return 0
  fi
  local IFS=.
  local i ver1=($1) ver2=($2)
  # fill empty fields in ver1 with zeros
  for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
  do
    ver1[i]=0
  done
  for ((i=0; i<${#ver1[@]}; i++))
  do
    if [[ -z ${ver2[i]} ]]
    then
      # fill empty fields in ver2 with zeros
      ver2[i]=0
    fi
    if ((10#${ver1[i]} > 10#${ver2[i]}))
    then
      return 1
    fi
    if ((10#${ver1[i]} < 10#${ver2[i]}))
    then
      return 2
    fi
  done
  return 0
}

checkNodeVersion () {
  OUTPUT=$1
  NODEVERSION=$(node --version | tr -d v)
  vercomp $NODEMINVERSION $NODEVERSION
  VERSIONRESULT=$?
  if [ "$VERSIONRESULT" = "1" ]; then
    echo "\n\n$OUTPUT\n\n"
    exit 1
  fi
}

if [ "$NVM" != "" ]; then
  checkNodeVersion "Please use nvm to install Node $NODEMINVERSION or higher"
  echo "\n\nYou already have nvm and a sufficient version of Node ($NODEVERSION) installed\n\n"
  exit 0
fi

if [ "$NODE" != "" ]; then
  checkNodeVersion "Node version $NODEVERSION is not high enough - $NODEMINVERSION or above required\n\nConsider using a Node version manager like nvm"
  echo "\n\nYou already have a sufficient version of Node ($NODEVERSION) installed.\n\nYou might consider using a Node version manager like nvm\n\n"
  exit 0
fi

if [ "$DEBUGINSTALL" != "" ]; then
  echo "Skipping installation of brew, nvm and node now"
  exit 0
fi

if [ "$BREW" = "" ]; then
  if [ -d "/usr/local/Cellar" ]; then
    echo "\n\nIt looks like brew has already been installed on this machine - /usr/local/Cellar found but no brew\n\n"
    exit 1
  fi
  echo "\n\nInstalling brew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "\n\nHomebrew already installed\n\n"
fi


echo Should not get here if Node or NVM installed
exit 0

brew install nvm

mkdir ~/.nvm # is this necessary?

echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bash_profile
echo '. "/usr/local/opt/nvm/nvm.sh"' >> ~/.bash_profile

source ~/.bash_profile

nvm install v$NODEINSTALLVERSION

echo 'nvm use stable' >> ~/.bash_profile
