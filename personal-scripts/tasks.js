const { execSync } = require("node:child_process");
const nfzf = require("node-fzf");

const boards = [
  // Inbox, job and projects are handled by "to do list"
  // "0 Inbox",
  // "1 Job",
  // "2 Projects",
  "3 Music",
  "4 Chores",
  "5 Health",
  "6 Reading",
  "To Do list",
];
const getCardsForBoard = (board) =>
  `trello show-cards -b "${board}" -l "Doing"`;
const cards = [];
const prettifyCard = (card) => card.split("\n")[1];

boards.forEach((board) => {
  const cmd = getCardsForBoard(board);
  const output = execSync(cmd);
  const card = prettifyCard(output.toString());
  if (card) cards.push(card);
});

let [useDnd, time, ...args] = process.argv.slice(2);
if (!time) time = DEFAULT_TASK_TIME;
const dndDuration = time * 60;

const ticketName = (task) =>
  task.split(" - https")[0].split(" ").slice(1).join(" ");

const fn = (data) => {
  const status = ticketName(data);

  execSync(`dnd on "Currently working on: ${status}" ${time}`);
  execSync(
    `sleep ${dndDuration}; terminal-notifier -title "DND turning off" -message "${status}" -sound default`,
  );
  execSync(`dnd off`);
};

const trelloFn = (card) => {
  const id = card.split(" - ")[0].replace("* ", "");
  const detailsCommand = `trello card-details ${id}`;
  console.log(execSync(detailsCommand).toString());
  process.exit();
};

if (useDnd) getMyTickets(fn);
else
  nfzf(cards, (choice) =>
    trelloFn(
      choice.selected.value === "custom" ? args[0] : choice.selected.value,
    ),
  );
