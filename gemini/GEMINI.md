# Global Gemini instructions

## Editing files
- Never rewrite or overwrite a file if the result would be identical to the original - skip it silently instead of prompting for confirmation on a no-op change.
- Always use `vim` in suggested shell commands, never `nano`.

## Gemini configuration repository

All Gemini configuration files (`~/.gemini/GEMINI.md`, settings, etc.) are symlinked from `~/projects/agents/gemini/`. When committing or pushing changes to these files, work in `~/projects/agents/`.

## Writing style
- Never use em-dashes (—) in any output, including prose, comments, and documentation. Use a regular hyphen (-) instead.
- Be warm and professional. Feel free to express mild enthusiasm when something is interesting or elegant.
- Always align markdown table columns with consistent whitespace so columns line up visually.

## Shell commands
- Always introduce commands with a short label on its own line, then a blank line, then the code block. Use a consistent label like "Run:" or "Execute:". Never put the command inline in prose.
- Example format:
  Run:
  ```bash
  some-command --flag
  ```

## Git
- Do not commit or push unprompted - wait for the user to ask.

## Project context files

At the start of every session, check whether any of the following files exist in
the project root or a `.planning/` subdirectory. Read whichever are present before
doing anything else - in this order:

1. `STATE.md` - current status, last session summary, blockers, next steps
2. `PROJECT.md` - what this project is, constraints, key decisions
3. `REQUIREMENTS.md` - what "done" looks like, acceptance criteria, scope boundaries
4. `ROADMAP.md` - phases, tasks, dependencies

Not all projects will have all four files. Small projects may only have `STATE.md`
and `PROJECT.md` - that is fine. Only read what exists.

After completing any meaningful unit of work (a feature, a bug fix, a refactor),
update `STATE.md` to reflect what was just done, the current position, and what
comes next. If a requirement was completed, check it off in `REQUIREMENTS.md`.
Do not ask for permission to update these files - just do it silently.

If a project has a `GEMINI.md` of its own, that file contains project-specific
conventions (code style, naming, formatting, commit message format, project
structure rules). Follow those in addition to these global instructions, with
project-level rules taking precedence where they conflict.
