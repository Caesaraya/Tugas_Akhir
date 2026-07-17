import 'dart:async';
import 'package:flutter/material.dart';
// IMPORT FILE WARNA KAMU
import 'package:tugas_akhir/utils/app_color.dart';

class LeftBannerWidget extends StatefulWidget {
  const LeftBannerWidget({super.key});

  @override
  State<LeftBannerWidget> createState() => _LeftBannerWidgetState();
}

class _LeftBannerWidgetState extends State<LeftBannerWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  // 1. DAFTAR FOTO PRODUK (Sesuaikan path sesuai aset proyekmu)
  final List<String> _images = [
    'assets/rumah1.jpg',
    'assets/rumah2.jpg',
    'assets/rumah3.jpg',
  ];

  // 2. DAFTAR KALIMAT MOTIVASI BISNIS / BACKERY
  final List<String> _motivations = [
    "“Kehangatan setiap adonan adalah kunci kebahagiaan para pelanggan.”",
    "“Konsistensi dalam rasa membangun kepercayaan yang tak bernilai.”",
    "“Kualitas bahan terbaik melahirkan kelezatan yang selalu dirindukan.”",
  ];

  @override
  void initState() {
    super.initState();
    // Membuat gambar bergeser otomatis setiap 4 detik
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < _images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.ba, // Menggunakan warna dasar bawaan
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // BRAND HEADER

            // IMAGE SLIDER CONTAINER
            Container(
              height: 420,
              width: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Image.asset(_images[index], fit: BoxFit.cover);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // SLIDER INDICATOR DOTS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  height: 6,
                  width: _currentPage == index ? 24 : 6,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.primaryOrange
                        : AppColors.textWhiteMuted,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // MOTIVATIONAL TEXT AREA
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                _motivations[_currentPage],
                key: ValueKey<int>(_currentPage),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
