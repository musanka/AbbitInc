namespace AbbitInc.Shared.DTOs.Request
{
    public class ResetEmployeeDto : BaseRequest
    {
        public Int64 EmployeeID { get; set; }
        public bool Active { get; set; }
   
    }
}
