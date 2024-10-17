namespace AbbitInc.Shared.DTOs.Request
{
    public class UpdatePersonDto : BaseRequest
    {
        public Int64 PersonID { get; set; }
        public string? FirstName { get; set; }
        public string? MiddleNames { get; set; }
        public string? LastName { get; set; }
        public DateTime BirthDay { get; set; } = DateTime.MinValue;
        public Int64 AddressID { get; set; }
        public string? Country { get; set; }
        public string? AddressLine { get; set; }
        public Int64 PhoneID { get; set; }
        public string? CountryCode { get; set; }
        public string? PhoneNo { get; set; }
       
    }
}
