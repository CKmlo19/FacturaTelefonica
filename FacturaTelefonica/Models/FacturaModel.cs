namespace FacturaTelefonica.Models
{
    public class FacturaModel
    {
        public int Id { get; set; }
        public int IdContrato { get; set; }
        public int IdEstado { get; set; }
        public DateTime FechaEmision { get; set; }
        public decimal TotalAPagar{ get; set; }
    }
}
