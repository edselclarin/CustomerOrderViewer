using CustomerOrderViewer;
using CustomerOrderViewer2_0.Models;
using Dapper;
using Microsoft.Data.SqlClient;

namespace CustomerOrderViewer2_0.Repository
{
    internal class ItemsCommand
    {
        private string _connectionStr;

        public ItemsCommand()
        {
            _connectionStr = CustomerOrderViewerConnectionString.ConnectionString;
        }

        public IList<Item> Get()
        {
            var items = new List<Item>();

            string sql = "Item_Get";

            using (var conn = new SqlConnection(_connectionStr))
            {
                conn.Open();

                // Use Dapper to run the query.
                items = conn.Query<Item>(sql).ToList();
            }

            return items;
        }
    }
}
