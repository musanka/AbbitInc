namespace AbbitInc.Shared.DTOs.Response
{
    public class EmployeeDto
    {
        public Int64 EmployeeID {  get; set; }
        public string? EmpoloyeeNo {  get; set; }
        public string? JobPosition { get; set; }
        public bool Active { get; set; }
        public bool Deleted { get; set; }

        // Employe Information (included in detailed response)
        public Int64 EmployeePersonID { get; set; }// CID relation to person table 
        public string? EmployeeName { get; set; }

        // Address Information (included in detailed response)
        public Int64? AddressID { get; set; }
        public string? AddressLine { get; set; }
        public string? Country { get; set; }

        // Phone Information (included in detailed response)
        public Int64? PhoneID { get; set; }
        public string? PhoneNumber { get; set; }
        public string? CountryCode { get; set; }

    }
}
