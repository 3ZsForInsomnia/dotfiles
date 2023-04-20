#!/usr/bin/env node

const { execSync } = require("child_process");
const { readFileSync, appendFileSync } = require("fs");
const os = require('os');

const logFile = "/tmp/site-block.txt";

const hostsFile = () => os.platform() !== 'win32' ? '/etc/hosts' : 'c:\\Windows\\System32\\Drivers\\etchostsosts';

const log = (str, param) => {
  const date = new Date();

  if (param) {
    const argsString =
      typeof param === "string" ? param : param.map((arg) => `\n${arg}`);

    appendFileSync(logFile, `${date}: ${str} - ${argsString}`);
  } else {
    appendFileSync(logFile, `${date}: ${str}`);
  }
};

const unblockHosts = (hosts) => {
  hosts.forEach((host) => {
    execSync(`sed -i "" "/${host}/d" ${hostsFile()}`, (err, stdout, stderr) => {
      if (err) {
        log("Error", err);
      } else if (stderr) {
        log("StdErr: ", stderr);
      } else {
        log("Successfully unblocked hosts: ", host);
        log(">> ", stdout);
      }
    });
  });
};

const blockHosts = (hosts) => {
  hosts.forEach((host) => {
    execSync(
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
execSync(
  "sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder",
  (err, stdout, stderr) => {
    if (err) {
      log("Error flushing dns cache", err);
    } else if (stderr) {
      log("StdErr flushing dns cache", stderr);
    } else {
      log("Successfully flushed cache");
    }
  }
);
