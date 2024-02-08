import path from 'path';
import { dirname } from 'path';
import { fileURLToPath } from 'url';

const HOME = process.env.HOME || process.env.USERPROFILE;

const __dirname = dirname(fileURLToPath(import.meta.url));

const ROOT = path.resolve(__dirname, '..', 'src');


export { HOME, ROOT };
