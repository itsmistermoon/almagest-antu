# Source: Matt Pocock — writing-great-skills
# URL: https://github.com/mattpocock/skills/tree/main/skills/productivity/writing-great-skills
# Ingested: 2026-07-01
# Files: SKILL.md + GLOSSARY.md

---
name: writing-great-skills
description: Reference for writing and editing skills well — the vocabulary and principles that make a skill predictable.
disable-model-invocation: true
---

A skill exists to wrangle determinism out of a stochastic system. **Predictability** — the agent taking the same _process_ every run, not producing the same output — is the root virtue; every lever below serves it.

**Bold terms** are defined in GLOSSARY.md.

## Invocation

Two choices, trading different costs:

- A **model-invoked** skill keeps a **description**, so the agent can fire it autonomously _and_ other skills can reach it. It contributes to **context load** — the description sits in the window every turn. Mechanics: omit `disable-model-invocation`, write a model-facing description with rich trigger phrasing.
- A **user-invoked** skill strips the description from the agent's reach: only you, typing its name, can invoke it — and no other skill can. Zero context load, but spends **cognitive load**. Mechanics: set `disable-model-invocation: true`; the `description` becomes human-facing.

Pick model-invocation only when the agent must reach the skill on its own, or another skill must.

When user-invoked skills multiply past what you can remember, that piled-up cognitive load is cured by a **router skill**: one user-invoked skill that names the others.

## Writing the description

A model-invoked **description** does two jobs — state what the skill is, and list the **branches** that should trigger it. Every word increases **context load**, so descriptions earn even harder pruning than the body:

- **Front-load the skill's leading word**
- **One trigger per branch.** Synonyms that rename a single branch are **duplication**. Collapse them; keep only genuinely distinct branches.
- **Cut identity that's already in the body.** Keep to triggers, plus any "when another skill needs…" reach clause.

## Information hierarchy

A skill is built from two content types — **steps** and **reference** — that mix freely. The core decision is which to use and where each sits on the **information hierarchy**:

1. **In-skill step** — an ordered action in SKILL.md, the primary tier. Each step ends on a **completion criterion**: make it _checkable_ (can the agent tell done from not-done?) and _exhaustive_ ("every modified model accounted for" — a vague criterion invites **premature completion**).
2. **In-skill reference** — a definition, rule, or fact in SKILL.md, consulted on demand.
3. **External reference** — reference pushed out of SKILL.md into a separate file, reached by a **context pointer**, loaded only when the pointer fires.

Push too little down and the top bloats; push too much and you hide material the agent actually needs.

**Progressive disclosure** is the move down the ladder — out of SKILL.md into a linked file — so the top stays legible. Branching is the cleanest disclosure test: inline what every branch needs, push behind a pointer what only some branches reach.

**Co-location** decides what sits beside a piece once there: keep a concept's definition, rules, and caveats under one heading rather than scattered.

## When to split

**Granularity** is how finely you divide skills. Each cut spends one of the two loads:

- **By invocation** — split off a model-invoked skill when you have a distinct **leading word** that should trigger it on its own, or another skill must reach it. You pay **context load** for the new always-loaded description.
- **By sequence** — split a run of steps when the **post-completion steps** tempt the agent to rush the one in front of it (**premature completion**). Keeping them out of view encourages more **legwork** on the current task.

## Pruning

Keep each meaning in a **single source of truth**: one authoritative place.

Check every line for **relevance**: does it still bear on what the skill does?

Hunt **no-ops** sentence by sentence: run the no-op test on each sentence in isolation, and when one fails, delete the whole sentence. Be aggressive — most prose that fails should go, not be rewritten.

## Leading words

A **leading word** is a compact concept already living in the model's pretraining that the agent thinks with while running the skill (e.g. _lesson_, _fog of war_, _tracer bullets_). Repeated throughout the text, it accumulates a distributed definition and anchors a whole region of behaviour in the fewest tokens.

It serves predictability twice:
- In the body it anchors _execution_: the agent reaches for the same behaviour every time the word appears.
- In the description it anchors _invocation_: when the same word lives in your prompts, docs, and code, the agent links that shared language to the skill and fires it more reliably.

