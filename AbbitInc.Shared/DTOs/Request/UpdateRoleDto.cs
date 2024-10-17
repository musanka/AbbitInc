   
namespace AbbitInc.Shared.DTOs.Request
{
    public class UpdateRoleDto : BaseRequest
    {
        public long RoleID { get; set; }
        public string? Shortname { get; set; }
        public string? Longname { get; set; }
        public string? Description { get; set; }         
    }
}