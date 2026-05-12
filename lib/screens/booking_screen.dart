import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final notesController = TextEditingController();

  final RxInt numberOfPlayers = 4.obs;

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    notesController.dispose();
    super.onClose();
  }

  void submitBooking(String date, String time) {
    if (formKey.currentState!.validate()) {
      String nama = nameController.text;
      String noWhatsapp = phoneController.text;
      int pemain = numberOfPlayers.value;
      String catatan = notesController.text.isEmpty
          ? "Tidak ada catatan"
          : notesController.text;

      String pesan =
          "Nama: $nama\n"
          "No Whatsapp: $noWhatsapp\n"
          "Jumlah Pemain: $pemain\n"
          "Tanggal: $date\n"
          "Jam: $time\n"
          "Catatan: $catatan";

      Get.snackbar(
        "Booking Berhasil",
        pesan,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 5),
      );
    }
  }
}

class BookingScreen extends StatelessWidget {
  final Map<dynamic, dynamic> court;
  final String date;
  final String time;

  BookingScreen({
    super.key,
    required this.court,
    required this.date,
    required this.time,
  });

  final BookingController controller = Get.put(BookingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 260,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/court.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(20),
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      court['name'] ?? 'Padel Court',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "$date, $time",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              transform: Matrix4.translationValues(0.0, -20.0, 0.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Informasi Pemesan",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _InputFormField(
                      text: "Nama Lengkap",
                      hintText: "Masukkan nama lengkap",
                      icon: Icons.person_outline,
                      controller: controller.nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama lengkap tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _InputFormField(
                      text: "No. Whatsapp",
                      hintText: "081XXXXXXXXX",
                      icon: Icons.phone_outlined,
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor Whatsapp tidak boleh kosong';
                        }

                        if (!value.startsWith('08') &&
                            !value.startsWith('+62')) {
                          return 'Nomor harus diawali 08 atau +62';
                        }

                        if (value.length < 10) {
                          return 'Nomor terlalu pendek (minimal 10 karakter)';
                        }

                        if (value.length > 15) {
                          return 'Nomor terlalu panjang (maksimal 15 karakter)';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Detail Pemesanan",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _DropdownPlayers(controller: controller),
                    const SizedBox(height: 16),
                    _InputFormField(
                      text: "Catatan Tambahan (Opsional)",
                      hintText: "Contoh: Butuh raket cadangan",
                      icon: Icons.note_alt_outlined,
                      controller: controller.notesController,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 56,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          shadowColor: Colors.blueAccent.withValues(alpha: 0.4),
                        ),
                        onPressed: () => controller.submitBooking(date, time),
                        child: const Text(
                          "Konfirmasi Booking",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DropdownPlayers extends StatelessWidget {
  final BookingController controller;

  const _DropdownPlayers({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Jumlah Pemain",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonFormField<int>(
            initialValue: controller.numberOfPlayers.value,
            onChanged: (value) {
              if (value != null) {
                controller.numberOfPlayers.value = value;
              }
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.people_outline,
                color: Colors.blueAccent.shade200,
              ),
            ),
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            items: const [
              DropdownMenuItem(
                value: 4,
                child: Text("4 Pemain", style: TextStyle(fontSize: 16)),
              ),
              DropdownMenuItem(
                value: 6,
                child: Text("6 Pemain", style: TextStyle(fontSize: 16)),
              ),
              DropdownMenuItem(
                value: 8,
                child: Text("8 Pemain", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InputFormField extends StatelessWidget {
  final String text;
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const _InputFormField({
    required this.text,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade400),
            prefixIcon: Icon(icon, color: Colors.blueAccent.shade200, size: 22),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.blueAccent,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade300),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
