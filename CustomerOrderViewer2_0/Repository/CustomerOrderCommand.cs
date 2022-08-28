using CustomerOrderViewer;
using CustomerOrderViewer2_0.Models;
using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;

namespace CustomerOrderViewer2_0.Repository
{
    internal class CustomerOrderCommand
    {
        private string _connectionStr;

        public CustomerOrderCommand()
        {
            _connectionStr = CustomerOrderViewerConnectionString.ConnectionString;
        }

        public void Upsert(int customerOrderId, int customerId, int itemId, string userId)
        {
            string sql = "CustomerOrderDetail_Upsert";

            var dt = new DataTable();
            
            dt.Columns.Add("CustomerOrderId", typeof(int));
            dt.Columns.Add("CustomerId", typeof(int));
            dt.Columns.Add("ItemId", typeof(int));
            
            dt.Rows.Add(customerOrderId, customerId, itemId);

            using (var conn = new SqlConnection(_connectionStr))
            {
                conn.Execute(
                    sql,
                    new
                    {
                        @CustomerOrderType = dt.AsTableValuedParameter("CustomerOrderType"),
                        @UserId = userId
                    }, 
                    commandType: CommandType.StoredProcedure);
            }
        }

        public void Delete(int customerOrderId, string userId)
        {
            string sql = "CustomerOrderDetail_Delete";
        
            using (var conn = new SqlConnection(_connectionStr))
            {
                conn.Execute(
                    sql, 
                    new 
                    { 
                        @CustomerOrderId = customerOrderId,
                        @UserId = userId
                    },
                    commandType: CommandType.StoredProcedure);
            }
        }

        public IList<CustomerOrderDetail> Get()
        {
            var items = new List<CustomerOrderDetail>();

            string sql = "CustomerOrderDetail_Get";

            using (var conn = new SqlConnection(_connectionStr))
            {
                conn.Open();

                // Use Dapper to run the query.
                items = conn.Query<CustomerOrderDetail>(sql).ToList();
            }

            return items;
        }
    }
}
