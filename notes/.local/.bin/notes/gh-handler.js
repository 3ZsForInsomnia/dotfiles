import * as dotenv from "dotenv";
import {
  run,
  truncateString,
  datify,
  dateDiff,
  replaceListUnderHeading,
} from "./utils.js";

dotenv.config({ path: "/home/zach/.local/.bin/notes/.env" });
const { REPOS } = process.env;
const repos = REPOS.split(",");

// Icons for each state
const ghMarkers = {
  conflicted: "",
  open: "",
};

const createPrEntry = (pr) =>
  `- ${pr.number} [${truncateString(pr.title)}](${pr.url}) ${
    ghMarkers[pr.state]
  } by ${pr.author} ${ghMarkers[pr.mergeable]}}\n    - Last Updated: ${datify(
    pr.updatedAt
  )} - Open for ${dateDiff(
    new Date(pr.createdAt),
    new Date()
  )} days | Commits: ${pr.commits.length} | Comments: ${
    pr.comments.length
  } | Reviews: ${pr.reviews.length}`;

const getPrs = (repo) =>
  `gh pr list --repo=${repo} --json title,number,url,comments,commits,state,createdAt,updatedAt,mergeable,reviews`;

export const handleGhPrs = () => {
  const uniquePrs = new Set();
  const prs = repos
    .flatMap((repo) => JSON.parse(run(getPrs(repo))))
    .filter((pr) =>
      uniquePrs.has(pr.number) ? false : uniquePrs.add(pr.number)
    );
  const prNodes =
    prs.length === 0
      ? (prNodes = "- No PRs!")
      : prs.map(createPrEntry);

  replaceListUnderHeading("Current PR's", prNodes);
};
