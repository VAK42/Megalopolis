import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DatabaseHelper {
 static final DatabaseHelper instance = DatabaseHelper._init();
 static Database? _database;
 DatabaseHelper._init();
 Future<Database> get database async {
  if (_database != null) return _database!;
  _database = await _initDB('megalopolis.db');
  return _database!;
 }
 Future<Database> _initDB(String filePath) async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, filePath);
  return await openDatabase(path, version: 1, onCreate: _createDB);
 }
 Future<void> _createDB(Database db, int version) async {
  await db.execute('''
  CREATE TABLE users (
  id TEXT PRIMARY KEY,
  role TEXT NOT NULL,
  name TEXT NOT NULL,
  email TEXT,
  password TEXT,
  phone TEXT,
  avatar TEXT,
  rating REAL DEFAULT 0.0,
  balance REAL DEFAULT 0.0,
  status TEXT DEFAULT 'active',
  createdAt INTEGER NOT NULL,
  updatedAt INTEGER NOT NULL
  )
  ''');
  await db.execute('''
  CREATE TABLE items (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  price REAL NOT NULL,
  sellerId TEXT,
  categoryId TEXT,
  images TEXT,
  rating REAL DEFAULT 0.0,
  stock INTEGER DEFAULT 0,
  metadata TEXT,
  createdAt INTEGER NOT NULL,
  FOREIGN KEY (sellerId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE orders (
  id TEXT PRIMARY KEY,
  orderType TEXT NOT NULL,
  rideType TEXT,
  userId TEXT NOT NULL,
  driverId TEXT,
  providerId TEXT,
  serviceId TEXT,
  serviceName TEXT,
  scheduledAt INTEGER,
  status TEXT NOT NULL,
  items TEXT,
  total REAL NOT NULL,
  address TEXT,
  pickupAddress TEXT,
  dropoffAddress TEXT,
  paymentMethod TEXT,
  promoCode TEXT,
  notes TEXT,
  createdAt INTEGER NOT NULL,
  completedAt INTEGER,
  FOREIGN KEY (userId) REFERENCES users (id),
  FOREIGN KEY (driverId) REFERENCES users (id),
  FOREIGN KEY (providerId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE addresses (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  label TEXT,
  fullAddress TEXT NOT NULL,
  lat REAL,
  lng REAL,
  isDefault INTEGER DEFAULT 0,
  isSavedPlace INTEGER DEFAULT 0,
  FOREIGN KEY (userId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE payments (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  type TEXT NOT NULL,
  details TEXT,
  isDefault INTEGER DEFAULT 0,
  FOREIGN KEY (userId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE transactions (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  type TEXT NOT NULL,
  amount REAL NOT NULL,
  status TEXT NOT NULL,
  reference TEXT,
  createdAt INTEGER NOT NULL,
  FOREIGN KEY (userId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE chats (
  id TEXT PRIMARY KEY,
  participants TEXT NOT NULL,
  lastMessage TEXT,
  lastMessageAt INTEGER,
  type TEXT DEFAULT 'direct'
  )
  ''');
  await db.execute('''
  CREATE TABLE messages (
  id TEXT PRIMARY KEY,
  chatId TEXT NOT NULL,
  senderId TEXT NOT NULL,
  content TEXT NOT NULL,
  type TEXT DEFAULT 'text',
  createdAt INTEGER NOT NULL,
  FOREIGN KEY (chatId) REFERENCES chats (id),
  FOREIGN KEY (senderId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE reviews (
  id TEXT PRIMARY KEY,
  targetType TEXT NOT NULL,
  targetId TEXT NOT NULL,
  userId TEXT NOT NULL,
  rating REAL NOT NULL,
  comment TEXT,
  images TEXT,
  createdAt INTEGER NOT NULL,
  FOREIGN KEY (userId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE bookings (
  id TEXT PRIMARY KEY,
  serviceId TEXT NOT NULL,
  providerId TEXT NOT NULL,
  userId TEXT NOT NULL,
  scheduledAt INTEGER NOT NULL,
  status TEXT NOT NULL,
  tasks TEXT,
  FOREIGN KEY (serviceId) REFERENCES items (id),
  FOREIGN KEY (providerId) REFERENCES users (id),
  FOREIGN KEY (userId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE friends (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  friendId TEXT NOT NULL,
  status TEXT DEFAULT 'accepted',
  createdAt INTEGER NOT NULL,
  FOREIGN KEY (userId) REFERENCES users (id),
  FOREIGN KEY (friendId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE promotions (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  code TEXT,
  discount REAL NOT NULL,
  startDate INTEGER,
  endDate INTEGER,
  type TEXT DEFAULT 'general',
  merchantId TEXT,
  usageCount INTEGER DEFAULT 0,
  isActive INTEGER DEFAULT 1,
  createdAt INTEGER NOT NULL,
  FOREIGN KEY (merchantId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE payouts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  merchantId TEXT NOT NULL,
  amount REAL NOT NULL,
  status TEXT DEFAULT 'pending',
  createdAt INTEGER NOT NULL,
  processedAt INTEGER,
  FOREIGN KEY (merchantId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE favorites (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  userId TEXT NOT NULL,
  itemId TEXT NOT NULL,
  type TEXT NOT NULL,
  createdAt INTEGER,
  FOREIGN KEY (userId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE tickets (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  subject TEXT NOT NULL,
  description TEXT,
  status TEXT DEFAULT 'open',
  priority TEXT DEFAULT 'medium',
  createdAt INTEGER NOT NULL,
  FOREIGN KEY (userId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE reports (
  id TEXT PRIMARY KEY,
  reporterId TEXT NOT NULL,
  targetType TEXT NOT NULL,
  targetId TEXT NOT NULL,
  reason TEXT NOT NULL,
  status TEXT DEFAULT 'pending',
  createdAt INTEGER NOT NULL,
  FOREIGN KEY (reporterId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE notifications (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  type TEXT DEFAULT 'system',
  isRead INTEGER DEFAULT 0,
  isStarred INTEGER DEFAULT 0,
  isMuted INTEGER DEFAULT 0,
  createdAt INTEGER NOT NULL,
  FOREIGN KEY (userId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE cartItems (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  userId TEXT NOT NULL,
  itemId TEXT NOT NULL,
  quantity INTEGER DEFAULT 1,
  createdAt INTEGER NOT NULL,
  FOREIGN KEY (userId) REFERENCES users (id),
  FOREIGN KEY (itemId) REFERENCES items (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE bills (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  provider TEXT NOT NULL,
  accountNumber TEXT NOT NULL,
  billType TEXT NOT NULL,
  amount REAL NOT NULL,
  dueDate INTEGER NOT NULL,
  status TEXT DEFAULT 'pending',
  lastPaymentDate INTEGER,
  createdAt INTEGER NOT NULL,
  FOREIGN KEY (userId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE giftCards (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  brand TEXT NOT NULL,
  cardNumber TEXT NOT NULL,
  balance REAL NOT NULL,
  expiryDate INTEGER,
  status TEXT DEFAULT 'active',
  createdAt INTEGER NOT NULL,
  FOREIGN KEY (userId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE walletCards (
  id TEXT PRIMARY KEY,
  userId TEXT,
  type TEXT,
  number TEXT,
  holder TEXT,
  expiry TEXT,
  balance REAL
  )
  ''');
  await db.execute('''
  CREATE TABLE searchHistory (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  userId TEXT NOT NULL,
  query TEXT NOT NULL,
  createdAt INTEGER NOT NULL,
  FOREIGN KEY (userId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE sellers (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  address TEXT,
  description TEXT,
  avatar TEXT,
  rating REAL DEFAULT 0.0,
  reviewCount INTEGER DEFAULT 0,
  productCount INTEGER DEFAULT 0,
  followerCount INTEGER DEFAULT 0,
  isVerified INTEGER DEFAULT 0,
  createdAt INTEGER NOT NULL
  )
  ''');
  await db.execute('''
  CREATE TABLE appSettings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  userId TEXT NOT NULL,
  key TEXT NOT NULL,
  value TEXT NOT NULL,
  type TEXT NOT NULL,
  updatedAt INTEGER NOT NULL,
  FOREIGN KEY (userId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE challenges (
  id TEXT PRIMARY KEY,
  userId TEXT,
  title TEXT NOT NULL,
  description TEXT,
  reward TEXT,
  target INTEGER NOT NULL DEFAULT 100,
  currentProgress INTEGER DEFAULT 0,
  type TEXT,
  createdAt INTEGER NOT NULL,
  FOREIGN KEY (userId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE userChallenges (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  challengeId TEXT NOT NULL,
  currentProgress INTEGER DEFAULT 0,
  isCompleted INTEGER DEFAULT 0,
  FOREIGN KEY (userId) REFERENCES users (id),
  FOREIGN KEY (challengeId) REFERENCES challenges (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE driverIncentives (
  id TEXT PRIMARY KEY,
  driverId TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  earned REAL DEFAULT 0.0,
  target REAL DEFAULT 100.0,
  createdAt INTEGER NOT NULL,
  FOREIGN KEY (driverId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE driverDocuments (
  id TEXT PRIMARY KEY,
  driverId TEXT NOT NULL,
  name TEXT NOT NULL,
  status TEXT DEFAULT 'pending',
  expiry TEXT,
  path TEXT,
  uploadedAt INTEGER NOT NULL,
  FOREIGN KEY (driverId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE driverTraining (
  id TEXT PRIMARY KEY,
  driverId TEXT NOT NULL,
  title TEXT NOT NULL,
  duration TEXT NOT NULL,
  completed INTEGER DEFAULT 0,
  completedAt INTEGER,
  FOREIGN KEY (driverId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE reportTypes (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  icon TEXT NOT NULL,
  type TEXT NOT NULL,
  isActive INTEGER DEFAULT 1,
  sortOrder INTEGER DEFAULT 0,
  createdAt INTEGER NOT NULL
  )
  ''');
  await db.execute('''
  CREATE TABLE spinWheelOptions (
  id TEXT PRIMARY KEY,
  value INTEGER NOT NULL,
  probability REAL DEFAULT 0.125,
  isActive INTEGER DEFAULT 1,
  sortOrder INTEGER DEFAULT 0,
  createdAt INTEGER NOT NULL
  )
  ''');
  await db.execute('''
  CREATE TABLE scratchCards (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  reward REAL DEFAULT 0.0,
  isScratched INTEGER DEFAULT 0,
  claimedAt INTEGER,
  createdAt INTEGER NOT NULL,
  FOREIGN KEY (userId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE checkIns (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  checkInDate INTEGER NOT NULL,
  reward REAL DEFAULT 0.0,
  streak INTEGER DEFAULT 1,
  createdAt INTEGER NOT NULL,
  FOREIGN KEY (userId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE badges (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  icon TEXT,
  earnedAt INTEGER NOT NULL,
  FOREIGN KEY (userId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE gifts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  fromUserId TEXT NOT NULL,
  toUserId TEXT NOT NULL,
  giftType TEXT NOT NULL,
  amount REAL NOT NULL,
  message TEXT,
  sentAt TEXT NOT NULL,
  status TEXT DEFAULT 'sent',
  FOREIGN KEY (fromUserId) REFERENCES users (id),
  FOREIGN KEY (toUserId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE expenseSplits (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  userId TEXT NOT NULL,
  friendIds TEXT NOT NULL,
  amount REAL NOT NULL,
  description TEXT,
  createdAt TEXT NOT NULL,
  status TEXT DEFAULT 'pending',
  FOREIGN KEY (userId) REFERENCES users (id)
  )
  ''');
  await db.execute('''
  CREATE TABLE locationShares (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  userId TEXT NOT NULL,
  friendIds TEXT NOT NULL,
  lat REAL NOT NULL,
  lng REAL NOT NULL,
  sharedAt TEXT NOT NULL,
  isActive INTEGER DEFAULT 1,
  FOREIGN KEY (userId) REFERENCES users (id)
  )
  ''');
 }
 Future<void> resetDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'megalopolis.db');
  if (_database != null) {
   await _database!.close();
   _database = null;
  }
  await deleteDatabase(path);
  _database = await _initDB('megalopolis.db');
 }
 Future<void> close() async {
  final db = await instance.database;
  db.close();
 }
}