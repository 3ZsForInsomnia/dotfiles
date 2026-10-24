---
name: hebrew-flashcards
description: "Add Hebrew study cards to Zach's Anki collection: vocab words (most common), rich vocab for words that don't translate cleanly, verb conjugation sets, and function-word (preposition/pronoun) sets. Verifies every word is real against dictionaries before adding. Use when Zach gives Hebrew words to add, or says 'add these to Anki', 'Hebrew flashcards', 'vocab cards', 'grammar cards', 'conjugation cards', or 'function words'."
user-invocable: true
---

# Hebrew flashcards

Adds cards to Zach's Anki collection through the Anki MCP tools (`findNotes`, `notesInfo`, `addNotes`, `updateNoteFields`, `deleteNotes`, and friends). Those tools only load in sessions started from his notes repo (`~/Documents/sync`); if they're missing, tell him to open the chat there instead of working around it.

The usual session: Zach brings a list of Hebrew words, and they become vocab cards, plus any related words he picks. Grammar and function-word sets are less common and are requested explicitly.

## The decks

Each deck uses exactly one note type, built around how that kind of thing gets studied. Never change the note types; fill their fields as they are.

- **Hebrew** (note type `Basic`): simple vocab, the default. Fields `Front` (the Hebrew word) and `Back` (English).
- **Vocab** (note type `Hebrew Vocab`): rich vocab for words a one-line translation can't capture. Fields: `מילה עברית` (the word), `תרגום אנגלי` (English translation), `הגדרה עברית` (a simplified Hebrew definition), `חלק דיבור / בניין` (part of speech, plus binyan for verbs), `מגדר` (gender, nouns only), `שורש` (root, letters joined with hyphens), `משפטי דוגמה` (example sentences), `הערות` (notes).
- **Grammar** (note type `Hebrew Grammar`): verb conjugation sets. Fields: `Hebrew Word`, `Infinitive`, `Root`, `Binyan`, `Tense`, `Person/Gender/Number`, `Target Request`, `Answer`, `Conjugation Table`.
- **Function** (note type `Hebrew Function Grammar`): prepositions and similar words with pronoun suffixes. Fields: `צורה עברית` (the inflected form), `צורת בסיס` (the base word), `תרגום אנגלי` (English), `סוג מילה` (word type), `גוף` (the pronoun), `טבלת נטייה` (the full inflection table), `הערות` (notes, in Hebrew).

Before writing to any deck, read two or three recent notes of that type (`findNotes` on the deck, then `notesInfo` on a few of the newest IDs) and copy their formatting exactly: niqqud, capitalization, separators, and the HTML used in table fields.

## Choosing the deck

Default to vocab, and between the two vocab decks, default to **Hebrew** (Basic). Use **Vocab** (rich) when a one-line English gloss would mislead or lose something: several unrelated senses, a cultural or emotional load, register or slang nuance, or a common false friend. Zach finds these hard to spot, so call them out yourself: when a word on his list is a good rich candidate, say why in a few words and ask which deck he wants. Classic examples: firgun, davka, stam, chaval, tachles, dugri, freier. Expect this regularly, not rarely.

Grammar and Function sets only when he asks for them.

## Verifying words and meanings

Never add a word that hasn't been confirmed to exist. Invented words, and especially real verbs conjugated in a binyan they don't exist in, have forced full deck cleanups before.

Sources, fetched with `curl` and read from the raw HTML or JSON (not through a summarizing fetch tool, which can mangle niqqud and tables):

- **Pealim**: `https://www.pealim.com/search/?q=<url-encoded word>` links to the word's page (`/dict/<id>-<slug>/`), which has meanings, full conjugation or inflection tables, and related words. The authority for verbs and conjugations, but it isn't a complete dictionary.
- **Wiktionary**: `https://en.wiktionary.org/api/rest_v1/page/definition/<url-encoded word>`, Hebrew entries under the `he` key. Lists verbs under the third person masculine singular past form, not the infinitive.
- **Tatoeba**: `https://tatoeba.org/en/api_v0/search?from=heb&to=eng&query=<url-encoded word>`, real example sentences written by people, with English translations.

