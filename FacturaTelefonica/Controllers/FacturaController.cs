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
        public IActionResult DetallesFactura(int id)
        {  
            var olista = _FacturaDatos.ListarDetallesFactura(id);
            // solo la vista ya que es un catalogo
            return View(olista);
        }
    }
}
