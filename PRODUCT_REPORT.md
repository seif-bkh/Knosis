# KNOSIS — Product Report & Functional Specification  
**Document v0.1 — Base to hand to an AI Agent to build the application with time**

---

## 0. Executive Summary

**Knosis** is an offline-first application that helps users learn languages through reading books and texts.  
The goal is not just "read a book," but:

> **Learn to read in flow, understand context, acquire vocabulary through meaning, revisit intelligently, take notes, ask questions, and evolve until you can read any text with confidence.**

Knosis transforms a book into a **journey**, not an intimidating mountain.  
It segments content, measures user level, provides appropriate reading modes, saves notes/questions/words, and brings user back through spaced repetition.

---

# 1. Product Identity

## 1.1 Name

**KNOSIS**

Inspiration: "Gnosis" = knowledge / inner knowing.  
We added a "K" to make it techy, memorable, and evocative of "Know."

### Pronunciation
**Know-sis** / **Kno-sis**

## 1.2 Taglines

- **From words to worlds.**
- Read. Understand. Return.
- Learn languages through deep reading.
- Turn books into language journeys.

## 1.3 Brand Promise

Knosis helps the user:

- start reading according to their level
- avoid the trap of "understanding every single word"
- preserve reading flow
- build vocabulary and comprehension through context
- write notes and ask questions
- return to content through spaced repetition
- finish long books without fear of the page count

---

# 2. Product Vision

Knosis is not just a PDF reader, nor just a vocabulary app.  
It is a **Reading Learning System**.

The app is built on 5 pillars:

## 2.1 Read

A comfortable, minimal reading mode that lets the user enter flow state.

## 2.2 Clarify

After reading, the user can clarify words, phrases, passages, and grammar points — but in a measured dose.

## 2.3 Reflect

The user writes:

- notes
- questions
- opinions
- summaries
- quotes
- objections
- ideas

## 2.4 Return

The app brings the user back to words, notes, questions, and passages after intervals through spaced repetition.

## 2.5 Evolve

Knosis learns from user behaviour:

- reading speed
- dictionary lookups
- comprehension
- fatigue
- preferred topics
- level progression

And gives appropriate texts, chunks, and rituals.

---

# 3. Problem Knosis Solves

## 3.1 The Problem

User wants to read in a new language, but:

- stops at every word
- loses context
- understands words but not paragraphs
- gets tired and gives up
- fears long books
- doesn't know what to review
- reads once and forgets everything
- makes many highlights without any system

## 3.2 The Solution

Knosis provides:

- placement test from the start
- book/text difficulty estimation
- intelligent chunking
- flow reading mode
- study reading mode
- guided rereading
- notes/questions system
- vocabulary review
- spaced repetition
- progress map
- offline-first private library

---

# 4. Target Audience

## 4.1 Primary Users

1. **Language Learners**
   - English, French, German, Spanish, etc.
   - levels A1–B2 especially
   - want to read real content

2. **Readers Who Want to Return to Reading**
   - fear long books
   - have attention issues
   - want an app to help them focus

3. **Students / Self-Learners**
   - read academic texts
   - need notes and questions

4. **Deep Readers**
   - want a commonplace book
   - quotes, reflections, rereading

## 4.2 Secondary Users

- teachers
- book clubs
- researchers
- people learning philosophy, literature, and science through language

---

# 5. Pedagogical Principles

Knosis must be built on these principles.

## 5.1 Context Before Dictionary

The app should not push the user to translate every word.

Central message:

> "Understand the scene/idea before trying to understand every word."

## 5.2 Extensive Reading

User reads a lot of appropriately-leveled content.  
Goal:

- volume
- pleasure
- speed
- natural intuition
- vocabulary through context

## 5.3 Intensive Reading

After flow, user selects a small passage to dive deep into:

- words
- grammar
- style
- meaning
- opinion

## 5.4 Rereading with Purpose

Not just "read again and that's it."  
Each reread has a purpose:

1. First read: what is the general meaning?
2. Second read: what are the details?
3. Third read: can I explain in my own words?
4. Later return: what do I still remember?

## 5.5 Retrieval Practice

The app asks the user:

- what do you remember?
- summarize in one sentence
- what question remains?
- what is the main idea?

The brain learns more when it tries to retrieve information rather than just reread it.

## 5.6 Spaced Repetition

Review is not the same thing every day.  
The app returns:

- words
- phrases
- quotes
- notes
- questions
- passages

at intervals:

- 1 day
- 3 days
- 7 days
- 14 days
- 30 days

## 5.7 Protect the Flow

During reading:

- no aggressive popups
- no quizzes in the middle of a paragraph
- no over-translation
- no stressful gamification

---

# 6. Core User Journey

## 6.1 First Launch

1. User opens Knosis
2. Sees intro:
   - "From words to worlds."
   - "Read in flow."
   - "Return smarter."
3. Chooses target language
4. Takes quick placement
5. App gives initial Reading Plan
6. User imports a book OR picks a sample text

## 6.2 Reading a Book

1. User uploads EPUB/TXT/PDF
2. App parses the book
3. App segments it:
   - chapters
   - sections
   - chunks
4. App estimates difficulty
5. User starts a session:
   - Flow Mode
   - Study Mode
   - Review Mode
