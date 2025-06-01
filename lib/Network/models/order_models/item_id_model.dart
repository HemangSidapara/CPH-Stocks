class ItemDetailsModel {
  String? partyName;
  String? itemName;
  String? itemId;
  int? pending;
  int? repair;
  bool isFromRecycleBin;

  ItemDetailsModel({
    this.partyName,
    this.itemName,
    this.itemId,
    this.pending,
    this.repair,
    this.isFromRecycleBin = false,
  });
}
