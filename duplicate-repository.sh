#!/usr/bin/env bash

REPOLOCATION=$1
REPOADDRESS=$2
SKIPSANITYCHECK=$REPOADDRESS


if [ "$REPOADDRESS" = "" ]; then
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
  # Test that repo is accessible
fi

if [ "$REPOLOCATION" = "" ]; then
  CURRENTDIR=$(pwd)
  read -p "
Where do you want to create your service repository?
<return> to use current directory ($CURRENTDIR)
-------------------------------------------------------------------
> " REPOLOCATION

  if [ "$REPOLOCATION" = "" ]; then
    REPOLOCATION=$CURRENTDIR
  fi
fi

mkdir -p $REPOLOCATION

cd $REPOLOCATION

if [ "$SKIPSANITYCHECK" = "" ]; then
  echo "\n\nDuplicating fb-service-starter to $REPOADDRESS\n\nChecking out code at $REPOLOCATION\n\nIs this correct?"
  select confirm in "Yes" "No"; do
    case $confirm in
      Yes ) break;;
      No ) echo "\nStopping\n"; exit 1;;
    esac
  done
fi

if [ "$DEBUGINSTALL" != "" ]; then
  echo "Skipping duplication of repository now"
  echo $REPOADDRESS
  exit 0
fi

git clone --bare https://github.com/ministryofjustice/fb-service-starter.git

cd fb-service-starter.git

git push --mirror $REPOADDRESS

cd ..

rm -rf fb-service-starter.git

git clone $REPOADDRESS