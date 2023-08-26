const https = require("https");
const { execSync } = require("node:child_process");
const nfzf = require("node-fzf");
const { CLICKUP_TEAM, CLICKUP_ME, CLICKUP_KEY, DEFAULT_TASK_TIME } =
  process.env;

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
const prettifyCard = (card) => card.split("\n")[1];

boards.forEach((board) => {
  const cmd = getCardsForBoard(board);
  const output = execSync(cmd);
  const card = prettifyCard(output.toString());
  if (card) cards.push(card);
});

const defaultItems = ["I am in a meeeting", "Zach is working", "custom"];

let [useDnd, time, ...args] = process.argv.slice(2);
if (!time) time = DEFAULT_TASK_TIME;
const dndDuration = time * 60;

const prettyTask = (task) => `c:${task.id} ${task.name} - ${task.url}`;
const sortTasks = (a, b) => a.due_date > b.due_date;

const options = {
  hostname: "api.clickup.com",
  path: `/api/v2/team/${CLICKUP_TEAM}/task?assignees[]=${CLICKUP_ME}`,
  headers: {
    Authorization: CLICKUP_KEY,
  },
};

const request = (options, callback) => {
  https.get(options, (resp) => {
    let str = "";
    resp.on("data", function (chunk) {
      str += chunk;
    });

    resp.on("end", function () {
      callback(str);
    });
  });
};

const getMyTickets = (callback) => {
  const onEndCallback = (str) => {
    const data = JSON.parse(str).tasks.sort(sortTasks).map(prettyTask);
    const allItems = [...data, ...cards, ...defaultItems];
    nfzf(allItems, (choice) =>
      callback(
        choice.selected.value === "custom" ? args[0] : choice.selected.value
      )
    );
  };

  request(options, onEndCallback);
};

const ticketName = (task) =>
  task.split(" - https")[0].split(" ").slice(1).join(" ");

const fn = (data) => {
  const status = ticketName(data);

  execSync(`dnd on "Currently working on: ${status}" ${time}`);
  execSync(
    `sleep ${dndDuration}; terminal-notifier -title "DND turning off" -message "${status}" -sound default`
  );
  execSync(`dnd off`);
};

const prettyPrintClickUpticket = (task) => {
  return task;
};

if (useDnd) getMyTickets(fn);
else {
  getMyTickets((card) => {
    if (card.match(/\* [\w\d]+ - /)) {
      const id = card.split(" - ")[0].replace("* ", "");
      const detailsCommand = `trello card-details ${id}`;
      console.log(execSync(detailsCommand).toString());
      process.exit();
    } else {
      const id = card.split(" ")[0].replace("c:", "");
      const cardDetailOptions = {
        ...options,
        path: `/api/v2/task/${id}/`,
      };
      const clickupDetailsCallback = (str) => {
        console.log(prettyPrintClickUpticket(str));
        process.exit();
      };
      request(cardDetailOptions, clickupDetailsCallback);
    }
  });
}
