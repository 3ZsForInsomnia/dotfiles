# AGENTS

<skills_system priority="1">

## Available Skills

<!-- SKILLS_TABLE_START -->
<usage>
When users ask you to perform tasks, check if any of the available skills below can help complete the task more effectively. Skills provide specialized capabilities and domain knowledge.

How to use skills:
- Invoke: `npx openskills read <skill-name>` (run in your shell)
  - For multiple: `npx openskills read skill-one,skill-two`
- The skill content will load with detailed instructions on how to complete the task
- Base directory provided in output for resolving bundled resources (references/, scripts/, assets/)

Usage notes:
- Only use skills listed in <available_skills> below
- Do not invoke a skill that is already loaded in your context
- Each skill invocation is stateless
</usage>

<available_skills>

<skill>
<name>agent-md-refactor</name>
<description>Refactor bloated AGENTS.md, CLAUDE.md, or similar agent instruction files to follow progressive disclosure principles. Splits monolithic files into organized, linked documentation.</description>
<location>global</location>
</skill>

<skill>
<name>algorithmic-art</name>
<description>Creating algorithmic art using p5.js with seeded randomness and interactive parameter exploration. Use this when users request creating art using code, generative art, algorithmic art, flow fields, or particle systems. Create original algorithmic art rather than copying existing artists' work to avoid copyright violations.</description>
<location>global</location>
</skill>

<skill>
<name>atlassian-cli</name>
<description>Use the Atlassian CLI (acli) to interact with Jira and Confluence from the command line. View, create, update, and transition Jira issues, search with JQL, and manage Confluence pages. Use when working with Jira tickets, updating issue status, or automating Atlassian workflows.</description>
<location>global</location>
</skill>

<skill>
<name>backend-to-frontend-handoff-docs</name>
<description>Create API handoff documentation for frontend developers. Use when backend work is complete and needs to be documented for frontend integration, or user says 'create handoff', 'document API', 'frontend handoff', or 'API documentation'.</description>
<location>global</location>
</skill>

<skill>
<name>brand-guidelines</name>
<description>Applies Anthropic's official brand colors and typography to any sort of artifact that may benefit from having Anthropic's look-and-feel. Use it when brand colors or style guidelines, visual formatting, or company design standards apply.</description>
<location>global</location>
</skill>

<skill>
<name>c4-architecture</name>
<description>Generate architecture documentation using C4 model Mermaid diagrams. Use when asked to create architecture diagrams, document system architecture, visualize software structure, create C4 diagrams, or generate context/container/component/deployment diagrams. Triggers include "architecture diagram", "C4 diagram", "system context", "container diagram", "component diagram", "deployment diagram", "document architecture", "visualize architecture".</description>
<location>global</location>
</skill>

<skill>
<name>canvas-design</name>
<description>Create beautiful visual art in .png and .pdf documents using design philosophy. You should use this skill when the user asks to create a poster, piece of art, design, or other static piece. Create original visual designs, never copying existing artists' work to avoid copyright violations.</description>
<location>global</location>
</skill>

<skill>
<name>capture-tasks-from-meeting-notes</name>
<description>"Analyze meeting notes to find action items and create Jira tasks for assigned work. When an agent needs to: (1) Create Jira tasks or tickets from meeting notes, (2) Extract or find action items from notes or Confluence pages, (3) Parse meeting notes for assigned tasks, or (4) Analyze notes and generate tasks for team members. Identifies assignees, looks up account IDs, and creates tasks with proper context."</description>
<location>global</location>
</skill>

<skill>
<name>claude-api</name>
<description>"Build apps with the Claude API or Anthropic SDK. TRIGGER when: code imports `anthropic`/`@anthropic-ai/sdk`/`claude_agent_sdk`, or user asks to use Claude API, Anthropic SDKs, or Agent SDK. DO NOT TRIGGER when: code imports `openai`/other AI SDK, general programming, or ML/data-science tasks."</description>
<location>global</location>
</skill>

<skill>
<name>codex</name>
<description>Use when the user asks to run Codex CLI (codex exec, codex resume) or references OpenAI Codex for code analysis, refactoring, or automated editing. Uses GPT-5.2 by default for state-of-the-art software engineering.</description>
<location>global</location>
</skill>

