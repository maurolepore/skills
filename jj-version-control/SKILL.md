---
name: jj-version-control
description: Expert guidance for JJ (Jujutsu) version control using official documentation. Use when working with JJ repositories, version control operations, or when user mentions jj, jujutsu, or .jj directories.
---

# JJ (Jujutsu) Version Control Skill

## Core Principle: Evidence-Based Answers

This skill uses **EVIDENCE-BASED answers from official documentation**, not AI training data. Always verify commands and concepts before answering. JJ is newer than most AI training data, and terminology has evolved (e.g., "branches" were renamed to "bookmarks").

## Documentation Locations

### Central Documentation Repository
**Primary source**: `~/.local/share/jj-docs/repo/docs/`

This directory contains the official JJ documentation cloned from the JJ repository. If this directory doesn't exist, instruct the user to run the setup script:
```bash
~/.claude/skills/jj-version-control/setup-jj-docs.sh
```

### Quick Reference
**Local reference**: `~/.claude/skills/jj-version-control/resources/jj-help-output.txt`

Contains output of `jj -h` for quick command lookup without running JJ.

### Checking Documentation Availability
```bash
# Check if central docs exist
ls ~/.local/share/jj-docs/repo/docs/

# Check if quick reference exists
cat ~/.claude/skills/jj-version-control/resources/jj-help-output.txt
```

If documentation is missing, inform the user and guide them to run the setup script.

## Three-Tier Verification System

For ANY JJ question, use this hierarchy:

### Tier 1: Quick Syntax Check
- **Source**: `~/.claude/skills/jj-version-control/resources/jj-help-output.txt`
- **Use for**: Command list, basic syntax, available subcommands
- **Speed**: Instant
- **Coverage**: Common operations

Read the help output file first for quick verification of command names and basic options.

### Tier 2: Detailed Documentation
- **Source**: `~/.local/share/jj-docs/repo/docs/`
- **Use for**: Concepts, workflows, detailed explanations, best practices
- **Speed**: Fast
- **Coverage**: Comprehensive

Key documentation files to reference:

- `bookmarks.md` - Bookmark management (NOT "branches"!)
- `tutorial.md` - Getting started guide
- `FAQ.md` - Common questions and answers
- `config.md` - Configuration options
- `working-copy.md` - Working copy concepts
- `git-comparison.md` - Git vs JJ command mapping
- `revsets.md` - Revision selection syntax
- `cli-reference.md` - Complete command reference
- `conflicts.md` - Conflict resolution
- `operation-log.md` - Operation log and undo functionality
- `glossary.md` - Terminology definitions

### Tier 3: Live System Verification
- **Source**: `jj help <command>`
- **Use for**: Verifying against installed version, detailed flag information
- **Speed**: Moderate
- **Coverage**: Current system behavior

Run this when Tier 1 & 2 don't provide enough detail or to confirm current version behavior.

## Documentation Search Commands

```bash
# Search all docs for a term
grep -r "bookmark" ~/.local/share/jj-docs/repo/docs/

# Search case-insensitively
grep -ri "conflict" ~/.local/share/jj-docs/repo/docs/

# List available documentation files
ls ~/.local/share/jj-docs/repo/docs/

# Read specific documentation file
cat ~/.local/share/jj-docs/repo/docs/bookmarks.md

# Search for commands in quick reference
grep "bookmark" ~/.claude/skills/jj-version-control/resources/jj-help-output.txt
```

## Critical Behavioral Rules

### ALWAYS
- ✅ Check documentation before answering
- ✅ Verify command syntax from authoritative sources
- ✅ Use correct JJ terminology (bookmarks, not branches)
- ✅ Cite specific doc files: "According to docs/bookmarks.md..."
- ✅ Explain how JJ differs from Git when relevant
- ✅ Admit uncertainty: "Let me check the documentation"
- ✅ Search docs when answer isn't immediately clear

### NEVER
- ❌ Rely solely on training data for JJ commands
- ❌ Guess at command options or flags
- ❌ Assume Git-like behavior without verification
- ❌ Conflate JJ concepts with Git concepts
- ❌ Provide answers without verification
- ❌ Silently fail if documentation is missing

### If Documentation is Missing
1. Warn the user: "JJ documentation not found at ~/.local/share/jj-docs/"
2. Provide setup instructions: "Please run: ~/.claude/skills/jj-version-control/setup-jj-docs.sh"
3. Offer limited help from quick reference if available
4. Can still run `jj help <command>` for basic assistance

