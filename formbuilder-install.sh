#!/usr/bin/env bash

SCRIPTDIR=$(dirname "$0")
if [ "$SCRIPTDIR" = "." ]; then
  SCRIPTDIR=$(pwd)
else
  SCRIPTDIR=$(pwd)/$SCRIPTDIR
fi

echo "\n\nDo you want to create a formbuilder directory in your home directory?\n\n"
select fbDirectory in "Yes" "No"; do
  case $fbDirectory in
    Yes ) USEFBDEFAULTS="yes"; mkdir -p ~/formbuilder; cd ~/formbuilder; break;;
    No ) break;;
  esac
done

CURRENTDIR=$(pwd)

if [ "$USEFBDEFAULTS" = "yes" ]; then
  EDITORLOCATION=$CURRENTDIR
  REPOLOCATION=$CURRENTDIR
else
  read -p "
Where do you want to install the Form Builder editor code?
<return> to use current directory ($CURRENTDIR)
-------------------------------------------------------------------
> " EDITORLOCATION

  if [ "$EDITORLOCATION" = "" ]; then
    EDITORLOCATION=$CURRENTDIR
  fi

  read -p "
Where do you want to create your service repository?
<return> to use current directory ($CURRENTDIR)
-------------------------------------------------------------------
> " REPOLOCATION

  if [ "$REPOLOCATION" = "" ]; then
    REPOLOCATION=$CURRENTDIR
  fi

fi

echo "\nHave you already made your new repo?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) break;;
    No ) echo "\nPlease make your repo and start again\n"; exit;;
  esac
done

read -p "
What is your repo's address?
-------------------------------------------------------------------
> " REPOADDRESS

REPODIR="${REPOADDRESS//.git}"
REPODIR=$(sed s/.*\\///g <<<$REPODIR)

echo "\n\nDo you want to check out the example service (fb-example-service)?\n\n"
select fbExample in "Yes" "No"; do
  case $fbExample in
    Yes ) EXAMPLECLONE="yes"; break;;
    No ) break;;
  esac
done

loadNVM () {
  NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # try loading NVM from ~/.nvm
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh" # try loading NVM from /usr/local/opt
  NVM=$(command -v nvm)
  if [ "$NVM" != "" ]; then
    echo 'Reloading nvm'
    nvm use stable
  fi
}

sh $SCRIPTDIR/node-install.sh
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi

# source ~/.bash_profile
loadNVM

sh $SCRIPTDIR/editor-install.sh $EDITORLOCATION
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi

sh $SCRIPTDIR/duplicate-repository.sh $REPOLOCATION $REPOADDRESS
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi


if [ "$EXAMPLECLONE" != "" ]; then
  git clone https://github.com/ministryofjustice/fb-example-service.git
  EXAMPLESTART="\n\nExample service can be run with the following command\n\nSERVICEDATA=$REPOLOCATION/fb-example-service npm start\n\n--------------------------------------"
fi


SERVICEDATA=$REPOLOCATION/$REPODIR
# need to get repo name back
CDEDITOR="cd $EDITORLOCATION/fb-editor-node"
STARTEDITOR="SERVICEDATA=$SERVICEDATA npm start"

echo "\n\n\n\n--------------------------------------\n\nInstructions to run the Form Builder editor\n\n$CDEDITOR\n\n$STARTEDITOR\n\nNB. You will have to close this window and start a new terminal session if you did not have Node installed previously\n\n--------------------------------------$EXAMPLESTART\n\n\n\nStarting the editor now\n\n\n\n"

cd $EDITORLOCATION/fb-editor-node

SERVICEDATA=$SERVICEDATA npm start