6. At session end:
   - quick summary
   - 1–3 questions
   - marked words
   - progress saved

## 6.3 Long Book Journey

A 2000-page book is not shown as a scary number.  
It appears as a journey:

- Part 1
- Chapter 1
- Today's step
- next milestone
- session streak
- ideas collected

The app does not say "you have 1847 pages left" as a main message.  
It says:

> "Today: 12 minutes, 4 pages, 1 idea captured."

---

# 7. Main Screens

## 7.1 Splash / Welcome

### Content

- Knosis logo
- Tagline: "From words to worlds."
- CTA: "Start your reading journey"

### Feeling

Modern, calm, intellectual, not school-like.

---

## 7.2 Onboarding

Screens:

1. Choose language
2. Choose goal:
   - read novels
   - read academic texts
   - improve vocabulary
   - build a habit
   - prepare for exams
3. Choose current comfort:
   - I understand simple sentences
   - I understand short stories
   - I can read articles slowly
   - I can read books but struggle
4. Placement test
5. Suggested plan

---

## 7.3 Home Dashboard

The home screen must answer three questions:

- What am I reading now?
- What should I review?
- How is my progress?

### Cards

- Continue Reading
- Today's Review
- Current Journey
- New Words
- Questions to Explore
- Reading Streak (optional)
- Suggested Short Text

---

## 7.4 Library

### Views

- Grid view
- List view
- By language
- By difficulty
- By status:
  - Not started
  - Reading
  - Paused
  - Finished
  - Rereading

### Book Card

- Cover
- Title
- Author
- Language
- Difficulty
- Progress
- Last read date
- Journey status

---

## 7.5 Book Journey Page

The page for one book.

### Contains

- Book cover/title/author
- Language
- Estimated difficulty
- Estimated sessions
- Chapters map
- Notes count
- Questions count
- Words collected
- Reread plan
- Start / Continue button

### Special Feature

"Journey Map":

- chapter nodes
- completed nodes
- review nodes
- important marked passages

---

## 7.6 Reader Screen

The most important screen.

### Requirements

- clean typography
- large comfortable spacing
- no distraction
- offline
- subtle progress
- easy highlight
- easy note
- easy dictionary lookup

### Top Bar

Minimal:

- back
- chapter title
- session timer
- more

### Bottom Bar

Hidden by default. On tap:

- Flow / Study toggle
- Add note
- Mark word
- Bookmark
- Pause session

---

## 7.7 Session End Screen

After reading session.

### Quick Prompts

- "Summarize what you read in one sentence"
- "What was the most important idea?"
- "What question remains?"
- "Rate comprehension: 1–5"
- "Do you want to review marked words later?"

### Save

Creates ReadingSession record.

---

## 7.8 Review Center

### Review Types

- Words
- Phrases
- Notes
- Questions
- Passages
- Summaries

### Modes

1. Quick Review — 5 minutes
2. Deep Review — 15 minutes
3. Reread marked passage
4. Recall from memory

---

## 7.9 Commonplace Book

The user's digital notebook.

### Contains

- quotes
- notes
- ideas
- themes
- linked books
- questions
- reflections

### Filters

- By book
- By language
- By tag
- By date
- By idea type

---

## 7.10 Settings

- Languages
- Reading preferences
- Font
- Theme:
  - Light
  - Sepia
  - Dark
  - OLED
- Dictionary settings
- Review settings
- Data export/import
- Privacy
- Backup
- Optional AI settings later

---

# 8. Detailed Features

---

## 8.1 Onboarding & Placement Test

### Priority

P0 for MVP.

### Goal

Measure the user's level in the chosen language.

### Test Components

1. Self-assessment
2. Vocabulary recognition
3. Short passage comprehension
4. Sentence meaning
5. Reading behaviour

### Output

- Estimated level:
  - A1
  - A2
  - B1
  - B2
  - C1
  - C2
- Reading comfort score
- Suggested chunk size
- Suggested dictionary strictness
- Suggested starting content

### Example Result

> "Your approximate level: B1 reading.  
> Start with short stories 600–1200 words.  
> Flow Mode recommended: 15-minute sessions.  
> Max dictionary lookups: 5 per session."

### Placement Should Evolve

After the user reads, the app updates the profile:

- comprehension rating
- lookup frequency
- reread success
- vocabulary retention

---

## 8.2 Import Library

### Priority

P0 for EPUB/TXT.  
P1 for PDF.

### Supported Formats

#### V1 MVP

- EPUB
- TXT
- Markdown

#### V1.5

- PDF text extraction

#### V2

- PDF OCR
- DOCX
- HTML pages
- Saved offline web articles

### Notes

PDF is hard because:

- pages are fixed
- text extraction may be messy
- columns/footnotes confuse parsers
- OCR requires heavy processing

So EPUB is the first-class format.

### Import Flow

1. User selects file
2. App copies file locally
3. Extracts metadata:
   - title
   - author
   - language if possible
   - cover
4. Extracts text
5. Detects chapters
6. Generates chunks
7. Estimates difficulty
8. Adds to library

---

## 8.3 Text Chunking

### Priority

P0.

### Why

Long books become manageable.

### Chunk Sizes by Level

- A1: 80–150 words
- A2: 150–250 words
- B1: 250–500 words
- B2: 500–900 words
- C1+: 900–1500 words