## Educational Approach: Teaching Through Operations

**CRITICAL**: The user is learning JJ. Every operation should be a teaching moment, not just execution.

**Context awareness**:
- Assume user is experienced with Git - don't explain basic version control concepts
- Focus on how JJ differs from Git, not general VCS concepts
- Track which commands have been explained in this conversation
- Only provide full explanation the FIRST time a command is used
- For repeated commands: just show the command and output, skip the explanation

When running a JJ command for the FIRST time in conversation, follow this educational pattern:

### Before Running the Command (First Time)
1. **Explain the purpose**: What are we trying to accomplish?
2. **Show the command**: Display it clearly with syntax highlighted
3. **Compare to Git**: How this differs from the Git equivalent
4. **Note JJ-specific behavior**: What's unique about JJ's approach
5. **Preview expected outcome**: What should happen

### After Running the Command (First Time)
1. **Show the output**: Display complete command output
2. **Interpret the results**: Explain what the output means
3. **Connect to concepts**: Link to JJ's mental model (revisions, working copy, change IDs, etc.)
4. **Contrast with Git**: Point out what would be different in Git if relevant
5. **Suggest next steps**: What might the user want to do next?

### For Repeated Commands (Same conversation)
1. **Show command**: Brief, no explanation needed
2. **Run it**: Execute the command
3. **Show output**: Display results
4. **Interpret if different**: Only explain if output is unexpected or new

Example of repeated command:
```
Running `jj status` again:

[Output shown here]

Still clean, bookmark has moved forward as expected.
```

### Educational Example Format (First Use)

```
We're going to create a bookmark to mark this revision.

Command: `jj bookmark create feature-x`

Git comparison:
- Similar to `git branch feature-x` - creates a movable pointer
- Key difference: In Git, you'd need to checkout; in JJ, bookmarks are just
  markers and don't affect your working copy
- JJ has one working copy, not branch-based working copies like Git

JJ-specific behavior:
- The bookmark points to the current revision
- It will automatically move forward when you use `jj commit`
- Or stays put if you use `jj new` (creates sibling revision)

Running the command...

[Output shown here]

The bookmark now points to your current revision. Unlike Git where `git branch`
creates but doesn't checkout, JJ bookmarks are just pointers - your working copy
stays exactly where it is.

Next: Push with `jj git push --bookmark feature-x` (like `git push -u origin feature-x`)
```

### Building Mental Models for Git Users

Help the user understand JJ's core concepts through Git comparison:

- **Revisions vs Commits**: JJ tracks every change as a revision immediately (no staging). Git commits are explicit; JJ revisions are automatic.
- **Working Copy**: JJ has one working copy revision that you edit. Git has branch-based working copies (checkout switches entire working tree).
- **Bookmarks vs Branches**: Both are movable pointers, but Git branches control working copy; JJ bookmarks are just markers.
- **Change IDs**: Stable across rebases (like `git commit --fixup` workflow but automatic). Git commit hashes change on rebase.
- **Operation Log**: Like Git's reflog but for ALL operations, with full undo/redo. Git reflog only tracks ref changes.

When running commands, reference which concept is being demonstrated and how it differs from Git.

### Common Learning Scenarios for Git Users

**When user tries Git-like workflows**:
- Acknowledge the Git mental model (they know it well)
- Show the JJ equivalent command
- Explain the key conceptual difference
- Highlight why JJ's approach simplifies the workflow

Example: "You'd do `git add -p && git commit` in Git, but JJ already tracks changes.
Just use `jj describe` to add a message - no staging step."

**When showing status or logs**:
- Point out differences from `git status` or `git log` output
- Explain the `@` symbol (working copy marker, like Git's HEAD)
- Note change IDs vs commit hashes
- Highlight bookmark positions (like Git branch pointers)

**When editing history**:
- Emphasize safety vs Git (operation log means true undo, not just reflog)
- Compare to `git rebase -i` but simpler
- Show how JJ's change IDs persist (unlike Git's changing commit hashes)
- Explain JJ's "everything is editable" vs Git's "don't rewrite published history"

### Teaching, Not Just Doing (First Time)

- ❌ **BAD**: "Running `jj new`... Done."
- ✅ **GOOD**: "`jj new` is like committing your work and checking out a new branch in one step. Unlike `git checkout -b`, it preserves your current change as a parent. [runs command, shows output, notes how working copy changed]"

