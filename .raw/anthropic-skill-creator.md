# Source: Anthropic — skill-creator SKILL.md
# URL: https://github.com/anthropics/claude-plugins-official/tree/main/plugins/skill-creator/skills/skill-creator
# Ingested: 2026-07-01

---
name: skill-creator
description: Create new skills, modify and improve existing skills, and measure skill performance. Use when users want to create a skill from scratch, edit, or optimize an existing skill, run evals to test a skill, benchmark skill performance with variance analysis, or optimize a skill's description for better triggering accuracy.
---

# Skill Creator

A skill for creating new skills and iteratively improving them.

At a high level, the process of creating a skill goes like this:

- Decide what you want the skill to do and roughly how it should do it
- Write a draft of the skill
- Create a few test prompts and run claude-with-access-to-the-skill on them
- Help the user evaluate the results both qualitatively and quantitatively
  - While the runs happen in the background, draft some quantitative evals if there aren't any (if there are some, you can either use as is or modify if you feel something needs to change about them). Then explain them to the user (or if they already existed, explain the ones that already exist)
  - Use the `eval-viewer/generate_review.py` script to show the user the results for them to look at, and also let them look at the quantitative metrics
- Rewrite the skill based on feedback from the user's evaluation of the results (and also if there are any glaring flaws that become apparent from the quantitative benchmarks)
- Repeat until you're satisfied
- Expand the test set and try again at larger scale

## Communicating with the user

Pay attention to context cues to understand how to phrase communication. Users range from plumbers opening terminals for the first time to senior engineers.

## Creating a skill

### Capture Intent

Start by understanding the user's intent. The current conversation might already contain a workflow the user wants to capture. Extract answers from the conversation history first.

1. What should this skill enable Claude to do?
2. When should this skill trigger? (what user phrases/contexts)
3. What's the expected output format?
4. Should we set up test cases to verify the skill works?

### Interview and Research

Proactively ask questions about edge cases, input/output formats, example files, success criteria, and dependencies.

### Write the SKILL.md

- **name**: Skill identifier
- **description**: When to trigger, what it does. All "when to use" info goes here. Make descriptions slightly "pushy" to combat Claude's tendency to undertrigger.
- **compatibility**: Required tools, dependencies (optional)

### Skill Writing Guide

#### Anatomy of a Skill

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter (name, description required)
│   └── Markdown instructions
└── Bundled Resources (optional)
    ├── scripts/    - Executable code for deterministic/repetitive tasks
    ├── references/ - Docs loaded into context as needed
    └── assets/     - Files used in output (templates, icons, fonts)
```

#### Progressive Disclosure

Three-level loading system:
1. **Metadata** (name + description) - Always in context (~100 words)
2. **SKILL.md body** - In context whenever skill triggers (<500 lines ideal)
3. **Bundled resources** - As needed (unlimited, scripts can execute without loading)

Keep SKILL.md under 500 lines. Reference files clearly from SKILL.md with guidance on when to read them. For large reference files (>300 lines), include a table of contents.

Domain organization: when a skill supports multiple domains/frameworks, organize by variant with separate reference files per variant. Claude reads only the relevant reference file.

#### Writing Patterns

Prefer imperative form in instructions.

**Writing Style**: Explain why things are important rather than using heavy-handed MUSTs. Use theory of mind. If you find yourself writing ALWAYS or NEVER in all caps, that's a yellow flag — reframe and explain the reasoning.

### Test Cases

After writing the skill draft, come up with 2-3 realistic test prompts. Save to `evals/evals.json`.

## Running and evaluating test cases

### Step 1: Spawn all runs (with-skill AND baseline) in the same turn

For each test case, spawn two subagents simultaneously — one with the skill, one without (baseline). Don't run with-skill first and then baseline later.

### Step 2: While runs are in progress, draft assertions

Draft quantitative assertions for each test case and explain them to the user.

### Step 3: As runs complete, capture timing data

When each subagent task completes, capture `total_tokens` and `duration_ms` immediately.

### Step 4: Grade, aggregate, and launch the viewer

1. Grade each run — spawn a grader subagent that reads `agents/grader.md`
2. Aggregate into benchmark — run `scripts.aggregate_benchmark`
3. Do an analyst pass — read benchmark data, surface patterns
4. Launch the viewer with `eval-viewer/generate_review.py`

GENERATE THE EVAL VIEWER *BEFORE* evaluating inputs yourself.

### Step 5: Read the feedback

When the user is done, read `feedback.json`. Empty feedback means the user thought it was fine.

## Improving the skill

### How to think about improvements

1. **Generalize from the feedback** — skills run millions of times; avoid overfitting to test examples
2. **Keep the prompt lean** — remove things that aren't pulling their weight
3. **Explain the why** — LLMs are smart; understanding why is more powerful than rigid rules
4. **Look for repeated work across test cases** — if all test runs wrote the same helper script, bundle it in `scripts/`

### The iteration loop

After improving:
1. Apply improvements to the skill
2. Rerun all test cases into a new `iteration-<N+1>/` directory
3. Launch the reviewer with `--previous-workspace`
4. Wait for user review
5. Read new feedback, improve again, repeat

Keep going until user is satisfied, feedback is all empty, or no meaningful progress.

## Description Optimization

The description field is the primary mechanism for skill triggering.

### Step 1: Generate trigger eval queries

Create 20 eval queries — mix of should-trigger and should-not-trigger. Must be realistic and concrete (not abstract). The most valuable should-not-trigger queries are near-misses that share keywords but need something different.

### Step 2: Review with user

Present the eval set using `assets/eval_review.html` template.

### Step 3: Run the optimization loop

```bash
python -m scripts.run_loop \
  --eval-set <path-to-trigger-eval.json> \
  --skill-path <path-to-skill> \
  --model <model-id-powering-this-session> \
  --max-iterations 5 \
  --verbose
```

Uses 60/40 train/test split, evaluates current description 3 times per query, proposes improvements based on failures, selects by test score (not train score) to avoid overfitting.

### How skill triggering works

Skills appear in Claude's `available_skills` list with name + description. Claude only consults skills for tasks it can't easily handle on its own — complex, multi-step queries reliably trigger; simple one-step queries may not, regardless of description quality.

## Reference files

- `agents/grader.md` — How to evaluate assertions against outputs
- `agents/comparator.md` — How to do blind A/B comparison between two outputs
- `agents/analyzer.md` — How to analyze why one version beat another
- `references/schemas.md` — JSON structures for evals.json, grading.json, etc.
