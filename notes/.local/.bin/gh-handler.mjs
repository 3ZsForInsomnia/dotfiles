import * as dotenv from "dotenv";
import { run, createUlNode, findHeader, getAst } from "./utils.mjs";

dotenv.config();
const { REPOS } = process.env;
const repos = REPOS.split(",");

const justNumbers = (str) => str.replace(/(^\d+)(.+$)/i, "$1");

const getPrInfoCommand = (prID) => `gh pr view ${prID}`;
const extractUrl = (text) => text.substring(text.indexOf("https"));
const extractPrInfoFromResponse = (text) => {
  const lines = text.split("\n");
  const title = lines[0];

  const [openedByString, commentsString] = lines[1].split(".");
  const comments = justNumbers(commentsString);
  const openedBy = openedByString.split(" ")[2];

  const body = lines.slice(2, lines.length - 2).join(" ");
  const url = extractUrl(lines[lines.length - 1]);

  return { url, body, comments, openedBy, title };
};

const extractPrIDs = (text) =>
  text
    .split("\n")
    .filter((line) => line.startsWith("#"))
    .map(justNumbers);

const myPrsCommand = (repo) =>
  `gh pr list --author "@me" --state open --repo=${repo}`;
const assignedPrsCommand = (repo) =>
  `gh pr list --assignee "@me" --state open --repo=${repo}`;

const createPrEntry = (pr) => ({});

const handlePr = (pr) =>
  !!pr && pr.length > 0
    ? extractPrIDs(pr).forEach((id) =>
        run(getPrInfoCommand(id), extractPrInfoFromResponse)
      )
    : "";

const getPrs = (repos) =>
  repos.forEach((repo) => {
    run(myPrsCommand(repo), handlePr);
    run(assignedPrsCommand(repo), handlePr);
  });

const getGhSections = (json) => {};

export const handleGhPrs = () => {
  getPrs(repos);
  const ast = getAst("00 - Home.md");
  // console.log(ast);
};
