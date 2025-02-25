@isTest
public class TestDataFactory {
    
    public static Account createTestAccount1() {
        Account testAccount1 = new Account(Name = 'Test Account 1');
        insert testAccount1;
        return testAccount1;
    }

    public static Account createTestAccount2() {
        Account testAccount2 = new Account(Name = 'Test Account 2');
        insert testAccount2;
        return testAccount2;
    }

    public static List<Product2> createTestProductList() {
        List<Product2> testProductsList = new List<Product2>();
        testProductsList.add(new Product2(Name = 'Produit 1'));
        testProductsList.add(new Product2(Name = 'Produit 2'));
        testProductsList.add(new Product2(Name = 'Produit 3'));
        insert testProductsList;
        return testProductsList;
    }
    
    public static List<PricebookEntry> createPricebookEntryList(List<Product2> testProductsList) {
        Id pricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        pbeList.add(new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = testProductsList[0].Id, UnitPrice = 100, IsActive = true));
        pbeList.add(new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = testProductsList[1].Id, UnitPrice = 200, IsActive = true));
        pbeList.add(new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = testProductsList[2].Id, UnitPrice = 300, IsActive = true));
        insert pbeList;
        return pbeList;
    }

    public static List<Order> createTestOrderList(Integer nbOfOrders, Id accountId, Id pricebookId, String status) {
        List<Order> orderList = new List<Order>();
        for(Integer i = 0; i<nbOfOrders; i++) {
            orderList.add(new Order(
                AccountId = accountId,
                EffectiveDate = Date.today(),
                Status = status,
                Pricebook2Id = pricebookId
            ));
        }
        insert orderList;
        return orderList;
    }

    public static List<OrderItem> createTestOrderItemList(List<Order> ordersList, List<PricebookEntry> pbeList) {
        List<OrderItem> orderItemList = new List<OrderItem>();
        for(Order order : ordersList) {
            orderItemList.add(new OrderItem(
                OrderId = order.Id,
                PricebookEntryId = pbeList[0].Id,
                Quantity = 3,
                UnitPrice = pbeList[0].UnitPrice
            ));
            orderItemList.add(new OrderItem(
                OrderId = order.Id,
                PricebookEntryId = pbeList[1].Id,
                Quantity = 5,
                UnitPrice = pbeList[1].UnitPrice
            ));
            orderItemList.add(new OrderItem(
                OrderId = order.Id,
                PricebookEntryId = pbeList[2].Id,
                Quantity = 2,
                UnitPrice = pbeList[2].UnitPrice
            ));
        }
        insert orderItemList;
        return orderItemList;
    }
}