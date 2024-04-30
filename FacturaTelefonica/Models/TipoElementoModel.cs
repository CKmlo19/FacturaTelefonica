namespace FacturaTelefonica.Models
{
    public class TipoElementoModel
    {
        public int Id { get; set; }
        public int IdTipoUnidad { get; set; }
        public string Nombre { get; set; }
        public int Valor { get; set; }
        public bool EsFijo { get; set; }
    }
}
