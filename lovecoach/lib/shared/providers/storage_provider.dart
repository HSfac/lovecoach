import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 저장소 관리 상태 관리
final storageProvider = StateNotifierProvider<StorageNotifier, StorageState>((ref) {
  return StorageNotifier();
});

// 자동 캐시 정리 설정
final autoClearSettingsProvider = StateNotifierProvider<AutoClearNotifier, AutoClearSettings>((ref) {
  return AutoClearNotifier();
});

class StorageState {
  final int totalCacheSize;
  final int imageCacheSize;
  final int chatCacheSize;
  final int tempFileSize;
  final bool isLoading;
  final String? error;

  const StorageState({
    this.totalCacheSize = 0,
    this.imageCacheSize = 0,
    this.chatCacheSize = 0,
    this.tempFileSize = 0,
    this.isLoading = false,
    this.error,
  });

  StorageState copyWith({
    int? totalCacheSize,
    int? imageCacheSize,
    int? chatCacheSize,
    int? tempFileSize,
    bool? isLoading,
    String? error,
  }) {
    return StorageState(
      totalCacheSize: totalCacheSize ?? this.totalCacheSize,
      imageCacheSize: imageCacheSize ?? this.imageCacheSize,
      chatCacheSize: chatCacheSize ?? this.chatCacheSize,
      tempFileSize: tempFileSize ?? this.tempFileSize,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  String get totalCacheSizeFormatted => _formatBytes(totalCacheSize);
  String get imageCacheSizeFormatted => _formatBytes(imageCacheSize);
  String get chatCacheSizeFormatted => _formatBytes(chatCacheSize);
  String get tempFileSizeFormatted => _formatBytes(tempFileSize);

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

class AutoClearSettings {
  final bool enableAutoClearing;
  final int autoClearDays;
  final bool clearOnAppStart;
  final bool clearImages;
  final bool clearChats;
  final bool clearTempFiles;

  const AutoClearSettings({
    this.enableAutoClearing = false,
    this.autoClearDays = 7,
    this.clearOnAppStart = false,
    this.clearImages = true,
    this.clearChats = false,
    this.clearTempFiles = true,
  });

  AutoClearSettings copyWith({
    bool? enableAutoClearing,
    int? autoClearDays,
    bool? clearOnAppStart,
    bool? clearImages,
    bool? clearChats,
    bool? clearTempFiles,
  }) {
    return AutoClearSettings(
      enableAutoClearing: enableAutoClearing ?? this.enableAutoClearing,
      autoClearDays: autoClearDays ?? this.autoClearDays,
      clearOnAppStart: clearOnAppStart ?? this.clearOnAppStart,
      clearImages: clearImages ?? this.clearImages,
      clearChats: clearChats ?? this.clearChats,
      clearTempFiles: clearTempFiles ?? this.clearTempFiles,
    );
  }
}

class StorageNotifier extends StateNotifier<StorageState> {
  StorageNotifier() : super(const StorageState()) {
    calculateStorageSize();
  }

  Future<void> calculateStorageSize() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final tempDir = await getTemporaryDirectory();
      final appDir = await getApplicationDocumentsDirectory();
      final cacheDir = await getApplicationCacheDirectory();

      // 각 디렉토리 크기 계산
      final tempSize = await _getDirectorySize(tempDir);
      final cacheSize = await _getDirectorySize(cacheDir);
      
      // 이미지 캐시 크기 (임시 추정)
      final imageSize = (cacheSize * 0.6).round(); // 캐시의 60%가 이미지라고 가정
      
      // 채팅 캐시 크기 (임시 추정)
      final chatSize = (cacheSize * 0.3).round(); // 캐시의 30%가 채팅이라고 가정

      state = state.copyWith(
        totalCacheSize: cacheSize + tempSize,
        imageCacheSize: imageSize,
        chatCacheSize: chatSize,
        tempFileSize: tempSize,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '저장소 정보를 불러오는 중 오류가 발생했습니다',
      );
    }
  }

  Future<int> _getDirectorySize(Directory directory) async {
    int totalSize = 0;
    
    if (await directory.exists()) {
      await for (final entity in directory.list(recursive: true)) {
        if (entity is File) {
          try {
            final stat = await entity.stat();
            totalSize += stat.size;
          } catch (e) {
            // 파일에 접근할 수 없는 경우 무시
          }
        }
      }
    }
    
    return totalSize;
  }

  Future<bool> clearAllCache() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final tempDir = await getTemporaryDirectory();
      final cacheDir = await getApplicationCacheDirectory();
      
      await _clearDirectory(tempDir);
      await _clearDirectory(cacheDir);
      
      // SharedPreferences의 캐시 키들도 정리
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith('cache_')).toList();
      for (final key in keys) {
        await prefs.remove(key);
      }
      
