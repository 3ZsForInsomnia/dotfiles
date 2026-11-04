---
name: daily-learning
description: "Zach's daily learning set: today's daf yomi with Rashi and Tosafot highlights, a new Hebrew word, a useful English word, and positive Jewish history plus other fun items, with the weekly Torah portion and haftarah on Saturdays or on request. Presents each with links, context, and connections, adds the words to Anki, then stays open for questions. Runs as the last step of daily planning; also use when Zach says 'daily learning', 'daf yomi', 'what's the parsha', 'word of the day', or asks for today's learning."
user-invocable: true
---

# Daily learning

Learning for fun: a set of items with links, context, and connections, then open discussion about any of them. Nothing is tracked, scheduled, or saved apart from the Anki cards.

## The items

In this order:

1. **Parsha and haftarah**: the weekly Torah portion and the reading from the Prophets that goes with it. Included automatically on Saturdays (by local date), and on any other day when Zach asks for them.
2. **Daf yomi**: the day's page of Talmud in the daf yomi cycle, which the whole world learns in step, one page a day. Sefaria's calendar knows today's page, so nothing needs tracking.
3. **Hebrew word**
4. **English word**
5. **Fun items**: Jewish, Hebrew, or Israeli.

Length follows the material. Short days are fine and preferable; never pad an item to fill space.

## Calendar

Get the parsha, haftarah, and daf from Sefaria, never from memory: double portions and the diaspora schedule make the parsha easy to get wrong, and a daf number can't be reliably calculated by hand.

```sh
curl -s 'https://www.sefaria.org/api/calendars?diaspora=1&year=<YYYY>&month=<M>&day=<D>'
```

Always pass `diaspora=1`; Zach follows the diaspora reading schedule. On a weekday the parsha and haftarah returned are the coming Shabbat's. In the response's `calendar_items`, the entries whose `title.en` is `Parashat Hashavua`, `Haftarah`, and `Daf Yomi` are the ones used here. Each has `displayValue.en` (the name, e.g. `Chayei Sara` or `Bekhorot 50`), `ref` (e.g. `Genesis 23:1-25:18`), and `url` (e.g. `Bekhorot.50`). The reading link is `https://www.sefaria.org/<url>`. The parsha entry also carries a one-paragraph summary in `description.en`; the haftarah and daf entries have none.

## Fetching texts

Fetch only what an item or a question needs, and English versions only, except the Hebrew-only commentaries below. Hebrew is shown in chat only as the `hebrew-flashcards` skill describes, never as quoted source text.

Sefaria's v3 texts API returns a ref's text in `versions[0].text`, as nested lists of passages containing HTML tags.

- **The daf, every day**: `https://www.sefaria.org/api/v3/texts/<url>?version=english`, with `<url>` from the calendar (e.g. `Bekhorot.50`, which returns both sides of the page, around 15k characters). This is the William Davidson edition: the literal translation in bold, interleaved with Steinsaltz's explanation. Knowledge of what a specific daf says is unreliable, so the summary comes from this text.
- **Rashi and Tosafot on the daf, every day**: `https://www.sefaria.org/api/v3/texts/<Commentator>_on_<Tractate>.<page><a|b>` with no version parameter, for both sides of the page, e.g. `Rashi_on_Bekhorot.50a`, `Rashi_on_Bekhorot.50b`, `Tosafot_on_Bekhorot.50a`, `Tosafot_on_Bekhorot.50b`. These exist only in Hebrew; translate what you show.
- **Related texts, for connections**: `https://www.sefaria.org/api/related/<ref>`, e.g. `Bekhorot.50a`. Its `links` list what the passage cites and what cites it, each with a `sourceRef` and a `category` (`Tanakh`, `Talmud`, `Midrash`, `Halakhah`, `Commentary`, and others); `topics` names the people and subjects involved. Fetch it for the daf daily, and for the parsha when it's included.
- **Parsha or haftarah text**, only when a question needs the exact wording: the texts endpoint with the calendar entry's `url` and `?version=english`.

## Parsha and haftarah

- **Name and link** for each.
- **Summary**: the parsha uses Sefaria's `description.en` as is. The haftarah gets a sentence or two, including how it connects to the parsha.
- **What Jews take from it**: the lessons and themes tradition draws from the portion, e.g. Rebecca's kindness at the well as the model of chesed (lovingkindness). Include it for the haftarah when it has its own.
- **Connections** and **extras**, as described below.

## Daf yomi

