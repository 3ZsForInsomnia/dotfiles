import * as dotenv from "dotenv";
import {
  run,
  truncateString,
  dateDiff,
  replaceListUnderHeading,
  hasItems,
  sortDateByProp,
} from "./utils.js";

dotenv.config({ path: "/home/zach/.local/.bin/notes/.env" });
const { REPOS } = process.env;
const repos = REPOS.split(",");

const ghMarkers = {
  merge: "",
  MERGEABLE: "",
  OPEN: "",
  MERGED: "",
  draft: "",
  BLOCKED: "",
};

const sortReviews = sortDateByProp("submittedAt");
const sortComments = sortDateByProp("createdAt");
const sortCommits = sortDateByProp("committedDate");

const getLastActivity = (reviews, comments, commits) => {
  if (hasItems(reviews) && hasItems(comments)) {
    const lastReview = reviews.sort(sortReviews)[reviews.length - 1];
    const lastComment = comments.sort(sortComments)[comments.length - 1];
    const lastCommit = commits.sort(sortCommits)[commits.length - 1];

    const reviewDate = new Date(lastReview.submittedAt);
    const commentDate = new Date(lastComment.createdAt);
    const commitDate = new Date(lastCommit.committedDate);

    return [reviewDate, commentDate, commitDate].sort()[2];
  }

  return "";
};

const createPrEntry = ({
  title,
  url,
  state,
  author,
  mergeable,
  createdAt,
  commits,
  comments,
  reviews,
  mergeStateStatus,
  isDraft,
}) =>
  `- [${truncateString(title)}](${url}) by ${author.login} | State: ${ghMarkers[state]
  } - Review/CI Status: ${ghMarkers[mergeStateStatus]}${isDraft ? ` - Draft ghMarkers[draft] - ` : ""
  } - Mergeable: ${ghMarkers[mergeable]}
    - Last touched: ${getLastActivity(
    reviews,
    comments,
    commits
  ).toDateString()} | Open for ${dateDiff(
    new Date(createdAt),
    new Date()
  )} days${hasItems(commits) ? ` | Commits: ${commits.length}` : ""}${hasItems(comments) ? ` | Comments: ${comments.length}` : ""
  }${hasItems(reviews) ? ` | Reviews: ${reviews.length}` : ""}`;

const getPrs = (repo) =>
  `gh pr list --repo=${repo} --json title,number,author,url,comments,commits,state,createdAt,updatedAt,mergeable,reviews,mergeStateStatus,isDraft`;

export const handleGhPrs = () => {
  const uniquePrs = new Set();
  const prs = repos
    .flatMap((repo) => JSON.parse(run(getPrs(repo))))
    .filter((pr) =>
      uniquePrs.has(pr.number) ? false : uniquePrs.add(pr.number)
    );
  // TODO: fix request - should only retrieve my PR's
  console.log("prs", prs);
  // prs.length === 0
  //   ? replaceListUnderHeading("Current PR's", "- No PRs!")
  //   : replaceListUnderHeading("Current PR's", prs.map(createPrEntry));
};
