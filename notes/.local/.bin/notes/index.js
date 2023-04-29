import { handleGhPrs } from "./gh-handler.js";
import { handleTrello } from './trello-handler.js';
import { handleNoteMovement } from './note-movement-helper.js';

const [command, ...args] = process.argv.slice(2);

const commands = {
  gh: () => handleGhPrs(),
  trello: () => handleTrello(),
  'daily-note': () => handleNoteMovement(),
  all: () => { handleTrello(); handleGhPrs(); },
  hourly: () => { handleTrello(); handleGhPrs(); },
};

if (command in commands) commands[command]();
else commands.hourly();
