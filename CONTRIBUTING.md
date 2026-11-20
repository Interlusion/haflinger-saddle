# Contributing

Haflinger Saddle is maintained for our own use. Contributions are welcome; support isn't promised, and we may decline a change that doesn't fit what the app is for ([README](README.md)).

## Before you start

- **A vulnerability** goes through [SECURITY.md](SECURITY.md), never an issue.
- **A bug:** open an issue with the bug report form.
- **Something new the app should do:** open an issue with the feature form first.
- **Never attach a real invoice**, to an issue, a pull request or a test: invoices hold names, addresses, bank details and amounts. Describe the ERPNext document with placeholders such as `Example GmbH`.

What the app is not for:

- **The formats and the official rules.** How an invoice is read, validated or written, the elements of CII and UBL, and ZUGFeRD PDFs belong to the library, [Haflinger](https://github.com/Interlusion/haflinger); a change there goes to its repository. The app maps ERPNext's documents to and from Haflinger's model (HAFL-ADR-001).
- **A service of its own.** The app installs into the bench like any other app; a feature that needs more than pip installs is optional ([ADR-001](docs/arc42/adr/ADR-001-a-frappe-app.md)).

## How a change is made

1. **Decision or spec first:** a changed behaviour starts in an ADR or a spec ([docs](docs/README.md)).
2. **Tests first,** where a spec's Definition of Done describes the behaviour: the failing test is committed before the code.
3. **The code,** with the checks passing locally: `uv run mdformat --check .` and `uv audit --locked`, and with Docker `scripts/check-links.sh`, `scripts/check-workflows.sh` and `scripts/check-secrets.sh`. They need uv 0.13.7, which `pyproject.toml` pins (`required-version`) so that `uv.lock` is written the same everywhere, CI included.

[AGENTS.md](AGENTS.md), the rules for coding agents, holds the rules every change follows, such as placeholders instead of company data.

## Commits and pull requests

Commits follow [Conventional Commits](https://www.conventionalcommits.org/) with the types `feat`, `fix`, `docs`, `ci`, `chore`, `refactor` and `test`, one topic per commit. The pull request template lists what review looks for.

## Licence

Haflinger Saddle is licensed under [GPL-3.0](LICENSE), as it builds on ERPNext. A contribution you submit for inclusion is licensed under the same terms; there is no separate agreement and no sign-off line. Code taken from other GPL-3.0 apps keeps its attribution.
