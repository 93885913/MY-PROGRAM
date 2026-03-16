Original prompt: 请你从证券交易师的角色来分析我们当前的选股策略适合做什么周期的股市预计以及这个交易策略的优缺点及改进建议

- Completed an A-share market analysis workflow using Eastmoney public pages and Playwright artifacts.
- Built and saved a reusable trading system document at `trading_strategy_template.md`.
- Kept Eastmoney browser inspection artifacts under `output/playwright/eastmoney-check/` for later review.
- Cleaned the workspace to remove earlier web-game test files and outputs so the project now focuses on stock analysis only.
- Created the first formal stock analysis report at `reports/a股分析报告_2026-03-16.md`.
- Rewrote the 2026-03-16 stock report using fresh online Eastmoney data and the newer trading-system template, including market regime, execution permission, role-based stock selection, position sizing, risk control, and next-session plans.
- Confirmed the workflow default should be `Eastmoney public pages first`, using Playwright to inspect board and stock pages before writing conclusions.
- Wrote the default rule into `docs/trading_strategy_template.md` so future analyses use webpage-by-webpage inspection unless explicitly changed.
