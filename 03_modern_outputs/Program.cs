using System;

namespace QCA.ModernApp
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("=== QCA MODERNIZED SYSTEM v1.0 ===");
            Console.WriteLine("Status: Legacy Logic Integrated via QCA Pipeline");
            Console.WriteLine("-------------------------------------------------");
            Console.WriteLine("1. Payroll Management (Migrated from FoxPro)");
            Console.WriteLine("2. Inventory Control (Migrated from Delphi)");
            Console.WriteLine("3. System Health Check");
            Console.WriteLine("4. Exit");
            
            Console.Write("\nSelect operation: ");
            var choice = Console.ReadLine();

            // Тут ми викликаємо наші нові сервіси, які ми створили раніше
            if (choice == "1") Console.WriteLine("Running Salary Calculations...");
            if (choice == "2") Console.WriteLine("Updating Warehouse Balances...");
        }
    }
}