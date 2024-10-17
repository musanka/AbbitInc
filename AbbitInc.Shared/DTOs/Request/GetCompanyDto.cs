namespace AbbitInc.Shared.DTOs.Request
{
    public class GetCompanyDto : BaseRequest
    {
        public Int64? CompanyID { get; set; }
        public Int64? OwnerPersonID { get; set; }
        public bool IncludeDetails { get; set; } = false; // Flag for whether to include details
    }
}
