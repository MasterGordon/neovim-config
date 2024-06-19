[ -e ~/.local/share/nvim/site/pack/packer/start/packer.nvim ] || git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
npm i -g @fsouza/prettierd@latest \
diagnostic-languageserver@latest \
eslint_d@latest \
lua-fmt@latest \
typescript-language-server@latest \
typescript@latest \
vim-language-server@latest \
vscode-css-languageserver-bin@latest \
vscode-html-languageserver-bin@latest \
vscode-json-languageserver@latest \
vscode-langservers-extracted@latest \
bash-language-server@latest \
@prisma/language-server@latest \
cspell@latest \
@cspell/dict-de-de@latest \
tsx@latest \
intelephense \
@vtsls/language-server

cspell link add @cspell/dict-de-de
dotnet tool install --global csharp-ls
