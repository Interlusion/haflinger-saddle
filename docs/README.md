# Documentation

## Quick navigation

| I want to … | Read |
| :- | :- |
| Understand e-invoicing: standards, formats, who is in charge | Haflinger's [E-Invoicing 101](https://github.com/Interlusion/haflinger/blob/main/docs/guides/e-invoicing-101.md) |
| Understand how the app fits together | [Architecture](arc42/README.md) |
| Know why it is built this way | [ADRs](arc42/adr/README.md) |
| See open work | [Backlog](backlog/backlog.md): quick items, and the `item-NNN` files in the same [folder](backlog/) |

## Directories

- **`arc42/`**: the architecture, all sections in one file for now; `arc42/adr/` holds the decisions.
- **`backlog/`**: `backlog.md` for quick items, `item-NNN-*.md` for items with detail, `archive/` for done or rejected ones.

Each of these comes with its first document:

- **`specs/`**: requirement specifications, the contract: a changed behaviour starts there.
- **`guides/`**: how-tos, such as installing the app and working on it, kept current.
- **`analysis/`**: reviews and research that feed ADRs and specs, numbered `analysis-NNN-*.md`; once their findings are carried over, they move to `analysis/archive/`.

## Document status

| Document | Status |
| :- | :- |
| ADRs | Proposed until accepted; edited in place until the app's 1.0.0, superseded by new ADRs rather than rewritten from then on ([ADR index](arc42/adr/README.md)) |
| Architecture | Kept current with every change it describes |
| Analyses | Temporary; archived once their findings are carried over |
| Backlog | Living |

## Conventions

- **Generic only.** Placeholders such as `Example GmbH`, never a real company's data.
- **Plain Markdown links**, so they work on GitHub.
- **Haflinger's documents by their ID**, with Haflinger's project code in front: `HAFL-ADR-010`, `HAFL-REQ-004-PRS-F007`, `HAFL-ITEM-005`. IDs never change, so they need no link; Haflinger's [documentation](https://github.com/Interlusion/haflinger/blob/main/docs/README.md) finds them. A link into Haflinger, where a reader needs to jump, is absolute, to its `main` branch. This app's project code is `SADL`, for Haflinger and others to name its documents (`SADL-ADR-001`); within this repository, IDs go without it.
- **Source of truth:** the specs for what the app must do; the code for what it does. When docs and code disagree, fix one of them in the same change.
- Agent-drafted documents say so under Author.
