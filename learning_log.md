# Learning Log

## [2026-02-17] Initial Project Setup
- **What happened:** Starting the installation of Agent Zero AI framework.
- **The Fix:** Initializing workspace with necessary audit trail files.
- **The Lesson:** Always ensure the foundation is set before complex installations.

## [2026-02-17] Error Type: [Environment/Dependencies]
- **What happened:** PowerShell execution policy blocked `activate` script; `faiss-cpu==1.11.0` was not found.
- **The Fix:** Used `.\venv\Scripts\python.exe` directly; updated `requirements.txt` to use `>=` instead of `==`.
- **The Lesson:** Flexible versioning in requirements can prevent OS/Python version mismatches.
