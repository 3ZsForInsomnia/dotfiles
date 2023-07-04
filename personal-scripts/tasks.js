const https = require("https");
const { execSync } = require("node:child_process");
const nfzf = require("node-fzf");
const { CLICKUP_TEAM, CLICKUP_ME, CLICKUP_KEY } = process.env;

const boards = [
  "0 Inbox",
  "1 Job",
  "2 Projects",
  "3 Music",
  "4 Chores",
  "5 Health",
  "6 Reading",
];
const getCardsForBoard = (board) =>
  `trello show-cards -b "${board}" -l "Doing"`;
const cards = [];
const prettifyCard = (card) => card.split("\n")[1].split(" - ")[1];

boards.forEach((board) => {
  const cmd = getCardsForBoard(board);
  const output = execSync(cmd);
  const card = prettifyCard(output.toString());
  if (card) cards.push(card);
});

const defaultItems = ["I am in a meeeting", "Zach is working", "custom"];

let [time, ...args] = process.argv.slice(2);
if (!time) time = 30;
const dndDuration = time * 60;

const prettyTask = (task) => `${task.name} - ${task.url}`;
const sortTasks = (a, b) => a.due_date > b.due_date;

const options = {
  hostname: "api.clickup.com",
  path: `/api/v2/team/${CLICKUP_TEAM}/task?assignees[]=${CLICKUP_ME}`,
  headers: {
    Authorization: CLICKUP_KEY,
  },
};

const getMyTickets = (callback) => {
  https.get(options, (resp) => {
    let str = "";
    resp.on("data", function(chunk) {
      str += chunk;
    });

    resp.on("end", function() {
      const data = JSON.parse(str).tasks.sort(sortTasks).map(prettyTask);
      const allItems = [...data, ...cards, ...defaultItems];
      nfzf(allItems, (choice) =>
        callback(
          choice.selected.value === "custom" ? args[0] : choice.selected.value
        )
      );
    });
  });
};

const ticketName = (task) => task.split(" - https")[0];

const fn = (data) => {
  const status = ticketName(data);

  execSync(`dnd on "Currently working on: ${status}" ${time}`);
  execSync(`sleep ${dndDuration}; terminal-notifier -title "DND turning off" -message "${status}" -sound default`);
};

getMyTickets(fn);
