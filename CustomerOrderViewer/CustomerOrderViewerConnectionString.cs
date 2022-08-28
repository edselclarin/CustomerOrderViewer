namespace CustomerOrderViewer
{
    public static class CustomerOrderViewerConnectionString
    {
        private static string _connStr = 
            @"Data Source=ITALY\SQLEXPRESS;Initial Catalog=CustomerOrderViewer;TrustServerCertificate=True;Integrated Security=True";

        public static string ConnectionString => _connStr;
    }
}
