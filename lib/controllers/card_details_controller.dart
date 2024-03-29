import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/models/card_detail.dart';

class CardDetailsController extends GetxController {
  final _supabaseClient = Supabase.instance.client;
  var cardDetailList = <CardDetail>[].obs;
  var selectedIndex = 0.obs;

  String getLastFourDigits() {
    if (cardDetailList.isNotEmpty) {
      return cardDetailList
          .elementAt(selectedIndex.value)
          .cardNumber
          .toString()
          .substring(12);
    }
    return "XXXX";
  }

  Future fetchCardDetails() async {
    //fetch Card Details
    final response = await _supabaseClient
        .from("Card_Details")
        .select()
        .eq(
          "user_id",
          _supabaseClient.auth.user()?.id,
        )
        .execute();
    final responseList = response.data as List;
    for (int i = 0; i < responseList.length; i++) {
      cardDetailList.add(CardDetail.fromJson(responseList[i]));
    }
  }

  Future getDefaultCardDetail() async {
    //get default card detail
    final defaultShippingResponse = await _supabaseClient
        .from("Users")
        .select('default_card_detail_id')
        .eq(
          "user_id",
          _supabaseClient.auth.currentUser?.id,
        )
        .execute();
    if (defaultShippingResponse.data.isEmpty) {
      print("----------Shipping details are empyty----------");
    } else {
      int? responseId =
          defaultShippingResponse.data[0]['default_card_detail_id'];
      await fetchCardDetails();

      if (responseId != null) {
        for (int i = 0; i < cardDetailList.length; i++) {
          if (cardDetailList.elementAt(i).id == responseId) {
            selectedIndex.value = i;
            break;
          }
        }
      }
    }
  }

  Future setDefaultCardDetail(int index) async {
    if (selectedIndex.value == index) {
      return;
    }
    selectedIndex.value = index;
    await _supabaseClient
        .from("Users")
        .update({'default_card_detail_id': cardDetailList.elementAt(index).id})
        .eq(
          "user_id",
          _supabaseClient.auth.user()?.id,
        )
        .execute();
  }
}
