namespace AbbitInc.Shared.DTOs.Request
{
    public class CreateCompanyDto : BaseRequest
    {
        public DateTime StartDate { get; set; } = DateTime.MinValue;
        public string? ShortName { get; set; }
        public string? LongName { get; set; }
        public string? IdValueCvr { get; set; }
        public string? IdValueCustNo { get; set; }
        public string? CountryCode { get; set; }
        public string? AddressLine { get; set; }
        public string? PhoneNo { get; set; }
        public string? Country { get; set; }
        public Int64 OwnerID { get; set; } // link person table 
    }
}
