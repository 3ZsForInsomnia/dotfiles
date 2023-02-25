#!/usr/bin/env node

const { exec } = require("child_process");
const { readFileSync, appendFileSync } = require("fs");

const logFile = "/tmp/site-block.txt";

const log = (str, args) => {
  const date = new Date();

  const argsString =
    typeof args === "string" ? args : args.map((arg) => `\n${arg}`);

  appendFileSync(logFile, `${date}: ${str} - ${argsString}`);
};

const unblockHosts = (hosts) => {
  hosts.forEach((host) => {
    exec(`sed -i "" "/${host}/d" /etc/hosts`, (err, stdout, stderr) => {
      if (err) {
        log("Error", err);
      } else if (stderr) {
        log("StdErr: ", stderr);
      } else {
        log("Successfully unblocked hosts: ", hosts);
        log(">> ", stdout);
      }
    });
  });
};

const blockHosts = (hosts) => {
  hosts.forEach((host) => {
    exec(
      `sh -c -e \"echo '127.0.0.1\t${host}' >> /etc/hosts\"`,
      (err, stdout, stderr) => {
        if (err) {
          log("Error", err);
        } else if (stderr) {
          log("StdErr: ", stderr);
        } else {
          log(">> ", stdout);
        }
      }
    );
  });
};

const [command, ...args] = process.argv.slice(2);

log("\n\nNew Entry", [command, args]);
if (command === "block") {
  blockHosts(args);
} else if (command === "unblock") {
  unblockHosts(args);
}
