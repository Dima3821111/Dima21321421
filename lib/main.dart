import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iPhone Style',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const iPhoneHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class iPhoneHomeScreen extends StatefulWidget {
  const iPhoneHomeScreen({super.key});

  @override
  State<iPhoneHomeScreen> createState() => _iPhoneHomeScreenState();
}

class _iPhoneHomeScreenState extends State<iPhoneHomeScreen> with SingleTickerProviderStateMixin {
  // Время и дата
  String _time = '--:--';
  String _date = '';
  String _seconds = '--';
  
  // Батарея
  int _batteryLevel = 78;
  bool _isCharging = true;
  
  // Сеть
  int _signalStrength = 4;
  bool _wifiConnected = true;
  
  // Погода
  String _weatherTemp = '23°';
  String _weatherCondition = '☀️';
  
  // Активности
  int _stepCount = 6842;
  int _calories = 245;
  double _standHours = 4.5;
  
  // Анимации
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;
  
  Timer? _timeTimer;
  Timer? _batteryTimer;
  
  // Список приложений с работающими ссылками
  final List<Map<String, dynamic>> _apps = [
    {
      'name': 'YouTube', 
      'icon': Icons.play_circle_filled, 
      'color': Colors.red,
      'url': 'https://m.youtube.com',  // Мобильная версия YouTube
    },
    {
      'name': 'Instagram', 
      'icon': Icons.camera_alt, 
      'color': Colors.purple,
      'url': 'https://www.instagram.com',
    },
    {
      'name': 'Telegram', 
      'icon': Icons.telegram, 
      'color': Colors.blue,
      'url': 'https://web.telegram.org',
    },
    {
      'name': 'Google', 
      'icon': Icons.search, 
      'color': Colors.blue,
      'url': 'https://www.google.com',
    },
    {
      'name': 'Wikipedia', 
      'icon': Icons.menu_book, 
      'color': Colors.grey,
      'url': 'https://www.wikipedia.org',
    },
    {
      'name': 'GitHub', 
      'icon': Icons.code, 
      'color': Colors.white,
      'url': 'https://github.com',
    },
    {
      'name': 'ChatGPT', 
      'icon': Icons.chat, 
      'color': Colors.green,
      'url': 'https://chat.openai.com',
    },
    {
      'name': 'Weather', 
      'icon': Icons.wb_sunny, 
      'color': Colors.orange,
      'url': 'https://weather.com',
    },
  ];

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
    