### Rules

- never cut mid-sentence
- avoid cutting mid-paragraph when possible
- preserve chapter structure
- create stable IDs for chunks
- allow manual adjustment later

### Chunk Data

Each chunk has:

- bookId
- chapterId
- index
- startOffset
- endOffset
- wordCount
- difficultyScore
- status:
  - unread
  - read once
  - reviewed
  - mastered

---

## 8.4 Reader Modes

Knosis must have 3 main modes.

---

### 8.4.1 Flow Mode

### Purpose

User reads without interruptions.

### Behaviour

- dictionary hidden or limited
- no popups
- no quizzes
- highlights possible but minimal
- unknown word can be "parked" for later
- timer optional
- app encourages moving forward

### Features

- "Mark for later"
- "Skip word"
- "I got the idea"
- end-of-session reflection

### UX Message

> "Keep the story alive. You can clarify later."

---

### 8.4.2 Study Mode

### Purpose

Analyze a passage.

### Behaviour

- dictionary enabled
- phrase explanations
- grammar notes
- user can split a sentence
- user can write translation/paraphrase
- app can ask questions

### Features

- word lookup
- phrase save
- sentence note
- grammar note
- compare first understanding vs now
- intensive reread

---

### 8.4.3 Review Mode

### Purpose

Return after time.

### Behaviour

- show old highlight
- hide note first, ask recall
- show saved vocabulary
- ask comprehension
- schedule next review

### Review Prompts

- "What do you remember from this passage?"
- "Summarize in your own words"
- "What does this word mean in this context?"
- "Do you want to review it again later?"

---

## 8.5 Dictionary & Vocabulary

### Priority

P1 for full offline dictionary.  
P0 for "mark unknown words."

### V1 MVP

- user selects word
- app saves word + context sentence
- user can add manual meaning
- review later

### V1.1

- offline dictionary packages
- simple definitions
- translation where available
- example sentences
- pronunciation IPA optional

### V2

- context-aware meaning
- collocations
- frequency rank
- word family:
  - decide
  - decision
  - decisive
  - indecisive

### V3 AI

- explain word in the current context
- give easy example at user level
- ask an active recall question

### Important Rule

The app should not make the dictionary too easy.  
If the user taps 30 words in 5 minutes, the app gently says:

> "You're falling into word-by-word mode. Try reading the next paragraph without lookup."

---

## 8.6 Notes System

### Priority

P0.

### Note Types

- Summary
- Question
- Opinion
- Confusion
- Quote
- Connection
- Vocabulary
- Grammar
- Character/event note
- Research later

### Note Structure

Each note has:

- bookId
- chapterId
- chunkId optional
- selected text optional
- note type
- content
- tags
- createdAt
- updatedAt
- review status

### UX

Quick note input:

- type the note fast
- choose the type later
- no friction

Prompt examples:

- "Explain this in your own words"
- "What do you disagree with?"
- "What does this remind you of?"
- "What question should you research?"

---

## 8.7 Questions System

### Priority

P1.

Knosis should take questions seriously.

### Question Statuses

- Open
- Researched
- Answered
- Revisit later
- Connected to another book

### Question Fields

- question text
- source passage
- user's guess
- research notes
- answer
- links
- tags

### Why

The user becomes an active reader, not a passive consumer.

---

## 8.8 Summaries

### Priority

P0.

Types:

1. Session summary
2. Chunk summary
3. Chapter summary
4. Book summary
5. Reread summary

### Good Summary Prompts

- "In one sentence, what happened?"
- "What is the main argument?"
- "If you had to explain this to a friend?"
- "What changed in your understanding?"

---

## 8.9 Spaced Repetition Review

### Priority

P1.

### Review Items

- vocabulary words
- phrases
- notes
- questions
- passages
- summaries

### Review Grading

User rates:

- Again
- Hard
- Good
- Easy

### Scheduling

Initial simple algorithm:

- Again: tomorrow
- Hard: 2 days
- Good: 4–7 days
- Easy: 14+ days

Later use SM-2 or FSRS.

### Key Idea

Review should feel light, not like an exam.

---

## 8.10 Progress Tracking

### Priority

P0.

### Metrics

- minutes read
- sessions completed
- chunks read
- chapters progressed
- words marked
- words learned
- notes written
- questions opened/answered
- rereads done
- comprehension confidence
- lookup rate
- flow score

### Avoid Bad Pressure

Do NOT overfocus on:

- pages left
- streak guilt
- speed competition

### Better Progress Messages

- "You returned to this idea 3 times."
- "Your lookup rate decreased this week."
- "You understood longer chunks than before."
- "You completed 8 focused sessions."

---

## 8.11 Book Journey System

### Priority

P0.

Each book has a "Journey."

### Journey Stages

- Imported
- Previewed
- Started
- First pass
- Deep pass
- Review pass
- Finished
- Revisit later

### Journey Page Shows

- next session
- last note
- open questions
- words due for review
- important passages
- milestones

### For Huge Books

Show:

- "Current milestone"
- "Next 20 pages"
- "Current chapter"
- "Current part"

Instead of always showing the full remaining pages.

---

## 8.12 Adaptive Recommendations

### Priority

P2.

App suggests:

- easier text
- shorter session
- switch to flow mode
- reread a chapter
- review vocabulary
- take a break

