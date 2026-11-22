# MCP Builder & Prompt Engineering

Clean-room playbook for designing and building MCP (Model Context
Protocol) servers and the prompts that drive them: small, safe tools
an agent can call, with schemas a model can actually use.

## 1. Tool design
- One tool, one job, named as a verb phrase. A tool that needs a
  paragraph of caveats to use safely is two tools or a redesign.
- Schemas: typed parameters, enums over free text wherever the real
  options are bounded, explicit units and formats in descriptions,
  sane defaults stated in the schema (not hidden in prose).
- Least privilege by construction: read and write are separate tools;
  destructive operations are separate tools with explicit scope
  parameters; credentials come from the host's secure storage, never
  from tool arguments, prompts, or files the server ships.
- Errors are data: return structured failures (what failed, whether
  retrying is safe, what would fix it) instead of stack traces or
  silent empties.

## 2. Server build & test
- Start from the official SDK for the language; keep transport boring
  (stdio for local, authenticated HTTP for remote).
- Test harness before polish: a scripted client that calls every tool
  with valid input, invalid input, and boundary input; record outputs
  as fixtures so regressions are diffable.
- Idempotency and timeouts are designed in, not patched: retried
  calls must not double-apply effects.
- Docs ship with the server: each tool's purpose, example call, and
  what it must never be used for.

## 3. Prompt engineering patterns
- Structure: role/task, context, constraints, output contract, and
  examples — in that order, each section earning its tokens.
- Few-shot examples drawn from the real task distribution, including
  one example of refusing/clarifying when input is insufficient.
- Evals before vibes: a small fixed test set of prompts with expected
  properties; a prompt change that is not re-run against the set is
  an untested change.
- Version prompts like code: keep the old version, note what changed
  and why.

## Rules
- A new MCP connection is a new trust decision: the user approves the
  server, its source, and its tool list before it is connected
  (follow `custom_connector_setup` for the connection flow).
- Never build a tool whose purpose is harvesting credentials,
  bypassing another service's access controls, or hiding actions
  from the user. If a design needs secrecy from its own user, stop.
- Prefer boring, inspectable implementations: if the user cannot read
  what the server does, it does not ship.