Hunt for opportunities to refactor skills to use leading words. Examples:
- "fast, deterministic, low-overhead" → _tight_
- "a loop you believe in" → _red_ (the loop goes _red_ on the bug, or it doesn't)

## Failure modes

- **Premature completion** — ending a step before it's genuinely done, attention slipping to _being done_. Defence: sharpen the completion criterion first; only if irreducibly fuzzy _and_ you observe the rush, hide post-completion steps by splitting.
- **Duplication** — the same meaning in more than one place. Costs maintenance and tokens, inflates a meaning's prominence past its real rank.
- **Sediment** — stale layers that settle because adding feels safe and removing feels risky. The default fate of any skill without a pruning discipline.
- **Sprawl** — a skill simply too long, even when every line is live and unique. Cure: disclose reference behind pointers, and split by branch or sequence.
- **No-op** — a line the model already obeys by default, so you pay load to say nothing. Test: does it change behaviour versus the default? A weak leading word (_be thorough_) is a no-op; the fix is a stronger word (_relentless_).

---

# GLOSSARY.md

## Predictability

The degree to which a skill makes the agent behave the same _way_ on every run — the same process, not the same output. The root virtue every other term serves.

_Avoid_: consistency, reliability, robustness, output-determinism

## Invocation

### Model-Invoked
A skill that keeps its **description** field, so the agent can see it and fire it autonomously. Pays a permanent **context load** on every turn. A model-invoked skill whose content is all **reference** can serve as shared reference home for other skills.

### User-Invoked
A skill with its **description** stripped — invisible to the agent, reachable only by the human. Zero **context load**. Because it has no description, nothing but the human can reach it — no other skill can fire it.

### Description
The skill's machine-readable trigger. Its mere presence is the invocation axis: keep it → model-invoked; delete it → user-invoked. Source of a model-invoked skill's **context load**.

### Context Pointer
A reference held in the agent's context that names out-of-context material and encodes the condition for reaching it. The **description** is the top-level context pointer. Its wording, not the target, decides _when_ the agent reaches — and _how reliably_.

### Context Load
The cost a **model-invoked** skill imposes on the agent's context window — its **description**, always loaded, spending both tokens and attention.

### Cognitive Load
The cost a **user-invoked** skill imposes on the human — what they must hold in their head. Not a cost to minimise: it is the price of human agency.

### Router Skill
A **user-invoked** skill whose job is to point at other user-invoked skills — naming each and when to reach for it. It can only hint, never fire them. The cure for **cognitive load** when user-invoked skills multiply.

### Granularity
How finely you divide skills. Two cuts guide division:
- By **invocation**: split off a model-invoked skill where you have a distinct leading word to trigger it
- By **sequence**: split a run of steps where post-completion steps need hiding

## Information Hierarchy

### Information Hierarchy
A skill's content ranked by how immediately the agent needs it. The rungs:
- **Steps** — in-file, primary
- **Reference**, in-file — secondary
- **Reference**, disclosed — behind a context pointer

### Steps
The ordered actions the agent performs — when a skill has them, the primary tier. Every step ends on a **completion criterion**.

### Reference
Material the agent refers to on demand — definitions, facts, parameters, examples, conditional instructions. Prime candidate for **progressive disclosure**.

### External Reference
**Reference** that lives outside the skill system — a plain file, no description, no steps — that any skill can point at. The only shared home two **user-invoked** skills can use.

### Progressive Disclosure
Moving **reference** down the ladder — out of SKILL.md and behind a **context pointer** — so the top stays legible. Licensed by **branching**: disclose what only some branches need, inline what every path needs.

### Co-location
Keeping the material an agent needs at once in one place — a concept's definition, rules, and caveats under a single heading.

### Sprawl
_Failure mode._ A skill that is simply too long — independent of whether lines are stale or repeated. Costs readability, maintainability, and tokens. The cure is the **information hierarchy**: push reference down, split by branch or sequence.

## Steering

### Branch
A distinct way a skill can be invoked — a case the skill handles — so different runs take different paths through it.

### Leading Word
A compact concept already living in the model's pretraining that the agent thinks with while running the skill. Repeated as a token, never as a sentence, it accumulates a distributed definition. Serves predictability twice: anchors execution in the body, anchors invocation in the description.

### Completion Criterion
The condition that tells the agent a unit of work is done. Two properties:
- **Clarity** (checkable: can the agent tell done from not-done?) — resists **premature completion**
- **Demand** (how much it requires) — sets **legwork**. "Every modified model accounted for" forces thorough work where "produce a change list" does not.

The strongest criteria are both checkable and exhaustive.

### Legwork
The work an agent does behind the scenes within a single step — reading files, exploring, digging. Raised by a **leading word** or a **completion criterion** that demands exhaustive work.

### Post-Completion Steps
The steps that follow the current step. Visible, they pull the agent forward into **premature completion**. Defence: hide them by splitting the sequence.

### Premature Completion
_Failure mode._ Ending the current step before it is genuinely done. A tug-of-war between visible **post-completion steps** (the pull forward) and the **completion criterion**'s clarity (the resistance). Sharpen the bound first; only hide later steps if the criterion is irreducibly fuzzy AND you observe the rush.

## Pruning

### Single Source of Truth
The desired state where each meaning lives in exactly one authoritative place. **Duplication** is its violation.

### Duplication
_Failure mode._ The same meaning given more than one **single source of truth**. Costs maintenance, costs tokens, and inflates prominence past the real rank.

### Relevance
Whether a line still bears on what the skill does. A line loses relevance by never bearing on the task or by going stale.

### Sediment
_Failure mode._ Layers of old content that settle in a skill and are never cleared. The default fate of any skill without a pruning discipline.

### No-Op
_Failure mode._ An instruction that changes nothing because the model already does it by default. Test: does a line change behaviour versus the default? A leading word too weak to beat the default is a no-op; the fix is a stronger word, not a different technique.
