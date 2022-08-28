using CustomerOrderViewer;
using CustomerOrderViewer2_0.Models;
using Dapper;
using Microsoft.Data.SqlClient;

namespace CustomerOrderViewer2_0.Repository
{
    internal class CustomersCommand
    {
        private string _connectionStr;

        public CustomersCommand()
        {
            _connectionStr = CustomerOrderViewerConnectionString.ConnectionString;
        }

        public IList<Customer> Get()
        {
            var items = new List<Customer>();

            string sql = "Customers_Get";

            using (var conn = new SqlConnection(_connectionStr))
            {
                conn.Open();

                // Use Dapper to run the query.
                items = conn.Query<Customer>(sql).ToList();
            }

            return items;
        }
    }
}
