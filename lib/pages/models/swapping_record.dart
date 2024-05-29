class SwappingRecord {
  final String id;
  final DateTime date;
  final String riderId;
  final String bikeId;
  final String mileage;
  final String gaugeIn;
  final String batteryIn;
  final String gaugeOut;
  final String batteryOut;
  final String charger;
  final String comment;
  final double price;

  SwappingRecord({
    required this.id,
    required this.date,
    required this.riderId,
    required this.bikeId,
    required this.mileage,
    required this.gaugeIn,
    required this.batteryIn,
    required this.gaugeOut,
    required this.batteryOut,
    required this.charger,
    required this.comment,
    required this.price,
  });
}
