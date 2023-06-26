import fs from "fs";
import https from "https";

const url = `https://wttr.in/${process.env.MY_LOCATION}_Qp.png`;
const path = `${process.env.NOTES_LOCATION}/9 - Resources/98 - Attachments/weather.png`;

const retrieveWeather = (url, path) => {
  https.get(url, (res) => {
    const filePath = fs.createWriteStream(path);
    res.pipe(filePath);
    filePath.on("finish", () => {
      filePath.close();
    });
  });
};

export const getTheWeather = () => retrieveWeather(url, path);
