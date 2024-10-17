namespace AbbitInc.Shared.DTOs.Request
{
    public class ResetUserRoleDto : BaseRequest
    {
        public Int64 UserID { get; set; }
        public Int64 RoleID { get; set; }
        public bool Active { get; set; }
      
    }
}
