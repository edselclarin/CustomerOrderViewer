namespace CustomerOrderViewer2_0.Models
{
    public class CustomerOrderDetail
    {
        public int CustomerOrderId { get; set; }
        public int CustomerId { get; set; }
        public int ItemID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }
    }
}
