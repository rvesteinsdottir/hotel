# What classes does each implementation include? Are the lists the same?

Impl A includes classes CartEntry, ShoppingCart, and Order. Impl B also includes CartEntry, Shopping Cart, and Order. The lists are the same.

# Write down a sentence to describe each class.

CartEntry is a class that stores information on unit_price and quantity. ShoppingCart is a class that stores informaton on all cart entries in an instance of shopping cart. Order totals the prices of all cart entries in the shopping cart (unit_price times unit_quantity) and then returns the total_price by multiplying the total price of all cart entries plus the total sales tax.

# How do the classes relate to each other? It might be helpful to draw a diagram on a whiteboard or piece of paper.

An order contains one instance of a shopping cart. A shopping cart, contains one or many cart entries.

# What data does each class store? How (if at all) does this differ between the two implementations?

In Impl A and Impl B, CarEntry stores unit_price and quantity. ShoppingCart stores entries, Order stores SALES_TAX and cart. The classes store the same instance variables in constants for both implementations.

# What methods does each class have? How (if at all) does this differ between the two implementations?

In Impl A, CartEntry and ShoppingCart classes do not have any methods orther than readers, writers, and initializers. Order has a method called total_price which references each entry within the cart (and the unit price and quantity of each entry) to calculate total price. In Impl B, CartEntry has a price method and ShoppingCart has a price method. Order has a total_price method but only needs to reference the price method in the cart to calculate total price.

# Consider the Order#total_price method. In each implementation:
  # Is logic to compute the price delegated to "lower level" classes like ShoppingCart and CartEntry, or is it retained in Order?

  In Impl A the Order#total_price method delegates to CartEntry to calculate price, which is two levels below the Order class. In Impl B, the Order#total_price method delagates to ShoppingCart which is one level below the Order class.

  # Does total_price directly manipulate the instance variables of other classes?

  In Impl A, Order#total_price directly manipulates the instance variables of CartEntry, while in Impl B, Order#total_price does not manipulate the instance variables of other classes.

# If we decide items are cheaper if bought in bulk, how would this change the code? Which implementation is easier to modify?

For each implementation you would add a method that would calculate the appropriate value for the unit_price instance variable based on quantity.

# Which implementation better adheres to the single responsibility principle?

Impl B better adheres to the single responsibility principle because each class is in charge of one thing. In this implementation, CartEntry calculates the price of the cart entry, ShoppingCart calculates the price of all cart entries and Order calculates the total price. Also, all logic is delegated to lower level classes. CartEntry calculates the price for the CartEntry and ShoppingCart calculates the price for all cart entries. This way Order does not need to manipulate the CartEntry instance variables directly to calculate total_price. Impl A does not implement single responsibility because the Order class is a "master" class that is in charge of all behavior. The Order class does not delegate logic to lower level classes.

# Bonus question once you've read Metz ch. 3: Which implementation is more loosely coupled?

Impl B is more loosely coupled because the higher level classes have fewer dependencies on lower level classes. In Impl A, the Order class needs to know how a ShoppingCart is organized and what information is stored within a CartEntry in order to calculate total price. This means the classes are not loosely coupled. In Impl B, the Order class only needs to know that ShoppingCart has a price, but does not need to know anything about the ShoppingCart or CartEntry classes beyond that. So Impl B is loosely coupled.

# Hotel Redesign
Add code to reduce the following lines of code, found in two places in hotel_system.rb:
  @rooms[room_id - 1].dates_reserved << {start: start_date, end: end_date}
This code should delegate this behavior to the Room class so that HotelSystem can have less information about how the Room class works.

Change this test so that HotelSystem and Block classes are more loosely coupled:
  if block.available_room_numbers.include?(room_id)
Delegate behavior of finding if the list of available room #s includes room_id to the Block class so HotelSystem can have less information about how the Block class works.

While you're at it, change this deletion so that Block class performs this behavior rather than HotelSystem class:
  block.available_room_numbers.delete(room_id)