    _batteryTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        _batteryLevel = (_batteryLevel - 1 + 100) % 100;
      });
    });
    
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _waveAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
  }
  
  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _time = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      _seconds = now.second.toString().padLeft(2, '0');
      _date = '${_getDayName(now.weekday)}, ${now.day} ${_getMonthName(now.month)}';
    });
  }
  
  String _getDayName(int weekday) {
    const days = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];
    return days[weekday - 1];
  }
  
  String _getMonthName(int month) {
    const months = ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн', 'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'];
    return months[month - 1];
  }
  
  void _refreshWeather() {
    setState(() {
      final random = Random();
      final temps = ['21°', '23°', '25°', '19°', '22°'];
      final conditions = ['☀️', '⛅', '🌤️', '☁️', '🌧️'];
      int index = random.nextInt(temps.length);
      _weatherTemp = temps[index];
      _weatherCondition = conditions[index];
    });
  }
  
  // Функция для открытия веб-сайтов
  Future<void> _openWebsite(String url, String appName) async {
    final Uri uri = Uri.parse(url);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Открывает в браузере
        );
        _showSnackBar('🔗 Открываем $appName...');
      } else {
        _showSnackBar('❌ Не удалось открыть $appName');
      }
    } catch (e) {
      _showSnackBar('❌ Ошибка: $e');
    }
  }
  
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
      ),
    );
  }
  
  // Открыть поиск в YouTube
  Future<void> _searchOnYouTube() async {
    final TextEditingController searchController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🔍 Поиск на YouTube'),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Введите запрос...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              final query = searchController.text.trim();
              if (query.isNotEmpty) {
                Navigator.pop(context);
                final searchUrl = 'https://m.youtube.com/results?search_query=${Uri.encodeComponent(query)}';
                await _openWebsite(searchUrl, 'YouTube Search');
              }
            },
            child: const Text('Поиск'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timeTimer?.cancel();
    _batteryTimer?.cancel();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1a1a2e),
              const Color(0xFF16213e),
              const Color(0xFF0f3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Status Bar
              _buildStatusBar(),
              
              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Dynamic Island Widget
                      _buildDynamicIsland(),
                      
                      const SizedBox(height: 16),
                      
                      // Activity Rings
                      _buildActivitySection(),
                      
                      const SizedBox(height: 24),
                      
                      // Quick Action Buttons
                      _buildQuickActions(),
                      
                      const SizedBox(height: 24),
                      
                      // Apps Grid
                      _buildAppsGrid(),
                      
                      const SizedBox(height: 24),
                      
                      // Notifications
                      _buildNotificationsSection(),
                      
                      const SizedBox(height: 24),
                      
                      // Music Widget
                      _buildMusicWidget(),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              
              // Home Indicator
              _buildHomeIndicator(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickAction(Icons.search, 'YouTube', Colors.red, _searchOnYouTube),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickAction(Icons.chat, 'ChatGPT', Colors.green, 
              () => _openWebsite('https://chat.openai.com', 'ChatGPT')),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickAction(Icons.public, 'Google', Colors.blue, 
              () => _openWebsite('https://www.google.com', 'Google')),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(color: Colors.white70, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Time
          Row(
            children: [
              Text(
                _time,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 2,
                height: 2,
                decoration: const BoxDecoration(
                  color: Colors.white60,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                _seconds,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          // Status Icons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                if (_isCharging)
                  const Icon(Icons.flash_on, color: Colors.green, size: 14),
                if (_isCharging) const SizedBox(width: 4),
                Icon(
                  _wifiConnected ? Icons.wifi : Icons.wifi_off,
                  size: 14,
                  color: Colors.white70,
                ),
                const SizedBox(width: 8),
                Row(
                  children: List.generate(4, (index) {
                    return Icon(
                      Icons.signal_cellular_alt,
                      size: 12,
                      color: index < _signalStrength ? Colors.white70 : Colors.white24,
                    );
                  }),
                ),
                const SizedBox(width: 8),
                Text(
                  '$_batteryLevel%',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(width: 4),
                Icon(
                  _isCharging ? Icons.battery_charging_full : Icons.battery_full,
                  size: 16,
                  color: _isCharging ? Colors.green : Colors.white70,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDynamicIsland() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'iPhone',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _date,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          // Weather Widget
          GestureDetector(
            onTap: _refreshWeather,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    _weatherCondition,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _weatherTemp,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActivitySection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActivityRing(0.7, Colors.red, 'Шаги', '$_stepCount'),
          _buildActivityRing(0.5, Colors.green, 'Калории', '$_calories'),
          _buildActivityRing(0.75, Colors.blue, 'Стояние', '$_standHours ч'),
        ],
      ),
    );
  }
  
  Widget _buildActivityRing(double progress, Color color, String label, String value) {
    return Column(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 6,
            backgroundColor: Colors.white.withOpacity(0.1),
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white60, fontSize: 11),
        ),
      ],
    );
  }
  
  Widget _buildAppsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '🌐 Интернет - сервисы',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: _apps.length,
          itemBuilder: (context, index) {
            final app = _apps[index];
            return GestureDetector(
              onTap: () => _openWebsite(app['url'] as String, app['name'] as String),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          app['color'] as Color,
                          (app['color'] as Color).withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (app['color'] as Color).withOpacity(0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(app['icon'] as IconData, color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    app['name'] as String,
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '📢 Уведомления',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildNotification('YouTube', 'Новое видео!', Icons.play_circle_filled, Colors.red, '5 мин'),
        _buildNotification('Instagram', 'Новый комментарий', Icons.camera_alt, Colors.purple, '15 мин'),
        _buildNotification('Telegram', 'Сообщение от друга', Icons.telegram, Colors.blue, '2 мин'),
      ],
    );
  }
  
  Widget _buildNotification(String title, String message, IconData icon, Color color, String time) {
    return GestureDetector(
      onTap: () {
        final app = _apps.firstWhere(
          (a) => a['name'] == title,
          orElse: () => _apps[0],
        );
        _openWebsite(app['url'] as String, title);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    message,
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                  Text(
                    time,
                    style: TextStyle(color: Colors.white38, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMusicWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.withOpacity(0.3), Colors.blue.withOpacity(0.3)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.music_note, color: Colors.white),
              SizedBox(width: 8),
              Text(
                '🎵 Сейчас играет',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ScaleTransition(
            scale: _waveAnimation,
            child: const Row(
              children: [
                Icon(Icons.album, size: 50, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Blinding Lights',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'The Weeknd',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.play_arrow, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHomeIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Container(
          width: 140,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}








описанние
// Импорт основного пакета Flutter для создания виджетов и UI
import 'package:flutter/material.dart';
// Импорт пакета для открытия URL-ссылок во внешнем браузере
import 'package:url_launcher/url_launcher.dart';
// Импорт для работы с таймерами и асинхронными операциями
import 'dart:async';
// Импорт для генерации случайных чисел (используется для погоды)
import 'dart:math';

// Точка входа в приложение - запускает приложение
void main() {
  runApp(const MyApp());
}

// Главный виджет приложения (Stateless - не изменяется после создания)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iPhone Style', // Заголовок приложения
      theme: ThemeData(
        brightness: Brightness.dark,   // Тёмная тема
        primarySwatch: Colors.blue,    // Основной цвет - синий
        useMaterial3: true,            // Используем Material Design 3
        scaffoldBackgroundColor: Colors.black, // Фон экрана чёрный
      ),
      home: const iPhoneHomeScreen(),   // Главный экран
      debugShowCheckedModeBanner: false, // Убираем баннер "Debug"
    );
  }
}

// Основной экран, который имитирует iPhone (Stateful - может менять состояние)
class iPhoneHomeScreen extends StatefulWidget {
  const iPhoneHomeScreen({super.key});

  @override
  State<iPhoneHomeScreen> createState() => _iPhoneHomeScreenState();
}

// Состояние главного экрана с анимациями и данными
class _iPhoneHomeScreenState extends State<iPhoneHomeScreen> with SingleTickerProviderStateMixin {
  // === ПЕРЕМЕННЫЕ ДЛЯ ВРЕМЕНИ И ДАТЫ ===
  String _time = '--:--';      // Хранит текущее время (часы:минуты)
  String _date = '';           // Хранит текущую дату (день недели, число, месяц)
  String _seconds = '--';      // Хранит текущие секунды
  
  // === ПЕРЕМЕННЫЕ ДЛЯ БАТАРЕИ ===
  int _batteryLevel = 78;      // Уровень заряда батареи в процентах
  bool _isCharging = true;     // Статус зарядки (подключена или нет)
  
  // === ПЕРЕМЕННЫЕ ДЛЯ СЕТИ ===
  int _signalStrength = 4;     // Уровень сигнала сотовой связи (0-4)
  bool _wifiConnected = true;  // Статус подключения к Wi-Fi
  
  // === ПЕРЕМЕННЫЕ ДЛЯ ПОГОДЫ ===
  String _weatherTemp = '23°';  // Температура воздуха
  String _weatherCondition = '☀️'; // Погодное состояние (солнце, облачно и т.д.)
  
  // === ПЕРЕМЕННЫЕ ДЛЯ АКТИВНОСТИ ===
  int _stepCount = 6842;        // Количество шагов
  int _calories = 245;          // Сожжённые калории
  double _standHours = 4.5;     // Часы стояния (фитнес-показатель)
  
  // === ПЕРЕМЕННЫЕ ДЛЯ АНИМАЦИЙ ===
  late AnimationController _waveController; // Контроллер анимации волны
  late Animation<double> _waveAnimation;    // Сама анимация (масштабирование)
  
  // === ТАЙМЕРЫ ===
  Timer? _timeTimer;    // Таймер для обновления времени каждую секунду
  Timer? _batteryTimer; // Таймер для имитации разряда батареи
  
  // === СПИСОК ПРИЛОЖЕНИЙ С РАБОТАЮЩИМИ ССЫЛКАМИ ===
  // Каждый элемент содержит: имя, иконку, цвет и URL для открытия
  final List<Map<String, dynamic>> _apps = [
    {
      'name': 'YouTube',   // Название приложения
      'icon': Icons.play_circle_filled, // Иконка из Material Icons
      'color': Colors.red, // Цвет для фона/акцентов
      'url': 'https://m.youtube.com',  // Мобильная версия YouTube
    },
    {
      'name': 'Instagram',
      'icon': Icons.camera_alt,
      'color': Colors.purple,
      'url': 'https://www.instagram.com',
    },
    {
      'name': 'Telegram',
      'icon': Icons.telegram,
      'color': Colors.blue,
      'url': 'https://web.telegram.org',
    },
    {
      'name': 'Google',
      'icon': Icons.search,
      'color': Colors.blue,
      'url': 'https://www.google.com',
    },
    {
      'name': 'Wikipedia',
      'icon': Icons.menu_book,
      'color': Colors.grey,
      'url': 'https://www.wikipedia.org',
    },
    {
      'name': 'GitHub',
      'icon': Icons.code,
      'color': Colors.white,
      'url': 'https://github.com',
    },
    {
      'name': 'ChatGPT',
      'icon': Icons.chat,
      'color': Colors.green,
      'url': 'https://chat.openai.com',
    },
    {
      'name': 'Weather',
      'icon': Icons.wb_sunny,
      'color': Colors.orange,
      'url': 'https://weather.com',
    },
  ];

  // Метод, вызываемый при создании виджета (один раз)
  @override
  void initState() {
    super.initState();
    _updateTime(); // Первоначальное обновление времени
    
    // Создаём таймер, который каждую секунду обновляет время на экране
    _timeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
    
    // Таймер для имитации работы батареи (каждые 30 секунд)
    _batteryTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        // Уменьшаем заряд на 1% циклически (после 0 идёт опять 100)
        _batteryLevel = (_batteryLevel - 1 + 100) % 100;
      });
    });
    
    // Инициализация контроллера анимации для виджета музыки
    _waveController = AnimationController(
      vsync: this,          // Привязываем к состоянию виджета
      duration: const Duration(seconds: 2), // Длительность одного цикла
    )..repeat(reverse: true); // Зацикливаем анимацию вперёд-назад
    
    // Анимация масштабирования от 0.9 до 1.1 и обратно
    _waveAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
  }
  
  // Обновляет текущее время, дату и секунды
  void _updateTime() {
    final now = DateTime.now(); // Получаем текущий момент времени
    setState(() {
      // Форматируем время: часы:минуты (всегда две цифры)
      _time = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      _seconds = now.second.toString().padLeft(2, '0'); // Секунды
      // Форматируем дату: "ПН, 15 Янв"
      _date = '${_getDayName(now.weekday)}, ${now.day} ${_getMonthName(now.month)}';
    });
  }
  
  // Преобразует номер дня недели (1-7) в короткое название на русском
  String _getDayName(int weekday) {
    const days = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];
    return days[weekday - 1]; // -1 потому что в массиве индексы с 0
  }
  
  // Преобразует номер месяца (1-12) в короткое название на русском
  String _getMonthName(int month) {
    const months = ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн', 'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'];
    return months[month - 1];
  }
  
  // Обновляет погоду случайным образом (имитация обновления)
  void _refreshWeather() {
    setState(() {
      final random = Random(); // Генератор случайных чисел
      final temps = ['21°', '23°', '25°', '19°', '22°']; // Возможные температуры
      final conditions = ['☀️', '⛅', '🌤️', '☁️', '🌧️']; // Возможные погодные иконки
      int index = random.nextInt(temps.length); // Случайный индекс
      _weatherTemp = temps[index];
      _weatherCondition = conditions[index];
    });
  }
  
  // Открывает веб-сайт по URL во внешнем браузере
  Future<void> _openWebsite(String url, String appName) async {
    final Uri uri = Uri.parse(url);
    
    try {
      // Проверяем, можно ли открыть этот URL
      if (await canLaunchUrl(uri)) {
        // Открываем во внешнем приложении (браузер)
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        _showSnackBar('🔗 Открываем $appName...');
      } else {
        _showSnackBar('❌ Не удалось открыть $appName');
      }
    } catch (e) {
      _showSnackBar('❌ Ошибка: $e');
    }
  }
  
  // Показывает всплывающее сообщение (SnackBar) внизу экрана
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating, // Плавающий стиль
        backgroundColor: Colors.black87,
      ),
    );
  }
  
  // Открывает диалоговое окно для поиска видео на YouTube
  Future<void> _searchOnYouTube() async {
    final TextEditingController searchController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🔍 Поиск на YouTube'),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Введите запрос...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          autofocus: true, // Автоматически фокусируем поле ввода
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Закрыть диалог
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              final query = searchController.text.trim();
              if (query.isNotEmpty) {
                Navigator.pop(context); // Закрываем диалог
                // Формируем URL поиска на YouTube
                final searchUrl = 'https://m.youtube.com/results?search_query=${Uri.encodeComponent(query)}';
                await _openWebsite(searchUrl, 'YouTube Search');
              }
            },
            child: const Text('Поиск'),
          ),
        ],
      ),
    );
  }

  // Очистка ресурсов при уничтожении виджета
  @override
  void dispose() {
    _timeTimer?.cancel();    // Останавливаем таймер времени
    _batteryTimer?.cancel(); // Останавливаем таймер батареи
    _waveController.dispose(); // Уничтожаем контроллер анимации
    super.dispose();
  }

  // ОСНОВНОЙ МЕТОД ПОСТРОЕНИЯ ИНТЕРФЕЙСА
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Градиентный фон (тёмно-синий перелив)
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1a1a2e), // Тёмно-синий
              const Color(0xFF16213e), // Средне-синий
              const Color(0xFF0f3460), // Светло-синий
            ],
          ),
        ),
        child: SafeArea( // Учитывает области системных панелей (нотификации и т.п.)
          child: Column(
            children: [
              _buildStatusBar(),        // Верхняя панель с временем, батареей, сигналом
              Expanded(                 // Растягиваем основное содержимое на всё свободное место
                child: SingleChildScrollView( // Позволяет скроллить, если контент не помещается
                  child: Column(
                    children: [
                      _buildDynamicIsland(),    // "Островок" с датой и погодой (как на iPhone 14+)
                      const SizedBox(height: 16),
                      _buildActivitySection(),  // Секция активности (шаги, калории)
                      const SizedBox(height: 24),
                      _buildQuickActions(),     // Быстрые действия (YouTube, ChatGPT, Google)
                      const SizedBox(height: 24),
                      _buildAppsGrid(),         // Сетка приложений 4x2
                      const SizedBox(height: 24),
                      _buildNotificationsSection(), // Секция уведомлений
                      const SizedBox(height: 24),
                      _buildMusicWidget(),      // Плеер с анимацией
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              _buildHomeIndicator(), // Индикатор дома (полоска внизу как на iPhone)
            ],
          ),
        ),
      ),
    );
  }
  
  // Строит три быстрые кнопки (YouTube, ChatGPT, Google)
  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickAction(Icons.search, 'YouTube', Colors.red, _searchOnYouTube),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickAction(Icons.chat, 'ChatGPT', Colors.green, 
              () => _openWebsite('https://chat.openai.com', 'ChatGPT')),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickAction(Icons.public, 'Google', Colors.blue, 
              () => _openWebsite('https://www.google.com', 'Google')),
          ),
        ],
      ),
    );
  }
  
  // Базовый виджет для одной быстрой кнопки
  Widget _buildQuickAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap, // Обработчик нажатия
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),    // Полупрозрачный фон
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5)), // Рамка с цветом
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(color: Colors.white70, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  // Верхняя статусная строка (время, секунды, сеть, батарея)
  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Размещаем по краям
        children: [
          // Левый блок: время и секунды
          Row(
            children: [
              Text(
                _time,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 2,
                height: 2,
                decoration: const BoxDecoration(
                  color: Colors.white60,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                _seconds,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          // Правый блок: индикаторы (зарядка, Wi-Fi, сигнал, батарея)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                if (_isCharging) ... [ // Если идёт зарядка - показываем молнию
                  const Icon(Icons.flash_on, color: Colors.green, size: 14),
                  const SizedBox(width: 4),
                ],
                Icon(
                  _wifiConnected ? Icons.wifi : Icons.wifi_off,
                  size: 14,
                  color: Colors.white70,
                ),
                const SizedBox(width: 8),
                // Четыре полоски сигнала сотовой связи
                Row(
                  children: List.generate(4, (index) {
                    return Icon(
                      Icons.signal_cellular_alt,
                      size: 12,
                      color: index < _signalStrength ? Colors.white70 : Colors.white24,
                    );
                  }),
                ),
                const SizedBox(width: 8),
                Text(
                  '$_batteryLevel%',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(width: 4),
                Icon(
                  _isCharging ? Icons.battery_charging_full : Icons.battery_full,
                  size: 16,
                  color: _isCharging ? Colors.green : Colors.white70,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // "Динамический остров" - блок с датой и погодой (как на новых iPhone)
  Widget _buildDynamicIsland() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Левая часть: надпись "iPhone" и дата
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'iPhone',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _date,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          // Правая часть: погода (кликабельно - обновляется)
          GestureDetector(
            onTap: _refreshWeather,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    _weatherCondition,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _weatherTemp,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Секция активности (три кольца с показателями)
  Widget _buildActivitySection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActivityRing(0.7, Colors.red, 'Шаги', '$_stepCount'),
          _buildActivityRing(0.5, Colors.green, 'Калории', '$_calories'),
          _buildActivityRing(0.75, Colors.blue, 'Стояние', '$_standHours ч'),
        ],
      ),
    );
  }
  
  // Одно кольцо активности (прогресс, цвет, подпись, значение)
  Widget _buildActivityRing(double progress, Color color, String label, String value) {
    return Column(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            value: progress,             // Прогресс от 0.0 до 1.0
            strokeWidth: 6,
            backgroundColor: Colors.white.withOpacity(0.1),
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white60, fontSize: 11),
        ),
      ],
    );
  }
  
  // Сетка приложений 4 колонки (интернет-сервисы)
  Widget _buildAppsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '🌐 Интернет - сервисы',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,               // Занимает столько места, сколько нужно
          physics: const NeverScrollableScrollPhysics(), // Отключаем скролл GridView
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,           // 4 иконки в строке
            mainAxisSpacing: 16,         // Отступы по вертикали
            crossAxisSpacing: 16,        // Отступы по горизонтали
            childAspectRatio: 0.8,       // Соотношение сторон ячейки
          ),
          itemCount: _apps.length,
          itemBuilder: (context, index) {
            final app = _apps[index];
            return GestureDetector(
              onTap: () => _openWebsite(app['url'] as String, app['name'] as String),
              child: Column(
                children: [
                  // Иконка приложения с градиентом и тенью
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          app['color'] as Color,
                          (app['color'] as Color).withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (app['color'] as Color).withOpacity(0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(app['icon'] as IconData, color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    app['name'] as String,
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
  
  // Секция с тремя уведомлениями (YouTube, Instagram, Telegram)
  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '📢 Уведомления',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildNotification('YouTube', 'Новое видео!', Icons.play_circle_filled, Colors.red, '5 мин'),
        _buildNotification('Instagram', 'Новый комментарий', Icons.camera_alt, Colors.purple, '15 мин'),
        _buildNotification('Telegram', 'Сообщение от друга', Icons.telegram, Colors.blue, '2 мин'),
      ],
    );
  }
  
  // Одно уведомление (кликабельное - открывает соответствующее приложение)
  Widget _buildNotification(String title, String message, IconData icon, Color color, String time) {
    return GestureDetector(
      onTap: () {
        // Ищем приложение по названию в списке _apps
        final app = _apps.firstWhere(
          (a) => a['name'] == title,
          orElse: () => _apps[0],
        );
        _openWebsite(app['url'] as String, title);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Иконка уведомления в кружке
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            // Текст уведомления
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    message,
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                  Text(
                    time,
                    style: TextStyle(color: Colors.white38, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Виджет музыкального плеера с анимированной волной
  Widget _buildMusicWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.withOpacity(0.3), Colors.blue.withOpacity(0.3)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.music_note, color: Colors.white),
              SizedBox(width: 8),
              Text(
                '🎵 Сейчас играет',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Анимированный блок (масштабируется)
          ScaleTransition(
            scale: _waveAnimation,
            child: const Row(
              children: [
                Icon(Icons.album, size: 50, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Blinding Lights',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'The Weeknd',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.play_arrow, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Индикатор дома (полоска внизу экрана, как на iPhone)
  Widget _buildHomeIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Container(
          width: 140,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
