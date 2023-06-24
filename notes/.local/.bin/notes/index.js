import { handleGhPrs } from "./gh-handler.js";
import { handleTrello } from "./trello-handler.js";
import { getTheWeather } from "./weather.js";

const [command, ...args] = process.argv.slice(2);

const commands = {
  gh: () => handleGhPrs(),
  trello: () => handleTrello(),
  weather: () => getTheWeather(),
  all: () => {
    handleTrello();
    handleGhPrs();
    getTheWeather();
  },
  hourly: () => {
    handleTrello();
    handleGhPrs();
  },
  everyFourHours: () => {
    getTheWeather();
  },
};

if (command in commands) commands[command]();
else commands.hourly();