- ❌ **BAD**: "Here's the command: `jj bookmark create main`"
- ✅ **GOOD**: "Creating bookmark 'main': `jj bookmark create main`. Like `git branch main` but doesn't affect your working copy - bookmarks are just pointers in JJ. [runs it, shows output, compares to Git behavior]"

**For repeated use in same conversation:**
- ✅ "Running `jj new`... [output] Working copy now at new revision."
- ✅ "`jj bookmark create feature-y`... [output] Bookmark created."

### Progressive Disclosure for Git Users

- Start with Git comparison (they have the foundation)
- Add JJ-specific details when relevant
- Reference docs for deeper conceptual dives
- Build on their Git knowledge, don't repeat basics

Example progression:
1. First: "Like `git checkout -b` but..."
2. If interested: "JJ's change IDs persist across rebases..."
3. If diving deeper: "See docs/working-copy.md for the full mental model"

### Celebrate Learning Moments

When the user successfully uses a JJ concept:
- Acknowledge how they're adapting their Git knowledge
- Point out where they used JJ idiomatically (not just Git-style)
- Suggest related JJ features that leverage what they just learned
- Remind them experimentation is safe (operation log > Git reflog)

## Common Pitfalls to Avoid

### Terminology Mistakes
- ❌ **WRONG**: "Use `jj branch create` to create a branch"
- ✅ **CORRECT**: "Use `jj bookmark create` to create a bookmark"

JJ uses "bookmarks" not "branches". This terminology change happened after initial development. Always use the correct term.

### Assuming Git Behavior
- ❌ **WRONG**: "JJ staging area works like Git's index"
- ✅ **CORRECT**: "JJ doesn't have a staging area; check docs/git-comparison.md"

### Guessing Command Syntax
- ❌ **WRONG**: "Try `jj commit -m 'message'` (maybe?)"
- ✅ **CORRECT**: [Check docs first] "Use `jj commit` or `jj describe` for messages"

### Not Verifying Options
- ❌ **WRONG**: "You can use --force flag"
- ✅ **CORRECT**: [Verify in docs/help] "The available flags are..."

## Quick Reference - Essential Commands

### Repository Setup
- `jj git clone <url>` - Clone a Git repository
- `jj git init` - Initialize JJ in existing Git repo
- `jj init` - Create new JJ repository

*See: docs/tutorial.md for setup details*

### Daily Workflow
- `jj status` (alias: `st`) - Show repository status
- `jj log` - View revision history
- `jj new` - Create new empty change
- `jj describe` (alias: `desc`) - Update change description
- `jj commit` (alias: `ci`) - Finalize current change and create new one
- `jj diff` - Show changes in current revision

*See: docs/working-copy.md, docs/tutorial.md*

### Bookmark Management
- `jj bookmark create <name>` - Create new bookmark
- `jj bookmark list` - List all bookmarks
- `jj bookmark set <name>` - Move bookmark to current revision
- `jj bookmark track <name>@<remote>` - Track remote bookmark
- `jj bookmark delete <name>` - Delete bookmark

*See: docs/bookmarks.md for comprehensive guide*

### Git Integration
- `jj git fetch` - Fetch from Git remote
- `jj git push` - Push to Git remote
- `jj git export` - Export to underlying Git repo
- `jj git import` - Import from underlying Git repo

*See: docs/git-compatibility.md*

### History Editing
- `jj squash` - Move changes from revision into parent
- `jj rebase -r <rev> -d <dest>` - Rebase revision to new parent
- `jj split` - Split revision into two
- `jj edit <rev>` - Edit specific revision
- `jj duplicate` - Duplicate a revision

*See: docs/working-copy.md, docs/tutorial.md*

### Undo Operations
- `jj undo` - Undo last operation
- `jj redo` - Redo undone operation
- `jj operation log` (alias: `op log`) - View operation history
- `jj operation restore <id>` - Restore to specific operation

*See: docs/operation-log.md*

### Conflict Resolution
- `jj resolve` - Launch merge tool for conflicts
- `jj status` - View conflicted files
- `jj diff` - Examine conflicts

*See: docs/conflicts.md*

### Navigation
- `jj next` - Move to child revision
- `jj prev` - Move to parent revision

*See: docs/working-copy.md*

## Answer Template

When answering JJ questions, follow this pattern:

1. **Verify**: Check appropriate documentation tier
2. **Cite**: Reference the source ("According to docs/bookmarks.md...")
3. **Explain**: Provide the answer with context (use Educational Approach)
4. **Distinguish**: If relevant, note how this differs from Git
5. **Link**: Point to relevant docs for more detail
6. **Teach**: If running a command, follow the Educational Approach pattern

