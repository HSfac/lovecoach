import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/inquiry_service.dart';
import '../models/inquiry_model.dart';
import 'auth_provider.dart';

final inquiryServiceProvider = Provider<InquiryService>((ref) {
  return InquiryService();
});

final userInquiriesProvider = StreamProvider<List<InquiryModel>>((ref) {
  final inquiryService = ref.read(inquiryServiceProvider);
  return inquiryService.getUserInquiriesStream();
});

final inquiryNotifierProvider = StateNotifierProvider<InquiryNotifier, AsyncValue<bool>>((ref) {
  return InquiryNotifier(ref);
});

class InquiryNotifier extends StateNotifier<AsyncValue<bool>> {
  final Ref ref;
  
  InquiryNotifier(this.ref) : super(const AsyncValue.data(false));

  Future<bool> submitInquiry(String message) async {
    try {
      state = const AsyncValue.loading();
      
      final inquiryService = ref.read(inquiryServiceProvider);
      final currentUser = ref.read(currentUserProvider).value;
      
      await inquiryService.submitInquiry(
        message: message,
        currentUser: currentUser,
      );
      
      state = const AsyncValue.data(true);
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  Future<List<InquiryModel>> getUserInquiries() async {
    try {
      final inquiryService = ref.read(inquiryServiceProvider);
      return await inquiryService.getUserInquiries();
    } catch (e) {
      return [];
    }
  }

  void resetState() {
    state = const AsyncValue.data(false);
  }
}