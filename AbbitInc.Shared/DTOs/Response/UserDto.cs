namespace AbbitInc.Shared.DTOs.Response
{
    public class UserDto
    {
        public Int64 UserID { get; set; }
        public string? Name { get; set; }
        public string? Email { get; set; }
        public bool ResetPassKey { get; set; }
        public bool Active { get; set; }
        public bool Deleted { get; set; }
    }
}
