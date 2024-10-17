namespace AbbitInc.Shared.DTOs.Request
{
    public class UpdateEmployeeDto : BaseRequest
    {
        public long EmployeeID { get; set; }
        public string? EmployeeNo { get; set; }
        public string? JobPosition { get; set; }
        public long PersonID { get; set; }
        public bool Active { get; set; }
        public bool Deleted { get; set; }
    }
}
