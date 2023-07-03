const https = ("https");
const { exec } = ("node:child_process");
const list = ("cli-list-select");
const { getInProgressCards } = ("../notes/.local/.bin/notes/trello-handler");
const { CLICKUP_TEAM, CLICKUP_ME, CLICKUP_KEY } = process.env;

const defaultItems = ["I am in a meeeting", "Zach is working", "custom"];

const [time, ...args] = process.argv.slice(2);
if (!time) time = 30;
const dndDuration = time * 1000;

const prettyTask = (task) => `Curr: ${task.name} - ${task.url}`;
const sortTasks = (a, b) => a.due_date > b.due_date;

const options = {
  hostname: "api.clickup.com",
  path: `/api/v2/team/${CLICKUP_TEAM}/task?assignees[]=${CLICKUP_ME}`,
  headers: {
    Authorization: CLICKUP_KEY,
  },
};

const getMyTickets = (callback) => {
  const trello = getInProgressCards();

  https.get(options, (resp) => {
    let str = "";
    resp.on("data", function(chunk) {
      str += chunk;
    });

    resp.on("end", function() {
      const data = JSON.parse(str).tasks.sort(sortTasks).map(prettyTask);
      list([...data, ...trello, ...defaultItems], { singleCheck: true }).then((choice) =>
        callback(data[choice.index] === "custom" ? args[0] : data[choice.index])
      );
    });
  });
};

const ticketName = (task) => task.split(" - https")[0];

const fn = (data) => {
  const status = ticketName(data);
  exec(`dnd on "${status}" ${time}`, (error) => {
    if (error) {
      console.error("Could not execute command: ", error);
      process.exit();
    }

    setTimeout(() => {
      exec(`dnd off ""`, (error) => {
        error
          ? console.error("Failed to turn DND off: ", error)
          : console.log("Congrats, you did some work!");
        process.exit();
      });
    }, dndDuration);
  });
};

getMyTickets(fn);