Rules:

- **A vocab word** must be found in Pealim or Wiktionary. If neither has it, don't add it; list it for Zach with what you know.
- **A definition** must agree across at least two of: Pealim, Wiktionary, your own knowledge. When they disagree in a way that matters, ask.
- **A grammar verb** must have a Pealim page with a conjugation table in that binyan. Every form on its cards is copied from that table, never produced yourself.
- **Example sentences** for rich cards come from Tatoeba or Wiktionary when available. Otherwise write one and mark it as yours in the summary, so Zach can check it.
- Google Translate isn't available to scripts; Zach checks it by hand if he wants it.

## Field conventions

- **Niqqud**: none by default on vocab cards. Add it only when the bare spelling could be read as more than one word, since the front of a card has no context to disambiguate. Grammar and Function notes use full niqqud, matching the existing notes.
- **Basic `Back`**: dictionary style. Capitalize the first word, separate groups of senses with semicolons, and use parentheses for clarifications or register, e.g. `To cut off, clip, trim; to reduce` or `To fuck (slang); to knock, rap`.
- **Verbs** on vocab cards go in the infinitive.

## Flows

**Vocab list**

1. For each word: verify it, gather meanings, and check for duplicates. Search both vocab decks with `nc:<word>` (Anki's niqqud-insensitive match), e.g. `deck:Hebrew nc:<word>`, then confirm hits with `notesInfo`.
2. Flag rich-card candidates and ask about them; everything else goes to the Hebrew deck.
3. Add each deck's cards with one `addNotes` call. Its approval prompt is Zach's preview of the batch, so don't ask for a separate confirmation first.
4. Summarize, then offer related words: Pealim's related words for each word, plus your own suggestions, as one numbered pick list. Add the ones he picks the same way.

**Grammar set**

A set is one verb in one binyan and one tense, with one note per row of Pealim's table for that tense (nine for past and future, four for present and imperative). Each verb is used for only one set in the whole deck, so the same root in another binyan or tense uses a different verb.

1. When Zach names what he's struggling with, show which binyan and tense combinations have no set yet (group the deck's notes by `Binyan` and `Tense`) to help pick.
2. Choose a verb in that binyan that exists on Pealim and whose infinitive doesn't appear in any Grammar note's `Infinitive` field.
3. Copy the forms from Pealim's table and fill the fields to match existing notes: `Target Request` is the tense and person (e.g. `צִוּוּי, רַבִּים`), `Answer` repeats `Hebrew Word`, and `Conjugation Table` is the whole tense as an HTML list of pronoun plus form.

**Function-word set**

One note per pronoun form of the base word (usually ten), each carrying the full inflection table. Take the forms from Pealim's inflection table for that word and match the existing notes' fields.

## Talking about Hebrew in chat

Zach's terminal (Ghostty and Neovim) doesn't apply right-to-left ordering, so normal Hebrew in chat displays backwards. When showing Hebrew in chat, write it with the letter order reversed so it reads correctly there, and keep it short: transliteration plus English (`lehaziz: to move, budge`) is the default way to refer to a word. Leave niqqud off reversed text, since each mark belongs to the letter before it and reversing character by character attaches it to the wrong letter. When vowels matter (pronunciation, telling apart words spelled alike, conjugated forms), pair the reversed Hebrew with a transliteration, using one consistent scheme (e.g. `ch` for ח, `kh` for כ, `tz` for צ, an apostrophe for a glottal stop where it matters). Reversed text is for display only: anything written to a card, file, or tool call, and anything Zach might copy, stays in normal order.

## Summary

After each batch: counts per deck; each added word as transliteration plus its English; skipped duplicates; words not added and why; sentences you wrote yourself; and the related-word pick list.
