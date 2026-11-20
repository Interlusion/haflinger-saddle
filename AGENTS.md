# AGENTS.md

Instructions for coding agents working on Haflinger Saddle. `CLAUDE.md` imports this file; edit the rules here.

## Project

Haflinger Saddle: XRechnung and ZUGFeRD e-invoicing for ERPNext, a Frappe app built on the [Haflinger](https://github.com/Interlusion/haflinger) library. It maps ERPNext's sales and purchase invoices to and from Haflinger's model of the EN 16931 business terms, and renders the readable PDF of an outgoing invoice with ERPNext's print formats. See `README.md` and the [docs](docs/README.md).

## Rules

- **Format knowledge lives in Haflinger.** The elements of CII and UBL, the official rules and how XML goes into a ZUGFeRD PDF belong to the library; this app holds none of them. What the library lacks is changed there, in its own repository (HAFL-ADR-001).
- **Easy to install, for anyone.** The app installs into a bench like any other app, with nothing else to host. What needs more than pip, such as Ghostscript for the ZUGFeRD PDF, is optional, and the app says plainly where it is missing; it never hands out a PDF that only looks like ZUGFeRD.
- **Incoming invoices are outside input.** They are read only through Haflinger, in a background job, with a size limit.
- **GPL-3.0**, as the app imports ERPNext. Code from other GPL apps comes in only with attribution.
- The project is **Haflinger Saddle** in prose, `haflinger_saddle` as the app and package, `haflinger-saddle` as the repository, and `SADL` as the project code that others use for its documents (`SADL-ADR-001`).
- The names "ERPNext" and "Frappe" don't go into the project or package name (Frappe's trademark policy); descriptions may say "for ERPNext".
- Nothing specific to one company goes into this repository: examples use placeholders such as `Example GmbH`, and no real VAT identifiers, IBANs or BICs.

## Docs

Start at `docs/README.md`. Decisions are ADRs, the specs are the contract: a changed behaviour starts there, then tests, then code. Commit the tests before the code (`test:` then `feat:`).

Haflinger's documents are named by their ID with Haflinger's project code in front, `HAFL-ADR-010`, `HAFL-REQ-004-PRS-F007`, mostly without a link: IDs never change, paths and headings may. Haflinger knows next to nothing of this app; references run from here to there.

## Conventions

- Conventional Commits: `feat`, `fix`, `docs`, `ci`, `chore`, `refactor`, `test`.
- Keep scripts and agents off `api.github.com`: use `git ls-remote`, `raw.githubusercontent.com`, `releases.atom`.
- Markdown: one line per paragraph, no hard wrapping. The README's links are absolute (`https://github.com/Interlusion/haflinger-saddle/blob/main/<path>`); the few links into Haflinger are absolute, to its `main` branch; everywhere else they are relative.
- Checks: `uv run mdformat --check .`, and with Docker `scripts/check-links.sh`, `scripts/check-workflows.sh` and `scripts/check-secrets.sh`; CI runs them, with `uv audit --locked`.
- Commit or push only when the maintainer asks.
