import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:history_identifier/config/data.dart';
import 'package:history_identifier/model/model.dart';
import 'package:hive/hive.dart';



final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

final isCustomerSubProvider = StateProvider<bool>((ref) => false);

final contentProvider = StateProvider<List<ContentModel>>((ref) => []);

final onSaveProvider = StateProvider<bool>((ref) => false);

final photoCounterProvider = StateProvider<int>((ref) => 0);

final contentSaveProvider = StateNotifierProvider<ContentSaveNotifier ,List<ContentSaveModel>>((ref) {
  
  return ContentSaveNotifier();
});

final photoTakenProvider = StateProvider<File?>((ref) => null,);

final saveIdProvider = StateProvider<String>((ref) => "");

final apiOperationsController = Provider<ApiOperations>((ref) {
  return ApiOperations();
});

final savedDayProvider = StateProvider<int>((ref) => 0);

final saveFreePhotoTakeProvider = StateProvider<int>((ref) => 0);

final onBoardPageProvider = StateProvider<bool>((ref) => false);




class ContentSaveNotifier extends StateNotifier<List<ContentSaveModel>> {

 
  final _box = Hive.box<ContentSaveModel>('savedContent');

  ContentSaveNotifier() : super([]) {
    loadFromBox();
  }

  Future<void> loadFromBox () async {
    state = await _box.values.toList();
  }

  //Hive.box<ContentSaveModel>('savedContent').values.toList()


  Future<void> add (ContentSaveModel model) async {
    print("HATA BURADA");
    state = [...state, model];
    
    await _box.put(model.Id, model);
  }

  void removeByContentId (String contentId) {
    
    state = state.where((saved) => saved.Id != contentId).toList();

    _box.delete(contentId);
    
  }

  void clear () {
    state = [];
    _box.clear();
  }

}


