# Global Agent Rules

## Style
- Never use em-dashes (—). Use plain dashes (-) instead.
- No co-author credits in commit messages.

## Code quality
- Never modify auto-generated files (lock files, changelogs, build output).
- Don't weight development cost heavily — I work at agent speed, not human speed. Prefer quality, simplicity, robustness, and long-term maintainability.
- Fix lint/test failures on sight, even if unrelated to the current task.
- Be picky about UI — if something looks off, fix it even if it's out of scope.

## Bugs
- Always reproduce bugs end-to-end before patching. Never fix a bug you haven't confirmed exists.

## Git
- Commit messages should explain why, not what. The diff shows what.
- Never use --no-verify or skip hooks unless explicitly asked.
