class ItemDetailsModel {
  String? partyName;
  String? itemName;
  String? itemId;
  int? pending;
  bool isFromRecycleBin;

  ItemDetailsModel({
    this.partyName,
    this.itemName,
    this.itemId,
    this.pending,
    this.isFromRecycleBin = false,
  });
}
