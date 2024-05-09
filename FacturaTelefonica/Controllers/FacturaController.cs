using Microsoft.AspNetCore.Mvc;
using FacturaTelefonica.Datos;
using FacturaTelefonica.Models;
namespace FacturaTelefonica.Controllers
{
    public class FacturaController : Controller
    {
        public IActionResult Portal()
        {
            return View();
        }
    }
}
