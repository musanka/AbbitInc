namespace AbbitInc.Shared.DTOs.Response
{
    public class CompanyDto
    {
        // Basic Information
        public Int64 CompanyID { get; set; }
        public DateTimeOffset StartDate { get; set; }
        public string? ShortName { get; set; }
        public string? LongName { get; set; }
        public bool Active { get; set; }
        public bool Deleted {  get; set; }
        public DateTimeOffset ChangedLast { get; set; }
        public string? ChangeBy {  get; set; }

        // Owner Information (included in detailed response)
        public Int64? OwnerPersonID { get; set; }
        public string? OwnerName { get; set; }

        // Address Information (included in detailed response)
        public Int64? AddressID { get; set; }
        public string? AddressLine { get; set; }
        public string? Country { get; set; }

        // Phone Information (included in detailed response)
        public Int64? PhoneID { get; set; }
        public string? PhoneNumber { get; set; }
        public string? CountryCode { get; set; }

        // CVR Number (included in detailed response)
        public string? CvrNumber { get; set; }
    }
}
