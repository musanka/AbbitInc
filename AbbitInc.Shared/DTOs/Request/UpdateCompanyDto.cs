namespace AbbitInc.Shared.DTOs.Request
{
    public class UpdateCompanyDto : BaseRequest
    {
        public Int64 CompanyID { get; set; }
        public string? ShortName { get; set; }
        public string? LongName { get; set; }
        public Int64 AddressID { get; set; }
        public string? Country { get; set; }
        public string? AddressLine { get; set; }
        public Int64 PhoneID { get; set; }
        public string? CountryCode { get; set; }
        public string? PhoneNo { get; set; }
    }
}
