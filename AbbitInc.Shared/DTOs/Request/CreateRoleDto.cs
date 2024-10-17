namespace AbbitInc.Shared.DTOs.Request
{
    public class CreateRoleDto : BaseRequest
    {
        public string? ShortName { get; set; }
        public string? LongName { get; set; }
        public string? Description { get; set; }
    }
}
