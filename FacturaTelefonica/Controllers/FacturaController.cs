using Microsoft.AspNetCore.Mvc;
using FacturaTelefonica.Datos;
using FacturaTelefonica.Models;
namespace FacturaTelefonica.Controllers
{

    public class FacturaController : Controller
    {
        FacturaDatos _FacturaDatos = new FacturaDatos();
        public IActionResult ListarFacturas()
        {
            return View();
        }
        [HttpPost]
        public IActionResult Listar(string numero)
        {
            var oLista = _FacturaDatos.ListarFacturas(numero);
            return View(oLista);
        }
    }
}
