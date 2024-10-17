using System.Runtime.CompilerServices;

namespace AbbitInc.Shared.DTOs.Request
{
    public abstract class BaseRequest
    {
        public string? ChangedBy { get; private set; }
        public string? CallWebApi { get; private set; }
        public void SetChangedBy(string userName, string callWebApi, [CallerMemberName] string callingMethod = "")
        {
            CallWebApi = callWebApi;
            var operation = callingMethod.Replace("Async", string.Empty);
            ChangedBy = $"{CallWebApi}|{userName}|{operation}";
        }

    }
}
