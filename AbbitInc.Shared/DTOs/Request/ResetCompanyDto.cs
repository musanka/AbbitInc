namespace AbbitInc.Shared.DTOs.Request
{
    public class ResetCompanyDto : BaseRequest
    {
        public Int64 CompanyID { get; set; }
        public bool Active { get; set; }
    }
}
