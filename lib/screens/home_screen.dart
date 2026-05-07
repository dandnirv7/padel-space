import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_space/screens/detail_court_screen.dart';

class HomeController extends GetxController {
  var searchText = ''.obs;

  void resetSearch() {
    searchText.value = '';
    filteredCourts.assignAll(allCourts);
  }

  var allCourts = <Map<String, String>>[
    {
      'name': 'Sport Padel Club',
      'location': 'Bekasi Barat, Bekasi',
      'price': '120.000',
    },
    {
      'name': 'Jakarta Padel Arena',
      'location': 'Kebayoran Baru, Jakarta Selatan',
      'price': '180.000',
    },
    {
      'name': 'Urban Smash Padel',
      'location': 'Cilandak, Jakarta Selatan',
      'price': '170.000',
    },
    {
      'name': 'Depok Padel House',
      'location': 'Beji, Depok',
      'price': '140.000',
    },
    {
      'name': 'Bogor Padel Center',
      'location': 'Bogor Tengah, Bogor',
      'price': '135.000',
    },
    {
      'name': 'Tangerang Padel Club',
      'location': 'BSD City, Tangerang',
      'price': '160.000',
    },
    {
      'name': 'Serpong Elite Padel',
      'location': 'Serpong, Tangerang Selatan',
      'price': '175.000',
    },
    {
      'name': 'Bekasi Padel Arena',
      'location': 'Bekasi Utara, Bekasi',
      'price': '130.000',
    },
    {
      'name': 'Green Court Padel',
      'location': 'Bekasi Timur, Bekasi',
      'price': '125.000',
    },
    {
      'name': 'Victory Padel Club',
      'location': 'Cibubur, Jakarta Timur',
      'price': '150.000',
    },
  ].obs;

  var filteredCourts = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    filteredCourts.assignAll(allCourts);
  }

  void search(String value) {
    searchText.value = value;

    if (value.isEmpty) {
      filteredCourts.assignAll(allCourts);
    } else {
      filteredCourts.value = allCourts.where((court) {
        final name = court['name']!.toLowerCase();
        final location = court['location']!.toLowerCase();
        final keyword = value.toLowerCase();

        return name.contains(keyword) || location.contains(keyword);
      }).toList();
    }
  }
}

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        actionsPadding: EdgeInsets.symmetric(horizontal: 20),
        surfaceTintColor: Colors.transparent,
        leading: Icon(Icons.sports_tennis),
        actions: [
          IconButton(icon: Icon(Icons.notifications_none), onPressed: () {}),
        ],
      ),
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _heroSection(),

              const SizedBox(height: 16),

              _searchLocationCourt(controller: controller),

              const SizedBox(height: 16),

              // TITLE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Pilihan Lapangan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "Lihat Semua",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(
                            Icons.arrow_forward,
                            size: 14,
                            color: Colors.blueAccent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // LIST COURT (IMPORTANT)
              Obx(() {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.filteredCourts.length,
                  itemBuilder: (context, index) {
                    final court = controller.filteredCourts[index];
                    return _buildCourtCard(context, court);
                  },
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _heroSection extends StatelessWidget {
  const _heroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          // BACKGROUND IMAGE (KANAN)
          Positioned(
            right: 0, // sedikit keluar biar aesthetic
            bottom: 0,
            child: Image.asset(
              'assets/images/hero_padel_player_pastel.png',
              height: 212,
              fit: BoxFit.contain,
            ),
          ),

          // TEXT (KIRI)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'BOOK YOUR',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),

                  Text(
                    'PADEL COURT',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      color: Color(0xFFA9B4FF),
                    ),
                  ),

                  Text(
                    'ANYTIME,\nANYWHERE',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),

                  // SizedBox(height: 8),
                  Text(
                    'Main kapan aja,\ndi lapangan terbaik.',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _searchLocationCourt extends StatelessWidget {
  const _searchLocationCourt({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),

          boxShadow: [
            BoxShadow(
              color: Color(0xFFDCE8FF),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: TextField(
          onChanged: controller.search,

          decoration: InputDecoration(
            hintText: "Cari lokasi atau nama lapangan...",
            hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),

            prefixIcon: const Icon(Icons.search),

            suffixIcon: Padding(
              padding: const EdgeInsets.all(0),
              child: GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                    backgroundColor: Colors.white,
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Filter Lokasi"),

                          ListTile(
                            title: const Text("Jakarta"),
                            onTap: () {
                              controller.search("jakarta");
                              Get.back();
                            },
                          ),

                          ListTile(
                            title: const Text("Bogor"),
                            onTap: () {
                              controller.search("bogor");
                              Get.back();
                            },
                          ),

                          ListTile(
                            title: const Text("Bekasi"),
                            onTap: () {
                              controller.search("bekasi");
                              Get.back();
                            },
                          ),

                          ListTile(
                            title: const Text("Depok"),
                            onTap: () {
                              controller.search("depok");
                              Get.back();
                            },
                          ),

                          ListTile(
                            title: const Text("Tangerang"),
                            onTap: () {
                              controller.search("tangerang");
                              Get.back();
                            },
                          ),

                          ListTile(
                            title: const Text("Reset"),
                            onTap: () {
                              controller.resetSearch();
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },

                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD3F4E8),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: const Icon(Icons.tune, color: Colors.black, size: 24),
                ),
              ),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ),
    );
  }
}

Widget _buildCourtCard(BuildContext context, Map<String, String> court) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 120,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          // IMAGE
          Container(
            width: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: AssetImage('assets/images/court.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  court['name']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Icon(Icons.location_on, size: 12, color: Colors.red),
                    SizedBox(width: 4),
                    Text(
                      court['location']!,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: const [
                    Icon(Icons.camera_indoor, size: 12),
                    SizedBox(width: 4),
                    Text("Indoor", style: TextStyle(fontSize: 12)),

                    SizedBox(width: 12),

                    Icon(Icons.people, size: 12),
                    SizedBox(width: 4),
                    Text("4 Pemain", style: TextStyle(fontSize: 12)),
                  ],
                ),

                const Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // PRICE
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Rp ",
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: court['price'],
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const TextSpan(
                            text: "/jam",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailCourtPage(court: court),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(14),
                          backgroundColor: const Color(0xFFFFF3E0),
                          elevation: 0,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          size: 18,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
