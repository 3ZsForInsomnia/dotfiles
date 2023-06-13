import { handleGhPrs } from "./gh-handler.js";
import { handleTrello } from './trello-handler.js';

const [command, ...args] = process.argv.slice(2);

const commands = {
  gh: () => handleGhPrs(),
  trello: () => handleTrello(),
  all: () => { handleTrello(); handleGhPrs(); },
  hourly: () => { handleTrello(); }, //handleGhPrs(); },
};

if (command in commands) commands[command]();
else commands.hourly();
