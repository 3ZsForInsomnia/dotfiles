import {
  run,
  hasItems,
  slice,
  replaceListUnderHeading,
  truthy,
  replace,
  truncateString,
} from "./utils.js";

const boardsWithLists = [
  ["'0 Inbox'", "'To Do'", "Doing"],
  ["'1 Job'", "'To Do'", "Doing"],
  ["'2 Projects'", "'To Do'", "Doing"],
  ["'3 Music'", "'To Do'", "Doing"],
  ["'4 Chores'", "'To Do'", "Doing"],
  ["'5 Health'", "'To Do'", "Doing"],
  ["'6 Reading'", "'To Do'", "Doing"],
  ["'8 Recurring'", "'To Do'", "Doing"],
];

const upcoming = boardsWithLists.map((a) => a.slice(0, 2));
const inProgress = boardsWithLists.map((a) => [a[0], a[2]]);
const overdue = [];

const getCardsInList = ([board, list]) =>
  `/usr/local/bin/trello show-cards -b ${board} -l ${list}`;
const getCardDetails = (cardId) => `/usr/local/bin/trello card-details ${cardId}`;
const createCardUrl = (id) => `https://trello.com/c/${id}/`;

const extractID = (text) => {
  const sansStar = text.substring(1);
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

const extractDetails = (board, id, text) => {
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

  const card = { board, title, dueDate, labels, url };

  const now = new Date();
  if (card && card.dueDate < now) overdue.push(card);

  return card;
};

const getCards = (entries) =>
  entries.flatMap(([board, list]) => {
    const cardsInList = getCardsInList([board, list]);
    const cards = run(cardsInList);

    if (cards?.length > 0) return cards
      .split("\n")
      .filter(truthy)
      .slice(1)
      .filter(hasItems)
      .flatMap(slice(1))
      .map(extractID)
      .map((id) => extractDetails(board, id, run(getCardDetails(id))));
  });

const createCardEntry = ({ board, title, url, dueDate, labels }) =>
  `- ${board.substring(3).slice(0, -1)}: [${title.length > 65 ? truncateString(title, 65) : title
  }](${url})${dueDate
    ? title.length > 40
      ? `\n    - Due: ${dueDate}`
      : ` | Due: ${dueDate}`
    : ""
  }
${hasItems(labels) ? `    - Labels: ${labels}\n` : ""}`;

export const handleTrello = () => {
  const upcomingCards = getCards(upcoming).filter(truthy).map(createCardEntry);
  if (hasItems(upcomingCards))
    replaceListUnderHeading("Upcoming", upcomingCards);

  const inProgressCards = getCards(inProgress)
    .filter(truthy)
    .map(createCardEntry);
  if (hasItems(inProgressCards))
    replaceListUnderHeading("In Progress", inProgressCards);

  if (hasItems(overdue))
    replaceListUnderHeading("Overdue", overdue.map(createCardEntry));
};
