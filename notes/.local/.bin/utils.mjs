import { readFileSync } from 'fs';
import { execSync } from "child_process";
import { unified } from "unified";
import remarkParse from "remark-parse";

const notesLocation = "/home/zach/code/notes";

export const createUlNode = (items) => unified().use(remarkParse).parse(items.map(item => `- ${item}`));

export const findHeader = (nodes, header) =>
  nodes.find((node) => node.type === "heading" && node.children[0] === header);

export const run = (command, callback) => {
  try {
    const output = callback(execSync(command))
  } catch (e) {
    console.error('Could not retrieve PR\'s: ', e);
  }
};

export const getAst = (file) =>
  unified()
    .use(remarkParse)
    .parse(readFileSync(`${notesLocation}/${file}`));
