import { handleGhPrs } from './gh-handler.mjs';

const [command, ...args] = process.argv.slice(2);

if (command === "gh") handleGhPrs();
