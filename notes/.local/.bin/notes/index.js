import { handleGhPrs } from "./gh-handler.js";

const [command, ...args] = process.argv.slice(2);

if (command === "gh") handleGhPrs();
