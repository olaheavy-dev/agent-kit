# Third-party notices

agent-kit is all rights reserved (see `LICENSE` at the root of the [agent-kit repository](https://github.com/olaheavy-dev/agent-kit/blob/main/LICENSE)), except the derived material marked below, which is offered under its own licence. This file sits inside the plugin folder so that it travels with every installed copy of the plugin. Why and how this material is used: [decision 0003](https://github.com/olaheavy-dev/agent-kit/blob/main/docs/decisions/0003-stack-neutral-kit.md).

## obra/superpowers

- Source: https://github.com/obra/superpowers
- Licence: MIT License, read on 6 November 2026 from https://github.com/obra/superpowers/blob/main/LICENSE (the same text as at the reference commit below)
- Reference commit: `22f0b463e7a5e579904dd6211a520321035526f7` (tag v7.0.2, committed 3 November 2026)

The skills and changes listed below are added by later pull requests under [issue #7](https://github.com/olaheavy-dev/agent-kit/issues/7); a row describes the plan until its item exists.

### Derived (MIT applies to the whole file, including our changes)

Each of these skills carries a header in its `SKILL.md` with the copyright line below and a pointer to this file.

| Kit skill | Where the text comes from |
| --- | --- |
| `brainstorming` | The founder's copy, which started from upstream text, adapted with extension points |
| `writing-plans` | The founder's copy, which started from upstream text, adapted with extension points |
| `verification-before-completion` | Upstream's skill of the same name at the reference commit, adapted with extension points |
| `systematic-debugging` | Upstream's skill of the same name at the reference commit, adapted with extension points |

We are not certain exactly which parts of the founder's `brainstorming` and `writing-plans` text are derived from upstream. The founder's comparison dated that text to around upstream v6.4.2, so the whole of both skills is treated as derived.

### Not third-party material (inspired only, or the founder's own; all rights reserved)

| Kit material | Relationship to upstream |
| --- | --- |
| `pr-review-loop`: the "no performative agreement" and "verify before changing anything" steps | Inspired by upstream's `receiving-code-review`, written fresh |
| `guardrails` skill (preloaded into the `implementer` agent): the ledger and its status codes | Inspired by upstream's `subagent-driven-development`, written fresh |
| `pair-tdd`, `autonomous-tdd`, `guardrails` | Believed to be the founder's own. Each is compared with upstream when it is ported, and moves to "Derived" if derived text is found |

If a change copies upstream wording into any of these, it adds the header and moves the item to "Derived" in the same pull request.

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
