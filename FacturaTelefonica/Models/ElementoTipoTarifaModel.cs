namespace FacturaTelefonica.Models
{
    public class ElementoTipoTarifaModel
    {
        public int Id { get; set; }
        public int idTipoTarifa { get; set; }
        public int idTipoUnidad { get; set; }
        public double Valor { get; set; }
    }
}
