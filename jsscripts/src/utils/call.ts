import util from 'util';
import { exec as nonPromisedExec } from 'child_process';

const exec = util.promisify(nonPromisedExec);

export default async function call(shellScript: string, silent?: boolean) {
  try {

    const { stdout, stderr } = await exec(
      `${shellScript}${silent ? ' &>/dev/null' : ''}`
    );
    return { stdout, stderr };
  } catch (e) {
    return { stderr: e };
  }
}
