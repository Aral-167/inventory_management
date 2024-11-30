import Array "mo:base/Array";
import Option "mo:base/Option";

actor InventoryManagement {
  type Item = {
    id: Nat;
    name: Text;
    quantity: Nat;
    price: Float;
  };

  var inventory: [Item] = [];

  public func createItem(name: Text, quantity: Nat, price: Float): async Item {
    let newItem: Item = {
      id = inventory.size();
      name = name;
      quantity = quantity;
      price = price;
    };
    inventory := Array.append(inventory, [newItem]);
    return newItem;
  };

  public func readItem(id: Nat): async ?Item {
    return Array.find<Item>(inventory, func (item: Item): Bool {
      item.id == id
    });
  };

  public func updateItem(id: Nat, name: ?Text, quantity: ?Nat, price: ?Float): async ?Item {
    var found = false;
    let updatedInventory: [Item] = Array.map<Item, Item>(inventory, func (item: Item): Item {
      if (item.id == id) {
        found := true;
        {
          id = item.id;
          name = Option.get(name, item.name);
          quantity = Option.get(quantity, item.quantity);
          price = Option.get(price, item.price);
        }
      } else {
        item
      }
    });
    inventory := updatedInventory;
    if (found) {
      return await InventoryManagement.readItem(id);
    } else {
      return null;
    };
  };

  public func deleteItem(id: Nat): async ?Item {
    let itemToDelete = await InventoryManagement.readItem(id);
    if (itemToDelete != null) {
      inventory := Array.filter<Item>(inventory, func (item: Item): Bool {
        item.id != id
      });
    };
    return itemToDelete;
  };

  public func listItems(): async [Item] {
    return inventory;
  };
};
