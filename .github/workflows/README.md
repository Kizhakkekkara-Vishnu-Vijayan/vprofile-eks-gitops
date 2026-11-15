# GitHub Actions pipeline

[Back to project overview](../../README.md) | [Phase 5 CI/CD documentation](../../docs/ci-cd/README.md)

The live workflow is [`ci.yaml`](ci.yaml). It runs **Build → Test → Docker Build & Push → Helm Image Tag Update**. The update job commits only `app.image.tag` in Helm after publishing the image.

For documentation-only changes, see the recommended `paths-ignore` addition in the [Phase 5 README](../../docs/ci-cd/README.md#10-workflow-trigger-filters-documentation-only-changes).
