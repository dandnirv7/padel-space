import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_space/screens/booking_screen.dart';

class DetailCourtController extends GetxController {
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  final selectedTime = ''.obs;

  final List<String> timeSlots = [
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
  ];

  void selectTimeSlot(String time) {
    selectedTime.value = time;
    timeController.text = time;
  }

  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    dateController.dispose();
    timeController.dispose();
    super.onClose();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      dateController.text = "${picked.day}-${picked.month}-${picked.year}";
    }
  }

  void proceedToBooking(BuildContext context, Map<dynamic, dynamic> court) {
    if (formKey.currentState!.validate()) {
      Get.to(
        () => BookingScreen(
          court: court,
          date: dateController.text,
          time: timeController.text,
        ),
      );
    }
  }
}

class DetailCourtScreen extends StatelessWidget {
  final Map<dynamic, dynamic> court;
  final DetailCourtController controller = Get.put(DetailCourtController());

  DetailCourtScreen({super.key, required this.court});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline_outlined),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    "assets/images/court.jpg",
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  court['name'] ?? '-',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      court['location'] ?? '-',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildFacilityChip(Icons.location_city_outlined, 'Indoor'),
                    _buildFacilityChip(Icons.people_outlined, '4 Player'),
                    _buildFacilityChip(Icons.ac_unit_outlined, 'AC'),
                    _buildFacilityChip(Icons.location_city_outlined, 'Indoor'),
                    _buildFacilityChip(Icons.location_city_outlined, 'Indoor'),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Tentang Lapangan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Lapangan ini memiliki fasilitas lengkap dengan standar internasional, cocok untuk bermain santai maupun kompetisi.",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Harga",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Rp ${court['price'] ?? '-'} / jam",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Pilih Jadwal",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: controller.dateController,
                        readOnly: true,
                        onTap: () => controller.selectDate(context),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Silakan pilih tanggal';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Pilih Tanggal",
                          prefixIcon: const Icon(
                            Icons.calendar_today,
                            color: Colors.blue,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        "Pilih Jam",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),

                      FormField<String>(
                        validator: (value) {
                          if (controller.timeController.text.isEmpty) {
                            return 'Silakan pilih jam';
                          }
                          return null;
                        },
                        builder: (field) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: controller.timeSlots.map((time) {
                                    final bool isSelected =
                                        controller.selectedTime.value == time;

                                    return ChoiceChip(
                                      label: Text(time),
                                      selected: isSelected,
                                      showCheckmark: false,
                                      onSelected: (_) {
                                        controller.selectTimeSlot(time);
                                        field.didChange(time);
                                      },
                                      selectedColor: Colors.blueAccent,
                                      backgroundColor: Colors.grey.shade100,
                                      labelStyle: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          color: isSelected
                                              ? Colors.blueAccent
                                              : Colors.grey.shade300,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              if (field.hasError)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    left: 4,
                                  ),
                                  child: Text(
                                    field.errorText!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () =>
                        controller.proceedToBooking(context, court),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Booking Sekarang",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFacilityChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
