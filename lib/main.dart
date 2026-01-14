import 'package:flutter/material.dart';

void main() {
  runApp(const HealthApp());
}

// 簡單的全域資料狀態管理 (為了讓首頁能即時反應記錄頁的修改)
// 使用 ValueNotifier 監聽數據變化
final ValueNotifier<UserProfile> userProfile = ValueNotifier<UserProfile>(
  UserProfile(height: 170.0, weight: 65.0, sysBP: 120, diaBP: 80, dietLog: []),
);

class UserProfile {
  double height; // cm
  double weight; // kg
  int sysBP;     // 收縮壓
  int diaBP;     // 舒張壓
  List<String> dietLog; // 飲食紀錄

  UserProfile({
    required this.height,
    required this.weight,
    required this.sysBP,
    required this.diaBP,
    required this.dietLog
  });

  // 計算 BMI
  double get bmi => weight / ((height / 100) * (height / 100));

  // 根據 BMI 給出運動建議
  String get exerciseRecommendation {
    double b = bmi;
    if (b < 18.5) {
      return "🏋️ 建議運動：肌力訓練\n目標：增加肌肉量\n推薦：啞鈴、伏地挺身、深蹲，並多攝取蛋白質。";
    } else if (b >= 24) {
      return "🏊 建議運動：有氧燃脂\n目標：減脂與心肺功能\n推薦：快走、游泳、飛輪，減少膝蓋負擔為佳。";
    } else {
      return "🏃 建議運動：綜合訓練\n目標：維持體態\n推薦：慢跑、瑜珈、HIIT 間歇運動。";
    }
  }
}

class HealthApp extends StatelessWidget {
  const HealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '個人健康管理',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey.shade50,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ================== 主畫面架構 ==================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // 現在只保留兩個分頁
  final List<Widget> _pages = [
    const DashboardTab(),    // 1. 總覽 (看數據、看建議)
    const HealthRecordTab(), // 2. 記錄 (改數據)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: '健康總覽',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_note_outlined),
            selectedIcon: Icon(Icons.edit_note),
            label: '數據記錄',
          ),
        ],
      ),
    );
  }
}

