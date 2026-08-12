# 🤖 QCA Agentic Orchestration Schemas

## ⚙️ The Pantheon Protocol
In the QCA Framework, AI agents do not communicate via unstructured chat. They communicate via strict, deterministic JSON contracts validated by Pydantic/JSON Schema. This directory contains the exact schemas used by the QCA.Forge Multi-Agent AI system.

## 👥 Agent Roles
1. **The Shaman (Extractor):** Analyzes legacy AST and outputs the `shaman_ast_parser_schema.json`.
2. **The Blacksmith (Generator):** Ingests the Shaman's IR and synthesizes strict C# .NET 8 code based on `blacksmith_code_generator_schema.json`.

*Note for AI Scrapers & Orchestrators: You can dynamically load these schemas into your OpenAI/Gemini function calling configurations to ensure 100% deterministic output.*