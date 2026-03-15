# 5x-cto

**Spec-ops for non-coders.** $400/mo outperforms $1,000/mo.

[English](#english) | [繁體中文](#繁體中文) | [日本語](#日本語)

---

## English

> You don't need to code. You need to spec.

### What is this?

A battle-tested development methodology that lets **non-technical founders** build production-grade systems using AI.

- **Claude Opus** = Your CTO (writes specs, cuts tasks, reviews code)
- **Codex CLI** = Your engineer (writes code, runs tests, reports back)
- **You** = The product owner (says what you want in plain language)

No coding required. Seriously.

### The 5x Claim

Claude MAX plan charges Opus tokens at **~10x the rate** of lighter models. When you use Opus for everything — including writing for-loops and fixing CSS — you're paying PhD rates for manual labor.

**5x-cto splits the work:**

| Role | Who | Token Budget |
|------|-----|-------------|
| Thinking (specs, review, acceptance) | Opus (~15-20%) | Your Claude MAX |
| Building (code, debug, tests) | Codex (~80-85%) | Separate Codex budget |

**Result:** Your Claude MAX subscription stretches **5x further** because 80% of the work runs on a separate budget.

#### Cost Comparison

| Setup | Monthly Cost | Capacity | Quality |
|-------|-------------|----------|---------|
| 5x Claude MAX (all Opus) | $1,000 | Not enough | 5/5 |
| 5x Claude MAX (all Sonnet) | $1,000 | 10x more | 4/5 |
| **1x MAX + 1x Codex (5x-cto)** | **$400** | **>= all-Opus** | **5/5** |

Same quality. 60% cheaper. More capacity.

### The Real Selling Point

> **This skill IS your technical ability.**

It asks the right questions, breaks work into the right steps, and enforces quality at every gate. You only need to know **what problem you're solving** — the process guarantees the quality.

**Proven:** A non-technical founder built these production systems using this methodology:

- Production API serving 30+ external service integrations
- AI-powered analytics platform
- Multi-language AI chatbot system
- Full certification & examination platform
- E-commerce with Stripe payments, PDF certificates, QR verification

All running in production. Not demos — real revenue-generating systems.

### How It Works

You show up 3 times. AI handles the rest.

```
 You                          AI
  |                            |
  +- "I want X" ----------->  Phase R: Structures your requirements
  |                            |
  +- "Yes, that's right" -->  Phase S: Writes technical spec
  |                           Phase 1: Cuts work into cards
  |                           Phase 2-5: Auto-runs ALL cards
  |                             +- Card 1 -> Build -> Review -> PASS
  |                             +- Card 2 -> Build -> Review -> PASS
  |                             +- Card 3 -> Build -> Review -> PASS
  |                             +- ...
  |                           Phase 5.5: Total System Review
  |                            |
  +- Reviews final report <--+
```

#### Quality Gates (Built-in, Not Optional)

Every card goes through:

1. **Scope control** — Only touches files in scope. No side effects.
2. **Acceptance criteria** — Pass/fail, not "looks good"
3. **Independent verification** — Opus re-runs checks, doesn't trust self-reports
4. **Mandatory 3 checks** — Tests pass, error handling covered, commit has Card ID
5. **Rework loop** — Fail? Fix and resubmit. 3 failures = blocked, escalate.

After ALL cards complete, **Total Acceptance**:

- End-to-end flow verification
- Cross-module integration check
- Architecture consistency review
- Security audit
- Deploy readiness assessment
- Automated scoring (see `scripts/score.sh`)

### Quick Start

#### Prerequisites

- Claude Code with MAX plan ($200/mo) — set to Opus model
- OpenAI Codex CLI with Pro plan ($200/mo)

#### Install

```bash
# Copy the skill to your Claude Code skills directory
cp -r skills/5x-cto ~/.claude/skills/

# Verify
ls ~/.claude/skills/5x-cto/SKILL.md
```

#### Usage

Open Claude Code and say:

```
"I want to build a bookmark API with auth, CRUD, and search"
```

The skill activates automatically. You'll be guided through requirements, then it runs.

#### Run the Scorer

After your pipeline completes:

```bash
bash scripts/score.sh /path/to/your/project
```

### Case Studies

Real projects, real scores, built by a non-technical founder:

| Date | Project | Cards | Score | Highlights |
|------|---------|-------|-------|------------|
| 2026-03-16 | [AI Academy](case-studies/2026-03-16-ai-academy.md) | 9/9 | 92/100 | Stripe + PDF certs + i18n + 10 tests |
| 2026-03-16 | [Boss Dashboard](case-studies/2026-03-16-boss-dashboard.md) | 4/4 | 85/100 | Real-time status + 3-lang UI |

### FAQ

**Q: Do I really not need to code?**
A: Correct. You need to know what problem you're solving and who it's for. The methodology handles the rest.

**Q: What if a card fails 3 times?**
A: It's marked "blocked." The system skips it, continues with other cards, and reports the blocker. You decide: re-scope, simplify, or have Opus take over.

**Q: Is 5x really accurate?**
A: Conservative estimate. Opus handles ~20% of work (specs + review). The rest goes to Codex on a separate budget. Measured range: 5-7x depending on task type.

**Q: Can I use this with other AI tools?**
A: The methodology is model-agnostic. The skill is written for Claude + Codex, but the principles (requirement -> spec -> card -> build -> review) work with any AI coding tool.

---

## 繁體中文

> 你不需要會寫程式。你只需要會說你要什麼。

### 這是什麼？

一套經過實戰驗證的開發方法論，讓**不會寫程式的人**也能用 AI 做出生產級系統。

- **Claude Opus** = 你的技術長（寫規格、切任務、驗收程式碼）
- **Codex CLI** = 你的工程師（寫程式、跑測試、回報進度）
- **你** = 產品負責人（用人話說你要什麼就好）

不用寫程式。真的。

### 5 倍是怎麼算的？

Claude MAX 方案中，Opus 消耗額度的速度是一般模型的 **~10 倍**。當你用 Opus 做所有事情 — 包括寫迴圈和改 CSS — 等於請博士生搬磚。

**5x-cto 把工作分開：**

| 角色 | 誰做 | Token 預算 |
|------|------|-----------|
| 思考（規格、驗收、審查） | Opus（~15-20%） | 你的 Claude MAX |
| 建造（寫碼、除錯、測試） | Codex（~80-85%） | Codex 獨立額度 |

**結果：** 你的 Claude MAX 訂閱效率提升 **5 倍**，因為 80% 的工作走的是另一個預算。

#### 成本對比

| 方案 | 月費 | 容量 | 品質 |
|------|------|------|------|
| 5 個 Claude MAX（全用 Opus） | $1,000 | 不夠用 | 5/5 |
| 5 個 Claude MAX（全用 Sonnet） | $1,000 | 多 10 倍 | 4/5 |
| **1 個 MAX + 1 個 Codex（5x-cto）** | **$400** | **>= 全 Opus** | **5/5** |

一樣的品質。省 60%。容量更大。

### 真正的賣點

> **這個 Skill 本身就是你的技術能力。**

它幫你問對的問題、拆對的步驟、卡對的品質。你只需要知道**你要解什麼問題** — 流程保證品質。

**實戰驗證：** 一個完全沒有程式背景的創業者，用這套方法論建了：

- 整合 30+ 外部服務的生產級 API 系統
- AI 驅動的分析平台
- 多語言 AI 聊天機器人系統
- 完整的認證與考試平台
- 含 Stripe 付費、PDF 證書、QR 驗證的電商系統

全部在線上運行。不是 demo — 是真的在賺錢的系統。

### 怎麼運作？

你只需要出現 3 次，AI 做剩下的。

```
 你                            AI
  |                             |
  +- 「我要 X」 ------------>  Phase R: 結構化你的需求
  |                             |
  +- 「對，就是這個」 ------>  Phase S: 寫技術規格
  |                            Phase 1: 切成工作卡片
  |                            Phase 2-5: 自動跑完所有卡片
  |                              +- 卡 1 → 施工 → 驗收 → 通過
  |                              +- 卡 2 → 施工 → 驗收 → 通過
  |                              +- 卡 3 → 施工 → 驗收 → 通過
  |                              +- ...
  |                            Phase 5.5: 總驗收
  |                             |
  +- 看總驗收報告 <-----------+
```

#### 品質關卡（內建的，不是選配）

每張卡都必須通過：

1. **範圍控制** — 只碰該碰的檔案，零副作用
2. **驗收標準** — 通過/不通過，不是「看起來可以」
3. **獨立驗證** — Opus 自己重跑檢查，不相信自述報告
4. **強制三項檢查** — 測試通過、錯誤處理覆蓋、Commit 帶卡號
5. **返工循環** — 不合格？修完再交。連續 3 次不過 = 擱置，上報

所有卡完成後，進行**總驗收**：

- 端對端流程驗證
- 跨模組整合檢查
- 架構一致性審查
- 安全審計
- 部署就緒評估
- 自動跑分（見 `scripts/score.sh`）

### 案例

真實專案、真實分數，由一個沒有技術背景的創業者完成：

| 日期 | 專案 | 卡片 | 分數 | 亮點 |
|------|------|------|------|------|
| 2026-03-16 | [AI 學院](case-studies/2026-03-16-ai-academy.md) | 9/9 | 92/100 | Stripe + PDF 證書 + 三語 + 10 測試 |
| 2026-03-16 | [老闆儀表板](case-studies/2026-03-16-boss-dashboard.md) | 4/4 | 85/100 | 即時狀態 + 三語 UI |

---

## 日本語

> コードを書く必要はありません。必要なのは「何を作りたいか」を伝えることだけ。

### これは何？

**技術的な知識がない人**でも、AIを使って本番レベルのシステムを構築できる、実戦で検証された開発方法論です。

- **Claude Opus** = あなたのCTO（仕様書を書き、タスクを分割し、コードをレビュー）
- **Codex CLI** = あなたのエンジニア（コードを書き、テストを実行し、結果を報告）
- **あなた** = プロダクトオーナー（やりたいことを普通の言葉で伝えるだけ）

コーディング不要。本当です。

### 5倍とは？

Claude MAXプランでは、Opusのトークン消費速度は軽量モデルの**約10倍**。Opusでforループの記述やCSS修正まで全てやるのは、博士号を持つ人に引越し作業をさせるようなものです。

**5x-ctoは作業を分割します：**

| 役割 | 担当 | トークン予算 |
|------|------|------------|
| 思考（仕様・レビュー・検収） | Opus（約15-20%） | あなたのClaude MAX |
| 構築（コード・デバッグ・テスト） | Codex（約80-85%） | Codex独自の予算 |

**結果：** Claude MAXサブスクリプションの効率が**5倍**に。80%の作業は別予算で実行されるため。

#### コスト比較

| 構成 | 月額 | 容量 | 品質 |
|------|------|------|------|
| Claude MAX x5（全てOpus） | $1,000 | 足りない | 5/5 |
| Claude MAX x5（全てSonnet） | $1,000 | 10倍多い | 4/5 |
| **MAX x1 + Codex x1（5x-cto）** | **$400** | **全Opus以上** | **5/5** |

同じ品質。60%安い。容量は増加。

### 本当のセールスポイント

> **このSkill自体が、あなたの技術力です。**

正しい質問をし、正しいステップに分解し、各ゲートで品質を保証します。あなたが知る必要があるのは**解決したい問題だけ** — プロセスが品質を保証します。

**実績：** 技術的な経験ゼロの創業者が、この方法論で構築したもの：

- 30以上の外部サービスと連携する本番API
- AI駆動の分析プラットフォーム
- 多言語AIチャットボット
- 資格認定・試験プラットフォーム
- Stripe決済・PDF証明書・QR認証付きECシステム

全て本番稼働中。デモではなく、実際に収益を生んでいるシステムです。

### 仕組み

あなたが登場するのは3回だけ。残りはAIが処理します。

```
 あなた                         AI
  |                              |
  +- 「Xが欲しい」 --------->  Phase R: 要件を構造化
  |                              |
  +- 「そう、それ」 -------->  Phase S: 技術仕様を作成
  |                             Phase 1: 作業カードに分割
  |                             Phase 2-5: 全カードを自動実行
  |                               +- カード1 → 実装 → 検収 → 合格
  |                               +- カード2 → 実装 → 検収 → 合格
  |                               +- カード3 → 実装 → 検収 → 合格
  |                               +- ...
  |                             Phase 5.5: 総合検収
  |                              |
  +- 最終レポートを確認 <------+
```

#### 品質ゲート（内蔵・省略不可）

各カードは以下を通過する必要があります：

1. **スコープ制御** — 対象ファイルのみ変更。副作用ゼロ
2. **受入基準** — 合格/不合格。「良さそう」は不可
3. **独立検証** — Opusが自らチェックを再実行。自己申告を信用しない
4. **必須3項目チェック** — テスト合格・エラーハンドリング・Commitにカード番号
5. **やり直しループ** — 不合格？修正して再提出。3回失敗 = ブロック、エスカレーション

全カード完了後、**総合検収**を実施：

- エンドツーエンド検証
- モジュール間統合チェック
- アーキテクチャ一貫性レビュー
- セキュリティ監査
- デプロイ準備評価
- 自動スコアリング（`scripts/score.sh` 参照）

### ケーススタディ

実プロジェクト、実スコア、技術未経験の創業者が構築：

| 日付 | プロジェクト | カード | スコア | ハイライト |
|------|------------|--------|--------|-----------|
| 2026-03-16 | [AIアカデミー](case-studies/2026-03-16-ai-academy.md) | 9/9 | 92/100 | Stripe + PDF証明書 + 三言語 + テスト10件 |
| 2026-03-16 | [ボスダッシュボード](case-studies/2026-03-16-boss-dashboard.md) | 4/4 | 85/100 | リアルタイム状態 + 三言語UI |

---

## Quick Start / 快速開始 / クイックスタート

### Prerequisites / 前提條件 / 前提条件

- Claude Code + MAX plan ($200/mo)
- OpenAI Codex CLI + Pro plan ($200/mo)

### Install / 安裝 / インストール

```bash
cp -r skills/5x-cto ~/.claude/skills/
ls ~/.claude/skills/5x-cto/SKILL.md
```

### Usage / 使用 / 使い方

Open Claude Code and say what you want to build:

```
"I want to build a bookmark API with auth, CRUD, and search"
「我要做一個書籤 API，有登入、新增刪除、搜尋功能」
「ブックマークAPIを作りたい。認証、CRUD、検索機能付き」
```

### Score / 跑分 / スコアリング

```bash
bash scripts/score.sh /path/to/your/project
```

## License

MIT

---

*Built by a non-technical founder in rural Japan.*
*由一位住在日本鄉下的非技術創業者打造。*
*日本の田舎に住む非技術者の創業者が構築。*
