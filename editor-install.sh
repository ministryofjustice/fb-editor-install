#!/usr/bin/env bash

EDITORLOCATION=$1

if [ "$REPOLOCATION" != "" ]; then
  CURRENTDIR=$(pwd)
  read -p "
  Where do you want to install the Form Builder editor code?
  <return> to use current directory ($CURRENTDIR)
  -------------------------------------------------------------------
  > " EDITORLOCATION

  if [ "$EDITORLOCATION" = "" ]; then
    EDITORLOCATION=$CURRENTDIR
  fi
fi

mkdir -p $EDITORLOCATION

cd $EDITORLOCATION

if [ "$DEBUGINSTALL" != "" ]; then
  echo "Skipping editor install now"
  exit 0
fi

git clone https://github.com/ministryofjustice/fb-editor-node.git

cd fb-editor-node

npm install

