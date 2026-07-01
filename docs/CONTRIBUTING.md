# Contributing (WIP)

We welcome contributions that fix bugs, reduce technical debt, improve documentation or readability. If you're new, start with bug reports or "help wanted" TODO tasks from Discord. For larger ideas, discuss on Discord before writing code.

## Maintainer Capacity and Sustainability

This project is maintained by a single active developer who handles fixes, features, CI workflows, releases, community management, and pull request review.

Because maintainer time and mental capacity is a finite resource, strict enforcement of contribution standards is necessary to ensure the project remains sustainable.

These rules exist to prevent maintainer burnout and ensure the project continues to exist.

---

## Community Expectations

The project relies on mutual respect and constructive communication. Adherence to the following standards is **required**:
- **Maintainer Authority:** Maintainers **retain the final decision** on project direction, balance, design choices, and what code gets merged.
- **Merit Ladder:** New contributors must **establish a track record of reliability** by addressing open bugs, refactoring debt, or documentation needs **before** proposing design changes. Unsolicited, opinionated design overhauls from unestablished contributors **likely will be met with skepticism**.
- **Scope Realism:** Contributions must align with **current project priorities**. PRs that add complex features while ignoring critical bug backlogs create maintenance debt and **may be rejected**.
- **Constructive Communication:** Personal attacks, passive-aggressive remarks, and unconstructive criticism of the existing codebase **are not welcomed**. If a segment of code is inefficient, **propose** a concrete, actionable solution.
- **Forks:** If your vision for the project fundamentally diverges from the design philosophy established by the maintainers, you are encouraged to **fork the repository** and maintain it yourself.

Failure to follow these expectations may result in **closed pull requests** or a **restriction** from the contribution process.

---

## Pull Requests

To keep the codebase manageable and safe, PRs must be immediately understandable. If a PR is overly complex, touches too many systems, or lacks clear documentation, it cannot be safely merged.

### Submission Rules

- **Design Approval:** Changes affecting game balance, core mechanics, or user-facing features **require prior discussion and approval**. Discuss the proposal on Discord before writing code. Unapproved design changes **will likely be closed**.
- **No Code Dumps:** Monolithic feature dumps that introduce thousands of lines of code without addressing existing debt **will likely not be accepted**. Focus on incremental, testable improvements.
- **Self-Testing:** Verify that changes do not break existing functionality. Every PR must include a brief note on how you tested the change. For small fixes, "ran it locally and confirmed the bug no longer reproduces" is sufficient. For larger changes, describe what you checked and how.
- **Clarity and Documentation:** Clearly document the specific problem being solved. Maintainers **will not** untangle changes made without an explanation; such pull requests **will require a complete description rewrite** or **may be closed**.
- **Code Style:** Review and adhere to the guidelines in `CODE_STYLE.md`.

### Single Change vs. Atomic Batches

Pull requests should *ideally* address a single logical change. However, multi-system PRs are *permitted* under **strict conditions**:
- The PR must be structured as a **batch of independent, atomic commits**.
- Each commit must represent exactly **one logical change**, use **Conventional Commit** naming, and be **completely self-contained** (squashed clean of fixup commits), so that the PR can be rebase-merged.
- The maintainer must be able to **review the PR chronologically**, commit by commit, without encountering broken states between commits. 
- If a multi-system PR lacks this clean commit hygiene, you will be **required to split it** into separate branches.

### On AI-Generated Code

Pull requests generated primarily by AI tools without thorough human review, testing, and understanding of the codebase **will be treated as code dumps** and rejected. **You** are responsible for every line you submit, regardless of how it was produced.

### Review Process

- **Response Times:** Expect initial feedback within roughly a few days. If you haven't heard back after 3, a polite nudge on Discord is fine.
- **Stale Policy:** Pull requests with no activity or unresolved change requests for 14 days will be marked stale. Stale PRs are no longer considered active, other contributors are free to work in the same area without conflict avoidance, and the PR will not block parallel efforts. The PR itself may remain open or be converted to a draft at the maintainer's discretion.

---

## Getting Help

For clarifications regarding architectural decisions or contribution guidelines, reach out via the Discord server.
