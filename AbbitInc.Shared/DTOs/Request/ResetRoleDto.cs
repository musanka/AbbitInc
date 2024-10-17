namespace AbbitInc.Shared.DTOs.Request
{
    public class ResetRoleDto :BaseRequest
    {
        public Int64 RoleID { get; set; }
        public bool Active { get; set; }
       
    }
}
