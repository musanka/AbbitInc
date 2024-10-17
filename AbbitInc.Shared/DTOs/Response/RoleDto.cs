namespace AbbitInc.Shared.DTOs.Response
{
    public class RoleDto
    {
        public Int64 RoleID { get; set; }
        public string? ShortName { get; set; }
        public string? LongName { get; set; }
        public string? Description { get; set; }
        public bool Active { get; set; }
        public bool Deleted { get; set; }          
        public DateTimeOffset ChangedLast { get; set; }  
        public string? ChangedBy { get; set; }     
    }
}
