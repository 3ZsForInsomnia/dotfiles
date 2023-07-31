#!/usr/bin/env node

/**
 * Handle only-count
 * Add zsh completions once done
 */

const { exec } = require("node:child_process");
const { cond } = require("ramda");

const times = ["morn", "aft", "eve", "night", "mid", "beg", "now"];
const timesMap = {
  beg: 0,
  morn: 7,
  aft: 12,
  eve: 17,
  night: 21,
  mid: 23,
  else: () => new Date().getHours(),
};
const time = (time) => timesMap[time] ?? timesMap["else"]();
const eq = (d1, d2) => d1.toLocaleString() == d2.toLocaleString();
const getCurrTime = (date) => {
  const now = new Date().getHours();
  if (!!date && !eq(now, new Date(date))) return "beg";

  if (now == timesMap["mid"]) return "mid";
  else if (now > timesMap["night"]) return "night";
  else if (now > timesMap["eve"]) return "eve";
  else if (now > timesMap["aft"]) return "aft";
  else if (now > timesMap["morn"]) return "morn";
  else return "beg";
};
const past = (d) => new Date(d).setHours(0, 0, 0, 0) < new Date().setHours(0, 0, 0, 0);

const whenNoArgsArePresent = ({ f, t, n, e, s }) => !f && !t && !n;
const whenOnlyACountIsgiven = ({ f, t, n }) => !!n && !f && !t;
const whenOnlyAStartDateIsGiven = ({ f, t, n }) => !!f && !t && !n;
const whenAStartDateAndCountIsGiven = ({ f, t, n }) => !!f && !!n && !t;
const whenAStartAndEndDateAreGiven = ({ f, t, n }) => !!f && !!t && !n;

const base =
  "gcalcli agenda --nocache --no-military --nodeclined --details length --details location --details calendar --details attendees --details description ";

const fStart = (f, s = getCurrTime(f)) => {
  const start = f ? new Date(f) : new Date();
  if (s == "now") start.setHours(start.getHours(), start.getMinutes(), 0, 0);
  else start.setHours(time(s), 0, 0, 0);

  return start.toLocaleString();
};
const fEnd = (s, t = 0, e = "mid") => {
  const end = s ? new Date(s) : new Date();
  end.setDate(end.getDate() + t);
  end.setHours(time(e), 59, 59, 999);

  return end.toLocaleString();
};

const thenGetTodaysAgenda = ({ f, t, n, s, e }) => {
  const start = fStart(null, s || "now");
  const end = fEnd(null, 0, e);

  return { start, end };
};

const thenGetThatDaysAgenda = ({ f, t, n, s = "beg", e }) => {
  const start = fStart(f, s);
  const end = fEnd(f, 0, e);

  return { start, end, isPast: past(start) };
};

const thenGetThatDayAndTheNextNDaysAgenda = ({ f, t, n, s = "beg", e }) => {
  const start = fStart(f, s);
  const end = fEnd(f, n, e);

  return { start, end, isPast: past(start) };
};

const thenGetTheDateRangesAgenda = ({ f, t, n, s = "beg", e }) => {
  const start = fStart(f, s);
  const end = fEnd(t, 0, e);

  return { start, end, isPast: past(start) };
};

const thenGetTheAgendaForNDaysFromNow = ({ n, s = "beg", e }) => {
  const start = fEnd(null, n, s);
  const end = fEnd(null, n, e);

  return { start, end };
};

const getCommand = cond([
  [whenNoArgsArePresent, thenGetTodaysAgenda],
  [whenOnlyAStartDateIsGiven, thenGetThatDaysAgenda],
  [whenAStartDateAndCountIsGiven, thenGetThatDayAndTheNextNDaysAgenda],
  [whenAStartAndEndDateAreGiven, thenGetTheDateRangesAgenda],
  [whenOnlyACountIsgiven, thenGetTheAgendaForNDaysFromNow],
]);

const args = require("yargs/yargs")(process.argv.slice(2))
  .option("f", {
    alias: "from",
    describe: "Start of date range",
    type: "string",
  })
  .option("t", { alias: "to", describe: "End of date range", type: "string" })
  .choices("s", times)
  .describe("s", "Start of time range")
  .choices("e", times)
  .describe("e", "End of time range")
  .option("n", { describe: "Get agenda for day n days from now" })
  .completion();

const { start, end, isPast, completion } = getCommand(args.argv);
if (completion) {
  completion();
  return;
}

const cmd = `${base}${isPast ? "" : "--nostarted "}"${start}" "${end}"`;
exec(cmd, (error, output) => {
  if (error) {
    console.error("Could not get agenda: ", error);
    return;
  }

  console.log(output);
});
