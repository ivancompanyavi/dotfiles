export enum PackageType {
  NPM = 'npm',
  HOMEBREW = 'homebrew',
  SHELL = 'shell',
}

export type Package = {
  name: string;
  preInstall?: string[];
  install?: string;
  checkInstall?: string;
  type: PackageType;
  postInstall?: string[];
}

export type Config = {
  packages: Package[];
};
