# Backlog

Quick items. Items with detail have their own file (`item-NNN-*.md`); done or rejected ones move to `archive/`.

- [ ] Is about 105 MB of Saxon acceptable in a bench, and does any target run on musl, for which there is no wheel (HAFL-ADR-006)? Haflinger's backlog keeps the question for HAFL-ADR-006; the app answers it, from the benches it runs in.
- [ ] Saxon in Frappe's workers: `factur-x` dropped `saxonche` 13.0.0 after it aborted inside Odoo with "Failed to enter the specified IsolateThread context" ([ITEM-002](item-002-saxonche-licence.md)). With `saxonche` 13.1.1 on Linux, `validate` gave the same findings in children forked before Saxon started and after it had compiled the rules, and in 8 threads at a time, new ones each round (checked by hand on 2026-11-01). Since 2026-11-02 Saxon runs in a worker process (HAFL-ADR-010), which a crash or a fork no longer shares with the host; Haflinger's suite tests forks, also during another thread's call, and threads (HAFL-REQ-002-PRS-NF005). Untested: gunicorn's and RQ's workers under load, in a bench with the app ([ITEM-001](item-001-invoices-in-erpnext.md)). Haflinger's backlog keeps the question for HAFL-ADR-010; the app runs the check in a bench.
- [ ] ADR-002, the toolchain: the ERPNext versions supported, Haflinger's version range while it is at 0.x, tests of the mapping without a bench and a few in a real one, uv and ruff beside what `bench new-app` generates, and a JavaScript linter; today's `pyproject.toml`, which holds only the checks' tools, is merged with the one `bench new-app` writes.
- [ ] With the first Python code: a test that the ADR index lists every ADR with its status and date, as Haflinger's `tests/unit/test_docs.py` does.
- [ ] With the code: a development guide, and an ERPNext site for end-to-end tests, locally and in CI.
- [ ] Before the first release: `CHANGELOG.md`, a releasing guide and a release workflow; the pull request template then asks for the changelog entry.
- [ ] The logo and the social preview, once the image exists.
- [ ] `THIRD-PARTY-NOTICES`, if code from another GPL-3.0 app comes in, with its attribution.
