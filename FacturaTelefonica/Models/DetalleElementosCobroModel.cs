using System.Security.Permissions;

namespace FacturaTelefonica.Models
{
    public class DetalleElementosCobroModel
    {
        public int Id { get; set; }
        public int IdDetalleFactura { get; set; }
        public string? TarifaBasica { get; set; }
        public int QMinutosExceso { get; set; }
        public int QGigasExceso { get; set; }
        public int QFamiliar { get; set; }
        public int QNocturno { get; set; }
        public int Llamada911 { get; set; }
        public int Llamada110 { get; set; }
        public int Llamada900 { get; set; }
        public int Llamada800 { get; set; }
    }
}
