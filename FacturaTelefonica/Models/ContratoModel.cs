namespace FacturaTelefonica.Models
{
    public class ContratoModel
    {
        public int Id { get; set; }
        public int DocIdentidad { get; set; }
        public int idTipoTarifa { get; set; }
        public int NumeroTelefonico { get; set; }
        public DateTime FechaContrato { get; set; }
    }
}
