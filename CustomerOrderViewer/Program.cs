using CustomerOrderViewer.Repository;

try
{
    // Run the query.
    var cmd = new CustomerOrderDetailCommand();
    var items = cmd.Get();
    if (items.Any())
    {
        // Print the header.
        var first = items.First();
        var props = first.GetType().GetProperties().Select(p => p.Name);
        Console.WriteLine(String.Join(" | ", props));

        // Print items.
        foreach (var item in items)
        {
            var values = item.GetType().GetProperties().Select(x => x.GetValue(item));
            Console.WriteLine(String.Join(" | ", values));
        }
    }
}
catch (Exception ex)
{
    Console.WriteLine(ex.InnerException != null ? ex.InnerException.Message : ex.Message);
}

