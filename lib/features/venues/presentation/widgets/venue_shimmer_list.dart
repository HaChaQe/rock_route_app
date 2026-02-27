import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_constants.dart'; // Sabitlerini çektiğin dosya

class VenueShimmerList extends StatelessWidget {
  const VenueShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // Yüklenirken 5 adet sahte kart gösterelim
      padding: const EdgeInsets.all(16.0), // Ekranın kenar boşlukları
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppConstants.surfaceColor, // Asıl kartın arka plan rengi
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          // Shimmer efektini sadece içerikteki gri kutulara uyguluyoruz
          child: Shimmer.fromColors(
            baseColor: Colors.grey[800]!,
            highlightColor: Colors.grey[600]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Üstteki Görsel İskeleti (150px yüksekliğinde)
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white, // Shimmer'ın parlaması için beyaz verilir
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppConstants.borderRadius),
                    ),
                  ),
                ),
                
                // 2. Alttaki Metin İskeletleri
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Başlık ve Puan Rozeti Satırı
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Başlık Kutusu
                          Expanded(
                            child: Container(
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Uzaklık ve Puan Rozeti Kutusu
                          Container(
                            width: 80,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Açıklama 1. Satır
                      Container(
                        width: double.infinity,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}