Based on:

- low comprehension rating
- too many lookups
- slow reading
- user abandoning sessions
- repeated confusion notes

### Example

> "This chapter seems dense. Try a 10-minute Flow Read first, then study one paragraph."

---

## 8.13 AI Coach

### Priority

V3, not MVP.

AI should be optional and privacy-aware.

### AI Roles

- explain passage at user level
- generate comprehension questions
- simplify a sentence
- create a glossary
- help summarize
- ask Socratic questions
- detect main ideas
- guide rereading

### AI Rules

- do NOT replace reading
- do NOT explain everything instantly
- encourage the user to guess first
- preserve flow
- work offline if possible later
- online AI optional with clear privacy warning

### AI Coach Style

Gentle, concise, like a mentor:

> "Before I explain, what do you think the paragraph means?"

---

# 9. Design Direction

## 9.1 Brand Personality

Knosis should feel:

- calm
- intelligent
- focused
- premium
- modern
- warm
- not childish
- not academically boring
- not overloaded

It should look like:

> "A beautiful private library + learning coach."

## 9.2 Visual Metaphor

Book + path + light.

Ideas:

- an open book with a path going through its pages
- the letter K formed by folded pages
- a small compass inside a book
- a highlight line turning into a road
- an eye + book, but subtle

## 9.3 Logo System

### App Icon

A minimalist **K** made from:

- one vertical book spine
- two page folds forming diagonals

Inside or around it:

- a small dot of light
- or a subtle bookmark

### Logo Feel

- geometric
- soft rounded corners
- no complex details
- recognizable at small size

### Full Logo (App + Wordmark)

- icon on the left
- wordmark "Knosis" on the right
- optional tagline below: "From words to worlds."

---

# 10. Color Palette

## Light Theme

- Background paper: `#FAF7F0`
- Main text ink: `#18202F`
- Primary teal: `#2F8C87`
- Deep navy: `#14213D`
- Warm gold accent: `#D6A94A`
- Soft border: `#E7DED1`
- Muted text: `#6D7280`

## Dark Theme

- Background: `#0F172A`
- Surface: `#172033`
- Main text: `#E5E7EB`
- Muted text: `#9CA3AF`
- Primary teal: `#4DB6AC`
- Accent gold: `#E0B85A`

## Sepia Reading Theme

- Background: `#F4ECD8`
- Text: `#2D2417`
- Highlight: `#FFE08A`

---

# 11. Typography

## UI Font

- Inter
- SF Pro
- Manrope

## Reading Font

- Literata
- Source Serif
- Georgia
- Merriweather

## Requirements

User can customize:

- font size
- line height
- paragraph spacing
- margins
- justification on/off
- dyslexia-friendly font optional

---

# 12. UI Style

- card-based layout
- soft shadows
- rounded corners 16–24px
- lots of whitespace
- subtle animations
- no flashy colors
- calm visual progress
- thin/rounded icons

## 12.1 Main Navigation

Suggested bottom tabs:

1. Home
2. Library
3. Review
4. Notes
5. Profile/Settings

The Reader opens fullscreen outside tabs.

---

# 13. Data Model

This is important for the AI Agent.

## 13.1 UserProfile

Fields:

- id
- name optional
- createdAt
- preferredTheme
- dailyGoalMinutes
- defaultReadingMode
- privacySettings

## 13.2 LanguageProfile

Fields:

- id
- userId
- languageCode
- targetLanguageName
- estimatedLevel
- comfortScore
- averageReadingSpeed
- lookupRate
- comprehensionAverage
- createdAt
- updatedAt

## 13.3 Book

Fields:

- id
- title
- author
- languageCode
- sourceFilePath
- coverPath
- format
- importedAt
- totalWords
- totalChapters
- difficultyScore
- status
- currentPosition
- lastReadAt

## 13.4 Chapter

Fields:

- id
- bookId
- title
- index
- startOffset
- endOffset
- wordCount
- difficultyScore

## 13.5 Chunk

Fields:

- id
- bookId
- chapterId
- index
- text
- startOffset
- endOffset
- wordCount
- difficultyScore
- status
- readCount
- lastReadAt

## 13.6 ReadingSession

Fields:

- id
- userId
- bookId
- chapterId optional
- chunkStartId
- chunkEndId
- mode
- startedAt
- endedAt
- durationSeconds
- wordsRead
- comprehensionRating
- flowRating
- summary
- createdAt

## 13.7 Annotation

Fields:

- id
- bookId
- chapterId
- chunkId
- selectedText
- startOffset
- endOffset
- color
- type
- createdAt

## 13.8 Note

Fields:

- id
- annotationId optional
- bookId
- chapterId optional
- chunkId optional
- type
- content
- tags
- createdAt
- updatedAt
- reviewEnabled
- nextReviewAt

## 13.9 Question

Fields:

- id
- bookId
- chapterId optional
- chunkId optional
- sourceText optional
- question
- userGuess optional
- answer optional
- status
- tags
- createdAt
- updatedAt
- nextReviewAt

## 13.10 VocabularyItem

Fields:

- id
- languageCode
- word
- lemma optional
- contextSentence
- bookId
- chapterId optional
- chunkId optional
- userMeaning optional
- dictionaryMeaning optional
- status
- easeScore
- intervalDays
- nextReviewAt
- createdAt
- updatedAt

