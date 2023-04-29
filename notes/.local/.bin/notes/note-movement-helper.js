import { renameSync } from "fs";
import { notesLocation } from './utils.js';

const archive = `${notesLocation}/7 - Archive/0 - Old activity notes/`;
const yesterdaysNoteLocation = (date) => `${notesLocation}/${date}.md`;
const archivedNoteName = (date) => `${archive}${date}.md`

export const handleNoteMovement = () => {
  const yesterday = new Date(new Date(Date.now() - 86400000));

  const yesterdaysDate = `${yesterday.getFullYear()}-${yesterday
    .getMonth()
    .toString()
    .padStart(2, "0")}-${yesterday.getDate()}`;

  const oldLocation = yesterdaysNoteLocation(yesterdaysDate);
  console.log("oldLocation", oldLocation);
  const newLocation = archivedNoteName(yesterdaysDate);
  console.log("newLocation", newLocation);

  renameSync(oldLocation, newLocation);
};
