namespace AbbitInc.Shared.DTOs.Request
{
    public class ResetAddressDto : BaseRequest
    {
        public Int64 AddressID { get; set; }
        public bool Active { get; set; }
      
    }
}
