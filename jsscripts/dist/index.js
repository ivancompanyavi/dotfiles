#!/usr/bin/env node
var __getOwnPropNames = Object.getOwnPropertyNames;
var __commonJS = (cb, mod) => function __require() {
  return mod || (0, cb[__getOwnPropNames(cb)[0]])((mod = { exports: {} }).exports, mod), mod.exports;
};

// package.json
var require_package = __commonJS({
  "package.json"(exports, module) {
    module.exports = {
      name: "personal-tools",
      version: "1.0.0",
      description: "",
      type: "module",
      main: "dist/index.js",
      module: "dist/index.mjs",
      types: "dist/index.d.ts",
      scripts: {
        build: "tsup",
        dev: "tsup --watch"
      },
      bin: {
        "personal-tools": "./dist/index.js"
      },
      keywords: [],
      author: "",
      license: "ISC",
      dependencies: {
        "@inquirer/checkbox": "^1.4.0",
        commander: "^11.1.0",
        "fzf-node": "^0.1.3",
        yaml: "^2.3.4"
      },
      devDependencies: {
        "@types/inquirer": "^9.0.6",
        "@types/node": "^20.8.10",
        "@typescript-eslint/eslint-plugin": "^6.9.1",
        "@typescript-eslint/parser": "^6.9.1",
        eslint: "^8.53.0",
        prettier: "^3.0.3",
        tsup: "^7.2.0",
        typescript: "^5.2.2"
      }
    };
  }
});

// src/index.ts
import { Command } from "commander";

// src/cli/scripts/install.ts
import { parse } from "yaml";
import fs from "fs";

// src/utils/paths.ts
import path from "path";
import { dirname } from "path";
import { fileURLToPath } from "url";
var HOME = process.env.HOME || process.env.USERPROFILE;
var __dirname = dirname(fileURLToPath(import.meta.url));
var ROOT = path.resolve(__dirname, "..", "src");

// src/utils/option-select.ts
import checkbox from "@inquirer/checkbox";
async function optionSelect(selections) {
  const selection = await checkbox({
    message: "Select options",
    choices: selections.map((s) => ({ name: s, value: s }))
  });
  return selection;
}

// src/utils/call.ts
import util from "util";
import { exec as nonPromisedExec } from "child_process";
var exec = util.promisify(nonPromisedExec);
async function call(shellScript, silent) {
  try {
    const { stdout, stderr } = await exec(
      `${shellScript}${silent ? " &>/dev/null" : ""}`
    );
    return { stdout, stderr };
  } catch (e) {
    return { stderr: e };
  }
}

// src/utils/install.ts
var installCheckPrefixes = {
  ["npm" /* NPM */]: (pkgName) => `npm list -g ${pkgName} | grep ${pkgName}`,
  ["homebrew" /* HOMEBREW */]: (pkgName) => `brew list ${pkgName}`,
  ["shell" /* SHELL */]: (pkgName) => `type ${pkgName}`
};
var installPrefixes = {
  ["npm" /* NPM */]: (pkgName) => `npm install -g ${pkgName}`,
  ["homebrew" /* HOMEBREW */]: (pkgName) => `brew install ${pkgName}`
};
async function install(pkg2) {
  const { type, name } = pkg2;
  const checkPrefix = pkg2.checkInstall || installCheckPrefixes[type](name);
  const prefix = pkg2.install || installPrefixes[type](name);
  if (pkg2.preInstall) {
    console.log(`Running pre-install commands for ${name}`);
    for (const cmd of pkg2.preInstall) {
      await call(cmd);
    }
  }
  console.log(checkPrefix);
  const { stdout, stderr } = await call(checkPrefix, false);
  console.log(stdout);
  console.log(stderr);
  if (stdout) {
    console.log(`Package "${name}" already installed`);
    return;
  }
  console.log(`Installing ${name}`);
  await call(prefix);
  console.log(`Installed ${name}`);
  if (pkg2.postInstall) {
    console.log(`Running post-install commands for ${name}`);
    for (const cmd of pkg2.postInstall) {
      await call(cmd);
    }
  }
}

// src/cli/scripts/install.ts
async function action() {
  const configFile = await fs.promises.readFile(`${ROOT}/config.yaml`, "utf-8");
  const config = parse(configFile);
  const pkgs = config.packages;
  const selection = await optionSelect(pkgs.map((p) => p.name));
  const selectedPackages = pkgs.filter(
    (p) => selection.includes(p.name)
  );
  for (const pkg2 of selectedPackages) {
    await install(pkg2);
  }
}
async function run(program) {
  program.command("install").description("Install packages").action(action);
  return program;
}
var install_default = run;

// src/cli/scripts/sync.ts
async function action2(packageName) {
}
async function run2(program) {
  program.command("sync").description("Synchronize package configurations").argument("[package]", "The package you want to configure.").action(action2);
  return program;
}
var sync_default = run2;

// src/cli/index.ts
async function getScripts() {
  return [install_default, sync_default];
}

// src/index.ts
var pkg = require_package();
async function start() {
  let program = new Command();
  program = program.name("personal-tools").version(pkg.version).description(pkg.description);
  const scripts = await getScripts();
  for (const script of scripts) {
    program = await script(program);
  }
  program.parse();
}
start();
//# sourceMappingURL=index.js.map