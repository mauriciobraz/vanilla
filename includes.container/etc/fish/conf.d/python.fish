set -gx PIP_REQUIRE_VIRTUALENV true
alias pip "pip --require-virtualenv"

if type -q poetry
    poetry config virtualenvs.create true
    poetry config virtualenvs.in-project true
end

set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin

pyenv init - fish | source

status --is-interactive; and pyenv init - | source
status --is-interactive; and pyenv virtualenv-init - | source