<skill>
<name>command-creator</name>
<description>This skill should be used when creating a Claude Code slash command. Use when users ask to "create a command", "make a slash command", "add a command", or want to document a workflow as a reusable command. Essential for creating optimized, agent-executable slash commands with proper structure and best practices.</description>
<location>global</location>
</skill>

<skill>
<name>commit-work</name>
<description>"Create high-quality git commits: review/stage intended changes, split into logical commits, and write clear commit messages (including Conventional Commits). Use when the user asks to commit, craft a commit message, stage changes, or split work into multiple commits."</description>
<location>global</location>
</skill>

<skill>
<name>crafting-effective-readmes</name>
<description>Use when writing or improving README files. Not all READMEs are the same — provides templates and guidance matched to your audience and project type.</description>
<location>global</location>
</skill>

<skill>
<name>daily-meeting-update</name>
<description>"Interactive daily standup/meeting update generator. Use when user says 'daily', 'standup', 'scrum update', 'status update', 'what did I do yesterday', 'prepare for meeting', 'morning update', or 'team sync'. Pulls activity from GitHub, Jira, and Claude Code session history. Conducts 4-question interview (yesterday, today, blockers, discussion topics) and generates formatted Markdown update."</description>
<location>global</location>
</skill>

<skill>
<name>database-schema-designer</name>
<description>Design robust, scalable database schemas for SQL and NoSQL databases. Provides normalization guidelines, indexing strategies, migration patterns, constraint design, and performance optimization. Ensures data integrity, query performance, and maintainable data models.</description>
<location>global</location>
</skill>

<skill>
<name>datadog-cli</name>
<description>Datadog CLI for searching logs, querying metrics, tracing requests, and managing dashboards. Use this when debugging production issues or working with Datadog observability.</description>
<location>global</location>
</skill>

<skill>
<name>dependency-updater</name>
<description>Smart dependency management for any language. Auto-detects project type, applies safe updates automatically, prompts for major versions, diagnoses and fixes dependency issues.</description>
<location>global</location>
</skill>

<skill>
<name>deployment-check</name>
<description>Check whether a merged PR or commit has been deployed to a specific environment (e.g., prod, UAT, QAT). Use when you need to verify if a feature, fix, or change has reached a target environment. Accepts a PR number, commit SHA, or a natural language description of the change.</description>
<location>global</location>
</skill>

<skill>
<name>design-system-starter</name>
<description>Create and evolve design systems with design tokens, component architecture, accessibility guidelines, and documentation templates. Ensures consistent, scalable, and accessible UI across products.</description>
<location>global</location>
</skill>

<skill>
<name>difficult-workplace-conversations</name>
<description>Structured approach to workplace conflicts, performance discussions, and challenging feedback using preparation-delivery-followup framework. Use when preparing for tough conversations, addressing conflicts, giving critical feedback, or navigating sensitive workplace discussions.</description>
<location>global</location>
</skill>

<skill>
<name>doc-coauthoring</name>
<description>Guide users through a structured workflow for co-authoring documentation. Use when user wants to write documentation, proposals, technical specs, decision docs, or similar structured content. This workflow helps users efficiently transfer context, refine content through iteration, and verify the doc works for readers. Trigger when user mentions writing docs, creating proposals, drafting specs, or similar documentation tasks.</description>
<location>global</location>
</skill>

<skill>
<name>docx</name>
<description>"Use this skill whenever the user wants to create, read, edit, or manipulate Word documents (.docx files). Triggers include: any mention of 'Word doc', 'word document', '.docx', or requests to produce professional documents with formatting like tables of contents, headings, page numbers, or letterheads. Also use when extracting or reorganizing content from .docx files, inserting or replacing images in documents, performing find-and-replace in Word files, working with tracked changes or comments, or converting content into a polished Word document. If the user asks for a 'report', 'memo', 'letter', 'template', or similar deliverable as a Word or .docx file, use this skill. Do NOT use for PDFs, spreadsheets, Google Docs, or general coding tasks unrelated to document generation."</description>
<location>global</location>
</skill>

