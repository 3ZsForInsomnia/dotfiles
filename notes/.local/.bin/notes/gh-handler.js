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
  } else if (hasItems(reviews)) {
    const lastReview = reviews.sort(sortReviews)[reviews.length - 1];
    const lastCommit = commits.sort(sortCommits)[commits.length - 1];

    const reviewDate = new Date(lastReview.submittedAt);
    const commitDate = new Date(lastCommit.committedDate);

    return [reviewDate, commitDate].sort()[1];
  } else {
    const lastCommit = commits.sort(sortCommits)[commits.length - 1];
    return new Date(lastCommit.committedDate);
  }
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
  approved,
}) =>
  `- [${truncateString(title)}](${url}) by ${author.login}\n\t- State: ${
    ghMarkers[state]
  } - Review/CI Status: ${ghMarkers[mergeStateStatus]}${
    isDraft ? ` - Draft ghMarkers[draft] - ` : ""
  } - Mergeable: ${ghMarkers[mergeable]} - Approved: ${approved}
\t- Last touched: ${getLastActivity(
    reviews,
    comments,
    commits
  ).toDateString()} | Open for ${dateDiff(
    new Date(createdAt),
    new Date()
  )} days${hasItems(commits) ? ` | Commits: ${commits.length}` : ""}${
    hasItems(comments) ? ` | Comments: ${comments.length}` : ""
  }${hasItems(reviews) ? ` | Reviews: ${reviews.length}` : ""}\n`;

const getMyPrs = (repo) =>
  `/opt/homebrew/bin/gh pr list --repo=${repo} --json title,number,author,assignees,url,comments,commits,state,createdAt,updatedAt,mergeable,reviews,mergeStateStatus,isDraft --author "@me"`;

const getAssignedPrs = (repo) =>
  `/opt/homebrew/bin/gh pr list --repo=${repo} --json title,number,author,assignees,url,comments,commits,state,createdAt,updatedAt,mergeable,reviews,mergeStateStatus,isDraft --assignee "@me"`;

export const handleGhPrs = () => {
  const uniquePrs = new Set();
  const myPrs = repos
    .flatMap((repo) => JSON.parse(run(getMyPrs(repo))))
    .filter((pr) =>
      uniquePrs.has(pr.number) ? false : uniquePrs.add(pr.number)
    );
  const assignedPrs = repos
    .flatMap((repo) => JSON.parse(run(getAssignedPrs(repo))))
    .filter((pr) =>
      uniquePrs.has(pr.number) ? false : uniquePrs.add(pr.number)
    );

  const prs = [...myPrs, ...assignedPrs].map((pr) => ({
    ...pr,
    approved:
      pr.reviews.length > 0
        ? pr.reviews.sort(sortReviews)[pr.reviews.length - 1].state ===
          "APPROVED"
          ? ""
          : ""
        : "",
  }));
  prs.length === 0
    ? replaceListUnderHeading("Current PR's", "- No PRs!")
    : replaceListUnderHeading("Current PR's", prs.map(createPrEntry));
};
