# 🛡️ eBPF Shadow Sentinel

## 🔬 Zero-Overhead Kernel Telemetry
To mathematically prove that our modernized C# .NET 8 code performs flawlessly compared to the legacy system, QCA Framework utilizes **eBPF (Extended Berkeley Packet Filter)** for Shadow Testing.

Instead of modifying the application code to track performance (which introduces overhead), we attach probes directly to the Linux Kernel. We monitor the exact I/O latency and system calls of both the legacy FoxPro/DBF process and the new PostgreSQL process simultaneously.

## 🛠️ Requirements
* Linux Kernel 4.15+ (Ubuntu 20.04 LTS or 22.04 LTS recommended)
* `bcc` (BPF Compiler Collection)
* Python 3.8+

This proof-of-concept script intercepts Virtual File System (VFS) read operations to compare the disk read latencies between legacy flat-files and modern transactional databases.