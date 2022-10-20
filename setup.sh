[ -e ~/.local/share/nvim/site/pack/packer/start/packer.nvim ] || git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
npm i -g @fsouza/prettierd \
diagnostic-languageserver \
eslint_d \
lua-fmt \
typescript-language-server \
typescript \
vim-language-server \
vscode-css-languageserver-bin \
vscode-html-languageserver-bin \
vscode-json-languageserver \
vscode-langservers-extracted \
bash-language-server \
@prisma/language-server \
cspell \
@cspell/dict-de-de

cspell link add @cspell/dict-de-de
dotnet tool install --global csharp-ls
