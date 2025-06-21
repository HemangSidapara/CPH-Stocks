import 'package:cph_stocks/Constants/api_keys.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/categories_models/get_category_list_model.dart' as get_categories;
import 'package:cph_stocks/Network/services/account_services/categories_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesController extends GetxController {
  RxBool isLoading = false.obs;

  RxList<get_categories.CategoryData> categoryList = RxList();
  RxList<get_categories.CategoryData> searchedCategoryList = RxList();

  TextEditingController searchCategoryController = TextEditingController();

  RxBool isOrderingEnable = false.obs;
  RxBool isOrdering = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCategoriesApiCall();
  }

  Future<void> getCategoriesApiCall({bool isRefresh = false}) async {
    try {
      isLoading(!isRefresh);
      final response = await CategoriesServices.getCategoriesService();

      if (response.isSuccess) {
        get_categories.GetCategoryListModel categoryListModel = get_categories.GetCategoryListModel.fromJson(response.response?.data);
        categoryList.clear();
        searchedCategoryList.clear();
        categoryList.addAll(categoryListModel.data ?? []);
        searchedCategoryList.addAll(categoryListModel.data ?? []);
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> reorderCategoriesApiCall() async {
    try {
      isOrdering(true);
      final response = await CategoriesServices.reorderCategoryService(
        reorderList: searchedCategoryList.indexed
            .map(
              (e) => {
                ApiKeys.categoryId: e.$2.categoryId,
                ApiKeys.orderNo: e.$1,
              },
            )
            .toList(),
      );

      if (response.isSuccess) {
        await getCategoriesApiCall(isRefresh: true);
        isOrderingEnable(false);
        Utils.handleMessage(message: response.message);
      }
    } finally {
      isOrdering(false);
    }
  }

  Future<void> createCategoryApiCall({
    required String categoryName,
    required String categoryPrice,
  }) async {
    final response = await CategoriesServices.createCategoryService(
      categoryName: categoryName,
      categoryPrice: categoryPrice,
    );

    if (response.isSuccess) {
      await getCategoriesApiCall(isRefresh: true);
      Get.back();
      Utils.handleMessage(message: response.message);
    }
  }

  Future<void> editCategoryApiCall({
    required String categoryId,
    required String categoryName,
    required String categoryPrice,
  }) async {
    final response = await CategoriesServices.editCategoryService(
      categoryId: categoryId,
      categoryName: categoryName,
      categoryPrice: categoryPrice,
    );

    if (response.isSuccess) {
      await getCategoriesApiCall(isRefresh: true);
      Get.back();
      Utils.handleMessage(message: response.message);
    }
  }

  void searchCategory(String value) {
    searchedCategoryList.clear();
    if (value.isNotEmpty) {
      searchedCategoryList.addAll(categoryList.where((element) => element.categoryName?.toLowerCase().contains(value.toLowerCase()) == true));
    } else {
      searchedCategoryList.addAll([...categoryList]);
    }
  }

  void reorderCategory(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = searchedCategoryList.removeAt(oldIndex);
    searchedCategoryList.insert(newIndex, item);
  }
}
