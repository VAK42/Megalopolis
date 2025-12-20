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
        userId TEXT NOT NULL,
        driverId TEXT,
        providerId TEXT,
        status TEXT NOT NULL,
        items TEXT,
        total REAL NOT NULL,
        address TEXT,
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
        usageCount INTEGER DEFAULT 0
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
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT NOT NULL,
        itemId TEXT NOT NULL,
        type TEXT NOT NULL,
        createdAt INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id),
        FOREIGN KEY (itemId) REFERENCES items (id)
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
  }
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}