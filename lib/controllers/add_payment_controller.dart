import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/controllers/card_details_controller.dart';
import '/models/card_detail.dart';

class AddPaymentController extends GetxController {
  int cardNumber = 0, cvv = 0, month = 0, year = 0;
  var name = "".obs;
  var dateString = "".obs;
  var lastFourDigits = "".obs;
  final _supabaseClient = Supabase.instance.client;
  final CardDetailsController _cardDetailsController = Get.find();

  Future addCardDetail() async {
    final insertData = await _supabaseClient.from("Card_Details").insert({
      "cardholder_name": name.value,
      "card_number": cardNumber,
      "month": month,
      "year": year,
      "user_id": _supabaseClient.auth.currentUser?.id
    }).execute();

    // if (insertData.error != null) {
    //   print("Error during insert operation: ${insertData.error}");
    // } else {
    //   print("Insert successful");
    // }

    if (_cardDetailsController.cardDetailList.isEmpty) {
      _cardDetailsController.selectedIndex.value = 0;

      //set default user Address Id in the database
      await _supabaseClient
          .from("Users")
          .update({'default_card_detail_id': insertData.data[0]})
          .eq(
            "user_id",
            _supabaseClient.auth.user()?.id,
          )
          .execute();
    }

    _cardDetailsController.cardDetailList.add(
      CardDetail(
        id: insertData.data[0]['payment_id'],
        name: name.value,
        cardNumber: cardNumber,
        month: month,
        year: year,
      ),
    );
    Get.back();
  }
}
