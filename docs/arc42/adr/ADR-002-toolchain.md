# ADR-002: Toolchain: ERPNext 16, Haflinger within a minor version, the mapping tested without a bench

| Meta | Value |
| :- | :- |
| **Status** | Proposed |
| **Date** | 2026-11-20 |
| **Author** | loxy (drafted with Claude) |

## Context

The app installs into a bench ([ADR-001](ADR-001-a-frappe-app.md)): bench installs it with pip into the bench's Python environment, next to Frappe, ERPNext and Haflinger. It is maintained mostly by agents with a person reviewing, who need fast, strict checks that run the same everywhere, as Haflinger's do (HAFL-ADR-002).

What the versions allow (read from Frappe's and ERPNext's `pyproject.toml` on 2026-11-20):

- Frappe 16 requires Python `>=3.14,<3.15`, ERPNext 16 `>=3.14`; Frappe 15 accepts `>=3.10,<3.15`, ERPNext 15 `>=3.10`. Haflinger requires 3.14 (HAFL-ADR-002).
- An app names the Frappe versions it runs on in `[tool.bench.frappe-dependencies]`, which bench checks when it installs the app; ERPNext 16 names `frappe = ">=16.60.0,<17.0.0"`.
- Haflinger is at 0.x, where a minor version may change the API (HAFL-ADR-013).

What `bench new-app` writes on Frappe 16:

- a `pyproject.toml` with `flit_core`, the version in the package's `__init__.py`, `requires-python = ">=3.14"`, `[tool.bench.dev-dependencies]`, Frappe Cloud's system packages in the older `[deploy.dependencies.apt]` table, and ruff with Frappe's style: tabs, lines of 110;
- a pre-commit configuration with ruff, prettier and eslint;
- a CI workflow that sets up a bench with MariaDB and Redis, installs the app into a new site and runs `bench run-tests`, and a linter workflow that runs Frappe's semgrep rules.

Frappe's tests need a site, with MariaDB and Redis, which takes minutes to set up. The mapping between ERPNext's documents and Haflinger's model is where most of the app's errors would be ([ITEM-001](../../backlog/item-001-invoices-in-erpnext.md)).

## Decision

- **ERPNext 16 and Frappe 16**, named in `[tool.bench.frappe-dependencies]` with an upper bound below 17; the lower bounds are the versions the app is first tested on. ERPNext 17 comes as a change of these bounds, tested like any other.
- **Python 3.14**, `requires-python = ">=3.14"` as bench writes it, and `.python-version`.
- **Haflinger within one minor version**: `haflinger[pdf]>=0.2,<0.3` while it is at 0.x, raised by hand after reading Haflinger's changelog, as a change of its own. From Haflinger 1.0.0, within one major version.
- **The mapping in plain Python**: the modules that turn ERPNext's documents into Haflinger's model and back take and return plain data, such as a document's `as_dict()`, and import nothing of Frappe or ERPNext. pytest tests them with uv, without a bench, in seconds, and basedpyright checks them strictly.
- **A thin Frappe layer**: hooks, custom fields, buttons, background jobs and database access, tested with Frappe's runner in a bench with ERPNext, MariaDB and Redis, locally and in CI as `bench new-app`'s workflow does; the ZUGFeRD PDF there with Ghostscript, checked with veraPDF ([ADR-001](ADR-001-a-frappe-app.md)).
- **What bench writes, kept where Frappe needs it**: `flit_core` and the version in `__init__.py`; Frappe's semgrep rules in CI, pinned to a commit, for what they find in Frappe apps, such as whitelisted methods without permission checks and SQL built from strings. Frappe Cloud's system packages go into the current `[tool.frappe-cloud]` table ([ADR-001](ADR-001-a-frappe-app.md)), not the older one.
- **ruff as in Haflinger**: 4 spaces, lines of 100 and Haflinger's strict rule set, which catches mistakes such as a bare `except` or SQL built from strings before review. Files Frappe generates in tabs are reformatted once; the type hints Frappe writes into a DocType's controller keep the file's indentation, so saving a DocType doesn't undo it. Two settings for Frappe: `typing-modules = ["frappe.types.DF"]`, so that ruff reads `DF.Literal["Draft", "Sent"]` in those hints as `Literal`, and the pytest rules off for the Frappe layer's tests, which are unittest classes.
- **uv beside bench**: uv locks the development tools and the dependencies the mapping's tests need, and runs the checks, as in Haflinger: mdformat, the link, workflow and secrets checks, and `uv audit` of the lock. Today's `pyproject.toml`, which holds only the checks' tools, is merged with the one `bench new-app` writes.
- **JavaScript** for the buttons in ERPNext's forms: prettier and eslint, as bench configures them, from the first JavaScript file on.

## Alternatives Considered

### Alternative 1: Frappe's tooling alone

Every test with `bench run-tests` in a site, checks through pre-commit, no uv.

**Rejected because**: every test, the mapping's included, would wait for a site that takes minutes to set up, and the mapping changes most often. Agents need checks that run in seconds.

### Alternative 2: ERPNext 15 too

**Rejected because**: Haflinger needs Python 3.14, at the top of what Frappe 15 accepts; supporting 15 means a second bench in CI and a second set of versions for every change, for benches that would have to move to Python 3.14 first.

### Alternative 3: Frappe's style, tabs, lines of 110 and Frappe's loose rule set

As `bench new-app` configures ruff, with about 20 rules off, among them unused imports and `raise` without `from`.

**Rejected because**: the code is written mostly by agents, whom strict rules help most, and one style across Haflinger and the app carries code, reviews and configuration over; the formatter turns what Frappe generates, and what Frappe's developers contribute, into it.

### Alternative 4: Haflinger without an upper bound

**Rejected because**: while Haflinger is at 0.x, a minor version may change the API, and an update in the bench would break the app without a change of its own.

## Consequences

### Positive

- The mapping, where most errors would be, is tested in seconds, without a bench.
- The app installs like a Frappe app for bench and Frappe Cloud, and its code reads like Haflinger's.
- An update of Haflinger reaches the app only when it is tested with it.

### Negative

- Two test runners, pytest and Frappe's, and CI that sets up a bench.
- Files Frappe generates, and code taken from Frappe or ERPNext, are reformatted to spaces.
- Haflinger's bound is raised by hand with each of its minor versions.

## Reconsideration Triggers

1. ERPNext 17 is released, or Frappe changes the Python version it requires.
2. Haflinger reaches 1.0.0.
3. The mapping can't be kept free of Frappe without copying what Frappe computes, such as taxes or rounding.

## Compliance

- The mapping's modules SHALL NOT import Frappe or ERPNext.
- The Haflinger requirement SHALL have an upper bound below its next minor version while it is at 0.x.
- CI SHALL run the mapping's tests without a bench, and the Frappe layer's in a bench with ERPNext.

## References

- [ADR-001](ADR-001-a-frappe-app.md), [ITEM-001](../../backlog/item-001-invoices-in-erpnext.md)
- HAFL-ADR-002, HAFL-ADR-013, among [Haflinger's ADRs](https://github.com/Interlusion/haflinger/blob/main/docs/arc42/adr/README.md)
