import { readFileSync, writeFileSync } from "fs";
import { execSync } from "child_process";

const notesLocation = "/home/zach/code/notes";
const homeNote = `${notesLocation}/00 - Home.md`;

export const slice = (num) => (str) => str.slice(num);
export const truthy = (val) => !!val;
export const hasItems = (val) => val && val.length > 0;

const maxStringLength = 75;
export const truncateString = (str) =>
  str && str.length > maxStringLength
    ? str.substring(0, maxStringLength) + "..."
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
}
export const sortDateByProp = (prop) => (obj1, obj2) => {
  const date1 = new Date(obj1[prop]);
  const date2 = new Date(obj2[prop]);

  return sortDate(date1, date2);
}

const getBoundaries = (lines, heading) => {
  const regex = new RegExp("[#+] " + heading);

  const headingIndex = lines.findIndex((line) => line.match(regex));
  let currLine = headingIndex;
  while (lines[currLine + 1].trim().startsWith("- ")) currLine++;

  return [headingIndex, currLine];
};

const replaceWithinBoundaries = (text, start, end, newList) => {
  const textCopy = [...text];
  const removed = textCopy.splice(start + 1, end - start);
  const added = textCopy.splice(start + 1, 0, newList.join("\n"));

  return textCopy;
};

export const replaceListUnderHeading = (heading, newList) => {
  const oldText = getHomeNote().split("\n");
  const [start, end] = getBoundaries(oldText, heading);
  if (start === -1 || end === -1) return;

  const newText = replaceWithinBoundaries(oldText, start, end, newList);
  writeHomeNote(newText.join("\n"));
};

export const run = (command, callback) => {
  try {
    return execSync(command).toString();
  } catch (e) {
    console.error("Command failed: ", e);
  }
};

const getHomeNote = () => readFileSync(homeNote, "utf-8");
const writeHomeNote = (newContents) => writeFileSync(homeNote, newContents);
