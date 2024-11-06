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
                SqlCommand cmd = new SqlCommand("dbo.ListarEmpleado", conexion);
                cmd.Parameters.AddWithValue("OutResultCode", 0); // se le coloca un 0 en el outresultcode
                
                cmd.Parameters.AddWithValue("inCodigo", numero);
      
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
                            Estado = dr["NombrePuesto"].ToString(),
                            TotalAPagar = (int)Convert.ToDecimal(dr["IdPuesto"]),
                            FechaEmision = (DateTime)dr["ValorDocumentoIdentidad"]
                        });
                    }
                }
            }


            return oLista;
        }
    }
}
