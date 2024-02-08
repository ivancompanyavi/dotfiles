import { HOME, ROOT } from '../utils/paths';

import { Package } from "./types";

const CONFIGS = `${ROOT}/packages/config-files`;

const brew = {
  install: (pkg: string) => `brew install ${pkg}`,
  check: (pkg: string) => `brew list ${pkg}`,
  tap: (pkg: string) => `brew tap ${pkg}`
};

const npm = {
  install: (pkg: string) => `npm install -g ${pkg}`,
  check: (pkg: string) => `npm list -g | grep ${pkg}`
};

const shell = {
  install: (pkg: string) => pkg,
  check: (pkg: string) => `which ${pkg}`
};

const node: Package = {
  name: 'node',
  installCheck: brew.check('node'),
  install: brew.install('node')
};
const luaLanguageServer: Package = {
  name: 'lua-language-server',
  install: brew.install('lua-language-server'),
  installCheck: brew.check('lua-language-server')
};
const tSLanguageServer: Package = {
  name: 'typescript-language-server',
  install: brew.install('typescript-language-server'),
  installCheck: brew.check('typescript-language-server')
};
const ripgrep: Package = {
  name: 'ripgrep',
  install: brew.install('ripgrep'),
  installCheck: brew.check('ripgrep')
};
const prettierd: Package = {
  name: 'prettierd',
  install: brew.install('fsouza/prettierd/prettierd'),
  installCheck: brew.check('prettierd')
};
const fzf: Package = {
  name: 'fzf',
  install: brew.install('fzf'),
  installCheck: brew.check('fzf')
};

const lazygit: Package = {
  name: 'lazygit',
  install: brew.install('lazygit'),
  installCheck: brew.check('lazygit'),
  preInstall: [brew.tap('koekeishiya/formulae/yabai')]
};
const yabai: Package = {
  name: 'yabai',
  install: brew.install('yabai'),
  installCheck: brew.check('yabai'),
  postInstall: [
    `cp -r ${CONFIGS}/yabai ${HOME}/.config/yabai`,
    `yabai --start-service`
  ],
  configs: [{ src: 'yabai', dst: '.config/yabai' }]
};
const typescript: Package = {
  name: 'typescript',
  install: npm.install('typescript'),
  installCheck: npm.check('typescript'),
  dependencies: [node]
};
const neovim: Package = {
  name: 'neovim',
  install: brew.install('neovim'),
  installCheck: brew.check('neovim'),
  configs: [{ src: 'nvim', dst: '.config/nvim' }],
  dependencies: [luaLanguageServer, tSLanguageServer, ripgrep, prettierd, fzf]
};
const nvm: Package = {
  name: 'nvm',
  install: shell.check(
    'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash'
  ),
  installCheck: shell.check('nvm')
};

export const packagesConfig: Package[] = [
  lazygit,
  yabai,
  typescript,
  neovim,
  nvm,
  node
];

