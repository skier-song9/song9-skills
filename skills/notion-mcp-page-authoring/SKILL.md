---
name: notion-mcp-page-authoring
description: Create and update Notion pages via Notion MCP while applying workspace-specific authoring rules. Use when a user asks to add a new Notion page, edit an existing Notion page, or follow custom Notion conventions such as page structure, heading emojis, tone, block types, or section formatting with `notion-create-pages` or `notion-update-page`.
---

# Notion MCP Page Authoring

## Overview

Use this skill when working on Notion page content through Notion MCP and the workspace has custom formatting or writing rules. Read the local rules document first, then apply the least destructive Notion operation that satisfies the request.

The correct MCP tool name for page edits is `notion-update-page`.

## Required References

Read `references/notion-page-rules.md` before calling `notion-create-pages` or `notion-update-page` for page content.
Treat that file as the source of truth for:
- default page structure
- heading emoji rules
- tone and voice
- approved or disallowed block types
- any workspace-specific page conventions

Fetch `notion://docs/enhanced-markdown-spec` before creating or updating page body content so the Markdown syntax matches the Notion MCP format.

If the rules document is incomplete:
- for new pages, keep the structure simple and avoid inventing strong stylistic patterns
- for existing pages, preserve the current page style unless the user explicitly asks to restyle it

## Workflow

1. Determine whether the request is to create a page or update an existing page.
2. Read `references/notion-page-rules.md`.
3. If the task changes page body content, fetch `notion://docs/enhanced-markdown-spec`.
4. If the task updates an existing page, fetch the current page before editing it.
5. Choose the narrowest Notion MCP operation that can complete the request.
6. Apply only the requested content and property changes.

## Create Pages

Use `notion-create-pages` when adding a new page.
Set the title in properties and write the body in Notion-flavored Markdown.
Apply the rules from `references/notion-page-rules.md` to the new content.
If the user provides draft text, preserve the meaning and wording as much as possible while formatting it to match the documented rules.

## Update Pages

Use `notion-update-page` when modifying an existing page.
Fetch the current page first so the existing content, structure, and child objects are visible before editing.
Prefer `update_properties` for property-only changes.
Prefer `update_content` with targeted replacements for partial content changes.
Use `replace_content` only when the user explicitly requests a full rewrite or full replacement.

Do not remove, rewrite, or reorder unrelated content.
Do not delete child pages, child databases, or existing sections unless the user explicitly asks for that deletion.
When the user asks for a scoped edit, keep the rest of the page intact even if it does not match the current rules document.
If an exact replacement target is unclear, fetch again or ask for clarification instead of broadening the edit.

## Guardrails

Use the least destructive operation that will work.
Keep edits narrowly scoped to the user's instruction.
Preserve existing information that was not part of the request.
Do not silently clean up nearby sections.
When adding new material to an existing page, insert or replace only the relevant section instead of regenerating the whole page.
