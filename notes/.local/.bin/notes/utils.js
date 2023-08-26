import { readFileSync, writeFileSync } from "fs";
import { execSync } from "child_process";
import * as dotenv from "dotenv";

dotenv.config({ path: "/Users/zachary/.local/.bin/notes/.env" });
export const { NOTES_LOCATION: notesLocation } = process.env;

const homeNote = `${notesLocation}/A0 - Home.md`;

export const slice = (start) => (str) => str.slice(start);
export const truthy = (val) => !!val;
export const hasItems = (val) => val && val.length > 0;

const maxStringLength = 75;
export const truncateString = (str, length) =>
  str && str.length > (length || maxStringLength)
    ? str.substring(0, length || maxStringLength) + "..."
    : str;
export const replace =
  (pattern, replaceWith = "") =>
  (str) =>
    str.replace(pattern, replaceWith);

export const justNumbers = (str) => str.replace(/(^\d+)(.+$)/i, "$1");

export const datify = (date) => new Date(date).toDateString();
export const dateDiff = (date1, date2) =>
  Math.ceil((date2.getTime() - date1.getTime()) / (1000 * 3600 * 24));
export const sortDate = (date1, date2) => {
  if (date1 > date2) return 1;
  if (date1 < date2) return -1;
  else return 0;
};
export const sortDateByProp = (prop) => (obj1, obj2) => {
  const date1 = new Date(obj1[prop]);
  const date2 = new Date(obj2[prop]);

  return sortDate(date1, date2);
};
export const sortByProp = (prop) => (a, b) => a[prop] - b[prop];

const getBoundaries = (lines, heading) => {
  const anyLevelHeading = new RegExp("[#+] " + heading);

  const headingIndex = lines.findIndex((line) => line.match(anyLevelHeading));
  let currLine = headingIndex;
  while (lines[currLine + 1].trim().startsWith("- ")) currLine++;

  return [headingIndex, currLine];
};

const replaceWithinBoundaries = (text, start, end, newList) => {
  const textCopy = [...text];
  const newText =
    newList?.length > 0 && newList.join ? newList.join("") : newList;
  textCopy.splice(start + 1, end - start);
  textCopy.splice(start + 1, 0, newText.trim());

  return textCopy;
};

export const replaceListUnderHeading = (heading, newList) => {
  const oldText = getHomeNote().split("\n");
  const [start, end] = getBoundaries(oldText, heading);
  if (start === -1 || end === -1) return;

  const newText = replaceWithinBoundaries(oldText, start, end, newList);
  writeHomeNote(newText.join("\n"));
};

export const run = (command) => {
  try {
    return execSync(command).toString();
  } catch (e) {
    console.error("Command failed: ", e.toString());
  }
};

const getHomeNote = () => readFileSync(homeNote, "utf-8");
const writeHomeNote = (newContents) => writeFileSync(homeNote, newContents);
