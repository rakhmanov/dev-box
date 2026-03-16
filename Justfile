set shell := ["bash", "-cu"]

go_version := "1.26"
nodejs_version := "24"
python_version := "3.12"
terraform_version := "1"
kubectl_version := "latest"
awscli_version := "latest"
terragrunt_version := "latest"
starship_version := "1"
task_version := "3"

default:
    just bootstrap

bootstrap name="" email="":
    just apt_prepare
    just set_git_config "{{name}}" "{{email}}"
    ./scripts/fish_setup.sh
    ./scripts/mise_setup.sh
    just install_tools
    ./scripts/starship_setup.sh
    ./scripts/fish_completions_setup.sh
    ./scripts/krew_setup.sh
    echo "Completed"

apt_prepare:
    sudo apt update
    sudo apt install -y git curl wget unzip build-essential \
    fish fzf yq jq ripgrep fd-find \
    libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
    libsqlite3-dev llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev 

apt_full_upgrade:
    sudo apt update && sudo apt upgrade -y

set_git_config name email:
    git config --global user.name "{{name}}"
    git config --global user.email "{{email}}"

install_tools:
    just install_and_set go {{go_version}}
    just install_and_set usage latest
    just install_and_set nodejs {{nodejs_version}}
    just install_and_set python {{python_version}}
    just install_and_set terraform {{terraform_version}}
    just install_and_set kubectl {{kubectl_version}}
    just install_and_set awscli {{awscli_version}}
    just install_and_set terragrunt {{terragrunt_version}}
    just install_and_set starship {{starship_version}}
    just install_and_set task {{task_version}}

# Use after connecting to the WSL via VS Code
vscode_extensions:
    ./scripts/vscode_extensions_setup.sh

# Internal functions
@install_and_set app version:
    ~/.local/bin/mise use --global {{app}}@{{version}}
