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
            var oLista = _FacturaDatos.ListarFacturas("");
            return View(oLista);
        }
        [HttpPost]
        public IActionResult ListarFacturas(string numero)
        {
            var oLista = _FacturaDatos.ListarFacturas(numero);
            return View(oLista);
        }
        public IActionResult DetallesFactura()
        {  
            var olista = _FacturaDatos.ListarDetalleFactura();
            // solo la vista ya que es un catalogo
            return View();
        }
    }
}
