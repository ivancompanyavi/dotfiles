import type { Command } from 'commander';
import { parse } from 'yaml'
import fs from 'fs'
import { ROOT } from '../../utils/paths';
import type { Config } from '../../types';
import optionSelect from '../../utils/option-select';
import install from '../../utils/install';

async function action() {
  const configFile = await fs.promises.readFile(`${ROOT}/config.yaml`, 'utf-8')

  const config: Config = parse(configFile)

  const pkgs = config.packages;
  const selection = await optionSelect(pkgs.map((p) => p.name));

  const selectedPackages = pkgs.filter((p) =>
    selection.includes(p.name)
  );

  for (const pkg of selectedPackages) {
    await install(pkg);
  }

}

async function run(program: Command) {
  program
    .command('install')
    .description('Install packages')
    .action(action);

  return program;
}

export default run;
