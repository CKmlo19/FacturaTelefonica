using System.Data.SqlClient;
using System.Data;
using FacturaTelefonica.Models;

namespace FacturaTelefonica.Datos
{
    public class FacturaDatos
    {
        public List<FacturaModel> ListarFacturas(string numero) {
            var oLista = new List<FacturaModel>();
            var cn = new Conexion();

            // abre la conexion
            using (var conexion = new SqlConnection(cn.getCadenaSQL()))
            {
                conexion.Open();
                // el procedure de listar
                SqlCommand cmd = new SqlCommand("dbo.ListarFacturas", conexion);
                cmd.Parameters.AddWithValue("OutResultCode", 0); // se le coloca un 0 en el outresultcode
                if(numero == null)
                {
                    numero = "";
                }
                cmd.Parameters.AddWithValue("inNumeroTelefono", numero);
      
                cmd.CommandType = CommandType.StoredProcedure;
                using (var dr = cmd.ExecuteReader()) // este se utiliza cuando se retorna una gran cantidad de datos, por ejemplo la tabla completa
                {
                    // hace una lectura del procedimiento almacenado
                    while (dr.Read())
                    {
                        oLista.Add(new FacturaModel()
                        {
                            // tecnicamente hace un select, es por eso que se lee cada registro uno a uno que ya esta ordenado
                            Id = (int)Convert.ToInt64(dr["Id"]),
                            Estado = dr["Estado"].ToString(),
                            TotalAPagar = (int)Convert.ToDecimal(dr["TotalAPagar"]),
                            FechaEmision = (DateTime)dr["FechaEmision"],
                            TotalSinIVA = (int)Convert.ToDecimal(dr["TotalSinIVA"]),
                            TotalConIVA = (int)Convert.ToDecimal(dr["TotalConIVA"]),
                        });
                    }
                }
            }


            return oLista;
        }
        public DetalleElementosCobroModel ListarDetallesFactura(int id)
        {
            var oLista = new DetalleElementosCobroModel();
            var cn = new Conexion();

            // abre la conexion
            using (var conexion = new SqlConnection(cn.getCadenaSQL()))
            {
                conexion.Open();
                // el procedure de listar
                SqlCommand cmd = new SqlCommand("dbo.ListarFacturas", conexion);
                cmd.Parameters.AddWithValue("OutResultCode", 0); // se le coloca un 0 en el outresultcode
  
                cmd.Parameters.AddWithValue("inNumeroTelefono", id);

                cmd.CommandType = CommandType.StoredProcedure;
                using (var dr = cmd.ExecuteReader()) // este se utiliza cuando se retorna una gran cantidad de datos, por ejemplo la tabla completa
                {
                    // hace una lectura del procedimiento almacenado
                    while (dr.Read())
                    {
                        // tecnicamente hace un select, es por eso que se lee cada registro uno a uno que ya esta ordenado
                        oLista.Id = (int)Convert.ToInt64(dr["Id"]);
                        oLista.TarifaBasica = dr["TarifaBasica"].ToString();
                        oLista.QMinutosExceso = (int)Convert.ToInt64(dr["QMinutosExceso"]);
                        oLista.QGigasExceso = (int)Convert.ToInt64(dr["QGigasExceso"]);
                        oLista.QFamiliar = (int)Convert.ToInt64(dr["QFamiliar"]);
                        oLista.QNocturno = (int)Convert.ToInt64(dr["QNocturno"]);
                        oLista.Llamada911 = (int)Convert.ToInt64(dr["Llamada911"]);
                        oLista.Llamada110 = (int)Convert.ToInt64(dr["Llamada110"]);
                        oLista.Llamada800 = (int)Convert.ToInt64(dr["Llamada800"]);
                        oLista.Llamada900 = (int)Convert.ToInt64(dr["Llamada900"]);
                     
                    }
                }
            }


            return oLista;
        }
    }
}
