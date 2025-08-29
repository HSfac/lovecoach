import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class IAPService {
  static final IAPService _instance = IAPService._internal();
  factory IAPService() => _instance;
  IAPService._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // 상품 ID들
  static const String premiumMonthlyId = 'premium_monthly_9900';
  static const Set<String> productIds = {premiumMonthlyId};

  // 상품 정보
  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  // 구매 상태 콜백
  Function(bool success, String message)? onPurchaseComplete;
  Function(List<PurchaseDetails>)? onPurchaseRestored;

  Future<void> initialize() async {
    // InAppPurchase 사용 가능한지 확인
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      throw Exception('인앱 결제를 사용할 수 없습니다.');
    }

    // Android 설정은 앱 스토어 배포시 필요
    if (defaultTargetPlatform == TargetPlatform.android) {
      // TODO: 실제 배포시 Android pending purchases 설정 필요
    }

    // 구매 스트림 리스너 등록
    _subscription = _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdated,
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        debugPrint('Purchase stream error: $error');
      },
    );

    // 상품 정보 로드
    await loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(productIds);
      
      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('Products not found: ${response.notFoundIDs}');
      }
      
      _products = response.productDetails;
      debugPrint('Loaded ${_products.length} products');
    } catch (e) {
      debugPrint('Failed to load products: $e');
      throw Exception('상품 정보를 불러올 수 없습니다.');
    }
  }

  Future<bool> purchasePremium() async {
    try {
      final ProductDetails? productDetails = _products
          .where((product) => product.id == premiumMonthlyId)
          .firstOrNull;

      if (productDetails == null) {
        throw Exception('상품을 찾을 수 없습니다.');
      }

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
      );

      // 구독 구매 시작
      final bool success = await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      
      if (!success) {
        throw Exception('구매를 시작할 수 없습니다.');
      }

      return true;
    } catch (e) {
      debugPrint('Purchase failed: $e');
      onPurchaseComplete?.call(false, e.toString());
      return false;
    }
  }

  Future<void> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      debugPrint('Restore purchases failed: $e');
      throw Exception('구매 복원에 실패했습니다.');
    }
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          debugPrint('Purchase pending: ${purchaseDetails.productID}');
          break;

        case PurchaseStatus.purchased:
          debugPrint('Purchase completed: ${purchaseDetails.productID}');
          _handlePurchaseSuccess(purchaseDetails);
          break;

        case PurchaseStatus.restored:
          debugPrint('Purchase restored: ${purchaseDetails.productID}');
          _handlePurchaseRestored(purchaseDetails);
          break;

        case PurchaseStatus.error:
          debugPrint('Purchase error: ${purchaseDetails.error}');
          _handlePurchaseError(purchaseDetails);
          break;

        case PurchaseStatus.canceled:
          debugPrint('Purchase canceled: ${purchaseDetails.productID}');
          onPurchaseComplete?.call(false, '구매가 취소되었습니다.');
          break;
      }

      // 구매 완료 처리
      if (purchaseDetails.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  void _handlePurchaseSuccess(PurchaseDetails purchaseDetails) {
    // 구매 검증 (서버에서 처리하는 것이 좋음)
    if (_verifyPurchase(purchaseDetails)) {
      onPurchaseComplete?.call(true, '구독이 완료되었습니다! 🎉');
      _updateUserSubscription(purchaseDetails);
    } else {
      onPurchaseComplete?.call(false, '구매 검증에 실패했습니다.');
    }
  }

  void _handlePurchaseRestored(PurchaseDetails purchaseDetails) {
    if (_verifyPurchase(purchaseDetails)) {
      _updateUserSubscription(purchaseDetails);
    }
    onPurchaseRestored?.call([purchaseDetails]);
  }

  void _handlePurchaseError(PurchaseDetails purchaseDetails) {
    String errorMessage = '구매 중 오류가 발생했습니다.';
    
    if (purchaseDetails.error != null) {
      final error = purchaseDetails.error!;
      switch (error.code) {
        case 'user_canceled':
          errorMessage = '사용자가 구매를 취소했습니다.';
          break;
        case 'payment_invalid':
          errorMessage = '결제 정보가 유효하지 않습니다.';
          break;
        case 'payment_not_allowed':
          errorMessage = '결제가 허용되지 않습니다.';
          break;
        default:
          errorMessage = error.message;
      }
    }
    
    onPurchaseComplete?.call(false, errorMessage);
  }

  bool _verifyPurchase(PurchaseDetails purchaseDetails) {
    // 실제 구현에서는 서버에서 영수증 검증을 해야 합니다.
    // 이는 보안상 중요한 부분입니다.
    
    // iOS: purchaseDetails.verificationData.serverVerificationData
    // Android: purchaseDetails.verificationData.serverVerificationData
    
    // 임시로 true 반환 (개발용)
    return purchaseDetails.purchaseID != null;
  }

  void _updateUserSubscription(PurchaseDetails purchaseDetails) {
    // Firebase에서 사용자의 구독 상태를 업데이트
    // 실제 구현에서는 서버에서 처리하는 것이 안전합니다.
    debugPrint('Updating user subscription: ${purchaseDetails.productID}');
  }

  // 구독 상태 확인
  Future<bool> isSubscriptionActive() async {
    try {
      // 실제 구현에서는 서버 API를 통해 구독 상태를 확인해야 합니다.
      await _inAppPurchase.restorePurchases();
      
      // 임시로 false 반환 (실제로는 서버에서 확인)
      return false;
    } catch (e) {
      debugPrint('Failed to check subscription: $e');
      return false;
    }
  }

  void dispose() {
    _subscription.cancel();
  }
}

// 상품 정보 모델
class SubscriptionProduct {
  final String id;
  final String title;
  final String description;
  final String price;
  final String currencyCode;

  SubscriptionProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currencyCode,
  });

  factory SubscriptionProduct.fromProductDetails(ProductDetails details) {
    return SubscriptionProduct(
      id: details.id,
      title: details.title,
      description: details.description,
      price: details.price,
      currencyCode: details.currencyCode,
    );
  }
}