## 13.11 ReviewEvent

Fields:

- id
- itemType
- itemId
- reviewedAt
- rating
- previousInterval
- newInterval
- notes

## 13.12 Tag

Fields:

- id
- name
- color
- createdAt

---

# 14. Algorithms

## 14.1 Placement Score

Input:

- self-rating
- vocab score
- comprehension score
- reading speed
- confidence

Output:

- CEFR estimate
- recommended chunk size
- recommended text difficulty
- dictionary limit

Simple weighted formula:

- comprehension: 40%
- vocab: 25%
- self-rating: 15%
- speed: 10%
- confidence: 10%

## 14.2 Difficulty Score

For each text/chunk:

- average sentence length
- word frequency
- unknown word density
- punctuation complexity
- paragraph length
- rare word count

Output: 0–100.

Labels:

- 0–20: Very Easy
- 21–40: Easy
- 41–60: Medium
- 61–80: Hard
- 81–100: Very Hard

## 14.3 Flow Score

Track:

- reading time
- pauses
- dictionary lookups
- notes during reading
- backtracking
- comprehension rating

Flow score is not judgment.  
It helps the app say:

> "Your best flow happens with 12–18 minute sessions."

## 14.4 Lookup Rate

Formula:

`lookups per 100 words`

If too high:

- suggest easier text
- suggest Flow Mode
- reduce dictionary use
- offer preview glossary before reading

## 14.5 Spaced Repetition

V1 simple:

- Again → 1 day
- Hard → 2 days
- Good → 5 days
- Easy → 14 days

Later:

- SM-2
- FSRS

---

# 15. Versions / Roadmap

---

## Version 0.1 — Prototype

### Goal

Prove the core reading experience.

### Features

- basic app shell
- local database
- import TXT
- basic reader
- highlight text
- add note
- save reading position
- simple home screen

### Done When

User can import text, read it, highlight, write a note, close the app, reopen, and continue.

---

## Version 0.5 — Internal Alpha

### Goal

Turn the prototype into a real offline reader.

### Features

- EPUB import
- chapter detection
- chunking
- basic library
- book detail page
- reading sessions
- session summary
- basic progress
- light/dark/sepia themes

### Done When

User can import an EPUB and read chapter by chapter with saved progress.

---

## Version 1.0 — MVP Offline

### Goal

First usable Knosis.

### Must-Have

- onboarding
- choose target language
- simple placement test
- import EPUB/TXT/Markdown
- library
- book journey page
- reader with Flow Mode
- reader with Study Mode
- highlights
- notes
- questions
- session end reflection
- marked words
- basic review center
- progress dashboard
- all data local/offline
- export notes as Markdown

### MVP Acceptance Criteria

- no account required
- app works fully offline after installation
- imported books stay local
- user can finish a reading session and see progress
- user can review marked words/notes later
- app handles huge books without lag

---

## Version 1.1 — Reading Quality

### Goal

Make the reader excellent.

### Features

- better typography controls
- full-screen focus
- reading themes
- bookmarks
- search inside a book
- chapter navigation
- better EPUB rendering
- quote capture
- note tags
- reading timer
- "lookup limit" setting

---

## Version 1.2 — Review System

### Goal

Make learning stick.

### Features

- spaced repetition scheduling
- review queue
- Again/Hard/Good/Easy
- vocabulary cards
- note recall cards
- question cards
- review statistics
- daily review reminder optional

---

## Version 1.5 — PDF Support

### Goal

Support more real books.

### Features

- PDF import
- text extraction
- PDF reading mode
- save highlights
- extract selected text
- chunk text if extraction is clean
- warning if PDF is scanned

### Notes

OCR should wait until later because it adds complexity.

---

## Version 2.0 — Adaptive Learning

### Goal

Knosis evolves with the user.

### Features

- adaptive chunk size
- improved difficulty estimation
- personalized recommendations
- reading behaviour insights
- lookup-rate warnings
- "too hard / too easy" detection
- weekly learning report
- rereading plan per book
- CEFR progression tracking

---

## Version 2.5 — Audio & Pronunciation

### Goal

Connect reading with listening.

### Features

- text-to-speech
- read-along mode
- audio speed control
- pronunciation replay
- shadowing prompts
- save phrases for listening review

---

## Version 3.0 — AI Coach

### Goal

Add intelligent guidance.

### Features

- explain passage at user level
- generate comprehension questions
- summarize a chapter
- detect main ideas
- create a glossary from a chunk
- Socratic mode
- "don't spoil me" mode
- optional online AI
- possible local AI later

### AI Coach Constraints

- user should think first
- explanations should be short by default
- AI should not interrupt Flow Mode
- all AI actions require user request or session boundary

---

## Version 4.0 — Sync & Ecosystem

### Goal

Make Knosis multi-device.

### Features

- optional account
- encrypted sync
- cloud backup
- desktop app
- web clipper
- import from articles
- teacher mode (maybe)
- shared reading plans (maybe)

### Important

Sync is optional. Offline-first remains core.

---

# 16. Technical Recommendations

## 16.1 Recommended Stack

For an offline-first cross-platform app:

### Option A: Flutter

Best if targeting:

- Android
- iOS
- desktop later