// ================== 分頁 1: 健康總覽 (Dashboard) ==================
class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  int _waterCount = 0;
  final int _waterGoal = 8;

  @override
  Widget build(BuildContext context) {
    // 使用 ValueListenableBuilder 來監聽 userProfile 的變化
    // 這樣當我們在「記錄」頁面修改體重時，這裡的 BMI 和建議會自動更新
    return ValueListenableBuilder<UserProfile>(
        valueListenable: userProfile,
        builder: (context, profile, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('今日健康概況'),
              backgroundColor: Colors.teal.shade50,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('早安，使用者', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),

                  // 1. 動態 BMI 卡片
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          title: '目前 BMI',
                          value: profile.bmi.toStringAsFixed(1),
                          unit: '',
                          icon: Icons.monitor_weight,
                          color: _getBmiColor(profile.bmi),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoCard(
                          title: '最新血壓',
                          value: '${profile.sysBP}/${profile.diaBP}',
                          unit: 'mmHg',
                          icon: Icons.favorite,
                          color: Colors.red.shade100,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 2. 專屬運動建議
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.teal.shade300],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          // 【修正 1】使用 withValues 替代 withOpacity
                          color: Colors.blue.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.fitness_center, color: Colors.white),
                            SizedBox(width: 8),
                            Text('專屬運動處方', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          profile.exerciseRecommendation,
                          style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 3. 喝水記錄 (保留互動功能)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('💧 喝水記錄', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('$_waterCount / $_waterGoal 杯', style: const TextStyle(fontSize: 16, color: Colors.teal)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: _waterCount / _waterGoal,
                          backgroundColor: Colors.grey.shade200,
                          color: Colors.blue,
                          minHeight: 10,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => setState(() { if (_waterCount < _waterGoal) _waterCount++; }),
                              icon: const Icon(Icons.add),
                              label: const Text('喝一杯'),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () => setState(() => _waterCount = 0),
                              child: const Text('重置'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Color _getBmiColor(double bmi) {
    if (bmi < 18.5) return Colors.orange.shade100; // 過輕
    if (bmi >= 24) return Colors.red.shade100;    // 過重
    return Colors.green.shade100;                 // 正常
  }

  Widget _buildInfoCard({required String title, required String value, required String unit, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: Colors.black54),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Text(unit, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

// ================== 分頁 2: 數據記錄 (Records) ==================
class HealthRecordTab extends StatelessWidget {
  const HealthRecordTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('健康數據手帳')),
      body: ValueListenableBuilder<UserProfile>(
          valueListenable: userProfile,
          builder: (context, profile, child) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 1. 身體數據編輯
                _buildRecordItem(
                    context,
                    '身體數據 (BMI)',
                    '${profile.height} cm / ${profile.weight} kg',
                    Icons.accessibility,
                    Colors.orange,
                        () => _showBodyEditDialog(context, profile)
                ),
                // 2. 血壓記錄編輯
                _buildRecordItem(
                    context,
                    '血壓記錄',
                    '收縮壓 ${profile.sysBP} / 舒張壓 ${profile.diaBP}',
                    Icons.favorite,
                    Colors.red,
                        () => _showBPEditDialog(context, profile)
                ),
                // 3. 飲食日記
                _buildRecordItem(
                    context,
                    '飲食日記',
                    '已記錄 ${profile.dietLog.length} 筆',
                    Icons.restaurant,
                    Colors.green,
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DietPage()))
                ),
              ],
            );
          }
      ),
    );
  }

  Widget _buildRecordItem(BuildContext context, String title, String subtitle, IconData icon, Color iconColor, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          // 【修正 1】使用 withValues 替代 withOpacity
          backgroundColor: iconColor.withValues(alpha: 0.1),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
        trailing: const Icon(Icons.edit, size: 20, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  // 修改身高體重的對話框
  void _showBodyEditDialog(BuildContext context, UserProfile profile) {
    final heightController = TextEditingController(text: profile.height.toString());
    final weightController = TextEditingController(text: profile.weight.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('更新身體數據'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '身高 (cm)', suffixText: 'cm'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '體重 (kg)', suffixText: 'kg'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              // 更新數據
              profile.height = double.tryParse(heightController.text) ?? profile.height;
              profile.weight = double.tryParse(weightController.text) ?? profile.weight;

              // 【修正 2】ValueNotifier 正確的更新方式 (重新賦值觸發監聽)
              userProfile.value = userProfile.value;

              Navigator.pop(context);
            },
            child: const Text('儲存'),
          ),
        ],
      ),
    );
  }

  // 修改血壓的對話框
  void _showBPEditDialog(BuildContext context, UserProfile profile) {
    final sysController = TextEditingController(text: profile.sysBP.toString());
    final diaController = TextEditingController(text: profile.diaBP.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('記錄血壓'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: sysController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '收縮壓 (高壓)', suffixText: 'mmHg'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: diaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '舒張壓 (低壓)', suffixText: 'mmHg'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              profile.sysBP = int.tryParse(sysController.text) ?? profile.sysBP;
              profile.diaBP = int.tryParse(diaController.text) ?? profile.diaBP;

              // 【修正 2】ValueNotifier 正確的更新方式
              userProfile.value = userProfile.value;

              Navigator.pop(context);
            },
            child: const Text('儲存'),
          ),
        ],
      ),
    );
  }
}

// ================== 飲食日記頁面 (獨立頁面) ==================
class DietPage extends StatefulWidget {
  const DietPage({super.key});

  @override
  State<DietPage> createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  final TextEditingController _foodController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('飲食日記')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _foodController,
                    decoration: const InputDecoration(
                      labelText: '吃了什麼？',
                      hintText: '例如：雞胸肉沙拉',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton.small(
                  onPressed: () {
                    if (_foodController.text.isNotEmpty) {
                      setState(() {
                        userProfile.value.dietLog.add(_foodController.text);
                        // 【修正 2】確保全域更新
                        userProfile.value = userProfile.value;
                        _foodController.clear();
                      });
                    }
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<UserProfile>(
                valueListenable: userProfile,
                builder: (context, profile, child) {
                  if (profile.dietLog.isEmpty) {
                    return const Center(child: Text('目前還沒有記錄，快記下第一餐吧！', style: TextStyle(color: Colors.grey)));
                  }
                  return ListView.builder(
                    itemCount: profile.dietLog.length,
                    itemBuilder: (context, index) {
                      // 顯示最新的在上面
                      final food = profile.dietLog[profile.dietLog.length - 1 - index];
                      return ListTile(
                        leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                        title: Text(food),
                        subtitle: Text(DateTime.now().toString().split(' ')[0]), // 簡單顯示今天日期
                      );
                    },
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}