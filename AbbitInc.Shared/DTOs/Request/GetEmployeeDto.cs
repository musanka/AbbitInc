namespace AbbitInc.Shared.DTOs.Request
{
    public class GetEmployeeDto : BaseRequest
    {
        public Int64? EmployeeID { get; set; }
        public bool IncludeDetails { get; set; } = false; 
    }
}
