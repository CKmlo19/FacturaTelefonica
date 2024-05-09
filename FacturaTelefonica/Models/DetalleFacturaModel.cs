namespace FacturaTelefonica.Models
{
    public class DetalleFacturaModel
    {
        public int id { get; set; }
        public int idFactura { get; set; }
        public decimal TotalSinIVA { get; set; }
        public decimal TotalConIVA { get; set; }
        public decimal MultaPorAtraso { get; set; }
        public DateTime FechaPago { get; set; }
    }
}
