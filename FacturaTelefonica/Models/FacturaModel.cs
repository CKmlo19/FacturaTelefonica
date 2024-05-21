namespace FacturaTelefonica.Models
{
    public class FacturaModel
    {
        public int Id { get; set; }
        public int IdContrato { get; set; }
        public int IdEstado { get; set; }
        public string? Estado { get; set; }
        public DateTime FechaEmision { get; set; }
        public decimal TotalAPagar{ get; set; }
        public decimal TotalSinIVA { get; set; }
        public decimal TotalConIVA { get; set; }
        public decimal MultaPorAtraso { get; set; }
        public DateTime FechaPago { get; set; }
        public int TarifaBase { get; set; }
        public int QMinutosExceso { get; set; }
        public int QGigasExceso { get; set; }
        public int QFamiliar { get; set; }
        public int QNocturo { get; set; }
        public int Llamada911 { get; set; }
        public int Llamada110 { get; set; }
        public int Llamada900 { get; set; }
        public int Llamada800 { get; set; }
    }
}
