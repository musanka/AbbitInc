namespace AbbitInc.Shared.DTOs.Response
{
    public class PersonDto
    {
        public Int64 PersonID { get; set; }
        public DateTime? BirthDay { get; set; }
        public string? FirstName { get; set; }
        public string? MiddleNames { get; set; }
        public string? LastName { get; set; }
        // Status fields
        public bool Active { get; set; }
        public DateTime? ChangedLast { get; set; }

        // Address Information
        public string? AddressLine { get; set; }
        public string? Country { get; set; }

        // Phone Information
        public string? CountryCode { get; set; }
        public string? PhoneNo { get; set; }

        // Additional fields (for PersonHead requests)
        public string? Email { get; set; }
    }
}
