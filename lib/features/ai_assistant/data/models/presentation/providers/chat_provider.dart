import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../chat_message.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  final apiKey = dotenv.env['GEMINI_API_KEY'] ?? "";
  return ChatNotifier(apiKey);
});

const String _systemPrompt = """
Sen RockRoute uygulamasının barmenisin. Adın Ronnie.
Yıllarca rock/metal barlarında çalıştın, her mekanın kokusunu, havasını bilirsin.
Konuşma tarzın: samimi, bazen kaba, bazen şiirsel. Ama asla yapay değil.

KİŞİLİK KURALLARI:
- Teknik müzik jargonunu (distortion, riff, amfi) SADECE çok doğal geldiğinde kullan, zorla sıkıştırma.
- Ronnie James Dio'ya NADIREN atıf yap, her cevaba koyma. Koyacaksan derin ve anlamlı olsun.
- Bazen sessiz bilge ol, bazen coşkulu, bazen yorgun bir barmen gibi konuş.
- Hitap: 'kanka', 'kardeş' — ama her cümlede değil. Kullanıcının tonuna uygun konuş.

MEKAN SORULARI İÇİN KURAL:
- Kullanıcı bir mekan sorduğunda Google'dan gerçek bilgiyi bul ve kullan.
- Mekan hakkında gerçek bilgileri rock kültürü çerçevesinde yorumla.
- Kesin bilgin yoksa dürüstçe söyle.
- AÇIK/KAPALI bilgisi verirken çok dikkatli ol, bu bilgi değişken olabilir.   // ✅ bunu ekle
- Çalışma saatleri veya güncel durum için her zaman en son arama sonucunu baz al. // ✅ bunu ekle

Cevapların kısa ve öz olsun. Her cevap farklı bir ruh hali taşısın.
""";

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final String apiKey;
  final List<Map<String, dynamic>> _history = [];

  ChatNotifier(this.apiKey) : super([]) {
    print("🔑 API KEY: $apiKey");
  }

  Future<void> sendMessage(String text) async {
    state = [...state, ChatMessage(message: text, isUser: true)];
    _history.add({
      'role': 'user',
      'parts': [{'text': text}]
    });

    try {
      print("📤 Mesaj gönderiliyor: $text");

      final response = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'system_instruction': {
            'parts': [{'text': _systemPrompt}]
          },
          'tools': [{'google_search': {}}],
          'contents': _history,
        }),
      );

      print("📥 Status: ${response.statusCode}");

      if (response.statusCode == 200) {

        final fullBody = response.body;
        for (int i = 0; i < fullBody.length; i += 800) {
          print(fullBody.substring(i, i + 800 > fullBody.length ? fullBody.length : i + 800));
        }
        
        final data = jsonDecode(response.body);
        final botMessage = data['candidates'][0]['content']['parts'][0]['text'] as String;

        _history.add({
          'role': 'model',
          'parts': [{'text': botMessage}]
        });

        state = [...state, ChatMessage(message: botMessage, isUser: false)];
      } else {
        final error = jsonDecode(response.body);
        print("🔴 API Hatası: ${error['error']['message']}");
        state = [...state, ChatMessage(message: "Hata: ${error['error']['message']}", isUser: false)];
      }
    } catch (e, stackTrace) {
      print("🔴 Genel Hata: $e");
      print("📋 Stack: $stackTrace");
      state = [...state, ChatMessage(message: "Sistemde bir parazit var kanka!", isUser: false)];
    }
  }
}