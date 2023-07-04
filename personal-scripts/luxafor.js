const { device } = require("luxafor-api");

try {
  const luxafor = device();

  const [color, ...args] = process.argv.slice(2);

  if (!luxafor) throw new Error("Flag not found");

  if (color === "off") luxafor.off();
  else if (color) luxafor.color(color);
} catch (e) {
  console.warn("There was an issue using luxafor - is it attached?");
}