Suggested:

- Flutter
- Riverpod for state management
- SQLite via Drift
- local file storage
- EPUB parser package
- PDF package later
- SQLite FTS5 for search

### Option B: Tauri + React

Best if desktop-first:

- Windows
- macOS
- Linux

### Option C: React Native

Possible, but EPUB/PDF/local file handling can be harder.

### Recommendation

Start with **Flutter**.

---

## 16.2 Architecture

Suggested modules:

```text
/lib
  /app
    router
    theme
    localization
  /core
    database
    file_storage
    utils
    errors
  /features
    onboarding
    placement
    library
    import
    reader
    notes
    vocabulary
    review
    progress
    settings
  /shared
    widgets
    models
    services
```

---

## 16.3 Offline-First Rules

- no login required
- database local
- files copied to local app storage
- notes stored locally
- reviews stored locally
- exports available
- app never sends book text unless the user explicitly enables AI online

---

## 16.4 Storage

Use:

- SQLite for structured data
- local file system for books/covers/cache
- Markdown export for notes
- JSON backup for full app data

---

## 16.5 Search

V1:

- search book titles
- search notes

V2:

- full-text search inside a book
- search vocabulary
- search questions

Use SQLite FTS when possible.

---

# 17. MVP Feature Priority Table

| Feature | Priority | Version |
|---|---:|---:|
| Offline local DB | P0 | 0.1 |
| TXT import | P0 | 0.1 |
| EPUB import | P0 | 0.5 |
| Reader | P0 | 0.1 |
| Save position | P0 | 0.1 |
| Library | P0 | 0.5 |
| Highlights | P0 | 0.1 |
| Notes | P0 | 0.1 |
| Questions | P0 | 1.0 |
| Session summary | P0 | 1.0 |
| Flow Mode | P0 | 1.0 |
| Study Mode | P0 | 1.0 |
| Placement test | P0 | 1.0 |
| Book journey | P0 | 1.0 |
| Review center basic | P0 | 1.0 |
| Spaced repetition | P1 | 1.2 |
| Dictionary offline | P1 | 1.1/1.2 |
| PDF import | P1 | 1.5 |
| Audio/TTS | P2 | 2.5 |
| AI Coach | P2 | 3.0 |
| Cloud sync | P3 | 4.0 |

---

# 18. Detailed Epics for AI Agent

## EPIC 01 — App Foundation

### Tasks

- create project
- setup theme
- setup routing
- setup local DB
- setup file storage
- setup error handling

### Acceptance

App opens, navigates between Home/Library/Settings, stores simple test data.

---

## EPIC 02 — Import System

### Tasks

- implement file picker
- copy file locally
- parse TXT
- parse EPUB
- extract metadata
- create Book/Chapter/Chunk records

### Acceptance

User imports a book and sees it in the library.

---

## EPIC 03 — Reader

### Tasks

- render chunk/chapter text
- font settings
- theme settings
- save position
- next/previous chunk
- highlight selected text
- add note to selection

### Acceptance

User can read comfortably and continue later.

---

## EPIC 04 — Reading Session

### Tasks

- start session
- timer
- track words/chunks
- pause/end session
- session summary prompt
- comprehension rating

### Acceptance

Session saved and visible in progress.

---

## EPIC 05 — Notes & Questions

### Tasks

- create note
- edit note
- delete note
- create question
- tag notes
- link note to book/chunk
- show notes list

### Acceptance

User has a personal commonplace system.

---

## EPIC 06 — Vocabulary

### Tasks

- mark word
- save context sentence
- add manual meaning
- list marked words
- review words manually

### Acceptance

User can collect words from reading and revisit them.

---

## EPIC 07 — Review Center

### Tasks

- create review items from notes/words/questions
- due queue
- Again/Hard/Good/Easy
- update nextReviewAt
- show daily reviews

### Acceptance

User can review learning items offline.

---

## EPIC 08 — Progress Dashboard

### Tasks

- reading minutes
- sessions
- books in progress
- notes count
- words count
- comprehension trend
- lookup rate (where available)

### Acceptance

Home shows meaningful progress without pressure.

---

## EPIC 09 — Placement

### Tasks

- self-rating screen
- vocab questions
- short passage questions
- scoring
- create LanguageProfile
- suggest settings

### Acceptance

New user gets a starting level and plan.

---

## EPIC 10 — Design Polish

### Tasks

- logo integration
- colors
- typography
- animations
- empty states
- onboarding illustrations
- dark/sepia modes

### Acceptance

App feels modern, calm, attractive, and clearly about reading/language learning.

---

# 19. UX Copy Examples

## Welcome

> Welcome to Knosis.  
> Learn languages by reading deeply, returning often, and understanding more each time.

## Flow Mode Reminder

> Don't stop at every word. Keep the meaning alive.

## Too Many Lookups

> You've looked up many words in a short time. Try reading the next paragraph for the general idea first.

## Session End

> What stayed with you?

## Review

> Before looking, what do you remember?

## Long Book Encouragement

> One session at a time. The book is a journey, not a number.

---

# 20. Empty States

## Empty Library

Text:

> Your library is waiting. Import a book or start with a short text.

CTA:

- Import Book
- Try Sample Text

## No Reviews

> Nothing due today. You can read more or revisit an old note.