<skill>
<name>domain-name-brainstormer</name>
<description>Generates creative domain name ideas for your project and checks availability across multiple TLDs (.com, .io, .dev, .ai, etc.). Saves hours of brainstorming and manual checking.</description>
<location>global</location>
</skill>

<skill>
<name>draw-io</name>
<description>draw.io diagram creation, editing, and review. Use for .drawio XML editing, PNG conversion, layout adjustment, and AWS icon usage.</description>
<location>global</location>
</skill>

<skill>
<name>excalidraw</name>
<description>"Use when working with *.excalidraw or *.excalidraw.json files, user mentions diagrams/flowcharts, or requests architecture visualization - delegates all Excalidraw operations to subagents to prevent context exhaustion from verbose JSON (single files: 4k-22k tokens, can exceed read limits)"</description>
<location>global</location>
</skill>

<skill>
<name>feedback-mastery</name>
<description>Navigate difficult conversations and deliver constructive feedback using structured frameworks. Covers the Preparation-Delivery-Follow-up model and Situation-Behavior-Impact (SBI) feedback technique. Use when preparing for difficult conversations, giving feedback, or managing conflicts.</description>
<location>global</location>
</skill>

<skill>
<name>frontend-design</name>
<description>Create distinctive, production-grade frontend interfaces with high design quality. Use this skill when the user asks to build web components, pages, artifacts, posters, or applications (examples include websites, landing pages, dashboards, React components, HTML/CSS layouts, or when styling/beautifying any web UI). Generates creative, polished code and UI design that avoids generic AI aesthetics.</description>
<location>global</location>
</skill>

<skill>
<name>frontend-to-backend-requirements</name>
<description>Document frontend data needs for backend developers. Use when frontend needs to communicate API requirements to backend, or user says 'backend requirements', 'what data do I need', 'API requirements', or is describing data needs for a UI.</description>
<location>global</location>
</skill>

<skill>
<name>game-changing-features</name>
<description>Find 10x product opportunities and high-leverage improvements. Use when user wants strategic product thinking, mentions '10x', wants to find high-impact features, or says 'what would make this 10x better', 'product strategy', or 'what should we build next'.</description>
<location>global</location>
</skill>

<skill>
<name>gemini</name>
<description>Use when the user asks to run Gemini CLI for code review, plan review, or big context (>200k) processing. Ideal for comprehensive analysis requiring large context windows. Uses Gemini 3 Pro by default for state-of-the-art reasoning and coding.</description>
<location>global</location>
</skill>

<skill>
<name>generate-status-report</name>
<description>"Generate project status reports from Jira issues and publish to Confluence. When an agent needs to: (1) Create a status report for a project, (2) Summarize project progress or updates, (3) Generate weekly/daily reports from Jira, (4) Publish status summaries to Confluence, or (5) Analyze project blockers and completion. Queries Jira issues, categorizes by status/priority, and creates formatted reports for delivery managers and executives."</description>
<location>global</location>
</skill>

<skill>
<name>gepetto</name>
<description>Creates detailed, sectionized implementation plans through research, stakeholder interviews, and multi-LLM review. Use when planning features that need thorough pre-implementation analysis.</description>
<location>global</location>
</skill>

<skill>
<name>gh-commit-and-pr</name>
<description>Automate the git workflow of creating a branch, committing with conventional commits, pushing to origin, and opening a GitHub pull request. Use when code changes are ready for review or when following the team's standard git workflow.</description>
<location>global</location>
</skill>

<skill>
<name>humanizer</name>
<description>|</description>
<location>global</location>
</skill>

<skill>
<name>internal-comms</name>
<description>A set of resources to help me write all kinds of internal communications, using the formats that my company likes to use. Claude should use this skill whenever asked to write some sort of internal communications (status reports, leadership updates, 3P updates, company newsletters, FAQs, incident reports, project updates, etc.).</description>
<location>global</location>
</skill>

<skill>
<name>jira</name>
<description>Use when the user mentions Jira issues (e.g., "PROJ-123"), asks about tickets, wants to create/view/update issues, check sprint status, or manage their Jira workflow. Triggers on keywords like "jira", "issue", "ticket", "sprint", "backlog", or issue key patterns.</description>
<location>global</location>
</skill>

