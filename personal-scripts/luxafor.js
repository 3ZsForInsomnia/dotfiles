const { device } = require("luxafor-api");

const luxafor = device();

const [color, ...args] = process.argv.slice(2);

if (!luxafor) console.error("Luxafor device not found!");

if (color === "off") luxafor.off();
else if (color) luxafor.color(color); 