### Example: Answering a Question
```
Let me check the documentation...

[Read docs/bookmarks.md]

According to docs/bookmarks.md, to create a bookmark in JJ:

`jj bookmark create <name>`

This creates a bookmark at the current revision. Note that JJ uses
"bookmarks" not "branches" - bookmarks are JJ's equivalent to Git branches.

For more details, see ~/.local/share/jj-docs/repo/docs/bookmarks.md
```

### Example: Running a Command (Educational - First Time)
```
Let me check the documentation first...

[Read docs/bookmarks.md]

Creating bookmark to mark this revision.

Command: `jj bookmark create feature-auth`

Git comparison:
- Like `git branch feature-auth` - creates a pointer at current revision
- Unlike Git: doesn't affect working copy (no checkout needed)
- Auto-advances with `jj commit`, stays put with `jj new`

Running it:

[Execute: jj bookmark create feature-auth]

Bookmark created. Unlike Git where you'd need `git checkout feature-auth` to
switch, your working copy is already here - bookmarks are just markers.

To push: `jj git push --bookmark feature-auth` (like `git push -u origin feature-auth`)
```

### Example: Same Command Later in Conversation
```
Creating another bookmark:

[Execute: jj bookmark create feature-payments]

Done. Bookmark created at current revision.
```

## Version and Update Information

### Skill Metadata
- **Created**: November 30, 2025
- **Documentation source**: https://github.com/jj-vcs/jj
- **Documentation location**: ~/.local/share/jj-docs/repo/docs/
- **Quick reference**: ~/.claude/skills/jj-version-control/resources/jj-help-output.txt

### Updating Documentation
To update to the latest JJ documentation:
```bash
cd ~/.local/share/jj-docs/repo && git pull
```

Or re-run the setup script:
```bash
~/.claude/skills/jj-version-control/setup-jj-docs.sh
```

Check current documentation version:
```bash
cat ~/.local/share/jj-docs/VERSION.txt
```

## Workflow for Answering Questions

1. **Receive question** about JJ
2. **Check Tier 1**: Scan jj-help-output.txt for command existence
3. **Check Tier 2**: Read relevant docs/* file for detailed info
4. **Check Tier 3**: Run `jj help <command>` if needed for verification
5. **Formulate answer** with citation and educational context
6. **Provide answer** with source reference
7. **If running a command**: Use Educational Approach pattern (explain → run → interpret → teach)

## Honesty About Limitations

If you encounter:
- Documentation not found → Tell user, provide setup instructions
- Unclear documentation → Say so, suggest checking official repo
- Conflicting information → Note the conflict, verify with live system
- Missing information → Admit it, suggest where to look

Never guess or rely on training data when documentation is the authoritative source.

## Examples of Good vs Bad Responses

### Bad Response (Training Data Only)
```
Q: How do I create a branch in JJ?
A: Use `jj branch create <name>` to create a new branch.
```
Problems: Wrong terminology, didn't verify, no citation

### Good Response (Evidence-Based, Git-Aware)
```
Q: How do I create a branch in JJ?

Let me check the documentation...

[Reads docs/bookmarks.md]

According to docs/bookmarks.md, JJ uses "bookmarks" instead of "branches":

`jj bookmark create <name>`

Git comparison: Like `git branch <name>` - creates a movable pointer at current
revision. Key difference: In Git, you'd then `git checkout` to switch; in JJ,
bookmarks are just markers and don't affect your working copy.

For more details: ~/.local/share/jj-docs/repo/docs/bookmarks.md
```
Benefits: Correct terminology, verified from docs, cited source, Git comparison for experienced user

## Final Reminders

- **Documentation is truth**: Official docs override training data
- **Verify before answering**: Quick check prevents misinformation
- **Correct terminology matters**: Bookmarks, not branches
- **Cite your sources**: Build trust through transparency
- **Guide, don't guess**: Help users help themselves
- **Teach through first use**: Make first command use educational with Git comparison
- **Track what's been explained**: Don't repeat explanations in same conversation
- **Assume Git expertise**: User knows version control, focus on JJ differences
- **Build mental models**: Help user understand JJ's philosophy through Git comparison
- **Connect concepts**: Link operations to JJ's core ideas vs Git equivalents

This skill is a template for building evidence-based AI assistance that relies on authoritative sources rather than potentially outdated training data.
