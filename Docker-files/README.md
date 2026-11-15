# Docker containerization - VProfile EKS GitOps

[Back to overview](../README.md) | [Phase 5 full guide](../docs/ci-cd/README.md)

This directory holds **live Docker build files**, while `docs/ci-cd/` holds the supporting implementation evidence.

| Path | Purpose |
| --- | --- |
| [`app/Dockerfile`](app/Dockerfile) | Multi-stage Maven/JDK 21 WAR build, then Tomcat/JRE 21 runtime |
| [`db/Dockerfile`](db/Dockerfile) | MySQL image with initialization SQL |
| [`db/db_backup.sql`](db/db_backup.sql) | Demo schema initialization; do not commit production data |

The application build context is the **repository root** (`context: .`); the DB build context is `Docker-files/db`. See [workflow](../.github/workflows/ci.yaml) and [Phase 5 guide](../docs/ci-cd/README.md).

The documentation pack does **not** replace these files; use the originals already present in your project.
