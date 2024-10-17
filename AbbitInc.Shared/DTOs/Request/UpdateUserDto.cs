namespace AbbitInc.Shared.DTOs.Request
{
    public class UpdateUserDto : BaseRequest
    {
        public Int64 UserID { get; set; }
        public string? Name { get; set; }
        public string? Email { get; set; }
        public string? PassKey { get; set; }
        public bool ResetPassKey { get; set; }
        public bool Active { get; set; }
        public bool Deleted { get; set; }
    }
}
