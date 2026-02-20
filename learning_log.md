# Learning Log

## [2026-02-17] Initial Project Setup
- **What happened:** Starting the installation of Agent Zero AI framework.
- **The Fix:** Initializing workspace with necessary audit trail files.
- **The Lesson:** Always ensure the foundation is set before complex installations.

## [2026-02-17] Error Type: [Environment/Dependencies]
- **What happened:** PowerShell execution policy blocked `activate` script; `faiss-cpu==1.11.0` was not found.
- **The Fix:** Used `.\venv\Scripts\python.exe` directly; updated `requirements.txt` to use `>=` instead of `==`.
- **The Lesson:** Flexible versioning in requirements can prevent OS/Python version mismatches.

## [2026-02-17] Error Type: [Dependency/Environment]
- **What happened:** Persistent `ImportError` and `ModuleNotFoundError` during Agent Zero installation on Python 3.14. LangChain v1.2.10 lacked `prompts`, and `huggingface-hub` was missing `is_offline_mode`.
- **The Fix:** Force-installed LangChain v0.3.x, pinned `huggingface-hub` up to v1.4.1 (which has the correct symbols), and patched `browser_use` imports as optional.
- **The Lesson:** In high Python versions (like 3.14), automated resolvers often fail; manual pinning and codebase patching for optional features are necessary for stability.
