namespace AbbitInc.Shared.DTOs.Request
{
    public class CreateEmployeeDto : BaseRequest
    {

        // how is employee created
        //if the person does not exist than create person too
        //so if EmployeePersonID = 0 than create person too and return CID to employee rec
        public string? EmployeeNo { get; set; } //how is the number generated 
        public string? JobPosition { get; set; }
        //Person info- create person if not exist
        public long? PersonID { get; set; }// CID relation to person table - i must have it if person exists than just use personID
        public DateTime? BirthDay { get; set; }
        public string? FirstName { get; set; }
        public string? MiddleNames { get; set; }
        public string? LastName { get; set; }
        //create address
        public string? Country { get; set; }
        public string? AddressLine { get; set; }
        //create phone
        public string? CountryCode { get; set; }
        public string? PhoneNo { get; set; }
    }
}