      await calculateStorageSize();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '캐시 삭제 중 오류가 발생했습니다',
      );
      return false;
    }
  }

  Future<bool> clearImageCache() async {
    try {
      final cacheDir = await getApplicationCacheDirectory();
      final imageDir = Directory('${cacheDir.path}/images');
      
      if (await imageDir.exists()) {
        await _clearDirectory(imageDir);
      }
      
      await calculateStorageSize();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> clearChatCache() async {
    try {
      // SharedPreferences에서 채팅 관련 캐시 삭제
      final prefs = await SharedPreferences.getInstance();
      final chatKeys = prefs.getKeys().where((key) => 
          key.startsWith('chat_') || key.startsWith('conversation_')).toList();
      
      for (final key in chatKeys) {
        await prefs.remove(key);
      }
      
      await calculateStorageSize();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> clearTempFiles() async {
    try {
      final tempDir = await getTemporaryDirectory();
      await _clearDirectory(tempDir);
      
      await calculateStorageSize();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _clearDirectory(Directory directory) async {
    if (await directory.exists()) {
      await for (final entity in directory.list()) {
        if (entity is File) {
          try {
            await entity.delete();
          } catch (e) {
            // 파일 삭제 실패는 무시
          }
        } else if (entity is Directory) {
          try {
            await entity.delete(recursive: true);
          } catch (e) {
            // 디렉토리 삭제 실패는 무시
          }
        }
      }
    }
  }
}

class AutoClearNotifier extends StateNotifier<AutoClearSettings> {
  static const String _enableAutoClearKey = 'enable_auto_clear';
  static const String _autoClearDaysKey = 'auto_clear_days';
  static const String _clearOnAppStartKey = 'clear_on_app_start';
  static const String _clearImagesKey = 'clear_images';
  static const String _clearChatsKey = 'clear_chats';
  static const String _clearTempFilesKey = 'clear_temp_files';

  AutoClearNotifier() : super(const AutoClearSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      state = AutoClearSettings(
        enableAutoClearing: prefs.getBool(_enableAutoClearKey) ?? false,
        autoClearDays: prefs.getInt(_autoClearDaysKey) ?? 7,
        clearOnAppStart: prefs.getBool(_clearOnAppStartKey) ?? false,
        clearImages: prefs.getBool(_clearImagesKey) ?? true,
        clearChats: prefs.getBool(_clearChatsKey) ?? false,
        clearTempFiles: prefs.getBool(_clearTempFilesKey) ?? true,
      );
    } catch (e) {
      // SharedPreferences 오류시 기본값 유지
    }
  }

  Future<void> setAutoClearing(bool enabled) async {
    state = state.copyWith(enableAutoClearing: enabled);
    await _saveSettings();
  }

  Future<void> setAutoClearDays(int days) async {
    state = state.copyWith(autoClearDays: days);
    await _saveSettings();
  }

  Future<void> setClearOnAppStart(bool enabled) async {
    state = state.copyWith(clearOnAppStart: enabled);
    await _saveSettings();
  }

  Future<void> setClearImages(bool enabled) async {
    state = state.copyWith(clearImages: enabled);
    await _saveSettings();
  }

  Future<void> setClearChats(bool enabled) async {
    state = state.copyWith(clearChats: enabled);
    await _saveSettings();
  }

  Future<void> setClearTempFiles(bool enabled) async {
    state = state.copyWith(clearTempFiles: enabled);
    await _saveSettings();
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setBool(_enableAutoClearKey, state.enableAutoClearing);
      await prefs.setInt(_autoClearDaysKey, state.autoClearDays);
      await prefs.setBool(_clearOnAppStartKey, state.clearOnAppStart);
      await prefs.setBool(_clearImagesKey, state.clearImages);
      await prefs.setBool(_clearChatsKey, state.clearChats);
      await prefs.setBool(_clearTempFilesKey, state.clearTempFiles);
    } catch (e) {
      // SharedPreferences 저장 실패는 무시
    }
  }
}