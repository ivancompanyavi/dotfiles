import type { Command } from 'commander';

async function action(packageName?: string) {
}

async function run(program: Command) {
  program
    .command('sync')
    .description('Synchronize package configurations')
    .argument('[package]', 'The package you want to configure.')
    .action(action);
  return program;
}

export default run;
