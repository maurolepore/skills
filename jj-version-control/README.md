# JJ Version Control Skill

An evidence-based Claude Code skill for JJ (Jujutsu) version control that prioritizes official documentation over AI training data.

## Table of Contents
- [Problem Statement](#problem-statement)
- [Solution Approach](#solution-approach)
- [How It Works](#how-it-works)
- [Installation](#installation)
- [Usage Examples](#usage-examples)
- [Maintenance](#maintenance)
- [Lessons Learned](#lessons-learned)
- [File Structure](#file-structure)

## Problem Statement

### The Challenge: Outdated Training Data

JJ (Jujutsu) is a modern version control system that's newer than most AI training data. This creates several problems:

1. **Terminology Evolution**: JJ renamed "branches" to "bookmarks" after initial development
2. **Command Changes**: Syntax and options have evolved
3. **Concept Drift**: Understanding of JJ concepts may be incomplete or outdated
4. **Silent Failures**: Users receive confident but incorrect answers

### Real-World Example: The "Branches vs Bookmarks" Mistake

**Without this skill**:
```
User: How do I create a branch in JJ?
Claude: Use `jj branch create <name>` to create a new branch.
Result: ❌ Command fails - "branch" subcommand doesn't exist in current JJ
```

**With this skill**:
```
User: How do I create a branch in JJ?
Claude: [Checks docs/bookmarks.md]
Claude: JJ uses "bookmarks" not "branches". Use `jj bookmark create <name>`
Result: ✅ Correct terminology, working command, user educated
```

### Why Memory-Based Skills Are Fragile

Creating skills purely from AI memory leads to:
- Outdated commands that no longer work
- Incorrect flag suggestions
- Misunderstanding of current concepts
- No way to verify accuracy
- Brittle knowledge that degrades over time

## Solution Approach

### Evidence-Based Design

This skill implements three key principles:

1. **Documentation as Ground Truth**
   - Official JJ docs cloned locally
   - Always verify before answering
   - Cite sources for transparency

2. **Three-Tier Verification System**
   - Tier 1: Quick syntax check (jj-help-output.txt)
   - Tier 2: Detailed documentation (docs/*.md files)
   - Tier 3: Live verification (jj help commands)

3. **Graceful Degradation**
   - Works even if documentation is missing (with warnings)
   - Clear instructions to fix missing pieces
   - Never silent failures

4. **Educational Approach**
   - First use of each command is a teaching moment with Git comparison
   - Repeated commands in same conversation: brief, no re-explanation
   - Assume Git expertise - focus on differences, not VCS basics
   - Build mental models by comparing to Git equivalents

### Key Innovation: Central Documentation Repository

Instead of duplicating docs in the skill folder:
```
~/.local/share/jj-docs/          ← Central location
    ├── repo/                     ← Full JJ repository
    │   └── docs/                 ← Official documentation
    └── VERSION.txt               ← Version tracking

~/.claude/skills/jj-version-control/  ← Skill location
    ├── SKILL.md                  ← References central docs
    ├── setup-jj-docs.sh          ← Installs central docs
    └── resources/
        └── jj-help-output.txt    ← Quick reference only
```

**Benefits**:
- Single source of truth for all JJ-related skills
- Easy updates (just `git pull`)
- Smaller skill footprint
- Version tracking for reproducibility

## How It Works

### Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    User asks JJ question                     │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│              Claude checks documentation                     │
│                                                              │
│  Tier 1: Quick Check                                        │
│  ├─ Read: resources/jj-help-output.txt                     │
│  └─ Verify: command exists, basic syntax                   │
│                                                              │
│  Tier 2: Detailed Documentation                             │
│  ├─ Read: ~/.local/share/jj-docs/repo/docs/*.md            │
│  └─ Verify: concepts, workflows, flags                     │
│                                                              │
│  Tier 3: Live Verification (if needed)                      │
│  ├─ Run: jj help <command>                                  │
│  └─ Verify: current system behavior                        │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│           Claude provides verified answer                    │
│           - Cites source (docs/bookmarks.md)                │
│           - Explains differences from Git                   │
│           - Uses correct terminology                        │
└─────────────────────────────────────────────────────────────┘
```

### Documentation Flow

1. **Installation** (one-time):
   ```bash
   ~/.claude/skills/jj-version-control/setup-jj-docs.sh
   ```
   - Clones https://github.com/jj-vcs/jj to ~/.local/share/jj-docs/repo
   - Records version info (commit hash, date)
   - Provides feedback on installation

2. **Query Processing**:
   - User asks question
   - Claude checks Tier 1 (quick reference)
   - If needed, checks Tier 2 (full docs)
   - If needed, checks Tier 3 (live system)
   - Formulates answer with citation

3. **Answer Delivery**:
   - Provides verified answer
   - Cites source file
   - Explains context/differences
   - Links to more information

## Installation

### Prerequisites

- **git**: Required for cloning documentation
  - macOS: `brew install git`
  - Ubuntu/Debian: `sudo apt install git`
  - Fedora: `sudo dnf install git`

- **jj** (optional): For Tier 3 verification
  - macOS: `brew install jj`
  - See: https://martinvonz.github.io/jj/latest/install-and-setup/

### Step-by-Step Setup

1. **Copy skill to Claude Code skills directory**:
   ```bash
   cp -r jj-version-control ~/.claude/skills/
   ```

2. **Run the setup script**:
   ```bash
   ~/.claude/skills/jj-version-control/setup-jj-docs.sh
   ```

3. **Verify installation**:
   ```bash
   # Check documentation exists
   ls ~/.local/share/jj-docs/repo/docs/

   # Check version info
   cat ~/.local/share/jj-docs/VERSION.txt

   # Check quick reference
   cat ~/.claude/skills/jj-version-control/resources/jj-help-output.txt
   ```

4. **Restart Claude Code** (if running):
   Skills are loaded on startup, so restart to activate.

### Verification

Test the skill by asking Claude:
- "How do I create a bookmark in JJ?"
- "What's the difference between JJ and Git?"
- "How do I undo my last operation in JJ?"

Claude should reference documentation files in its answers.

## Usage Examples

### Example 1: Correct Terminology

**Query**: "How do I list all branches in JJ?"

**Claude's Process**:
1. Reads `resources/jj-help-output.txt`
2. Sees `bookmark` command, not `branch`
3. Reads `~/.local/share/jj-docs/repo/docs/bookmarks.md`
4. Formulates corrected answer

**Response**:
```
According to docs/bookmarks.md, JJ uses "bookmarks" not "branches".

To list all bookmarks:
  jj bookmark list

Note: JJ's bookmarks are equivalent to Git branches. The terminology
was changed to better reflect that these are movable pointers.

For more info: ~/.local/share/jj-docs/repo/docs/bookmarks.md
```

✅ **Good**: Corrected terminology, verified from docs, cited source

### Example 2: Git Comparison

**Query**: "I'm used to Git - how do I commit in JJ?"

**Claude's Process**:
1. Reads `~/.local/share/jj-docs/repo/docs/git-comparison.md`
2. Understands JJ's different model
3. Explains the difference

**Response**:
```
According to docs/git-comparison.md, JJ's commit model differs from Git:

In Git: You stage changes, then commit
In JJ: Every change is automatically committed as you work

To finalize and describe a change:
  jj describe -m "commit message"

Or to create a new change on top:
  jj commit -m "commit message"

This automatically creates a new working-copy change.

See: ~/.local/share/jj-docs/repo/docs/git-comparison.md
```

✅ **Good**: Explained difference, provided correct commands, cited docs

### Example 3: Handling Missing Documentation

**Query**: "How do I resolve conflicts in JJ?"

**Claude's Process** (if docs missing):
1. Tries to read `~/.local/share/jj-docs/repo/docs/conflicts.md`
2. File not found
3. Falls back to live system

**Response**:
```
Warning: JJ documentation not found at ~/.local/share/jj-docs/

Please run the setup script:
  ~/.claude/skills/jj-version-control/setup-jj-docs.sh

For now, checking the installed system...

[Runs: jj help resolve]

According to `jj help resolve`:
  jj resolve

This launches an external merge tool for conflict resolution.

For comprehensive documentation, please install the docs.
```

✅ **Good**: Warned about missing docs, provided fix, still helped user

### What Makes a Good Answer?

Good answers are:
- ✅ **Verified**: Checked against documentation
- ✅ **Cited**: Reference source file
- ✅ **Contextual**: Explain JJ-specific concepts
- ✅ **Educational**: Help user understand, not just execute
- ✅ **Honest**: Admit limitations or missing info

Bad answers are:
- ❌ **Memory-based**: "I think the command is..."
- ❌ **Uncited**: No reference to where info came from
- ❌ **Git-assuming**: Assumes JJ works like Git
- ❌ **Guessing**: Suggests flags/options without verification
- ❌ **Silent**: Doesn't warn when documentation missing

## Maintenance

### Updating Documentation

JJ is actively developed. Keep documentation current:

#### Quick Update
```bash
cd ~/.local/share/jj-docs/repo && git pull
```

#### Full Refresh
```bash
~/.claude/skills/jj-version-control/setup-jj-docs.sh
```

#### Check Current Version
```bash
cat ~/.local/share/jj-docs/VERSION.txt
```

### When to Update

Update documentation when:
- JJ releases a new version
- You notice outdated information
- New features are added
- Every 1-3 months (JJ is actively developed)

### Updating Quick Reference

If JJ version changes significantly:
```bash
jj -h > ~/.claude/skills/jj-version-control/resources/jj-help-output.txt
```

### Version Tracking

The skill tracks versions in two places:

1. **Skill version**: `resources/VERSION.txt`
   - Skill creation date
   - JJ version used to generate resources
   - Update instructions

2. **Documentation version**: `~/.local/share/jj-docs/VERSION.txt`
   - Git commit hash of docs
   - Commit date
   - Download timestamp

This allows debugging when commands don't match documentation.

## Lessons Learned

### 1. Evidence Over Memory

**Lesson**: AI training data becomes outdated, especially for new tools.

**Solution**: Always reference authoritative, versioned documentation.

**Application**: Any rapidly-evolving tool benefits from this approach:
- New frameworks (Astro, Fresh, etc.)
- Evolving tools (Deno, Bun, etc.)
- Tools with breaking changes

### 2. Central Documentation Location

**Lesson**: Duplicating documentation in each skill is wasteful and error-prone.

**Solution**: Central repository (`~/.local/share/`) referenced by multiple skills.

**Benefits**:
- One update updates all skills
- Reduced disk usage
- Version tracking in one place
- Easy to verify currency

### 3. Graceful Degradation

**Lesson**: Skills shouldn't fail silently when resources are missing.

**Solution**: Three-tier system with fallbacks and clear error messages.

**Implementation**:
- Tier 1: Local quick reference (always available)
- Tier 2: Central docs (preferred, installable)
- Tier 3: Live system (fallback, requires tool installed)

### 4. Verification is Not Optional

**Lesson**: Confident but wrong answers are worse than admitted uncertainty.

**Solution**: Make verification the default workflow, not an afterthought.

**In practice**:
- SKILL.md explicitly requires checking docs
- Claude taught to say "Let me check the documentation"
- Answers must cite sources

### 5. Correct Terminology Matters

**Lesson**: Using wrong terms (branches vs bookmarks) confuses users and breaks commands.

**Solution**: Emphasize correct terminology in skill instructions, cite glossary.

**Result**: Users learn correct terms, building better mental models.

### 6. Building Robust vs Fragile Skills

**Fragile skill**:
```yaml
---
name: jj-tool
description: Help with JJ
---

Use `jj branch` to work with branches.
```
- Hardcoded commands (outdated)
- No verification mechanism
- Silent failures
- No update path

**Robust skill** (this one):
```yaml
---
name: jj-version-control
description: Expert guidance using official documentation
---

Always check documentation before answering:
- Tier 1: Quick reference
- Tier 2: Full docs
- Tier 3: Live system

Never rely on training data alone.
```
- Documentation-driven
- Verification required
- Clear error handling
- Update mechanism included

### 7. Teaching Through Operations

**Lesson**: Users learning a new tool need more than just commands - they need understanding.

**Problem**: Just running commands without explanation:
- Users don't understand what happened
- Can't transfer knowledge to new situations
- Don't build mental models of the tool
- Become dependent on AI for every operation

**Solution**: Educational approach pattern for FIRST use of each operation:
- Compare to Git equivalent the user already knows
- Highlight the key conceptual difference
- Show the command with context
- Run it and display output
- Interpret results focusing on JJ-specific behavior
- Brief follow-ups on repeated commands (no re-explanation)

**Example - First time using `jj new`**:
```
`jj new` is like `git commit` followed by `git checkout -b new-branch` in one step.

[runs command, shows output]

Unlike Git checkout which switches branches, JJ just moved your working copy
to a new revision. Your previous work is now a parent (like a Git commit),
but you can still edit it anytime with `jj edit <revision-id>`.
```

**Example - Second time using `jj new` in same conversation**:
```
[runs jj new, shows output]

Working copy now at new revision abc123.
```

**Benefits**:
- Leverages existing Git knowledge (faster learning curve)
- Focuses on meaningful differences, not basics
- Builds transferable mental models through comparison
- Reduces noise in repeated operations
- Makes learning efficient and respectful of user's expertise

**In practice**:
- SKILL.md includes "Educational Approach" section with Git-aware guidance
- First use: Git comparison → run → interpret JJ differences
- Repeated use: brief execution and output only
- Assumes Git expertise, explains JJ philosophy
- Tracks conversation state to avoid repetition
- Encourages experimentation (operation log > Git reflog)

## File Structure

```
jj-version-control/
├── SKILL.md                      # Main skill file
│   ├── YAML frontmatter          # Skill name and description
│   ├── Documentation locations   # Where to find docs
│   ├── Three-tier system         # Verification hierarchy
│   ├── Behavioral rules          # How to answer questions
│   ├── Quick reference           # Common commands
│   └── Version info              # Metadata and updates
│
├── setup-jj-docs.sh              # Documentation installer
│   ├── Clones JJ repository      # From github.com/jj-vcs/jj
│   ├── Records version           # Commit hash, date
│   ├── Idempotent updates        # Safe to re-run
│   └── Error handling            # Clear messages
│
├── resources/
│   ├── jj-help-output.txt        # Output of: jj -h
│   │   └── Quick command list    # For Tier 1 verification
│   │
│   └── VERSION.txt               # Skill metadata
│       ├── Creation date         # When skill was built
│       ├── JJ version            # Version used for resources
│       └── Update instructions   # How to maintain
│
└── README.md                     # This file
    ├── Problem statement         # Why this exists
    ├── Solution approach         # How it works
    ├── Installation              # How to set up
    ├── Usage examples            # Good vs bad answers
    ├── Maintenance               # How to update
    └── Lessons learned           # Design principles

Central documentation (created by setup script):
~/.local/share/jj-docs/
├── repo/                         # Git clone of jj-vcs/jj
│   ├── docs/                     # Official documentation
│   │   ├── bookmarks.md          # Bookmark guide
│   │   ├── tutorial.md           # Getting started
│   │   ├── git-comparison.md     # Git vs JJ
│   │   ├── conflicts.md          # Conflict resolution
│   │   └── ... (many more)       # Comprehensive docs
│   └── .git/                     # Git metadata
└── VERSION.txt                   # Documentation version info
    ├── Git commit hash           # Exact version
    ├── Commit date               # When docs were current
    └── Download date             # When installed
```

## Meta: A Template for Better Skills

This skill demonstrates principles applicable to any rapidly-evolving tool:

### The Pattern
1. **Identify authoritative source** (official docs, API specs)
2. **Create installation mechanism** (clone, download, update)
3. **Implement verification hierarchy** (quick → detailed → live)
4. **Require citation** (never answer without checking)
5. **Handle missing resources gracefully** (warn, provide fix)
6. **Track versions** (reproducibility, debugging)
7. **Educate users** (explain → run → interpret → teach pattern)
8. **Build mental models** (connect operations to core concepts)

### Application Examples

This pattern works for:
- **New frameworks**: Astro, Qwik, Fresh
- **Evolving tools**: Deno, Bun, Vite
- **API-driven tools**: Cloud CLIs, SDKs
- **Language features**: New Swift, Rust, etc.

### Core Insight

> The best AI assistance comes from combining AI's language understanding
> with authoritative, current documentation. Neither alone is sufficient.

AI provides:
- Natural language understanding
- Context synthesis
- Explanation generation

Documentation provides:
- Current, accurate information
- Authoritative source of truth
- Versioned knowledge

This skill bridges both, creating reliable, maintainable AI assistance.

---

## Quick Start Summary

```bash
# 1. Copy skill to Claude Code
cp -r jj-version-control ~/.claude/skills/

# 2. Install documentation
~/.claude/skills/jj-version-control/setup-jj-docs.sh

# 3. Restart Claude Code
# (Skills load on startup)

# 4. Test it
# Ask Claude: "How do I create a bookmark in JJ?"
# Should reference docs/bookmarks.md in answer
```

## Support and Contribution

- **JJ Documentation**: https://martinvonz.github.io/jj/
- **JJ Repository**: https://github.com/jj-vcs/jj
- **JJ Discord**: https://discord.gg/dkmfj3aGQN

To improve this skill:
1. Update documentation: Re-run `setup-jj-docs.sh`
2. Report issues: Check if SKILL.md needs updates
3. Share learnings: Document new patterns in README

---

**Created**: November 30, 2025
**Version**: 1.0.0
**License**: Use freely, credit appreciated
**Philosophy**: Evidence over memory, verification over guessing, teaching through every operation