<skill>
<name>lesson-learned</name>
<description>"Analyze recent code changes via git history and extract software engineering lessons. Use when the user asks 'what is the lesson here?', 'what can I learn from this?', 'engineering takeaway', 'what did I just learn?', 'reflect on this code', or wants to extract principles from recent work."</description>
<location>global</location>
</skill>

<skill>
<name>marp-slide</name>
<description>Create professional Marp presentation slides with 7 beautiful themes (default, minimal, colorful, dark, gradient, tech, business). Use when users request slide creation, presentations, or Marp documents. Supports custom themes, image layouts, and "make it look good" requests with automatic quality improvements.</description>
<location>global</location>
</skill>

<skill>
<name>mcp-builder</name>
<description>Guide for creating high-quality MCP (Model Context Protocol) servers that enable LLMs to interact with external services through well-designed tools. Use when building MCP servers to integrate external APIs or services, whether in Python (FastMCP) or Node/TypeScript (MCP SDK).</description>
<location>global</location>
</skill>

<skill>
<name>meme-factory</name>
<description>Generate memes using the memegen.link API. Use when users request memes, want to add humor to content, or need visual aids for social media. Supports 100+ popular templates with custom text and styling.</description>
<location>global</location>
</skill>

<skill>
<name>mermaid-diagrams</name>
<description>Comprehensive guide for creating software diagrams using Mermaid syntax. Use when users need to create, visualize, or document software through diagrams including class diagrams (domain modeling, object-oriented design), sequence diagrams (application flows, API interactions, code execution), flowcharts (processes, algorithms, user journeys), entity relationship diagrams (database schemas), C4 architecture diagrams (system context, containers, components), state diagrams, git graphs, pie charts, gantt charts, or any other diagram type. Triggers include requests to "diagram", "visualize", "model", "map out", "show the flow", or when explaining system architecture, database design, code structure, or user/application flows.</description>
<location>global</location>
</skill>

<skill>
<name>mui</name>
<description>Material-UI v7 component library patterns including sx prop styling, theme integration, responsive design, and MUI-specific hooks. Use when working with MUI components, styling with sx prop, theme customization, or MUI utilities.</description>
<location>global</location>
</skill>

<skill>
<name>naming-analyzer</name>
<description>Suggest better variable, function, and class names based on context and conventions.</description>
<location>global</location>
</skill>

<skill>
<name>openapi-to-typescript</name>
<description>Converts OpenAPI 3.0 JSON/YAML to TypeScript interfaces and type guards. This skill should be used when the user asks to generate types from OpenAPI, convert schema to TS, create API interfaces, or generate TypeScript types from an API specification.</description>
<location>global</location>
</skill>

<skill>
<name>pdf</name>
<description>Use this skill whenever the user wants to do anything with PDF files. This includes reading or extracting text/tables from PDFs, combining or merging multiple PDFs into one, splitting PDFs apart, rotating pages, adding watermarks, creating new PDFs, filling PDF forms, encrypting/decrypting PDFs, extracting images, and OCR on scanned PDFs to make them searchable. If the user mentions a .pdf file or asks to produce one, use this skill.</description>
<location>global</location>
</skill>

<skill>
<name>perplexity</name>
<description>Web search and research using Perplexity AI. Use when user says "search", "find", "look up", "ask", "research", or "what's the latest" for generic queries. NOT for library/framework docs (use Context7) or workspace questions.</description>
<location>global</location>
</skill>

<skill>
<name>plugin-forge</name>
<description>Create and manage Claude Code plugins with proper structure, manifests, and marketplace integration. Use when creating plugins for a marketplace, adding plugin components (commands, agents, hooks), bumping plugin versions, or working with plugin.json/marketplace.json manifests.</description>
<location>global</location>
</skill>

<skill>
<name>pptx</name>
<description>"Use this skill any time a .pptx file is involved in any way — as input, output, or both. This includes: creating slide decks, pitch decks, or presentations; reading, parsing, or extracting text from any .pptx file (even if the extracted content will be used elsewhere, like in an email or summary); editing, modifying, or updating existing presentations; combining or splitting slide files; working with templates, layouts, speaker notes, or comments. Trigger whenever the user mentions \"deck,\" \"slides,\" \"presentation,\" or references a .pptx filename, regardless of what they plan to do with the content afterward. If a .pptx file needs to be opened, created, or touched, use this skill."</description>
<location>global</location>
</skill>

