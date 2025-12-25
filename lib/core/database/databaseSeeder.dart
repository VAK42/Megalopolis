import 'package:flutter/foundation.dart';
import 'databaseHelper.dart';
class DatabaseSeeder {
 final DatabaseHelper _dbHelper = DatabaseHelper.instance;
 Future<void> seed() async {
  final db = await _dbHelper.database;
  final users = await db.query('users');
  if (users.isNotEmpty) { debugPrint('Database Already Seeded'); return; }
  debugPrint('Seeding Database...');
  final now = DateTime.now().millisecondsSinceEpoch;
  await db.rawInsert('''
  INSERT INTO users (id, role, name, email, password, phone, avatar, rating, status, createdAt, updatedAt)
  VALUES 
  ('1', 'user', 'John Anderson', 'john.anderson@example.com', 'password123', '+1234567890', 'https://i.pravatar.cc/150?u=1', 5.0, 'active', ?, ?),
  ('2', 'user', 'Sarah Martinez', 'sarah.martinez@example.com', 'password123', '+1234567891', 'https://i.pravatar.cc/150?u=2', 4.9, 'active', ?, ?),
  ('3', 'user', 'Michael Chen', 'michael.chen@example.com', 'password123', '+1234567892', 'https://i.pravatar.cc/150?u=3', 4.8, 'active', ?, ?),
  ('4', 'user', 'David Thompson', 'david.driver@example.com', 'password123', '+1987654321', 'https://i.pravatar.cc/150?u=4', 4.9, 'active', ?, ?),
  ('5', 'user', 'Lisa Rodriguez', 'lisa.driver@example.com', 'password123', '+1987654322', 'https://i.pravatar.cc/150?u=5', 4.8, 'active', ?, ?),
  ('6', 'user', 'James Wilson', 'james.driver@example.com', 'password123', '+1987654323', 'https://i.pravatar.cc/150?u=6', 4.7, 'active', ?, ?),
  ('7', 'user', 'Tech World Electronics', 'contact@techworld.com', 'password123', '+1122334455', 'https://picsum.photos/200?random=1', 4.6, 'active', ?, ?),
  ('8', 'user', 'Fashion Gallery', 'info@fashiongallery.com', 'password123', '+1122334456', 'https://picsum.photos/200?random=2', 4.5, 'active', ?, ?),
  ('9', 'user', 'Royal Burger House', 'contact@royalburger.com', 'password123', '+1122334457', 'https://picsum.photos/200?random=3', 4.7, 'active', ?, ?),
  ('10', 'user', 'Pizza Palace', 'info@pizzapalace.com', 'password123', '+1122334458', 'https://picsum.photos/200?random=4', 4.8, 'active', ?, ?),
  ('11', 'user', 'Mega Mart Groceries', 'contact@megamart.com', 'password123', '+1122334459', 'https://picsum.photos/200?random=5', 4.4, 'active', ?, ?),
  ('12', 'user', 'Clean Pro Services', 'cleanpro@example.com', 'password123', '+1122334460', 'https://i.pravatar.cc/150?u=12', 4.9, 'active', ?, ?),
  ('13', 'user', 'Fix It Plumbing', 'fixit@example.com', 'password123', '+1122334461', 'https://i.pravatar.cc/150?u=13', 4.8, 'active', ?, ?),
  ('14', 'user', 'Spark Electric Co', 'spark@example.com', 'password123', '+1122334462', 'https://i.pravatar.cc/150?u=14', 4.7, 'active', ?, ?),
  ('15', 'admin', 'System Administrator', 'admin@megalopolis.com', 'admin123', '+1000000000', 'https://i.pravatar.cc/150?u=15', 5.0, 'active', ?, ?)
  ''', [now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now]);
  await db.rawInsert('''
  INSERT INTO items (id, type, name, description, price, sellerId, categoryId, images, rating, stock, metadata, createdAt)
  VALUES 
  ('p1', 'product', 'Wireless Noise-Cancelling Headphones', 'Premium Wireless Headphones With Active Noise Cancellation And 30 Hour Battery Life', 249.99, '7', 'electronics', '["https://picsum.photos/400/400?random=101", "https://picsum.photos/400/400?random=102"]', 4.7, 50, '{}', ?),
  ('p2', 'product', 'Smart Fitness Watch Pro', 'Advanced Fitness Tracker With Heart Rate Monitor, GPS And Sleep Tracking', 349.99, '7', 'electronics', '["https://picsum.photos/400/400?random=103", "https://picsum.photos/400/400?random=104"]', 4.8, 35, '{}', ?),
  ('p3', 'product', 'Gaming Laptop RTX 4060', 'High Performance Gaming Laptop With RTX 4060 Graphics And 16GB RAM', 1499.99, '7', 'electronics', '["https://picsum.photos/400/400?random=105"]', 4.9, 15, '{}', ?),
  ('p4', 'product', '4K Ultra HD Smart TV 55"', '55 Inch 4K Smart TV With HDR And Built-In Streaming Apps', 699.99, '7', 'electronics', '["https://picsum.photos/400/400?random=106"]', 4.6, 25, '{}', ?),
  ('p5', 'product', 'Bluetooth Speaker Portable', 'Waterproof Portable Bluetooth Speaker With 24 Hour Battery', 79.99, '7', 'electronics', '["https://picsum.photos/400/400?random=107"]', 4.5, 100, '{}', ?),
  ('p6', 'product', 'Wireless Gaming Mouse', 'RGB Gaming Mouse With Programmable Buttons And 16000 DPI', 59.99, '7', 'electronics', '["https://picsum.photos/400/400?random=108"]', 4.4, 80, '{}', ?),
  ('p7', 'product', 'Mechanical Keyboard RGB', 'Mechanical Gaming Keyboard With RGB Backlight And Brown Switches', 129.99, '7', 'electronics', '["https://picsum.photos/400/400?random=109"]', 4.6, 60, '{}', ?),
  ('p8', 'product', 'Running Shoes Air Max', 'Premium Running Shoes With Air Cushioning For Maximum Comfort', 139.99, '8', 'fashion', '["https://picsum.photos/400/400?random=110", "https://picsum.photos/400/400?random=111"]', 4.7, 120, '{}', ?),
  ('p9', 'product', 'Premium Cotton T-Shirt', 'Soft Cotton T-Shirt In Multiple Colors, Perfect For Casual Wear', 29.99, '8', 'fashion', '["https://picsum.photos/400/400?random=112"]', 4.3, 200, '{}', ?),
  ('p10', 'product', 'Designer Jeans Slim Fit', 'Classic Slim Fit Jeans Made From Premium Denim', 89.99, '8', 'fashion', '["https://picsum.photos/400/400?random=113"]', 4.5, 150, '{}', ?),
  ('p11', 'product', 'Leather Jacket Classic', 'Genuine Leather Jacket With Quilted Interior Lining', 299.99, '8', 'fashion', '["https://picsum.photos/400/400?random=114"]', 4.8, 40, '{}', ?),
  ('p12', 'product', 'Sneakers Urban Street', 'Comfortable Urban Sneakers Perfect For Daily Wear', 79.99, '8', 'fashion', '["https://picsum.photos/400/400?random=115"]', 4.4, 90, '{}', ?),
  ('p13', 'product', 'Organic Whole Milk 1L', 'Fresh Organic Whole Milk From Local Farms', 4.99, '11', 'dairy', '["https://picsum.photos/400/400?random=116"]', 4.6, 500, '{}', ?),
  ('p14', 'product', 'Free Range Eggs Dozen', 'Fresh Free Range Eggs From Happy Hens', 6.99, '11', 'dairy', '["https://picsum.photos/400/400?random=117"]', 4.7, 300, '{}', ?),
  ('p15', 'product', 'Fresh Bread Sourdough', 'Artisan Sourdough Bread Baked Fresh Daily', 5.99, '11', 'bakery', '["https://picsum.photos/400/400?random=118"]', 4.8, 100, '{}', ?),
  ('p16', 'product', 'Organic Apples 1kg', 'Crisp And Sweet Organic Apples From Local Orchards', 7.99, '11', 'fruits', '["https://picsum.photos/400/400?random=119"]', 4.5, 200, '{}', ?),
  ('p17', 'product', 'Fresh Chicken Breast 500g', 'Premium Quality Fresh Chicken Breast', 12.99, '11', 'meat', '["https://picsum.photos/400/400?random=120"]', 4.6, 150, '{}', ?),
  ('p18', 'product', 'Olive Oil Extra Virgin 500ml', 'Premium Extra Virgin Olive Oil From Spain', 15.99, '11', 'condiments', '["https://picsum.photos/400/400?random=121"]', 4.9, 80, '{}', ?),
  ('f1', 'food', 'Classic Cheeseburger Meal', 'Juicy Beef Burger With Cheese, Lettuce, Tomato, Fries And Soft Drink', 12.99, '9', 'burgers', '["https://picsum.photos/400/400?random=201"]', 4.6, 999, '{"sizes": [{"name": "Standard", "price": 12.99}, {"name": "Large", "price": 14.99}], "toppings": [{"name": "Extra Cheese", "price": 1.50}, {"name": "Bacon", "price": 2.00}], "nutrition": {"calories": "850", "protein": "25g", "fat": "40g", "carbs": "85g", "fiber": "6g", "sugar": "12g", "sodium": "1250mg", "cholesterol": "80mg", "vitaminA": "4% DV", "vitaminC": "2% DV", "calcium": "10% DV", "iron": "15% DV"}}', ?),
  ('f2', 'food', 'Bacon Double Burger Deluxe', 'Double Beef Patty With Crispy Bacon, Cheese, Special Sauce, Fries And Drink', 15.99, '9', 'burgers', '["https://picsum.photos/400/400?random=202"]', 4.7, 999, '{"sizes": [{"name": "Standard", "price": 15.99}, {"name": "Titan", "price": 18.99}], "toppings": [{"name": "Extra Bacon", "price": 2.50}, {"name": "Onion Rings", "price": 1.50}], "nutrition": {"calories": "1100", "protein": "45g", "fat": "65g", "carbs": "90g", "fiber": "5g", "sugar": "15g", "sodium": "1600mg", "cholesterol": "110mg", "vitaminA": "6% DV", "vitaminC": "4% DV", "calcium": "20% DV", "iron": "20% DV"}}', ?),
  ('f3', 'food', 'Crispy Chicken Nuggets 12pcs', '12 Pieces Of Golden Crispy Chicken Nuggets With Your Choice Of Sauce', 9.99, '9', 'chicken', '["https://picsum.photos/400/400?random=203"]', 4.5, 999, '{"sizes": [{"name": "12pcs", "price": 9.99}, {"name": "20pcs", "price": 14.99}], "toppings": [{"name": "BBQ Sauce", "price": 0.50}, {"name": "Honey Mustard", "price": 0.50}], "nutrition": {"calories": "550", "protein": "28g", "fat": "30g", "carbs": "40g", "fiber": "2g", "sugar": "1g", "sodium": "900mg", "cholesterol": "65mg", "vitaminA": "2% DV", "vitaminC": "0% DV", "calcium": "4% DV", "iron": "6% DV"}}', ?),
  ('f4', 'food', 'Spicy Chicken Sandwich', 'Spicy Breaded Chicken Breast With Lettuce, Mayo And Pickles', 10.99, '9', 'chicken', '["https://picsum.photos/400/400?random=204"]', 4.6, 999, '{"sizes": [{"name": "Regular", "price": 10.99}, {"name": "Combo", "price": 13.99}], "toppings": [{"name": "Extra Spicy", "price": 0.00}, {"name": "Cheese", "price": 1.00}], "nutrition": {"calories": "620", "protein": "32g", "fat": "35g", "carbs": "55g", "fiber": "4g", "sugar": "8g", "sodium": "1100mg", "cholesterol": "70mg", "vitaminA": "8% DV", "vitaminC": "6% DV", "calcium": "10% DV", "iron": "15% DV"}}', ?),
  ('f5', 'food', 'French Fries Large', 'Crispy Golden French Fries Seasoned To Perfection', 4.99, '9', 'sides', '["https://picsum.photos/400/400?random=205"]', 4.4, 999, '{"sizes": [{"name": "Medium", "price": 3.99}, {"name": "Large", "price": 4.99}], "toppings": [{"name": "Cheese Sauce", "price": 1.50}, {"name": "Bacon Bits", "price": 2.00}], "nutrition": {"calories": "450", "protein": "5g", "fat": "22g", "carbs": "60g", "fiber": "5g", "sugar": "0g", "sodium": "350mg", "cholesterol": "0mg", "vitaminA": "0% DV", "vitaminC": "15% DV", "calcium": "2% DV", "iron": "4% DV"}}', ?),
  ('f6', 'food', 'Margherita Pizza 12"', 'Classic Margherita Pizza With Fresh Mozzarella, Tomato Sauce And Basil', 14.99, '10', 'pizza', '["https://picsum.photos/400/400?random=206"]', 4.8, 999, '{"sizes": [{"name": "Small 10", "price": 12.99}, {"name": "Medium 12", "price": 14.99}, {"name": "Large 14", "price": 17.99}], "toppings": [{"name": "Extra Cheese", "price": 2.00}, {"name": "Olives", "price": 1.50}], "nutrition": {"calories": "250", "protein": "12g", "fat": "10g", "carbs": "30g", "fiber": "2g", "sugar": "3g", "sodium": "550mg", "cholesterol": "25mg", "vitaminA": "10% DV", "vitaminC": "15% DV", "calcium": "20% DV", "iron": "10% DV"}}', ?),
  ('f7', 'food', 'Pepperoni Pizza 14"', 'Large Pepperoni Pizza With Extra Cheese And Premium Pepperoni', 18.99, '10', 'pizza', '["https://picsum.photos/400/400?random=207"]', 4.9, 999, '{"sizes": [{"name": "Medium 12", "price": 16.99}, {"name": "Large 14", "price": 18.99}, {"name": "X-Large 16", "price": 21.99}], "toppings": [{"name": "Extra Pepperoni", "price": 3.00}, {"name": "Mushrooms", "price": 1.50}], "nutrition": {"calories": "320", "protein": "14g", "fat": "16g", "carbs": "32g", "fiber": "2g", "sugar": "4g", "sodium": "720mg", "cholesterol": "35mg", "vitaminA": "8% DV", "vitaminC": "10% DV", "calcium": "15% DV", "iron": "12% DV"}}', ?),
  ('f8', 'food', 'Hawaiian Pizza 12"', 'Sweet And Savory Pizza With Ham, Pineapple And Mozzarella', 16.99, '10', 'pizza', '["https://picsum.photos/400/400?random=208"]', 4.5, 999, '{"sizes": [{"name": "Small 10", "price": 14.99}, {"name": "Medium 12", "price": 16.99}], "toppings": [{"name": "Extra Pineapple", "price": 1.50}, {"name": "Jalapenos", "price": 1.00}], "nutrition": {"calories": "280", "protein": "11g", "fat": "9g", "carbs": "35g", "fiber": "2g", "sugar": "8g", "sodium": "600mg", "cholesterol": "30mg", "vitaminA": "6% DV", "vitaminC": "20% DV", "calcium": "12% DV", "iron": "8% DV"}}', ?),
  ('f9', 'food', 'Meat Lovers Pizza 14"', 'Loaded With Pepperoni, Sausage, Bacon, Ham And Ground Beef', 21.99, '10', 'pizza', '["https://picsum.photos/400/400?random=209"]', 4.7, 999, '{"sizes": [{"name": "Medium 12", "price": 19.99}, {"name": "Large 14", "price": 21.99}], "toppings": [{"name": "Stuffed Crust", "price": 4.00}, {"name": "Extra Cheese", "price": 2.50}], "nutrition": {"calories": "380", "protein": "18g", "fat": "20g", "carbs": "34g", "fiber": "2g", "sugar": "5g", "sodium": "850mg", "cholesterol": "45mg", "vitaminA": "8% DV", "vitaminC": "8% DV", "calcium": "18% DV", "iron": "14% DV"}}', ?),
  ('f10', 'food', 'Garlic Bread With Cheese', 'Toasted Garlic Bread Topped With Melted Mozzarella Cheese', 6.99, '10', 'sides', '["https://picsum.photos/400/400?random=210"]', 4.6, 999, '{"sizes": [{"name": "4pcs", "price": 6.99}, {"name": "8pcs", "price": 10.99}], "toppings": [{"name": "Marinara Dip", "price": 1.00}], "nutrition": {"calories": "180", "protein": "6g", "fat": "8g", "carbs": "22g", "fiber": "1g", "sugar": "1g", "sodium": "320mg", "cholesterol": "15mg", "vitaminA": "2% DV", "vitaminC": "0% DV", "calcium": "10% DV", "iron": "6% DV"}}', ?),
  ('f11', 'food', 'Caesar Salad', 'Fresh Romaine Lettuce With Caesar Dressing, Croutons And Parmesan', 8.99, '10', 'salads', '["https://picsum.photos/400/400?random=211"]', 4.4, 999, '{"sizes": [{"name": "Side", "price": 5.99}, {"name": "Full", "price": 8.99}], "toppings": [{"name": "Grilled Chicken", "price": 4.00}, {"name": "Shrimp", "price": 5.00}], "nutrition": {"calories": "350", "protein": "10g", "fat": "28g", "carbs": "12g", "fiber": "4g", "sugar": "3g", "sodium": "450mg", "cholesterol": "25mg", "vitaminA": "120% DV", "vitaminC": "45% DV", "calcium": "8% DV", "iron": "6% DV"}}', ?),
  ('f12', 'food', 'Chicken Wings 10pcs', '10 Pieces Of Chicken Wings With Choice Of Buffalo, BBQ Or Honey Mustard', 11.99, '10', 'appetizers', '["https://picsum.photos/400/400?random=212"]', 4.7, 999, '{"sizes": [{"name": "10pcs", "price": 11.99}, {"name": "20pcs", "price": 19.99}], "toppings": [{"name": "Ranch Dip", "price": 0.50}, {"name": "Blue Cheese", "price": 0.50}], "nutrition": {"calories": "800", "protein": "50g", "fat": "55g", "carbs": "5g", "fiber": "0g", "sugar": "2g", "sodium": "1200mg", "cholesterol": "180mg", "vitaminA": "6% DV", "vitaminC": "2% DV", "calcium": "4% DV", "iron": "8% DV"}}', ?),
  ('s1', 'service', 'Professional House Cleaning', 'Complete House Cleaning Service Including All Rooms, Kitchen, And Bathrooms', 75.00, '12', 'cleaning', '["https://picsum.photos/400/400?random=301"]', 4.9, 1, '{"duration": "3 Hours"}', ?),
  ('s2', 'service', 'Deep Carpet Cleaning', 'Professional Deep Carpet Cleaning With Industrial Equipment', 120.00, '12', 'cleaning', '["https://picsum.photos/400/400?random=302"]', 4.8, 1, '{"duration": "2 Hours"}', ?),
  ('s3', 'service', 'Window Washing Service', 'Interior And Exterior Window Cleaning For All Windows', 90.00, '12', 'cleaning', '["https://picsum.photos/400/400?random=303"]', 4.7, 1, '{"duration": "2 Hours"}', ?),
  ('s4', 'service', 'Emergency Plumbing Repair', 'Emergency 24/7 Plumbing Repair Service For All Plumbing Issues', 150.00, '13', 'plumbing', '["https://picsum.photos/400/400?random=304"]', 4.9, 1, '{"duration": "1 Hour"}', ?),
  ('s5', 'service', 'Drain Cleaning Service', 'Professional Drain Cleaning And Unclogging Service', 100.00, '13', 'plumbing', '["https://picsum.photos/400/400?random=305"]', 4.8, 1, '{"duration": "1.5 Hours"}', ?),
  ('s6', 'service', 'Water Heater Installation', 'Professional Water Heater Installation Or Replacement', 250.00, '13', 'plumbing', '["https://picsum.photos/400/400?random=306"]', 4.9, 1, '{"duration": "3 Hours"}', ?),
  ('s7', 'service', 'Electrical Wiring Repair', 'Expert Electrical Wiring Repair And Troubleshooting', 130.00, '14', 'electrical', '["https://picsum.photos/400/400?random=307"]', 4.8, 1, '{"duration": "2 Hours"}', ?),
  ('s8', 'service', 'Ceiling Fan Installation', 'Professional Ceiling Fan Installation Service', 95.00, '14', 'electrical', '["https://picsum.photos/400/400?random=308"]', 4.7, 1, '{"duration": "1.5 Hours"}', ?),
  ('s9', 'service', 'Light Fixture Installation', 'Installation Of Light Fixtures Including Chandeliers And Recessed Lighting', 110.00, '14', 'electrical', '["https://picsum.photos/400/400?random=309"]', 4.6, 1, '{"duration": "1 Hour"}', ?)
  ''', [now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now]);
  await db.rawInsert('''
  INSERT INTO addresses (id, userId, label, fullAddress, lat, lng, isDefault, isSavedPlace)
  VALUES 
  ('addr1', '1', 'Home', '123 Main Street, Downtown, Megalopolis City, 12345', 40.7128, -74.0060, 1, 1),
  ('addr2', '1', 'Work', '456 Business Avenue, Corporate District, Megalopolis City, 12346', 40.7580, -73.9855, 0, 1),
  ('addr3', '2', 'Home', '789 Oak Lane, Suburban Area, Megalopolis City, 12347', 40.7489, -73.9680, 1, 1),
  ('addr4', '3', 'Home', '321 Pine Road, Garden District, Megalopolis City, 12348', 40.7614, -73.9776, 1, 1)
  ''');
  await db.rawInsert('''
  INSERT INTO promotions (id, title, description, code, discount, startDate, endDate, type, usageCount)
  VALUES 
  ('promo1', 'Welcome Bonus', 'Get 20% Off Your First Order On Any Category', 'WELCOME20', 20.0, ?, ?, 'newUser', 0),
  ('promo2', 'Food Friday', 'Enjoy 15% Off All Food Orders Every Friday', 'FOOD15', 15.0, ?, ?, 'food', 0),
  ('promo3', 'Free Delivery', 'Free Delivery On Orders Over Dollar 50', 'FREEDEL50', 5.0, ?, ?, 'delivery', 0),
  ('promo4', 'Flash Sale', '30% Off Electronics For Limited Time Only', 'FLASH30', 30.0, ?, ?, 'electronics', 0)
  ''', [now - 86400000, now + 2592000000, now - 86400000, now + 604800000, now - 86400000, now + 31536000000, now, now + 86400000]);
  await db.rawInsert('''
  INSERT INTO walletCards (id, userId, type, number, holder, expiry, balance)
  VALUES 
  ('card1', '1', 'visa', '4532 7512 3412 1234', 'John Anderson', '12/26', 0),
  ('card2', '1', 'mastercard', '5412 1234 5678 9012', 'John Anderson', '03/27', 0),
  ('card3', '2', 'visa', '4916 5678 9012 3456', 'Sarah Martinez', '08/25', 0)
  ''');
  await db.rawInsert('''
  INSERT INTO transactions (id, userId, type, amount, status, reference, createdAt)
  VALUES 
  ('txn1', '1', 'topup', 100.00, 'completed', 'Initial Wallet Top Up', ?),
  ('txn2', '1', 'payment', 12.99, 'completed', 'Food Order Payment', ?),
  ('txn3', '2', 'topup', 50.00, 'completed', 'Wallet Reload', ?)
  ''', [now - 604800000, now - 86400000, now - 172800000]);
  await db.rawInsert('''
  INSERT INTO orders (id, userId, providerId, orderType, items, total, status, address, pickupAddress, dropoffAddress, completedAt, createdAt)
  VALUES 
  ('ord1', '1', '9', 'food', 'Food Order #1', 25.50, 'preparing', '123 Main St', NULL, NULL, NULL, ?),
  ('ord2', '1', '4', 'ride', 'Ride To Downtown', 15.00, 'completed', '123 Main St', 'Central Park', 'Downtown Market', ?, ?),
  ('ord3', '1', '12', 'service', 'House Cleaning', 75.00, 'completed', '123 Main St', NULL, NULL, ?, ?),
  ('ord4', '1', '11', 'mart', 'Grocery Order', 45.20, 'outForDelivery', '123 Main St', NULL, NULL, NULL, ?)
  ''', [now, now - 3600000, now - 7200000, now - 172800000, now - 259200000, now]);
  await db.rawInsert('''
  INSERT INTO notifications (id, userId, title, body, type, isRead, createdAt)
  VALUES 
  ('notif1', '1', 'Welcome To Megalopolis', 'Thank You For Joining Us! Explore Our Amazing Features And Services.', 'system', 0, ?),
  ('notif2', '1', 'Special Offer', 'Get 20% Off Your First Order! Use Code WELCOME20 At Checkout.', 'promotion', 0, ?),
  ('notif3', '2', 'Order Delivered', 'Your Order Has Been Successfully Delivered. Thank You For Your Purchase!', 'order', 1, ?)
  ''', [now - 86400000, now - 3600000, now - 43200000]);
  await db.rawInsert('''
  INSERT INTO chats (id, participants, lastMessage, lastMessageAt, type)
  VALUES 
  ('chat1', '1,2', 'Hey! How Are You Doing Today?', ?, 'direct'),
  ('chat2', '1,3', 'Thanks For The Help Yesterday!', ?, 'direct'),
  ('chat3', '1,9', 'Your Order Is On The Way!', ?, 'direct'),
  ('chat4', '2,3', 'See You Tomorrow!', ?, 'direct')
  ''', [now - 1800000, now - 3600000, now - 7200000, now - 86400000]);
  await db.rawInsert('''
  INSERT INTO messages (id, chatId, senderId, content, type, createdAt)
  VALUES 
  ('msg1', 'chat1', '2', 'Hi There! Hope You Are Having A Great Day!', 'text', ?),
  ('msg2', 'chat1', '1', 'Hey! I Am Doing Great, Thanks For Asking!', 'text', ?),
  ('msg3', 'chat1', '2', 'Hey! How Are You Doing Today?', 'text', ?),
  ('msg4', 'chat2', '3', 'Hi! Just Wanted To Say Thanks For Your Help!', 'text', ?),
  ('msg5', 'chat2', '1', 'No Problem At All! Happy To Help!', 'text', ?),
  ('msg6', 'chat2', '3', 'Thanks For The Help Yesterday!', 'text', ?),
  ('msg7', 'chat3', '9', 'Your Order Has Been Confirmed!', 'text', ?),
  ('msg8', 'chat3', '9', 'Your Order Is On The Way!', 'text', ?)
  ''', [now - 7200000, now - 3600000, now - 1800000, now - 10800000, now - 7200000, now - 3600000, now - 10800000, now - 7200000]);
  await db.rawInsert('''
  INSERT INTO reviews (id, targetType, targetId, userId, rating, comment, images, createdAt)
  VALUES 
  ('rev1', 'item', 'p1', '2', 4.5, 'Great Headphones! Amazing Sound Quality And Battery Life.', NULL, ?),
  ('rev2', 'item', 'f1', '3', 4.0, 'Delicious Burger, But A Bit Pricey For The Size.', NULL, ?),
  ('rev3', 'driver', '4', '1', 5.0, 'Excellent Driver! Very Professional And Arrived On Time.', NULL, ?),
  ('rev4', 'item', 's1', '1', 5.0, 'Outstanding Cleaning Service! My House Looks Brand New.', NULL, ?)
  ''', [now - 172800000, now - 259200000, now - 345600000, now - 432000000]);
  await db.rawInsert('''
  INSERT INTO friends (id, userId, friendId, status, createdAt)
  VALUES 
  ('friend1', '1', '2', 'accepted', ?),
  ('friend2', '1', '3', 'accepted', ?),
  ('friend3', '2', '3', 'accepted', ?)
  ''', [now - 2592000000, now - 1296000000, now - 604800000]);
  await db.rawInsert('''
  INSERT INTO bills (id, userId, provider, accountNumber, billType, amount, dueDate, status, lastPaymentDate, createdAt)
  VALUES 
  ('bill1', '1', 'Electric Company', 'ACC123456', 'electricity', 85.50, ?, 'pending', NULL, ?),
  ('bill2', '1', 'Water Services', 'WAT987654', 'water', 45.75, ?, 'pending', NULL, ?),
  ('bill3', '1', 'Internet Provider', 'INT555444', 'internet', 79.99, ?, 'paid', ?, ?),
  ('bill4', '2', 'Electric Company', 'ACC789012', 'electricity', 92.30, ?, 'pending', NULL, ?)
  ''', [now + 432000000, now, now + 864000000, now, now - 86400000, now - 172800000, now - 2592000000, now + 604800000, now]);
  await db.rawInsert('''
  INSERT INTO giftCards (id, userId, brand, cardNumber, balance, expiryDate, status, createdAt)
  VALUES 
  ('gc1', '1', 'Amazon', '6011 0000 0000 1234', 100.00, ?, 'active', ?),
  ('gc2', '1', 'Starbucks', '6011 0000 0000 5678', 75.00, ?, 'active', ?),
  ('gc3', '1', 'iTunes', '6011 0000 0000 9012', 50.00, ?, 'active', ?),
  ('gc4', '2', 'Amazon', '6011 0000 0000 3456', 25.00, ?, 'active', ?)
  ''', [now + 31536000000, now, now + 15768000000, now, now + 31536000000, now, now + 31536000000, now]);
  await db.rawInsert('''
  INSERT INTO searchHistory (userId, query, createdAt)
  VALUES 
  ('1', 'Headphones', ?),
  ('1', 'Smart Watch', ?),
  ('1', 'Phone', ?),
  ('1', 'Laptop', ?)
  ''', [now - 86400000, now - 172800000, now - 259200000, now - 345600000]);
  await db.rawInsert('''
  INSERT INTO sellers (id, name, description, avatar, rating, reviewCount, productCount, followerCount, isVerified, createdAt)
  VALUES 
  ('seller1', 'Tech Store', 'Official Electronics Store. Authorized Dealer For Samsung, Apple, Sony, And More. Fast Shipping And Authentic Products Guaranteed.', NULL, 4.8, 1234, 234, 12300, 1, ?),
  ('seller2', 'Fashion Hub', 'Premium Fashion And Accessories. Latest Trends And Designer Collections.', NULL, 4.6, 856, 189, 8500, 1, ?),
  ('seller3', 'Home Essentials', 'Quality Home And Kitchen Products. Everything You Need For Your Home.', NULL, 4.5, 432, 156, 5600, 0, ?)
  ''', [now - 31536000000, now - 15768000000, now - 7884000000]);
  await db.rawInsert('''
  INSERT INTO appSettings (key, value, type, updatedAt)
  VALUES 
  ('maintenanceMode', 'false', 'boolean', ?),
  ('latestVersion', '2.0.0', 'string', ?),
  ('minVersion', '1.0.0', 'string', ?),
  ('maintenanceMessage', 'We Are Performing Scheduled Maintenance!', 'string', ?),
  ('maintenanceEta', '2 Hours', 'string', ?),
  ('searchHint', 'Search For Food, Rides, Services...', 'string', ?),
  ('globalCategories', '[{"label":"Food","icon":"restaurant","route":"/food"},{"label":"Rides","icon":"directions_car","route":"/ride"},{"label":"Shopping","icon":"shopping_bag","route":"/mart"},{"label":"Services","icon":"handyman","route":"/services"},{"label":"Bills","icon":"receipt","route":"/wallet/billPayment"}]', 'json', ?)
  ''', [now, now, now, now, now, now, now]);
  await db.rawInsert('''
  INSERT INTO challenges (id, title, description, reward, target, type, createdAt)
  VALUES 
  ('chal1', 'Order 10 Meals', 'Order 10 Meals To Earn Points', 'Earn 500 Points', 10, 'food', ?),
  ('chal2', 'Take 20 Rides', 'Complete 20 Rides Around The City', 'Earn 1000 Points', 20, 'ride', ?),
  ('chal3', 'Spend 500', 'Spend 500 Across All Services', 'Earn 2000 Points', 500, 'general', ?)
  ''', [now, now, now]);
  await db.rawInsert('''
  INSERT INTO userChallenges (id, userId, challengeId, currentProgress, isCompleted)
  VALUES 
  ('uc1', '1', 'chal1', 7, 0),
  ('uc2', '1', 'chal2', 15, 0),
  ('uc3', '1', 'chal3', 350, 0)
  ''');
  await db.rawInsert('''
  INSERT INTO driverIncentives (id, driverId, title, description, earned, target, createdAt)
  VALUES 
  ('inc1', '4', 'Peak Hour Bonus', 'Earn 1.5x During 6-9 AM', 45.0, 100.0, ?),
  ('inc2', '4', 'Weekend Warrior', 'Complete 20 Trips This Weekend', 12.0, 20.0, ?),
  ('inc3', '4', 'Perfect Rating', 'Maintain 4.9+ Rating', 4.9, 5.0, ?)
  ''', [now, now, now]);
  await db.rawInsert('''
  INSERT INTO driverDocuments (id, driverId, name, status, expiry, uploadedAt)
  VALUES 
  ('doc1', '4', 'Driver License', 'verified', '12/2025', ?),
  ('doc2', '4', 'Vehicle Registration', 'verified', '06/2024', ?),
  ('doc3', '4', 'Insurance', 'pending', '03/2024', ?),
  ('doc4', '4', 'Background Check', 'verified', 'N/A', ?)
  ''', [now, now, now, now]);
  await db.rawInsert('''
  INSERT INTO driverTraining (id, driverId, title, duration, completed, completedAt)
  VALUES 
  ('train1', '4', 'Safety Guidelines', '15 Min', 1, ?),
  ('train2', '4', 'Customer Service', '10 Min', 1, ?),
  ('train3', '4', 'App Navigation', '8 Min', 0, NULL),
  ('train4', '4', 'Handling Payments', '12 Min', 0, NULL),
  ('train5', '4', 'Emergency Protocols', '20 Min', 0, NULL)
  ''', [now - 86400000, now - 172800000]);
  await db.rawInsert('''
  INSERT INTO reportTypes (id, name, icon, type, isActive, sortOrder, createdAt)
  VALUES 
  ('rt1', 'Revenue Report', 'attachMoney', 'revenue', 1, 1, ?),
  ('rt2', 'User Growth', 'trendingUp', 'userGrowth', 1, 2, ?),
  ('rt3', 'Order Summary', 'shoppingCart', 'orderSummary', 1, 3, ?),
  ('rt4', 'Transaction Log', 'receipt', 'transactionLog', 1, 4, ?)
  ''', [now, now, now, now]);
  await db.rawInsert('''
  INSERT INTO spinWheelOptions (id, value, probability, isActive, sortOrder, createdAt)
  VALUES 
  ('sw1', 5, 0.20, 1, 1, ?),
  ('sw2', 10, 0.18, 1, 2, ?),
  ('sw3', 15, 0.15, 1, 3, ?),
  ('sw4', 20, 0.12, 1, 4, ?),
  ('sw5', 25, 0.10, 1, 5, ?),
  ('sw6', 50, 0.08, 1, 6, ?),
  ('sw7', 0, 0.10, 1, 7, ?),
  ('sw8', 100, 0.07, 1, 8, ?)
  ''', [now, now, now, now, now, now, now, now]);
  await db.rawInsert('''
  INSERT INTO appSettings (key, value, type, updatedAt)
  VALUES 
  ('appName', 'Megalopolis', 'string', ?),
  ('appVersion', '1.0.0', 'string', ?),
  ('currencySymbol', '\$', 'string', ?),
  ('borderRadius', '12.0', 'double', ?),
  ('cardBorderRadius', '16.0', 'double', ?),
  ('paddingSmall', '8.0', 'double', ?),
  ('paddingMedium', '16.0', 'double', ?),
  ('paddingLarge', '24.0', 'double', ?),
  ('iconSizeSmall', '16.0', 'double', ?),
  ('iconSizeMedium', '24.0', 'double', ?),
  ('iconSizeLarge', '32.0', 'double', ?),
  ('elevationLow', '2.0', 'double', ?),
  ('elevationMedium', '4.0', 'double', ?),
  ('elevationHigh', '8.0', 'double', ?),
  ('animationDurationMs', '300', 'integer', ?),
  ('shimmerDurationMs', '1500', 'integer', ?),
  ('searchDebounceMs', '500', 'integer', ?)
  ''', [now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now, now]);
  debugPrint('Database Seeded Successfully With Comprehensive Data!');
 }
}