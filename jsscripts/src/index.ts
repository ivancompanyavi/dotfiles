#!/usr/bin/env node

import { Command } from 'commander';
import { getScripts } from './cli';

/* eslint-disable-next-line @typescript-eslint/no-var-requires */
const pkg = require('../package.json');

async function start() {
  let program = new Command();

  program = program
    .name('personal-tools')
    .version(pkg.version)
    .description(pkg.description);

  const scripts = await getScripts();

  for (const script of scripts) {
    program = await script(program);
  }

  program.parse();
}

start();
