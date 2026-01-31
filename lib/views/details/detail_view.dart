import 'package:flutter/material.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Stack(
        children: [
          //arkaplan resmi
          Positioned.fill(
            child: Image.asset("assets/images/img1.jpg",
            fit: BoxFit.cover,
            )
          ),

          //karartma perde
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black54,
                    Colors.black87,
                  ],
                ),
              ),
            ),
          ),

          //içerik
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Başlık
                Text(
                  "%100 Metal Sunar: Mighty Metal",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                //boşluk
                const SizedBox(height: 10),

                //tarih saat
                Row(
                  children: const [
                    Icon(Icons.calendar_month, color: Color(0xFFD32F2F)),
                    SizedBox(width: 8),
                    Text("02 Şubat 2026", style: TextStyle(color: Colors.white70, fontSize: 16)),
                    SizedBox(width: 20),
                    Icon(Icons.location_on, color: Color(0xFFD32F2F)),
                    SizedBox(width: 20),
                    Text("Jolly Joker, Bursa", style: TextStyle(color: Colors.white70, fontSize: 16)),
                  ],
                ),

                //boşluk
                const SizedBox(height: 20),

                //açıklama
                const Text(
                  "Metal müziğin önde gelen organizasyonu %100 Metal'den yeni etkinlik! "
                  "Mighty Metal klasik ve power metal tutkunları için ilk kez Bursa'da.\n"
                  "Bu unutulmaz gece için hemen yerini ayır!",
                  style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
                ),

                //boşluk
                const SizedBox(height: 30),

                //bilet al
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD32F2F),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("BİLET AL - 1500 ₺", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}