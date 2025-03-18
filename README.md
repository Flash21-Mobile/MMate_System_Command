# This is the CMD for managing Mmate_System

### Please run the following code in the terminal
#### (GitHub should be set up globally)
    $ git clone https://github.com/Flash21-Mobile/MMate_System_Command.git "$HOME/.mmate" && echo "export PATH=\$PATH:$HOME/.mmate" >> ~/.zshrc && source ~/.zshrc


## How to Start
#### Please enter the following command in the terminal
    $ mmate init

After that, enter the following code in pubspec.yaml

    core_system:
      path: mmate_system/core
    design_system:
      path: mmate_system/design
    function_system:
      path: mmate_system/function


## Run pub get in the project globally
It can only be used in projects where mmate_system has been added and at the project root

    $ mmate pub get


## To upgrade to the latest version of MMate_System
It can only be used in project root

    $ mmate upgrade


## To post a new version of MMate System
It can only be used in project root

    $ mmate update