- **Name and link.**
- **Summary**, from the fetched text: what the page is about and how its argument moves, in a short paragraph or a few bullets. Explain legal concepts in plain terms as they come up.
- **Commentary highlights**: zero to two comments from Rashi or Tosafot, translated and explained. A comment is worth showing when it adds something the Steinsaltz explanation doesn't:
  - It changes the reading: it explains a word or phrase so the passage means something other than the obvious reading, or rejects an interpretation that seemed natural.
  - It raises a contradiction with another passage and resolves it (Tosafot's signature move).
  - Tosafot disagrees with Rashi, giving two readings of the same line, each with a reason.
  - It becomes the basis for later halakha or a recognizable custom.
  - It opens a window onto the commentator's world, such as Rashi glossing a word in Old French or a comment reflecting life in medieval France or Germany.
  - It's surprising, funny, or asks a sharp question a reader would want asked.

  Glosses that restate the Steinsaltz explanation, routine notes on who said what, and technical back-and-forth that only settles a procedural detail don't qualify. When Tosafot cites another passage, fetch it rather than guessing what it says. End the section by offering the rest of the commentary on request.
- **Connections** and **extras**, as described below.

## Connections

A standard part of the parsha, haftarah, and daf. Share every type that's present, labelled by type:

- **Modern Jewish life**: practice and custom today that traces back to the text, including differences between Ashkenazi, Sephardi, and Mizrahi communities.
- **Other texts**: places elsewhere in Tanakh, Talmud, midrash, or halakha that give the text context or that it gives context to, e.g. a daf that quotes a verse from this week's parsha. Use the related-texts list, then search for links it doesn't hold.
- **History**: the period, places, people, and events behind the text.

Frame differences by community, not by denomination. Draw on traditional rabbinic sources and academic scholarship, and leave out fringe political groups' views. Search the web to confirm anything specific enough to misattribute: a named ruling, the source of a midrash, a historical date.

## Extras

Optional, for the parsha, haftarah, and daf:

- One to three midrashim (rabbinic stories and interpretations) that are well known, funny, or illuminating.
- Background on a rabbi, biblical figure, or anyone else who appears in the text.

Skip anything dull. Material is dull when it has no link to modern Jewish life, no interesting history, and no connection to another text that gives it life. That last test often can't be settled from memory, so check the related-texts list and search before deciding something is dull.

## Hebrew word

Zach's Hebrew is conversational but slow, with limited vocabulary. Pick a word from everyday adult Hebrew (news, conversation, Israeli TV and media), past textbook basics and short of literary or archaic.

The `hebrew-flashcards` skill owns how Hebrew cards are verified and written. Read it at `~/src/dotfiles/ai/.config/skillz/custom/hebrew-flashcards/SKILL.md` before this step and follow its rules for verifying the word, checking for duplicates, choosing between decks, filling fields, and showing Hebrew in chat. Check for duplicates in the `Hebrew` and `Vocab` decks only; `Function` and `Grammar` hold grammar drills, not vocabulary. When the candidate is a duplicate or fails verification, pick another.

Present the word with its transliteration, the Hebrew shown as that skill describes, its English meaning, a short example, and a deck recommendation: `Hebrew` for a clean one-line translation, `Vocab` for a word a one-line gloss would mislead on, with a few words on why. Add the card only after Zach agrees or picks the other deck, then add it as `hebrew-flashcards` describes.

## English word

Pick a word that makes speech and writing more precise: one an educated adult meets in good writing (serious journalism, essays, nonfiction) and may not use, or use exactly. It should be usable in ordinary professional or everyday writing this week. Never pick a word for being rare, ornate, or obscure.

Before presenting it, search the `English` deck for it (`findNotes` with `deck:English "Word:<word>"`) and pick another if it's there. Present it with:

- A definition.
- One example sentence.
- One to three near-synonyms it beats in some situations, with how and why it's the better choice there.

Add it to the `English` deck with the `English Vocab` note type, filling `Word`, `Definition`, `Example`, and `Compared with` (the near-synonym comparison). Create the deck with `createDeck` if it doesn't exist. Add it after presenting; the `addNotes` approval prompt is Zach's preview, so don't ask separately.

## Fun items

Always one item of Jewish history, plus whatever else is interesting: food, language and slang, music, notable people, customs and holidays, Israel today. Jewish history spans about 3,000 years and most of the map, so range widely across periods and places.

History items are positive: achievements, culture, people, communities that flourished. Holidays rooted in surviving persecution, such as Purim and Chanukah, are fine when the item is about how they're celebrated rather than the persecution itself.

Add more fun items when one is very short, or when the parsha and daf were short or painfully dry. Don't add them to even out a day's length.

Confirm with a web search anything tied to a date ("on this day") and any specific claim about a dated event or a named person's life before presenting it.

## Anki

The Anki MCP tools (`findNotes`, `notesInfo`, `addNotes`, `createDeck`, `sync`) only load in sessions started from Zach's notes repo (`~/Documents/sync`), and only work while the Anki desktop app is running, because they talk to its AnkiConnect add-on at `localhost:8765`. If the tools are missing, say so and skip the Anki steps; the rest still runs.

Before the first Anki call:

1. Check whether Anki is already running: `pgrep -x Anki`.
2. If it isn't, launch it with `open -a Anki` and poll `curl -s -m 1 localhost:8765 -d '{"action":"version","version":6}'` once a second for up to 30 seconds. If it never answers, tell Zach, list the words that weren't added, and continue without Anki.

After the last card is added, run the `sync` tool. Then, only if this session launched Anki, quit it gracefully with `osascript -e 'quit app "Anki"'`. Never force-kill Anki; that risks corrupting the collection.

## The flow

1. Fetch the calendar, then the daf, its Rashi and Tosafot, and its related texts (plus the parsha's related texts when it's included). Start Anki if it isn't running.
2. Read `hebrew-flashcards`, then pick and check the Hebrew and English words.
3. Present everything in one message, in the order under **The items**, with a heading per item. End by asking about the Hebrew word's deck and inviting questions about anything.
4. Add the English card, and the Hebrew card once Zach decides. Then sync and close Anki as described above.
5. Answer questions about any item, fetching texts as described under **Fetching texts** when a question needs them.
