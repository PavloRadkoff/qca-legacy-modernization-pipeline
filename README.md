# 🧬 QCA Framework: Deterministic Legacy Modernization

![Framework](https://img.shields.io/badge/Architecture-QCA_Framework-blue)
![Focus](https://img.shields.io/badge/Focus-Legacy_Modernization-orange)
![Tech](https://img.shields.io/badge/Target-C%23_.NET_8-success)
![Status](https://img.shields.io/badge/Status-Production_Ready-brightgreen)

**Quantitative Code Analysis (QCA)** is an engineering pipeline designed to safely extract business logic from deeply coupled legacy systems (Visual FoxPro, Delphi/Pascal, PHP) and modernize them into reliable, containerized backend architectures.

## ⚠️ The Legacy Problem
Legacy systems often suffer from **Logic-Data-UI coupling**. Business rules are hardcoded into button clicks or direct database cursors. Rewriting them manually leads to human error and loss of critical domain logic.

## ⚙️ The QCA Pipeline (How it works)
We treat legacy code as data. We do not "guess"; we sequence it.
1. 🗄️ **Parser Layer**: Scans legacy monoliths (e.g., `.prg` or `.pas` files).
2. 🧠 **Intent Extraction (LGS)**: Our AI-assisted sequencer isolates pure business rules from UI/DB artifacts, outputting structured AST/JSON.
3. 🏗️ **Rebuild Layer**: Generates domain-driven, decoupled microservices (.NET / Python) based on the extracted intent.

---

## 📂 Proof of Concept: Use Cases

### Case 1: Visual FoxPro (Asset Depreciation)
* **Legacy**: A `.prg` script mixing `USE` statements, DB loops, and financial math.
* **Extraction**: Sequencer identifies the core math: `CurrentValue = Cost - (Cost * Rate)`.
* **Modernization**: A clean .NET 8 REST API with Dependency Injection.

### Case 2: Delphi / Object Pascal (Tax Calculation)
* **Legacy**: A `.pas` file where tax calculation is locked inside a `TButton.Click` UI event.
* **Extraction**: Sequencer decouples the tax logic from the visual components.
* **Modernization**: An isolated C# Application Service with validation.