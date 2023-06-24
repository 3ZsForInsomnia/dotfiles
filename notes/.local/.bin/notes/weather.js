const https = require("https");
const { writeFileSync } = require("fs");

const options = {
  hostname: "wttr.in",
  path: `${process.env.MY_LOCATION}_Qp.png`,
};

export const getTheWeather = () => {
  https.get(options, (resp) => {
    let str = "";
    resp.on("data", function(chunk) {
      str += chunk;
    });

    resp.on("end", function() {
      writeFileSync(
        `${process.env.NOTES_LOCATION}9 - Resources/98 Attachments/weather.png`,
        { encoding: "png" }
      );

      process.exit();
    });
  });
};

