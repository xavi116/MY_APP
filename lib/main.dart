import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

// 全域變數：音樂播放器
final player = AudioPlayer()..setReleaseMode(ReleaseMode.loop);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '黃冠竣的自傳',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 這裡放入四個頁面
  final tabs = [
    Screen1(),
    Screen2(),
    Screen3(),
    Screen4(),
  ];

  int previousIndex = 0;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 初始化播放第一首 (如果需要剛進去就播的話)
    if (currentIndex == 0) player.play(AssetSource("1.mp3"));

    return Scaffold(
      appBar: AppBar(
        title: Text("我的自傳 App"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: tabs[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        selectedFontSize: 18,
        unselectedFontSize: 14,
        iconSize: 30,
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: currentIndex == 0
                ? Image.asset('assets/a1.png', width: 40, height: 40)
                : Image.asset('assets/a11.png', width: 30, height: 30),
            label: "自我介紹",
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 1
                ? Image.asset('assets/a2.png', width: 40, height: 40)
                : Image.asset('assets/a21.png', width: 30, height: 30),
            label: "學習歷程",
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 2
                ? Image.asset('assets/a3.jpg', width: 40, height: 40)
                : Image.asset('assets/a31.jpg', width: 30, height: 30),
            label: "學習計畫",
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 3
                ? Image.asset('assets/a4.png', width: 40, height: 40)
                : Image.asset('assets/a41.png', width: 30, height: 30),
            label: "專業方向",
          ),
        ],
        onTap: (index) {
          setState(() {
            previousIndex = currentIndex;
            currentIndex = index;
            // 切換頁面時換音樂
            if (index == 0) {
              if (previousIndex == currentIndex) player.resume();
              player.stop();
              player.play(AssetSource("1.mp3"));
            }
            if (index == 1) {
              if (previousIndex == currentIndex) player.resume();
              player.stop();
              player.play(AssetSource("2.mp3"));
            }
            if (index == 2) {
              if (previousIndex == currentIndex) player.resume();
              player.stop();
              player.play(AssetSource("3.mp3"));
            }
            if (index == 3) {
              if (previousIndex == currentIndex) player.resume();
              player.stop();
              player.play(AssetSource("4.mp3"));
            }
          });
        },
      ),
    );
  }
}

// ================== 第一頁：自我介紹 ==================
class Screen1 extends StatelessWidget {
  Screen1({super.key});

  final String s1 = "我是黃冠竣，來自彰化，今年21歲，是個外冷內熱的天蠍座。生長在一家四口的家庭，父親在警界服務，或許是受到父親嚴謹工作的耳濡目染，雖然小時候曾經歷過一段叛逆不懂事的時期，總覺得大人的碎念很煩，直到長大離家求學後，才逐漸體會到家人的苦心，也開始後悔當初沒有多聽聽他們的建議。\n\n"
      "除了家庭，音樂是我生活中不可或缺的調味劑，我熱愛彈吉他，在指尖觸碰琴弦的震動中，我能找到平靜，也能宣洩情緒。現在的我，正努力補足過去的不足，希望成為一個讓家人驕傲的大人。";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
            child: Text(
              "Who am I",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.fromLTRB(30, 0, 30, 30),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 3),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.amberAccent, offset: Offset(6, 6)),
              ],
            ),
            child: Text(s1, style: TextStyle(fontSize: 20)),
          ),
          // 放照片的地方
          Container(
            color: Colors.redAccent,
            child: Image.asset('assets/a1.png'),
            width: 200,
            height: 200,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ================== 第二頁：學習歷程 ==================
class Screen2 extends StatelessWidget {
  Screen2({super.key});

  final String s2 = "高中畢業於彰師大附工，那是奠定我基礎技能的重要階段。目前就讀於國立高雄科技大學，這是一個充滿機會與挑戰的環境。\n\n"
      "在學業之外，我投入了大量的熱情在「吉他社」，並擔任了「燈控長」的幹部職位。這個職位不只是負責打燈，更考驗著對舞台氛圍的掌握以及團隊合作的默契。在無數次的活動與成發中，我學會了如何在幕後默默付出，成就台上的光彩，這段經歷讓我明白，每一個細節的精準控制，都是完美演出的關鍵，也培養了我解決突發狀況的能力。";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
            child: Text(
              "My History",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.fromLTRB(30, 0, 30, 30),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 3),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.lightBlueAccent, offset: Offset(6, 6)),
              ],
            ),
            child: Text(s2, style: TextStyle(fontSize: 20)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.purple, width: 2, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                      image: AssetImage('assets/a2.png'), fit: BoxFit.cover),
                ),
              ),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.purple, width: 2, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                      image: AssetImage('assets/a3.jpg'), fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ================== 第三頁：學習計畫 ==================
class Screen3 extends StatelessWidget {
  const Screen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("大三時期目標", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // 置中
            children: [
              Container(
                height: 300,
                width: 250, // 加寬一點讓字能顯示完整
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(Icons.check_circle_outline, color: Colors.green),
                      title: Text("補足學科漏洞", style: TextStyle(fontSize: 20)),
                      subtitle: Text("複習基礎，打好地基"),
                    ),
                    ListTile(
                      leading: Icon(Icons.flag, color: Colors.red),
                      title: Text("確立職涯目標", style: TextStyle(fontSize: 20)),
                      subtitle: Text("尋找適合自己的出路"),
                    ),
                    ListTile(
                      leading: Icon(Icons.trending_up, color: Colors.blue),
                      title: Text("提升學業成績", style: TextStyle(fontSize: 20)),
                      subtitle: Text("對自己負責，爭取佳績"),
                    ),
                    ListTile(
                      leading: Icon(Icons.music_note, color: Colors.orange),
                      title: Text("享受學生青春", style: TextStyle(fontSize: 20)),
                      subtitle: Text("把握最後的校園時光"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ================== 第四頁：專業方向 ==================
class Screen4 extends StatelessWidget {
  Screen4({super.key});

  final String s4 = "身為資訊領域的學生，我期望未來能成為一名全端工程師或是行動裝置 App 開發者。\n\n"
      "我喜歡將邏輯思維轉化為實際可操作的應用程式，就像在吉他社控制燈光一樣，透過程式碼來搭建使用者的舞台。目前的目標是精進 Flutter 與前後端串接技術，期許自己不僅能寫出高效率的程式碼，更能開發出具備美感與使用者體驗的產品，將科技與人文溫度結合。";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
            child: Text(
              "Future & Career",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.fromLTRB(30, 0, 30, 30),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 3),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.purpleAccent, offset: Offset(6, 6)),
              ],
            ),
            child: Text(s4, style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 15),
          Container(
            width: 200,
            height: 200,
            child: Image.asset('assets/a4.png'), // 假設這裡有一張代表專業的圖片
          ),
        ],
      ),
    );
  }
}