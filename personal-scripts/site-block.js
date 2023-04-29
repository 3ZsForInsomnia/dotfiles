const { readFileSync, createWriteStream } = require("fs");
const { format } = require("util");
const hostile = require("hostile");

const logFileLocation =
  process.env.SITEBLOCK_LOGFILE ??
  process.env.HOME + "/.local/state/site-block.log";

const logFile = createWriteStream(logFileLocation, { flags: "w" });
const log = (str) => {
  const strToLog = `SiteBlock: ${str}\n`;
  logFile.write(format(strToLog));
  process.stdout.write(format(strToLog));
};

const [command, ...siteGroups] = process.argv.slice(2);
log(`Args passed: ${command}, ${siteGroups}`);

if (command !== "block" && command !== "unblock") {
  log(
    `You used an invalid command: ${command}! The only valid commands are "block" and "unblock"!`
  );
  return;
}

const func = command === "block" ? "set" : "remove";

let configLocation = process.env.SITEBLOCK_CONFIG;
if (!configLocation) {
  configLocation = process.env.HOME + "/.config/site-block/site-block.json";
}
log(`Config location: ${configLocation}`);

const config = JSON.parse(readFileSync(configLocation, "utf-8"));

siteGroups.forEach((siteGroup) => {
  if (!config[siteGroup])
    log(`A site group you provided was not recognized: ${siteGroup}`);
  else {
    log(`Working on site group ${siteGroup}`);
    config[siteGroup].forEach((site) => {
      const error = hostile[func]("127.0.0.1", site);
      if (error && error !== true) log(`Failed to ${command} ${site}, due to error: ${error}`);
      else log(`Successfully ${command}ed ${site}`);
    });
  }
});
