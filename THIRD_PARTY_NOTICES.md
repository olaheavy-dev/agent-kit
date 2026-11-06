# Third-party notices

agent-kit is all rights reserved (see [LICENSE](LICENSE)), except for the third-party material listed here, which stays under its own licence. Why and how this material is used: [decision 0003](docs/decisions/0003-stack-neutral-kit.md).

## obra/superpowers

- Source: https://github.com/obra/superpowers
- Licence: MIT License, read on 6 November 2026 from https://github.com/obra/superpowers/blob/main/LICENSE (the same text as at the reference commit below)
- Reference commit: `22f0b463e7a5e579904dd6211a520321035526f7` (tag v7.0.2, committed 3 November 2026)

### What in agent-kit comes from it

| Kit skill | Relationship to upstream |
| --- | --- |
| `brainstorming` | Derived: adapted from the founder's copy, which started from upstream text. Carries the MIT header. |
| `writing-plans` | Derived: adapted from the founder's copy, which started from upstream text. Carries the MIT header. |
| `verification-before-completion` | Inspired by the upstream skill of the same name, written fresh. |
| `systematic-debugging` | Inspired by the upstream skill of the same name, written fresh. |
| `pr-review-loop` (the "no performative agreement" and "verify before changing anything" steps) | Inspired by upstream's `receiving-code-review`, written fresh. |
| `pair-tdd`, `autonomous-tdd`, `guardrails` | Believed to be the founder's own. Each is compared with upstream when it is ported, and moves to "Derived" if derived text is found. |

These skills are added by later pull requests under [issue #7](https://github.com/olaheavy-dev/agent-kit/issues/7); a row describes the plan until its skill exists.

We are not certain exactly which parts of the founder's `brainstorming` and `writing-plans` text are derived from upstream. The founder's comparison dated that text to around upstream v6.4.2, so the whole of both skills is treated as derived.

### Licence text

```text
MIT License

Copyright (c) 2025 Jesse Vincent

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
