namespace AbbitInc.Shared.DTOs.Request
{
    public class ResetPersonDto : BaseRequest
    {
        public Int64 PersonID { get; set; }
        public bool Active { get; set; }
     
    }
}
