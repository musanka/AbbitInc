namespace AbbitInc.Shared.DTOs.Request
{
    public class CreatePersonDto : BaseRequest
    {
        public Int64 UserID { get; set; }
        public DateTime BirthDay { get; set; } = DateTime.MinValue;
        public string? FirstName { get; set; }
        public string? MiddleNames { get; set; }
        public string? LastName { get; set; }
        public string? Country { get; set; }
        public string? AddressLine { get; set; }
        public string? CountryCode { get; set; } 
        public string? PhoneNo { get; set; }
       
    }
}
