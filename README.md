# Form Builder Editor install scripts

Shell scripts to install [Form Builder Editor](https://github.com/ministryofjustice/fb-editor-node) and set up service repos.

On a Mac.

Windows-flavour to come.


## Requirements

- Admin rights on your computer
- If `Node` not already installed, your `.bash_profile` must be writeable


## Usage

```
git clone https://github.com/ministryofjustice/fb-editor-install.git
```

You can then run any of the following scripts:


## Full install script

```
sh fb-editor-install/formbuilder-install.sh
```

This script assumes (but prompts you to confirm) that you have already made a git repository for your service.

After prompting you for the location of your service repositiory and where you want things installed, this script runs the following scripts:

- `node-install.sh`
  ensures that `Node` is installed (see `Install Node script`, below for details).
- `editor-install.sh`
  installs the Form Builder Editor (see `Install Editor script` below for details)
- `duplicate-repository.sh`
  duplicates a starter repository to your service repository (see `Duplicate fb-service-starter repository script` below for details)

At the end of the script, instructions on how to run the editor are echoed back to you.

NB. you must close the terminal window you ran the script in and open a new one for your terminal to pick up the newly installed `Node`.


### Install Node script

```
sh fb-editor-install/node-install.sh
```

The script will check for any previously installed versions of `Node` (the Javascript runtime engine), `nvm` (a Node version manager) and `brew` (a Mac OS application manager).

- If `Node` is found
  - and it satisfies the version requirements, then the script does nothing further.
  - but is beneath the version requirement threshold, the script will abort and inform you that the requirement has not been met. *It is up to you to decide how to resolve that issue, but we recommend the use of a version manager like `nvm`.*
- If `Node` is not found, the script checks for `nvm`
  - If `nvm` is not found, the script checks for `brew`
    - If `brew` is not found, the script installs `brew` and then uses `brew` to install `nvm`
  - The script then uses `nvm` to install `Node`

**NB. no version of `Node`, `nvm` or `brew` will be overwritten by this script**


### Install Editor script

```
sh fb-editor-install/editor-install.sh
```

- checks out [Form Builder Editor](https://github.com/ministryofjustice/fb-editor-node)
- installs dependencies


### Duplicate fb-service-starter repository script

This script assumes (but prompts you to confirm) that you have already made the git repository for your service.

```
sh fb-editor-install/duplicate-repository.sh
```

- checks out a copy of [fb-service-starter](https://github.com/ministryofjustice/fb-service-starter.git)
- pushes that back to your repository