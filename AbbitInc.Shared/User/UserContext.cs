namespace AbbitInc.Shared.User
{
    public class UserContext
    {
        public Int64 UserId { get; private set; }
        public Int64 PersonId { get; private set; }
        public Int64 RoleId { get; private set; }
        public string? UserName { get; private set; }
        public string? Email { get; private set; }

        public void SetCurrentUser(long userId, long personId, long roleId, string userName, string email)
        {
            UserId = userId;
            PersonId = personId;
            RoleId = roleId;
            UserName = userName;
            Email = email;
        }

        public Int64 GetCurrentUserId() => UserId;
        public Int64 GetCurrentPersonId() => PersonId;
        public Int64 GetCurrentRoleId() => RoleId;
        public string GetCurrentUserName() => UserName;
        public string GetCurrentUserEmail() => Email;
    }
    //public class UserContext
    //{
    //    private Int64 _userId; //netUserName no name id
    //    private Int64 _personId; //Preson name??? maybe best with IDs
    //    private Int64 _roleId; //RoleID yes
    //    private string _userName = "UnknownUser";//yes yes
    //    private string _email = "UnknownEmail";// maybe no
    //    public void SetCurrentUser(long userId, long personId, long roleId, string userName, string email)
    //    {
    //        _userId = userId;
    //        _personId = personId;
    //        _roleId = roleId;
    //        _userName = userName;
    //        _email = email;
    //    }

    //    public Int64 GetCurrentUserId() => _userId;
    //    public Int64 GetCurrentPersonId() => _personId;
    //    public Int64 GetCurrentRoleId() => _roleId;
    //    public string GetCurrentUserName() => _userName;
    //    public string GetCurrentUserEmail() => _email;
    //}
}