## No Notes

> Capture ideas, questions, and quotes while reading.

---

# 21. Privacy & Trust

Knosis should clearly say:

- your books stay on your device
- your notes stay private
- no account needed
- no tracking by default
- AI online is optional
- exports available anytime

For AI online later:

- show a warning:
  > "This passage will be sent to an AI service only if you continue."

---

# 22. Accessibility

Required:

- scalable text
- high contrast mode
- dark mode
- sepia mode
- dyslexia-friendly font option
- reduce motion
- screen reader labels
- large tap targets
- offline use

---

# 23. Risks & Solutions

## Risk 1: User Overuses Dictionary

### Solution

- lookup limit
- gentle warnings
- Flow Mode as default
- mark for later

## Risk 2: PDF Complexity

### Solution

- EPUB first
- PDF beta later
- clear import warnings

## Risk 3: App Becomes Too Complicated

### Solution

- 3 main actions:
  - Continue Reading
  - Review
  - Add Note
- advanced features hidden

## Risk 4: User Feels Guilty

### Solution

- no aggressive streaks
- progress by sessions, ideas, returns
- encouraging copy

## Risk 5: AI Kills Learning

### Solution

- AI asks before explaining
- user guesses first
- short answers
- no AI interruptions during Flow Mode

---

# 24. Definition of Done

Any feature is done only if:

- works offline
- persists after app restart
- has an empty state
- has an error state
- has basic tests where possible
- respects the current theme
- does not break reader flow
- handles large books reasonably
- has accessible buttons/labels

---

# 25. First Build Plan

## Milestone 1

- Flutter app
- theme
- navigation
- SQLite
- TXT import
- simple reader

## Milestone 2

- EPUB import
- library
- chapters/chunks
- save reading position

## Milestone 3

- highlights
- notes
- questions
- session summary

## Milestone 4

- onboarding
- placement test
- language profile
- reading recommendations

## Milestone 5

- vocabulary marking
- review center
- simple spaced repetition

## Milestone 6

- design polish
- export notes
- performance cleanup
- MVP release

---

# 26. What Knosis Should NOT Be

Knosis should not become:

- a social media app
- a childish gamified app
- a generic PDF reader
- a pure flashcard app
- an AI chatbot with reading attached
- an app that rewards finishing without understanding
- an app that forces the user to analyze every sentence

Core identity:

> **A calm offline reading companion that teaches you how to understand deeply.**

---

# 27. Final MVP Statement

**Knosis v1.0** is successful if a user can:

1. choose a language
2. get a level estimate
3. import a book
4. read it in distraction-free mode
5. avoid the word-by-word trap
6. mark important words/passages
7. write notes/questions
8. finish sessions with summaries
9. review what matters later
10. feel progress without fear of big books

---

# 28. Logo Design Specification

## 28.1 Logo Concept

**A minimal geometric "K" formed entirely from a book architecture — spine + two folded pages.**

### The Symbol

The Knosis logo is an abstract representation of:

- **Open book** → knowledge
- **Letter K** → brand identity
- **Path/road** → the learning journey through pages
- **Mountain** → 3 folded pages forming an ascending shape

### Construction

The mark is built from **3 simple elements**:

1. **Vertical spine** — the tall vertical line of the K
2. **Upper page stroke** — the upper diagonal arm of the K
3. **Lower page stroke** — the lower diagonal arm of the K

Together, they suggest:

- an open book viewed from above
- a folded paper crane
- a mountain made of pages

### Key Design Rules

- the whole mark must fit inside a **simple geometric square**
- rounded line caps (2–3px radius)
- balanced stroke weight: the spine is slightly thicker than the arms
- no decorative details
- negative space should be clean
- works at 16px and at 512px
- one single color per usage

---

## 28.2 Detailed Visual Description

### The Mark

Imagine this:

- a **single vertical line** at the left — the spine, slightly taller than the rest
- from the top-right of the spine, a **diagonal stroke** goes up and to the right — the upper page
- from the same area, a **second diagonal stroke** starts lower and drops down to the right — the lower page
- the two strokes do not touch the spine at the exact same point; there is a tiny gap for elegance
- at the hinge where the two strokes meet the spine, there is a **subtle open-book angle**

Between the two diagonal strokes, a **small dot** sits in the negative space:

- represents a light/word/idea being born
- 3–4px in diameter
- aligned centrally

Total mark dimensions: approx. **40 × 40 units**
Stroke widths: spine = 6 units, arms = 4.5 units
Corner radius: rounded caps everywhere

---

## 28.3 Clear Space

- minimum space around the logo = height of the vertical spine × 1.5
- never place text closer than X units

---

## 28.4 Sizes & Safe Zone

| Usage | Size |
|---|---|
| App icon | 1024 × 1024 px |
| Splash screen | centered, 120–160 px |
| Top bar | 24–32 px |
| Small favicon | 16 × 16 px |

---

## 28.5 Color Variants

### Variant 1 — Original

- Spine + arms: `#2F8C87` (teal)
- Dot: `#D6A94A` (gold)

### Variant 2 — Monochrome Dark

- all strokes: `#18202F` (ink navy)

### Variant 3 — Monochrome Light

- all strokes: `#FAF7F0` (paper cream)

### Variant 4 — Reversed Glass (for dark backgrounds)

