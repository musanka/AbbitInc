namespace AbbitInc.Shared.DTOs.Request
{
    public class ResetPhoneDto : BaseRequest
    {
        //ToDo mayne phoneID
        public string?  PhoneNo { get; set; }
        public bool Active { get; set; }
      
    }
}
