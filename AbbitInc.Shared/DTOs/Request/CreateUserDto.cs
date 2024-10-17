namespace AbbitInc.Shared.DTOs.Request
{
    public class CreateUserDto : BaseRequest
    {
        public string? Name { get; set; }
        public string? Email { get; set; }
        public string? PassKey { get; set; }
       
    }
}
