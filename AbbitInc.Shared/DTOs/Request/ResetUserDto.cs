namespace AbbitInc.Shared.DTOs.Request
{
    public class ResetUserDto : BaseRequest
    {
        public Int64 UserID { get; set; }
        public bool Active { get; set; }
      
    }
}
