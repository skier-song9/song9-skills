---
name: notion-paper-page-authoring
description: Update an existing Notion page with structured notes from an arXiv paper while preserving workspace-specific page rules. Use when Codex is asked to organize a paper into Notion from an arXiv URL and a Notion page URL, especially for requests such as "논문 정리해서 노션에 작성", "CRAG 논문 노션에 정리", "attention is all you need 논문 노션 정리", or "https://arxiv.org/abs/... 논문 노션 정리".
---

# Notion Paper Page Authoring

## Overview

Use this skill to read an arXiv paper, extract paper content from its HTML page, and fill an existing Notion page without changing the page title or rewriting unrelated content. Treat `notion-mcp-page-authoring` as the base skill for all Notion formatting and editing rules, then layer paper-specific summarization rules on top.

## Required Inputs

Require both inputs before doing any paper work:
- arXiv URL
- Notion page URL

If either input is missing, ask for it directly and stop. Do not guess the Notion target page. Do not proceed with only a paper title.

## Required References

Read `../notion-mcp-page-authoring/SKILL.md` before editing the Notion page.
Read `references/paper-summary-rules.md` before summarizing the paper.

If the task will create or update page body content:
- read `../notion-mcp-page-authoring/references/notion-page-rules.md`
- fetch `notion://docs/enhanced-markdown-spec`

Treat the base Notion skill and its rules as the source of truth for page formatting, page structure conventions, heading emoji rules, allowed blocks, and editing safety.
Use skill-relative paths for bundled resources and sibling skills. Do not embed user-specific absolute filesystem paths unless a tool explicitly requires them.

## Workflow

1. Confirm the user provided both the arXiv URL and the Notion page URL.
2. Normalize the arXiv source.
3. Fetch the existing Notion page and understand its structure, sections, and table of contents.
4. Read the paper content from arXiv HTML.
5. Read `references/paper-summary-rules.md`.
6. Fill only missing or empty paper-summary sections in the existing page.
7. Preserve the title and all unrelated existing content.
8. Remove any temporary files or directories created during the skill run before finishing.

## Normalize The arXiv Source

Prefer an arXiv HTML URL.

If the user gives an arXiv `abs` URL:
- use web search to find the corresponding arXiv HTML page
- prefer the official `arxiv.org/html/...` result

If the user gives a non-arXiv paper URL:
- use web search only if it is necessary to find the official arXiv HTML page
- otherwise ask the user for the arXiv URL instead of guessing across multiple papers

If no arXiv HTML page exists or the HTML page lacks enough body content:
- continue with abstract-only output
- clearly limit the summary to what was available from the source

## Read The Paper HTML

Create a dedicated temporary directory, for example with `mktemp -d`, before downloading the paper HTML.
Download the arXiv HTML into that temporary directory with `wget`.
If `wget` fails, retry with `curl`.
Read the downloaded HTML file locally instead of relying on partial browser snippets when possible.
After the summary is written or the task aborts, remove every temporary file and the temporary directory created during this step.

Use web search only when needed for:
- finding the HTML URL from an `abs` URL
- clarifying paper metadata
- filling gaps that materially affect the summary

Do not use web search to invent claims that are not supported by the paper.

## Edit The Existing Notion Page

Always update an existing page. Never create a new Notion page for this skill.
Never update the page title.

Fetch the current page first and inspect:
- whether the page is empty
- which sections already exist
- which sections are still blank or incomplete

If the target URL points to a database instead of a page, fail and tell the user that this skill requires a page URL.

If the page is effectively empty:
- add the full paper-summary structure according to `references/paper-summary-rules.md`

If the page already contains some sections:
- add content only to empty sections
- avoid overwriting sections that already contain substantive content unless the user explicitly asks for refresh or replacement

Prefer `notion-update-page` with targeted `update_content` operations.
Use broader replacement only if the page is empty or the user explicitly wants a full rewrite.

## Writing Rules

Write the paper summary in Korean.
Write as if the researcher is describing the work, not as if teaching or speaking to a reader.
Follow the base Notion heading and block rules exactly.
Preserve technical terms in English when needed.
Use diagrams, Mermaid, or pseudocode only when that representation is present in the paper body or appendix and can be reconstructed faithfully.

## Guardrails

Do not invent experimental settings, performance gains, related-work details, or conclusions that are not supported by the paper.
Do not silently rewrite nearby sections to make the page more uniform.
Do not delete child pages, child databases, or unrelated blocks.
If a section exists but its emptiness is ambiguous, ask before overwriting it.
If only the abstract is available, limit the output to abstract-based content instead of fabricating the remaining sections.
Do not leave downloaded paper files, extracted artifacts, or other temporary files behind after the skill finishes.