- strokes: `#E5E7EB`

---

## 28.6 Wordmark

### "Knosis" Text Treatment

- font: **Manrope** SemiBold
- lowercase "knosis"
- letter-spacing: 0.5px
- size in app bar: 20–24px
- color: same ink navy `#18202F`
- dark theme: `#E5E7EB`
- optional thin accent on the "K": teal serif flourish

### Full Lockup

```text
[icon]  k n o s i s
        from words to worlds
```

---

## 28.7 App Icon Design (Final Recommendation)

Background:

- deep navy to teal vertical gradient
- egde: very subtle rounded square (iOS) / adaptive squircle

Foreground (centered):

- the white/cream "K" mark
- the dot becomes gold accent

Scale:

- icon fills about 62% of the canvas
- clear space all around

Result:

- feels like a **premium digital library** at a glance
- communicates: reading, learning, elegance, calm intelligence
- instantly recognizable in a home screen grid

---

## 28.8 Logo Usage Do's & Don'ts

### Do:

- use on solid backgrounds (paper, navy, dark slate)
- use the monochrome version when color printing is limited
- position the wordmark next to the mark with generous breathing room
- use the gold dot only in the main color version

### Don't:

- stretch or squish the mark
- rotate the mark
- change the angle of the strokes
- add shadows to the mark
- put it on a busy texture/photo
- use multiple colors beyond teal/gold/ink
- add AI glows or gradients to the strokes
- animate the mark except for a soft page-turn flip

---

# 29. Next Steps

1. **Create AGENTS.md** — the "contract" for the AI Agent:
   - tech stack rules
   - coding standards
   - directory structure
   - execution plan by milestone
   - testing requirements
   - definition of done per task
   - communication rules
2. **Create ARCHITECTURE.md** — for the AI to follow when structuring the project
3. **Create PRD split** — break the PDF into task-readable packages (each epic → tasks → acceptance criteria)
4. **Choose platform milestone** — start with Milestone 1: Flutter + SQLite + basic reader
5. **Build design tokens** — create the actual `theme.dart` from the palette above
6. **Generate assets** — logo icons, splash, app icon from the spec above

---

# 30. Platform Scope — Android Only

Knosis is an Android-exclusive application.

Unless the product owner explicitly changes this scope in the future, the project must NOT spend engineering time, abstractions, dependencies, testing effort, or design compromises on:

- iOS
- Web
- Windows
- macOS
- Linux

Flutter remains the selected framework, but it is being used specifically to build a high-quality Android application.

Android must be treated as the product's native environment rather than as one target among several.

## 30.1 Android Experience

Knosis should feel natural to Android users.

The application should properly support:

- Android predictive back where supported
- system back gesture
- edge-to-edge layouts
- Android share/open-with flows
- Android document/file picker
- system dark mode
- adaptive app icon
- dynamic text scaling
- keyboard/inset handling
- Android accessibility services
- Android lifecycle behaviour
- process death and state restoration where reasonable

Navigation must never fight Android's back behaviour.

## 30.2 Gestures

Gestures should make reading more fluid without becoming hidden requirements.

Potential reader gestures include:

- horizontal swipe for previous/next reading unit when appropriate
- tap center to show/hide reader controls
- text long-press for selection
- natural selection handles
- swipe/down or back gesture to dismiss transient surfaces
- pinch or explicit controls for text sizing only if UX testing justifies it

Important actions must remain discoverable through visible UI. A user must not be required to know an undocumented gesture to use a core feature.

Gestures must not conflict with:

- Android system back gesture
- text selection
- accessibility navigation
- scrolling

## 30.3 Performance Philosophy

Knosis must feel lightweight.

Optimize for:

- fast cold start
- smooth reading and scrolling
- responsive navigation
- low idle CPU usage
- reasonable memory consumption
- reasonable APK/app bundle size
- efficient local storage
- minimal background work
- large-book handling without loading entire books into memory

Avoid dependencies for functionality that can be implemented cleanly with the existing stack.

Do not add libraries merely for convenience without considering:

- package size
- maintenance quality
- transitive dependencies
- performance
- Android compatibility

## 30.4 UI/UX Performance

Visual polish must not come at the expense of responsiveness.

Prefer:

- short subtle transitions
- 60fps+ interaction where hardware permits
- simple compositing
- lazy rendering
- restrained shadows and blur
- predictable navigation
- immediate feedback after taps

Avoid:

- excessive blur
- unnecessary gradients everywhere
- heavy particle effects
- decorative continuous animations
- oversized image assets
- animation that delays interaction

Knosis should feel calm because its interface is clear, not because it is slow.

## 30.5 Reader Performance

Books may contain thousands of pages.

The implementation must therefore:

- parse/import books without blocking the UI thread
- avoid keeping the entire rendered book in memory
- persist stable reading positions
- load text incrementally
- paginate/chunk efficiently
- keep annotations stable across sessions
- test with unusually large EPUB/TXT files

Book length must not materially degrade normal reader navigation.

## 30.6 Release Target

Primary distribution target:

- Android App Bundle (`.aab`) for release
- APK artifacts may be produced for development/testing

Minimum and target Android SDK versions must be selected deliberately during project initialization and documented.

The architecture should remain Android-specific unless the product owner explicitly requests expansion to another platform.
