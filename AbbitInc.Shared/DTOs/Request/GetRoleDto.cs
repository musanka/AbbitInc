namespace AbbitInc.Shared.DTOs.Request
{
    public class GetRoleDto : BaseRequest
    {
        public Int64? RoleID { get; set; }  // Optional: to fetch a specific role
    }
}
