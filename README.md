# GridGuard

AI Demand Scenario Simulation for U.S. Power Grid Resilience.

A user configures an AI demand scenario. The platform runs a stochastic geometric model.
It returns the regime classification, the covariance structure, and the CLT-certified
failure probability for each grid territory.

The full design is in `docs/GridGuard_TechSpec_v1.2.docx`. The working development guide
is `CLAUDE.md` — read that first if you are extending the project.

## Stack

- **Frontend:** Next.js (App Router), TypeScript, Tailwind CSS
- **Engine:** Python — numpy, scipy. Pure and unit tested.
- **API:** Python serverless functions run the engine; a Node function handles scenario CRUD
- **Deployment:** Vercel, with GitHub-based CI/CD

## Project layout

```
engine/        Python simulation engine (the core science — working and tested)
api/           Vercel serverless functions
app/           Next.js pages
components/    React dashboard components
lib/           Shared TypeScript types and the API client
data/          Sample territory data
docs/          The technical product specification
CLAUDE.md      Development guide for Claude Code
```

## Prerequisites

- Node.js 18+
- Python 3.11+

## Setup

```bash
# frontend
npm install

# engine
pip install -r engine/requirements.txt
```

## Run the engine

```bash
# run a sample scenario from the command line
python -m engine

# run the unit tests
python -m pytest engine/tests -q
```

## Run the app

```bash
npm run dev
```

Open http://localhost:3000. Set scenario parameters in the control bar and click **Run**.
The dashboard calls `/api/simulate`, the Python function runs the engine, and the result
flows to the panels.

> Local note: the Next.js dev server runs the Node API route (`api/scenarios.ts`) directly.
> The Python endpoints (`api/simulate.py`, `api/trajectory.py`, `api/infer.py`) run on
> Vercel's Python runtime. Use `vercel dev` to exercise them locally, or deploy a preview.

## Deploy

1. Push the repository to GitHub.
2. Import the repository into Vercel. Vercel detects Next.js and the Python functions
   from the file extensions and `vercel.json`.
3. Set the environment variables from `.env.example` in the Vercel project settings.
4. Every push gets a preview deployment. A merge to `main` deploys to production.

## Status

This is a scaffold. The engine is real and tested. The frontend and API are wired stubs
with clear TODOs. Build order follows the roadmap in the spec. See `CLAUDE.md` for the
priority TODO list and the per-area status table.

## Basis

The simulation engine implements the Central Limit Theorem and multivariate CLT results
for random simplicial complexes published in Akinwande & Reitzner, *Advances in Applied
Mathematics*, 2020.
