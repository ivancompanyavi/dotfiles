import { Command } from 'commander'
import fs from 'fs'
import { ROOT } from '../utils/paths'
import install from './scripts/install'
import sync from './scripts/sync'

const scripts: ((cmd: Command) => Promise<Command>)[] = []

async function getScripts() {
  // if (scripts.length > 0) {
  //   return scripts
  // }
  // const scriptsFolder = fs.readdirSync(`${ROOT}/cli/scripts`, { withFileTypes: true })
  // for (const script of scriptsFolder) {
  //   const path = `${ROOT}/cli/scripts/${script.name}`
  //   const pkg = await import(path)
  //   scripts.push(pkg.default)
  // }
  // return scripts
  return [install, sync]
}

export { getScripts };
