namespace AbbitInc.Shared.User
{
    public interface IUserContext
    {
        Int64 GetCurrentUserId();
        Int64 GetCurrentPersonId();
        Int64 GetCurrentRoleId();
        string GetCurrentUserName();
        string GetCurrentUserEmail();
    }
}
