using CustomerOrderViewer2_0.Repository;

try
{
    Console.Write("Enter your name: ");
    string userId = Console.ReadLine();

    bool exit = false;

    do
    {
        Console.WriteLine();
        Console.WriteLine(
            "OPTIONS" + Environment.NewLine +
            "1 - Show All" + Environment.NewLine +
            "2 - Upsert Customer Order" + Environment.NewLine +
            "3 - Delete Customer Order" + Environment.NewLine +
            "4 - Exit" + Environment.NewLine);
        Console.Write("Option? ");
        string line = Console.ReadLine();
        Console.WriteLine();

        if (int.TryParse(line, out int option))
        {
            switch (option)
            {
                case 1:
                    ShowAll();
                    break;
                case 2:
                    UpsertCustomerOrder(userId);
                    break;
                case 3:
                    DeleteCustomerOrder(userId);
                    break;
                case 4:
                    exit = true;
                    break;
                default:
                    Console.WriteLine("Unknown option.");
                    break;
            }
        }
    }
    while (!exit);
}
catch (Exception ex)
{
    Console.WriteLine(ex.InnerException != null ? ex.InnerException.Message : ex.Message);
}

void DeleteCustomerOrder(string userId)
{
    Console.Write("Enter CustomerOrderId: ");
    string line = Console.ReadLine();
    Console.WriteLine();

    if (!int.TryParse(line, out int customerOrderId))
    {
        Console.WriteLine("Invalid CustomerOrderId.");
        return;
    }

    var cmd = new CustomerOrderCommand();

    cmd.Delete(customerOrderId, userId);
}

void UpsertCustomerOrder(string userId)
{
    Console.WriteLine("NOTE: For new entries use CustomerOrderId = -1.");

    Console.Write("Enter CustomerOrderId: ");
    string line1 = Console.ReadLine();
    if (!int.TryParse(line1, out int customerOrderId))
    {
        Console.WriteLine("Invalid CustomerOrderId.");
        return;
    }

    Console.Write("Enter CustomerId: ");
    string line2 = Console.ReadLine();
    if (!int.TryParse(line2, out int customerId))
    {
        Console.WriteLine("Invalid CustomerId.");
        return;
    }

    Console.Write("Enter ItemId: ");
    string line3 = Console.ReadLine();
    if (!int.TryParse(line3, out int itemId))
    {
        Console.WriteLine("Invalid ItemId.");
        return;
    }

    var cmd = new CustomerOrderCommand();

    cmd.Upsert(customerOrderId, customerId, itemId, userId);
}

void ShowAll()
{
    Console.WriteLine("Orders");
    Console.WriteLine();
    DisplayOrders();
    Console.WriteLine();

    Console.WriteLine("Customer");
    Console.WriteLine();
    DisplayCustomers();
    Console.WriteLine();

    Console.WriteLine("Items");
    Console.WriteLine();
    DisplayItems();
    Console.WriteLine();
}

void DisplayItems()
{
    var itemsCmd = new ItemsCommand();
    var items = itemsCmd.Get();
    DisplayList(items);
}

void DisplayCustomers()
{
    var customersCmd = new CustomersCommand();
    var customers = customersCmd.Get();
    DisplayList(customers);
}

void DisplayOrders()
{
    var ordersCmd = new CustomerOrderCommand();
    var orders = ordersCmd.Get();
    DisplayList(orders);
}

void DisplayList<T>(IList<T> items)
{
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
    else
    {
        Console.WriteLine("List is empty.");
    }
}