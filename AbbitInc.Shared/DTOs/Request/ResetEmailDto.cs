namespace AbbitInc.Shared.DTOs.Request
{
    public class ResetEmailDto : BaseRequest
    {
        public string? Email { get; set; }
        public bool Active { get; set; }
     
    }
}
