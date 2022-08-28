using CustomerOrderViewer.Models;
using Microsoft.Data.SqlClient;

namespace CustomerOrderViewer.Repository
{
    internal class CustomerOrderDetailCommand
    {
        private string _connectionStr;

        public CustomerOrderDetailCommand()
        {
            _connectionStr = CustomerOrderViewerConnectionString.ConnectionString;
        }

        public IList<CustomerOrderDetail> Get()
        {
            var list = new List<CustomerOrderDetail>();

            using (var conn = new SqlConnection(_connectionStr))
            {
                conn.Open();

                var cmd = new SqlCommand("SELECT * FROM CustomerOrderDetail ORDER BY CustomerOrderId", conn);

                var reader = cmd.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        var item = new CustomerOrderDetail();

                        foreach (var prop in item.GetType().GetProperties())
                        {
                            prop.SetValue(item, reader[prop.Name]);
                        }

                        list.Add(item);
                    }
                }
            }

            return list;
        }
    }
}
