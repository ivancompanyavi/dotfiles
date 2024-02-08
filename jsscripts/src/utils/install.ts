import { PackageType } from "../types";
import type { Package } from "../types";
import call from './call'

const installCheckPrefixes: { [key: PackageType]: (pkgName: string) => string } = {
  [PackageType.NPM]: (pkgName: string) => `npm list -g ${pkgName} | grep ${pkgName}`,
  [PackageType.HOMEBREW]: (pkgName: string) => `brew list ${pkgName}`,
  [PackageType.SHELL]: (pkgName: string) => `type ${pkgName}`,
}
const installPrefixes: { [key: PackageType]: (pkgName: string) => string } = {
  [PackageType.NPM]: (pkgName: string) => `npm install -g ${pkgName}`,
  [PackageType.HOMEBREW]: (pkgName: string) => `brew install ${pkgName}`,
};



export default async function install(pkg: Package) {
  const { type, name } = pkg;
  const checkPrefix = pkg.checkInstall || installCheckPrefixes[type](name);
  const prefix = pkg.install || installPrefixes[type](name);

  if (pkg.preInstall) {
    console.log(`Running pre-install commands for ${name}`);
    for (const cmd of pkg.preInstall) {
      await call(cmd);
    }
  }


  console.log(checkPrefix)
  const { stdout, stderr } = await call(checkPrefix, false);
  console.log(stdout)
  console.log(stderr)
  if (stdout) {
    console.log(`Package "${name}" already installed`);
    return;
  }
  console.log(`Installing ${name}`);
  await call(prefix);
  console.log(`Installed ${name}`);

  if (pkg.postInstall) {
    console.log(`Running post-install commands for ${name}`);
    for (const cmd of pkg.postInstall) {
      await call(cmd);
    }
  }
}