<skill>
<name>professional-communication</name>
<description>Guide technical communication for software developers. Covers email structure, team messaging etiquette, meeting agendas, and adapting messages for technical vs non-technical audiences. Use when drafting professional messages, preparing meeting communications, or improving written communication.</description>
<location>global</location>
</skill>

<skill>
<name>qa-test-planner</name>
<description>Generate comprehensive test plans, manual test cases, regression test suites, and bug reports for QA engineers. Includes Figma MCP integration for design validation.</description>
<location>global</location>
</skill>

<skill>
<name>react-dev</name>
<description>This skill should be used when building React components with TypeScript, typing hooks, handling events, or when React TypeScript, React 19, Server Components are mentioned. Covers type-safe patterns for React 18-19 including generic components, proper event typing, and routing integration (TanStack Router, React Router).</description>
<location>global</location>
</skill>

<skill>
<name>react-useeffect</name>
<description>React useEffect best practices from official docs. Use when writing/reviewing useEffect, useState for derived values, data fetching, or state synchronization. Teaches when NOT to use Effect and better alternatives.</description>
<location>global</location>
</skill>

<skill>
<name>reducing-entropy</name>
<description>Manual-only skill for minimizing total codebase size. Only activate when explicitly requested by user. Measures success by final code amount, not effort. Bias toward deletion.</description>
<location>global</location>
</skill>

<skill>
<name>requirements-clarity</name>
<description>Clarify ambiguous requirements through focused dialogue before implementation. Use when requirements are unclear, features are complex (>2 days), or involve cross-team coordination. Ask two core questions - Why? (YAGNI check) and Simpler? (KISS check) - to ensure clarity before coding.</description>
<location>global</location>
</skill>

<skill>
<name>search-company-knowledge</name>
<description>"Search across company knowledge bases (Confluence, Jira, internal docs) to find and explain internal concepts, processes, and technical details. When an agent needs to: (1) Find or search for information about systems, terminology, processes, deployment, authentication, infrastructure, architecture, or technical concepts, (2) Search internal documentation, knowledge base, company docs, or our docs, (3) Explain what something is, how it works, or look up information, or (4) Synthesize information from multiple sources. Searches in parallel and provides cited answers."</description>
<location>global</location>
</skill>

<skill>
<name>session-handoff</name>
<description>"Creates comprehensive handoff documents for seamless AI agent session transfers. Triggered when: (1) user requests handoff/memory/context save, (2) context window approaches capacity, (3) major task milestone completed, (4) work session ending, (5) user says 'save state', 'create handoff', 'I need to pause', 'context is getting full', (6) resuming work with 'load handoff', 'resume from', 'continue where we left off'. Proactively suggests handoffs after substantial work (multiple file edits, complex debugging, architecture decisions). Solves long-running agent context exhaustion by enabling fresh agents to continue with zero ambiguity."</description>
<location>global</location>
</skill>

<skill>
<name>ship-learn-next</name>
<description>Transform learning content (like YouTube transcripts, articles, tutorials) into actionable implementation plans using the Ship-Learn-Next framework. Use when user wants to turn advice, lessons, or educational content into concrete action steps, reps, or a learning quest.</description>
<location>global</location>
</skill>

<skill>
<name>skill-creator</name>
<description>Create new skills, modify and improve existing skills, and measure skill performance. Use when users want to create a skill from scratch, edit, or optimize an existing skill, run evals to test a skill, benchmark skill performance with variance analysis, or optimize a skill's description for better triggering accuracy.</description>
<location>global</location>
</skill>

<skill>
<name>skill-judge</name>
<description>Evaluate Agent Skill design quality against official specifications and best practices. Use when reviewing, auditing, or improving SKILL.md files and skill packages. Provides multi-dimensional scoring and actionable improvement suggestions.</description>
<location>global</location>
</skill>

