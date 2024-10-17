namespace AbbitInc.Shared.DTOs.Request
{
    public class AssignUserRoleDto : BaseRequest
    {
        public Int64? UserId { get; set; }
        public Int64? RoleId { get; set; }
       
    }
}
