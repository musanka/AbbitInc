namespace AbbitInc.Shared.DTOs.Request
{
    public class GetPersonDto : BaseRequest
    {
        public Int64? PersonID { get; set; }
        public bool IncludeDetails { get; set; } = false; 
    }
}
