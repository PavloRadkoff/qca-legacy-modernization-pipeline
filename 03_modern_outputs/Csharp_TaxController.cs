using Microsoft.AspNetCore.Mvc;

namespace Enterprise.Invoicing.Api
{
    [ApiController]
    [Route("api/v1/tax")]
    public class TaxController : ControllerBase
    {
        [HttpPost("calculate")]
        public IActionResult CalculateTax([FromBody] TaxRequestDto request)
        {
            // Business rules isolated from UI
            decimal taxRate = request.IsExport ? 0.0m : 0.20m;
            
            decimal taxableAmount = request.SubTotal - request.Discount;
            decimal finalTax = taxableAmount * taxRate;

            if (finalTax < 0) finalTax = 0;

            return Ok(new 
            { 
                Status = "Success", 
                CalculatedTax = finalTax 
            });
        }
    }

    public record TaxRequestDto(decimal SubTotal, decimal Discount, bool IsExport);
}