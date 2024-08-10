class Leaverequest{
  String? userid;
  bool? isapproved;
  String? startdate;
  String? enddate;

  Leaverequest(
      this.userid,
      this.enddate,
      this.startdate,
      {
        required this.isapproved
      }
      );
}