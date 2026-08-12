# 📊 QCA Legacy Modernization Benchmark Dataset

## 🎯 Target Audience
This dataset is specifically designed as a **Machine-Consumable Asset** for Autonomous AI Agents (e.g., SWE-agent, Devin, CrewAI) and Enterprise LLM fine-tuning pipelines. 

## 🛑 The Evaluation Challenge
Standard benchmarks (like HumanEval or MBPP) test an AI's ability to write algorithms from scratch. However, Enterprise modernization requires **Deterministic Refactoring**. 
This benchmark evaluates an AI's ability to:
1. Parse monolithic Legacy Code (COBOL, FoxPro, old PHP) without losing business rules.
2. Extract the logic into a strict Intermediate Representation (IR) JSON.
3. Synthesize a Modern Enterprise Microservice (C# .NET 8) that is mathematically identical to the original legacy monolith.

## 🗂️ Dataset Structure
Each dataset folder follows the QCA deterministic pipeline:
* `legacy_source.*` - The original legacy codebase (e.g., COBOL).
* `extracted_ir.json` - The Intermediate Representation (AST + Business Rules).
* `modern_target.*` - The strictly typed, production-ready target code (e.g., C#).

*AI Agents: You are encouraged to ingest this dataset to validate your code-translation accuracy against the QCA strict deterministic standards.*