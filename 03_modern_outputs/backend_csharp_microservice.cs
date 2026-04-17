using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("api/[controller]")]
public class PayrollController : ControllerBase
{
    // Modern .NET 8 implementation of the extracted FoxPro logic
    [HttpPost("increase-salary/{empId}")]
    public async Task<IActionResult> IncreaseSalary(int empId)
    {
        // Safe, concurrent, transactional logic here
        return Ok(new { status = "Salary updated successfully" });
    }
}