<skill>
<name>slack-gif-creator</name>
<description>Knowledge and utilities for creating animated GIFs optimized for Slack. Provides constraints, validation tools, and animation concepts. Use when users request animated GIFs for Slack like "make me a GIF of X doing Y for Slack."</description>
<location>global</location>
</skill>

<skill>
<name>spec-to-backlog</name>
<description>"Automatically convert Confluence specification documents into structured Jira backlogs with Epics and implementation tickets. When an agent needs to: (1) Create Jira tickets from a Confluence page, (2) Generate a backlog from a specification, (3) Break down a spec into implementation tasks, or (4) Convert requirements into Jira issues. Handles reading Confluence pages, analyzing specifications, creating Epics with proper structure, and generating detailed implementation tickets linked to the Epic."</description>
<location>global</location>
</skill>

<skill>
<name>supabase-postgres-best-practices</name>
<description>Postgres performance optimization and best practices from Supabase. Use this skill when writing, reviewing, or optimizing Postgres queries, schema designs, or database configurations.</description>
<location>global</location>
</skill>

<skill>
<name>template</name>
<description>Replace with description of the skill and when Claude should use it.</description>
<location>global</location>
</skill>

<skill>
<name>theme-factory</name>
<description>Toolkit for styling artifacts with a theme. These artifacts can be slides, docs, reportings, HTML landing pages, etc. There are 10 pre-set themes with colors/fonts that you can apply to any artifact that has been creating, or can generate a new theme on-the-fly.</description>
<location>global</location>
</skill>

<skill>
<name>triage-issue</name>
<description>"Intelligently triage bug reports and error messages by searching for duplicates in Jira and offering to create new issues or add comments to existing ones. When an agent needs to: (1) Triage a bug report or error message, (2) Check if an issue is a duplicate, (3) Find similar past issues, (4) Create a new bug ticket with proper context, or (5) Add information to an existing ticket. Searches Jira for similar issues, identifies duplicates, checks fix history, and helps create well-structured bug reports."</description>
<location>global</location>
</skill>

<skill>
<name>web-artifacts-builder</name>
<description>Suite of tools for creating elaborate, multi-component claude.ai HTML artifacts using modern frontend web technologies (React, Tailwind CSS, shadcn/ui). Use for complex artifacts requiring state management, routing, or shadcn/ui components - not for simple single-file HTML/JSX artifacts.</description>
<location>global</location>
</skill>

<skill>
<name>web-to-markdown</name>
<description>"Use ONLY when the user explicitly says: 'use the skill web-to-markdown ...' (or 'use a skill web-to-markdown ...'). Converts webpage URLs to clean Markdown by calling the local web2md CLI (Puppeteer + Readability), suitable for JS-rendered pages."</description>
<location>global</location>
</skill>

<skill>
<name>webapp-testing</name>
<description>Toolkit for interacting with and testing local web applications using Playwright. Supports verifying frontend functionality, debugging UI behavior, capturing browser screenshots, and viewing browser logs.</description>
<location>global</location>
</skill>

<skill>
<name>writing-clearly-and-concisely</name>
<description>Use when writing prose humans will read—documentation, commit messages, error messages, explanations, reports, or UI text. Applies Strunk's timeless rules for clearer, stronger, more professional writing.</description>
<location>global</location>
</skill>

<skill>
<name>xlsx</name>
<description>"Use this skill any time a spreadsheet file is the primary input or output. This means any task where the user wants to: open, read, edit, or fix an existing .xlsx, .xlsm, .csv, or .tsv file (e.g., adding columns, computing formulas, formatting, charting, cleaning messy data); create a new spreadsheet from scratch or from other data sources; or convert between tabular file formats. Trigger especially when the user references a spreadsheet file by name or path — even casually (like \"the xlsx in my downloads\") — and wants something done to it or produced from it. Also trigger for cleaning or restructuring messy tabular data files (malformed rows, misplaced headers, junk data) into proper spreadsheets. The deliverable must be a spreadsheet file. Do NOT trigger when the primary deliverable is a Word document, HTML report, standalone Python script, database pipeline, or Google Sheets API integration, even if tabular data is involved."</description>
<location>global</location>
</skill>

</available_skills>
<!-- SKILLS_TABLE_END -->

</skills_system>
