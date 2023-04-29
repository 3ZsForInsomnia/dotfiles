import {
  run,
  hasItems,
  slice,
  replaceListUnderHeading,
  truthy,
  replace,
} from "./utils.js";

// First entry is board, then upcoming, followed by 1+ in progress lists
const boardsWithLists = [
  ["Chores", "'To Do'", "Doing"],
  ["Health", "'To Do'"],
  ["Home", "'To Do'", "Doing"],
  ["Inbox", "'To Do'", "Doing"],
  ["'Jira tickets'", "'To Do'", "Doing", "'On hold (in review/QA)'"],
  ["Listening", "'To Do'", "Reviewing"],
  ["Music", "'To Do'", "'Learning/Practicing'", "Recording"],
  ["Projects", "'To Do'", "Doing"],
  ["Reading", "'To Do'", "Reading"],
  ["Recurring", "Doing"],
  ["Writing", "'To Do'", "Writing", "Reviewing/editing"],
];

const upcoming = boardsWithLists.map((a) => a.slice(0, 2));
const inProgress = boardsWithLists
  .map((a) => [a[0], a.slice(2)])
  .filter((a) => hasItems(a[1]))
  .flatMap((a) => a[1].map((b) => [a[0], b]));
const overdue = [];

const getCardsInList = ([board, list]) =>
  `trello show-cards -b ${board} -l ${list}`;
const getCardDetails = (cardId) => `trello card-details ${cardId}`;
const createCardUrl = (id) => `https://trello.com/c/${id}/`;

const extractID = (text) => {
  const sansStar = text.slice(2);
  const id = sansStar.substring(0, sansStar.indexOf(" - "));
  return id;
};

const isLineRelevant = (line) =>
  !line.startsWith("You are subscribed") && !line.startsWith("1 member");
const preserveMdStyleIndent = replace("  ", "    ");

const getRelevantLines = (lines) =>
  lines
    .split("\n")
    .map(replace(/[^a-zA-Z0-9-.,:'"\][{} ()*&^%$#@!]+/g))
    .map(replace(/\[\d+m/g))
    .filter(truthy)
    .map(preserveMdStyleIndent)
    .filter(isLineRelevant);

const extractDetails = (id, text) => {
  let lines = getRelevantLines(text);

  const title = lines[0].substring(lines[0].lastIndexOf("  ") + 2);

  let labels = [];
  const hasLabels = lines.findIndex((line) => line.startsWith("Labels: "));
  if (hasLabels > -1) labels = lines[hasLabels].substring(7);

  const hasDueDate = lines.findIndex((line) => line.startsWith("Due "));
  let dueDate;
  if (hasDueDate > -1)
    dueDate = new Date(lines[hasDueDate].substring(4)).toDateString();

  const url = createCardUrl(id);

  const card = { title, dueDate, labels, url };

  const now = new Date();
  if (card && card.dueDate < now) overdue.push(card);

  return card;
};

const getCards = (list) =>
  list
    .map(getCardsInList)
    .map((command) => run(command).split("\n").filter(truthy))
    .filter(hasItems)
    .flatMap(slice(1))
    .map(extractID)
    .map((id) => extractDetails(id, run(getCardDetails(id))));

const createCardEntry = ({ title, url, dueDate, labels }) =>
  `- [${title}](${url})${dueDate ? ` | Due: ${dueDate}` : ''}${
    hasItems(labels) ? ` | Labels: ${labels}` : ""
  }`;

export const handleTrello = () => {
  const upcomingCards = getCards(upcoming).map(createCardEntry);
  if (hasItems(upcomingCards))
    replaceListUnderHeading("Upcoming", upcomingCards);

  const inProgressCards = getCards(inProgress).map(createCardEntry);
  if (hasItems(inProgressCards))
    replaceListUnderHeading("In Progress", inProgressCards);

  if (hasItems(overdue))
    replaceListUnderHeading("Overdue", overdue.map(createCardEntry));
};
