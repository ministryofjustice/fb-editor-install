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


sh $SCRIPTDIR/node-install.sh && source ~/.bash_profile && sh $SCRIPTDIR/editor-install.sh $EDITORLOCATION && sh $SCRIPTDIR/duplicate-repository.sh $REPOLOCATION $REPOADDRESS

SERVICEDATA=$REPOLOCATION/$REPODIR
# need to get repo name back
echo "Kill this window and open a new one\n\ncd $EDITORLOCATION/fb-editor-node\n\nSERVICEDATA=$SERVICEDATA npm start"