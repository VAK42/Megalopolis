import 'package:flutter/foundation.dart';
import 'databaseHelper.dart';
class DatabaseSeeder {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  Future<void> seed() async {
    final db = await _dbHelper.database;
    final users = await db.query('users');
    if (users.isNotEmpty) {
      debugPrint('Database Already Seeded');
      return;
    }
    debugPrint('Seeding Database...');
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.rawInsert(
      '''
      INSERT INTO users (id, role, name, email, password, phone, avatar, rating, status, createdAt, updatedAt)
      VALUES 
      ('1', 'user', 'John Anderson', 'john.anderson@example.com', 'password123', '+1234567890', 'https://i.pravatar.cc/150?u=1', 5.0, 'active', ?, ?),
      ('2', 'user', 'Sarah Martinez', 'sarah.martinez@example.com', 'password123', '+1234567891', 'https://i.pravatar.cc/150?u=2', 4.9, 'active', ?, ?),
      ('3', 'user', 'Michael Chen', 'michael.chen@example.com', 'password123', '+1234567892', 'https://i.pravatar.cc/150?u=3', 4.8, 'active', ?, ?),
      ('4', 'driver', 'David Thompson', 'david.driver@example.com', 'password123', '+1987654321', 'https://i.pravatar.cc/150?u=4', 4.9, 'active', ?, ?),
      ('5', 'driver', 'Lisa Rodriguez', 'lisa.driver@example.com', 'password123', '+1987654322', 'https://i.pravatar.cc/150?u=5', 4.8, 'active', ?, ?),
      ('6', 'driver', 'James Wilson', 'james.driver@example.com', 'password123', '+1987654323', 'https://i.pravatar.cc/150?u=6', 4.7, 'active', ?, ?),
      ('7', 'merchant', 'Tech World Electronics', 'contact@techworld.com', 'password123', '+1122334455', 'https://picsum.photos/200?random=1', 4.6, 'active', ?, ?),
      ('8', 'merchant', 'Fashion Gallery', 'info@fashiongallery.com', 'password123', '+1122334456', 'https://picsum.photos/200?random=2', 4.5, 'active', ?, ?),
      ('9', 'merchant', 'Royal Burger House', 'contact@royalburger.com', 'password123', '+1122334457', 'https://picsum.photos/200?random=3', 4.7, 'active', ?, ?),
      ('10', 'merchant', 'Pizza Palace', 'info@pizzapalace.com', 'password123', '+1122334458', 'https://picsum.photos/200?random=4', 4.8, 'active', ?, ?),
      ('11', 'merchant', 'Mega Mart Groceries', 'contact@megamart.com', 'password123', '+1122334459', 'https://picsum.photos/200?random=5', 4.4, 'active', ?, ?),
      ('12', 'provider', 'Clean Pro Services', 'cleanpro@example.com', 'password123', '+1122334460', 'https://i.pravatar.cc/150?u=12', 4.9, 'active', ?, ?),
      ('13', 'provider', 'Fix It Plumbing', 'fixit@example.com', 'password123', '+1122334461', 'https://i.pravatar.cc/150?u=13', 4.8, 'active', ?, ?),
      ('14', 'provider', 'Spark Electric Co', 'spark@example.com', 'password123', '+1122334462', 'https://i.pravatar.cc/150?u=14', 4.7, 'active', ?, ?),
      ('15', 'admin', 'System Administrator', 'admin@megalopolis.com', 'admin123', '+1000000000', 'https://i.pravatar.cc/150?u=15', 5.0, 'active', ?, ?)
      ''',
      [now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now],
    );
    await db.rawInsert(
      '''
      INSERT INTO items (id, type, name, description, price, sellerId, categoryId, images, rating, stock, metadata, createdAt)
      VALUES 
      ('p1', 'product', 'Wireless Noise-Cancelling Headphones', 'Premium Wireless Headphones With Active Noise Cancellation And 30 Hour Battery Life', 249.99, '7', 'electronics', '[\"https://picsum.photos/400/400?random=101\", \"https://picsum.photos/400/400?random=102\"]', 4.7, 50, '{}', ?),
      ('p2', 'product', 'Smart Fitness Watch Pro', 'Advanced Fitness Tracker With Heart Rate Monitor, GPS And Sleep Tracking', 349.99, '7', 'electronics', '[\"https://picsum.photos/400/400?random=103\", \"https://picsum.photos/400/400?random=104\"]', 4.8, 35, '{}', ?),
      ('p3', 'product', 'Gaming Laptop RTX 4060', 'High Performance Gaming Laptop With RTX 4060 Graphics And 16GB RAM', 1499.99, '7', 'electronics', '[\"https://picsum.photos/400/400?random=105\"]', 4.9, 15, '{}', ?),
      ('p4', 'product', '4K Ultra HD Smart TV 55"', '55 Inch 4K Smart TV With HDR And Built-In Streaming Apps', 699.99, '7', 'electronics', '[\"https://picsum.photos/400/400?random=106\"]', 4.6, 25, '{}', ?),
      ('p5', 'product', 'Bluetooth Speaker Portable', 'Waterproof Portable Bluetooth Speaker With 24 Hour Battery', 79.99, '7', 'electronics', '[\"https://picsum.photos/400/400?random=107\"]', 4.5, 100, '{}', ?),
      ('p6', 'product', 'Wireless Gaming Mouse', 'RGB Gaming Mouse With Programmable Buttons And 16000 DPI', 59.99, '7', 'electronics', '[\"https://picsum.photos/400/400?random=108\"]', 4.4, 80, '{}', ?),
      ('p7', 'product', 'Mechanical Keyboard RGB', 'Mechanical Gaming Keyboard With RGB Backlight And Brown Switches', 129.99, '7', 'electronics', '[\"https://picsum.photos/400/400?random=109\"]', 4.6, 60, '{}', ?),
      ('p8', 'product', 'Running Shoes Air Max', 'Premium Running Shoes With Air Cushioning For Maximum Comfort', 139.99, '8', 'fashion', '[\"https://picsum.photos/400/400?random=110\", \"https://picsum.photos/400/400?random=111\"]', 4.7, 120, '{}', ?),
      ('p9', 'product', 'Premium Cotton T-Shirt', 'Soft Cotton T-Shirt In Multiple Colors, Perfect For Casual Wear', 29.99, '8', 'fashion', '[\"https://picsum.photos/400/400?random=112\"]', 4.3, 200, '{}', ?),
      ('p10', 'product', 'Designer Jeans Slim Fit', 'Classic Slim Fit Jeans Made From Premium Denim', 89.99, '8', 'fashion', '[\"https://picsum.photos/400/400?random=113\"]', 4.5, 150, '{}', ?),
      ('p11', 'product', 'Leather Jacket Classic', 'Genuine Leather Jacket With Quilted Interior Lining', 299.99, '8', 'fashion', '[\"https://picsum.photos/400/400?random=114\"]', 4.8, 40, '{}', ?),
      ('p12', 'product', 'Sneakers Urban Street', 'Comfortable Urban Sneakers Perfect For Daily Wear', 79.99, '8', 'fashion', '[\"https://picsum.photos/400/400?random=115\"]', 4.4, 90, '{}', ?),
      ('p13', 'product', 'Organic Whole Milk 1L', 'Fresh Organic Whole Milk From Local Farms', 4.99, '11', 'dairy', '[\"https://picsum.photos/400/400?random=116\"]', 4.6, 500, '{}', ?),
      ('p14', 'product', 'Free Range Eggs Dozen', 'Fresh Free Range Eggs From Happy Hens', 6.99, '11', 'dairy', '[\"https://picsum.photos/400/400?random=117\"]', 4.7, 300, '{}', ?),
      ('p15', 'product', 'Fresh Bread Sourdough', 'Artisan Sourdough Bread Baked Fresh Daily', 5.99, '11', 'bakery', '[\"https://picsum.photos/400/400?random=118\"]', 4.8, 100, '{}', ?),
      ('p16', 'product', 'Organic Apples 1kg', 'Crisp And Sweet Organic Apples From Local Orchards', 7.99, '11', 'fruits', '[\"https://picsum.photos/400/400?random=119\"]', 4.5, 200, '{}', ?),
      ('p17', 'product', 'Fresh Chicken Breast 500g', 'Premium Quality Fresh Chicken Breast', 12.99, '11', 'meat', '[\"https://picsum.photos/400/400?random=120\"]', 4.6, 150, '{}', ?),
      ('p18', 'product', 'Olive Oil Extra Virgin 500ml', 'Premium Extra Virgin Olive Oil From Spain', 15.99, '11', 'condiments', '[\"https://picsum.photos/400/400?random=121\"]', 4.9, 80, '{}', ?),
      ('f1', 'food', 'Classic Cheeseburger Meal', 'Juicy Beef Burger With Cheese, Lettuce, Tomato, Fries And Soft Drink', 12.99, '9', 'burgers', '[\"https://picsum.photos/400/400?random=201\"]', 4.6, 999, '{}', ?),
      ('f2', 'food', 'Bacon Double Burger Deluxe', 'Double Beef Patty With Crispy Bacon, Cheese, Special Sauce, Fries And Drink', 15.99, '9', 'burgers', '[\"https://picsum.photos/400/400?random=202\"]', 4.7, 999, '{}', ?),
      ('f3', 'food', 'Crispy Chicken Nuggets 12pcs', '12 Pieces Of Golden Crispy Chicken Nuggets With Your Choice Of Sauce', 9.99, '9', 'chicken', '[\"https://picsum.photos/400/400?random=203\"]', 4.5, 999, '{}', ?),
      ('f4', 'food', 'Spicy Chicken Sandwich', 'Spicy Breaded Chicken Breast With Lettuce, Mayo And Pickles', 10.99, '9', 'chicken', '[\"https://picsum.photos/400/400?random=204\"]', 4.6, 999, '{}', ?),
      ('f5', 'food', 'French Fries Large', 'Crispy Golden French Fries Seasoned To Perfection', 4.99, '9', 'sides', '[\"https://picsum.photos/400/400?random=205\"]', 4.4, 999, '{}', ?),
      ('f6', 'food', 'Margherita Pizza 12"', 'Classic Margherita Pizza With Fresh Mozzarella, Tomato Sauce And Basil', 14.99, '10', 'pizza', '[\"https://picsum.photos/400/400?random=206\"]', 4.8, 999, '{}', ?),
      ('f7', 'food', 'Pepperoni Pizza 14"', 'Large Pepperoni Pizza With Extra Cheese And Premium Pepperoni', 18.99, '10', 'pizza', '[\"https://picsum.photos/400/400?random=207\"]', 4.9, 999, '{}', ?),
      ('f8', 'food', 'Hawaiian Pizza 12"', 'Sweet And Savory Pizza With Ham, Pineapple And Mozzarella', 16.99, '10', 'pizza', '[\"https://picsum.photos/400/400?random=208\"]', 4.5, 999, '{}', ?),
      ('f9', 'food', 'Meat Lovers Pizza 14"', 'Loaded With Pepperoni, Sausage, Bacon, Ham And Ground Beef', 21.99, '10', 'pizza', '[\"https://picsum.photos/400/400?random=209\"]', 4.7, 999, '{}', ?),
      ('f10', 'food', 'Garlic Bread With Cheese', 'Toasted Garlic Bread Topped With Melted Mozzarella Cheese', 6.99, '10', 'sides', '[\"https://picsum.photos/400/400?random=210\"]', 4.6, 999, '{}', ?),
      ('f11', 'food', 'Caesar Salad', 'Fresh Romaine Lettuce With Caesar Dressing, Croutons And Parmesan', 8.99, '10', 'salads', '[\"https://picsum.photos/400/400?random=211\"]', 4.4, 999, '{}', ?),
      ('f12', 'food', 'Chicken Wings 10pcs', '10 Pieces Of Chicken Wings With Choice Of Buffalo, BBQ Or Honey Mustard', 11.99, '10', 'appetizers', '[\"https://picsum.photos/400/400?random=212\"]', 4.7, 999, '{}', ?),
      ('s1', 'service', 'Professional House Cleaning', 'Complete House Cleaning Service Including All Rooms, Kitchen, And Bathrooms', 75.00, '12', 'cleaning', '[\"https://picsum.photos/400/400?random=301\"]', 4.9, 1, '{\"duration\": \"3 Hours\"}', ?),
      ('s2', 'service', 'Deep Carpet Cleaning', 'Professional Deep Carpet Cleaning With Industrial Equipment', 120.00, '12', 'cleaning', '[\"https://picsum.photos/400/400?random=302\"]', 4.8, 1, '{\"duration\": \"2 Hours\"}', ?),
      ('s3', 'service', 'Window Washing Service', 'Interior And Exterior Window Cleaning For All Windows', 90.00, '12', 'cleaning', '[\"https://picsum.photos/400/400?random=303\"]', 4.7, 1, '{\"duration\": \"2 Hours\"}', ?),
      ('s4', 'service', 'Emergency Plumbing Repair', 'Emergency 24/7 Plumbing Repair Service For All Plumbing Issues', 150.00, '13', 'plumbing', '[\"https://picsum.photos/400/400?random=304\"]', 4.9, 1, '{\"duration\": \"1 Hour\"}', ?),
      ('s5', 'service', 'Drain Cleaning Service', 'Professional Drain Cleaning And Unclogging Service', 100.00, '13', 'plumbing', '[\"https://picsum.photos/400/400?random=305\"]', 4.8, 1, '{\"duration\": \"1.5 Hours\"}', ?),
      ('s6', 'service', 'Water Heater Installation', 'Professional Water Heater Installation Or Replacement', 250.00, '13', 'plumbing', '[\"https://picsum.photos/400/400?random=306\"]', 4.9, 1, '{\"duration\": \"3 Hours\"}', ?),
      ('s7', 'service', 'Electrical Wiring Repair', 'Expert Electrical Wiring Repair And Troubleshooting', 130.00, '14', 'electrical', '[\"https://picsum.photos/400/400?random=307\"]', 4.8, 1, '{\"duration\": \"2 Hours\"}', ?),
      ('s8', 'service', 'Ceiling Fan Installation', 'Professional Ceiling Fan Installation Service', 95.00, '14', 'electrical', '[\"https://picsum.photos/400/400?random=308\"]', 4.7, 1, '{\"duration\": \"1.5 Hours\"}', ?),
      ('s9', 'service', 'Light Fixture Installation', 'Installation Of Light Fixtures Including Chandeliers And Recessed Lighting', 110.00, '14', 'electrical', '[\"https://picsum.photos/400/400?random=309\"]', 4.6, 1, '{\"duration\": \"1 Hour\"}', ?)
      ''',
      [now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now],
    );
    await db.rawInsert(
      '''
      INSERT INTO addresses (id, userId, label, fullAddress, lat, lng, isDefault, isSavedPlace)
      VALUES 
      ('addr1', '1', 'Home', '123 Main Street, Downtown, Megalopolis City, 12345', 40.7128, -74.0060, 1, 1),
      ('addr2', '1', 'Work', '456 Business Avenue, Corporate District, Megalopolis City, 12346', 40.7580, -73.9855, 0, 1),
      ('addr3', '2', 'Home', '789 Oak Lane, Suburban Area, Megalopolis City, 12347', 40.7489, -73.9680, 1, 1),
      ('addr4', '3', 'Home', '321 Pine Road, Garden District, Megalopolis City, 12348', 40.7614, -73.9776, 1, 1)
      ''',
    );
    await db.rawInsert(
      '''
      INSERT INTO promotions (id, title, description, code, discount, startDate, endDate, type, usageCount)
      VALUES 
      ('promo1', 'Welcome Bonus', 'Get 20% Off Your First Order On Any Category', 'WELCOME20', 20.0, ?, ?, 'newUser', 0),
      ('promo2', 'Food Friday', 'Enjoy 15% Off All Food Orders Every Friday', 'FOOD15', 15.0, ?, ?, 'food', 0),
      ('promo3', 'Free Delivery', 'Free Delivery On Orders Over Dollar 50', 'FREEDEL50', 5.0, ?, ?, 'delivery', 0),
      ('promo4', 'Flash Sale', '30% Off Electronics For Limited Time Only', 'FLASH30', 30.0, ?, ?, 'electronics', 0)
      ''',
      [now - 86400000, now + 2592000000, now - 86400000, now + 604800000, now - 86400000, now + 31536000000, now, now + 86400000],
    );
    await db.rawInsert(
      '''
      INSERT INTO walletCards (id, userId, type, number, holder, expiry, balance)
      VALUES 
      ('card1', '1', 'visa', '**** **** **** 1234', 'John Anderson', '12/26', 0),
      ('card2', '1', 'mastercard', '**** **** **** 5678', 'John Anderson', '03/27', 0),
      ('card3', '2', 'visa', '**** **** **** 9012', 'Sarah Martinez', '08/25', 0)
      ''',
    );
    await db.rawInsert(
      '''
      INSERT INTO transactions (id, userId, type, amount, status, reference, createdAt)
      VALUES 
      ('txn1', '1', 'topup', 100.00, 'completed', 'Initial Wallet Top Up', ?),
      ('txn2', '1', 'payment', 12.99, 'completed', 'Food Order Payment', ?),
      ('txn3', '2', 'topup', 50.00, 'completed', 'Wallet Reload', ?)
      ''',
      [now - 604800000, now - 86400000, now - 172800000],
    );
    await db.rawInsert(
      '''
      INSERT INTO notifications (id, userId, title, body, type, isRead, createdAt)
      VALUES 
      ('notif1', '1', 'Welcome To Megalopolis', 'Thank You For Joining Us! Explore Our Amazing Features And Services.', 'system', 0, ?),
      ('notif2', '1', 'Special Offer', 'Get 20% Off Your First Order! Use Code WELCOME20 At Checkout.', 'promotion', 0, ?),
      ('notif3', '2', 'Order Delivered', 'Your Order Has Been Successfully Delivered. Thank You For Your Purchase!', 'order', 1, ?)
      ''',
      [now - 86400000, now - 3600000, now - 43200000],
    );
    await db.rawInsert(
      '''
      INSERT INTO reviews (id, targetType, targetId, userId, rating, comment, images, createdAt)
      VALUES 
      ('rev1', 'item', 'p1', '2', 4.5, 'Great Headphones! Amazing Sound Quality And Battery Life.', NULL, ?),
      ('rev2', 'item', 'f1', '3', 4.0, 'Delicious Burger, But A Bit Pricey For The Size.', NULL, ?),
      ('rev3', 'driver', '4', '1', 5.0, 'Excellent Driver! Very Professional And Arrived On Time.', NULL, ?),
      ('rev4', 'item', 's1', '1', 5.0, 'Outstanding Cleaning Service! My House Looks Brand New.', NULL, ?)
      ''',
      [now - 172800000, now - 259200000, now - 345600000, now - 432000000],
    );
    await db.rawInsert(
      '''
      INSERT INTO friends (id, userId, friendId, status, createdAt)
      VALUES 
      ('friend1', '1', '2', 'accepted', ?),
      ('friend2', '1', '3', 'accepted', ?),
      ('friend3', '2', '3', 'accepted', ?)
      ''',
      [now - 2592000000, now - 1296000000, now - 604800000],
    );
    debugPrint('Database Seeded Successfully With Comprehensive Data!');
  }
}