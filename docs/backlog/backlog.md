# Backlog

Quick items. Items with detail have their own file (`item-NNN-*.md`); done or rejected ones move to `archive/`.

- [ ] Is about 105 MB of Saxon acceptable in a bench, and does any target run on musl, for which there is no wheel (HAFL-ADR-006)? Moved here from Haflinger's backlog on 2026-11-20.
- [ ] Saxon in Frappe's workers: `factur-x` dropped `saxonche` 13.0.0 after it aborted inside Odoo with "Failed to enter the specified IsolateThread context" ([ITEM-002](item-002-saxonche-licence.md)). With `saxonche` 13.1.1 on Linux, `validate` gave the same findings in children forked before Saxon started and after it had compiled the rules, and in 8 threads at a time, new ones each round (checked by hand on 2026-11-01). Since 2026-11-02 Saxon runs in a worker process (HAFL-ADR-010), which a crash or a fork no longer shares with the host; Haflinger's suite tests forks, also during another thread's call, and threads (HAFL-REQ-002-PRS-NF005). Untested: gunicorn's and RQ's workers under load, in a bench with the app ([ITEM-001](item-001-invoices-in-erpnext.md)). Moved here from Haflinger's backlog on 2026-11-20.
