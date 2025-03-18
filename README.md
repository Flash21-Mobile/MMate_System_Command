mmate_system을 관리하는 CMD 입니다

아래 코드를 터미널에서 실행해주세요
(깃허브가 전역에 설정되어 있어야 합니다)

git clone https://github.com/Flash21-Mobile/MMate_System_Command.git "$HOME/.mmate" && echo "export PATH=\$PATH:$HOME/.mmate" >> ~/.zshrc && source ~/.zshrc


### MMate System init
    $ mmate init

#### then Add this Code in pubspec.yaml
    core_system:
      path: mmate_system/core
    design_system:
      path: mmate_system/design
    function_system:
      path: mmate_system/function


### MMate Project Global Pub get
$ mmate pub get


### MMate System Upgrade
$ mmate upgrade


### Post new version MMate System 
$ mmate update
