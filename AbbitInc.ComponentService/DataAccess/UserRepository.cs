using AbbitInc.Shared.DTOs.Request;
using AbbitInc.Shared.DTOs.Response;
using Microsoft.Data.SqlClient;
using System.Data;
using Newtonsoft.Json;
using System.Reflection;


namespace AbbitInc.ComponentService.DataAccess
{
    public class UserRepository : IUserRepository
    {
        private readonly string _connectionString;
        public UserRepository(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("AbbitUserDb")
                           ?? throw new ArgumentNullException(nameof(configuration), "Connection string 'AbbitUserDb' not found.");
        }


        #region User Methods
        public List<UserDto> GetUser(GetUserDto getUserDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@UserID", SqlDbType.BigInt) { Value = getUserDto.UserID },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = getUserDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = getUserDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(getUserDto) }
            };

            return ExecuteQuery<UserDto>(GetStoredProcedureName(), parameters);
        }
        public string CreateUser(CreateUserDto createUserDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@FirstName", SqlDbType.NVarChar, 256) { Value = createUserDto.Name },
                new SqlParameter("@Email", SqlDbType.NVarChar, 256) { Value = createUserDto.Email },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = createUserDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = createUserDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(createUserDto) }
            };
            return ExecuteNonQuery(GetStoredProcedureName(), parameters);
        }
        public string ResetUserStatus(ResetUserDto resetUserDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@UserID", SqlDbType.BigInt) { Value = resetUserDto.UserID },
                new SqlParameter("@Active", SqlDbType.Bit) { Value = resetUserDto.Active },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = resetUserDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = resetUserDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(resetUserDto) }
            };
            return ExecuteNonQuery(GetStoredProcedureName(), parameters);
        }

        public string DeleteUser(DeleteUserDto deleteUserDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@UserID", SqlDbType.BigInt) { Value = deleteUserDto.UserID },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = deleteUserDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = deleteUserDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(deleteUserDto) }
            };
            return ExecuteNonQuery(GetStoredProcedureName(), parameters);
        }
        public string UpdateUser(UpdateUserDto updateUserDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@UserID", SqlDbType.BigInt) { Value = updateUserDto.UserID },
                new SqlParameter("@Name", SqlDbType.NVarChar, 256) { Value = updateUserDto.Name },
                new SqlParameter("@Email", SqlDbType.NVarChar, 256) { Value = updateUserDto.Email },
                new SqlParameter("@PassKey", SqlDbType.NVarChar, 256) { Value = updateUserDto.PassKey },
                new SqlParameter("@ResetPassKey", SqlDbType.Bit) { Value = updateUserDto.ResetPassKey },
                new SqlParameter("@Active", SqlDbType.Bit) { Value = updateUserDto.Active },
                new SqlParameter("@Deleted", SqlDbType.Bit) { Value = updateUserDto.Deleted },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = updateUserDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = updateUserDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(updateUserDto) }
            };
            return ExecuteNonQuery("UpdateUser", parameters);
        }

        #endregion

        #region Person Methods
        public string CreatePerson(CreatePersonDto createPersonDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@UserID", SqlDbType.BigInt) { Value = createPersonDto.UserID },
                new SqlParameter("@FirstName", SqlDbType.NChar, 256) { Value = createPersonDto.FirstName },
                new SqlParameter("@MiddleNames", SqlDbType.NVarChar, 256) { Value = createPersonDto.MiddleNames },
                new SqlParameter("@LastNames", SqlDbType.NVarChar, 256) { Value = createPersonDto.LastName },
                new SqlParameter("@Country", SqlDbType.NChar, 256) { Value = createPersonDto.Country },
                new SqlParameter("@AddressLine", SqlDbType.NVarChar, 256) { Value = createPersonDto.AddressLine },
                new SqlParameter("@CountryCode", SqlDbType.NVarChar, 256) { Value = createPersonDto.CountryCode },
                new SqlParameter("@PhoneNo", SqlDbType.NVarChar, 256) { Value = createPersonDto.PhoneNo },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = createPersonDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = createPersonDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(createPersonDto) }
            };
            return ExecuteNonQuery(GetStoredProcedureName(), parameters);
        }
        public string ResetPersonStatus(ResetPersonDto resetPersonDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@PersonID", SqlDbType.BigInt) { Value = resetPersonDto.PersonID },
                new SqlParameter("@Active", SqlDbType.Bit) { Value = resetPersonDto.Active },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = resetPersonDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = resetPersonDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(resetPersonDto) }
            };
            return ExecuteNonQuery(GetStoredProcedureName(), parameters);
        }
        public string DeletePerson(DeletePersonDto deletePersonDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@PersonID", SqlDbType.BigInt) { Value = deletePersonDto.PersonID },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = deletePersonDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = deletePersonDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(deletePersonDto) }
            };
            return ExecuteNonQuery(GetStoredProcedureName(), parameters);
        }
        public List<PersonDto> GetPerson(GetPersonDto getPersonDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@PersonID", SqlDbType.BigInt){ Value = getPersonDto.PersonID },
                new SqlParameter(" @IncludeDetails", SqlDbType.Bit){ Value = getPersonDto.IncludeDetails},
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = getPersonDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = getPersonDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(getPersonDto) }
            };
            return ExecuteQuery<PersonDto>(GetStoredProcedureName(), parameters);
        }
        public string UpdatePerson(UpdatePersonDto updatePersonDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@PersonID", SqlDbType.BigInt) { Value = updatePersonDto.PersonID },
                new SqlParameter("@FirstName", SqlDbType.NVarChar, 256) { Value = updatePersonDto.FirstName },
                new SqlParameter("@MiddleNames", SqlDbType.NVarChar, 256) { Value = updatePersonDto.MiddleNames },
                new SqlParameter("@LastName", SqlDbType.NVarChar, 256) { Value = updatePersonDto.LastName },
                new SqlParameter("@BirthDay", SqlDbType.DateTime) { Value = updatePersonDto.BirthDay },
                new SqlParameter("@AddressID", SqlDbType.BigInt) { Value = updatePersonDto.AddressID },
                new SqlParameter("@Country", SqlDbType.NVarChar, 256) { Value = updatePersonDto.Country },
                new SqlParameter("@AddressLine", SqlDbType.NVarChar, 256) { Value = updatePersonDto.AddressLine },
                new SqlParameter("@PhoneID", SqlDbType.BigInt) { Value = updatePersonDto.PhoneID },
                new SqlParameter("@CountryCode", SqlDbType.NVarChar, 256) { Value = updatePersonDto.CountryCode },
                new SqlParameter("@PhoneNo", SqlDbType.NVarChar, 256) { Value = updatePersonDto.PhoneNo },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = updatePersonDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = updatePersonDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(updatePersonDto) }
            };
            return ExecuteNonQuery("UpdatePerson", parameters);
        }

        #endregion


        #region Company Methods
        public string CreateCompany(CreateCompanyDto createCompanyDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@StartDate", SqlDbType.DateTimeOffset) { Value = createCompanyDto.StartDate },
                new SqlParameter("@ShortName", SqlDbType.NChar, 256) { Value = createCompanyDto.ShortName },
                new SqlParameter("@LongName", SqlDbType.NVarChar, 256) { Value = createCompanyDto.LongName },
                new SqlParameter("@IdValueCvr", SqlDbType.NVarChar, 256) { Value = createCompanyDto.IdValueCvr },
                new SqlParameter("@IdValueCustNo", SqlDbType.NChar, 256) { Value = createCompanyDto.IdValueCustNo },
                new SqlParameter("@AddressLine", SqlDbType.NVarChar, 256) { Value = createCompanyDto.AddressLine },
                new SqlParameter("@Country", SqlDbType.NVarChar, 256) { Value = createCompanyDto.Country },
                new SqlParameter("@PhoneNo", SqlDbType.NVarChar, 256) { Value = createCompanyDto.PhoneNo },
                new SqlParameter("@CountryCode", SqlDbType.NVarChar, 256) { Value = createCompanyDto.CountryCode },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = createCompanyDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = createCompanyDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(createCompanyDto) }
            };
            return ExecuteNonQuery(GetStoredProcedureName(), parameters);
        }
        public string ResetCompanyStatus(ResetCompanyDto resetCompanyDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@CompanyID", SqlDbType.BigInt) { Value = resetCompanyDto.CompanyID },
                new SqlParameter("@Active", SqlDbType.Bit) { Value = resetCompanyDto.Active },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = resetCompanyDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = resetCompanyDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(resetCompanyDto) }
            };
            return ExecuteNonQuery(GetStoredProcedureName(), parameters);
        }
        public string DeleteCompany(DeleteCompanyDto deleteCompanyDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@CompanyID", SqlDbType.BigInt) { Value = deleteCompanyDto.CompanyID },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = deleteCompanyDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = deleteCompanyDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(deleteCompanyDto) }
            };
            return ExecuteNonQuery(GetStoredProcedureName(), parameters);
        }
        public List<CompanyDto> GetCompany(GetCompanyDto getCompanyDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@CompanyID", SqlDbType.BigInt) { Value = getCompanyDto.CompanyID },
                new SqlParameter("@OwnerPersonID", SqlDbType.BigInt) { Value = getCompanyDto.OwnerPersonID },
                new SqlParameter("@IncludeDetails", SqlDbType.Bit) { Value = getCompanyDto.IncludeDetails },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = getCompanyDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = getCompanyDto.CallWebApi }
            };

            return ExecuteQuery<CompanyDto>(GetStoredProcedureName(), parameters);
        }
        public string UpdateCompany(UpdateCompanyDto updateCompanyDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@CompanyID", SqlDbType.BigInt) { Value = updateCompanyDto.CompanyID },
                new SqlParameter("@ShortName", SqlDbType.NVarChar, 256) { Value = updateCompanyDto.ShortName },
                new SqlParameter("@LongName", SqlDbType.NVarChar, 256) { Value = updateCompanyDto.LongName },
                new SqlParameter("@AddressID", SqlDbType.BigInt) { Value = updateCompanyDto.AddressID },
                new SqlParameter("@Country", SqlDbType.NVarChar, 256) { Value = updateCompanyDto.Country },
                new SqlParameter("@AddressLine", SqlDbType.NVarChar, 256) { Value = updateCompanyDto.AddressLine },
                new SqlParameter("@PhoneID", SqlDbType.BigInt) { Value = updateCompanyDto.PhoneID },
                new SqlParameter("@CountryCode", SqlDbType.NVarChar, 256) { Value = updateCompanyDto.CountryCode },
                new SqlParameter("@PhoneNo", SqlDbType.NVarChar, 256) { Value = updateCompanyDto.PhoneNo },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = updateCompanyDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = updateCompanyDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(updateCompanyDto) }
            };
            return ExecuteNonQuery("UpdateCompany", parameters);
        }

        #endregion

        #region Phone Methods
        public string ResetPhoneStatus(ResetPhoneDto resetPhoneDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@PhoneNo", SqlDbType.BigInt) { Value = resetPhoneDto.PhoneNo },
                new SqlParameter("@Active", SqlDbType.Bit) { Value = resetPhoneDto.Active },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = resetPhoneDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = resetPhoneDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(resetPhoneDto) }
            };
            return ExecuteNonQuery(GetStoredProcedureName(), parameters);
        }
        public string DeletePhone(DeletePhoneDto deletePhoneDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@PhoneNo", SqlDbType.BigInt) { Value = deletePhoneDto.PhoneNo },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = deletePhoneDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = deletePhoneDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(deletePhoneDto) }
            };
            return ExecuteNonQuery(GetStoredProcedureName(), parameters);
        }

        #endregion

        #region Email Methods
        public string ResetEmailStatus(ResetEmailDto resetEmailDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@Email", SqlDbType.BigInt) { Value = resetEmailDto.Email },
                new SqlParameter("@Active", SqlDbType.Bit) { Value = resetEmailDto.Active },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = resetEmailDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = resetEmailDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(resetEmailDto) }
            };
            return ExecuteNonQuery(GetStoredProcedureName(), parameters);
        }
        public string DeleteEmail(DeleteEmailDto deleteEmailDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@Email", SqlDbType.BigInt) { Value = deleteEmailDto.Email },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = deleteEmailDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = deleteEmailDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(deleteEmailDto) }
            };
            return ExecuteNonQuery(GetStoredProcedureName(), parameters);
        }

        #endregion

        #region Address Methods
        public string ResetAddressStatus(ResetAddressDto resetAddressDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@AddressID", SqlDbType.BigInt) { Value = resetAddressDto.AddressID },
                new SqlParameter("@Active", SqlDbType.Bit) { Value = resetAddressDto.Active },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = resetAddressDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = resetAddressDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(resetAddressDto) }
            };
            return ExecuteNonQuery(GetStoredProcedureName(), parameters);
        }
        public string DeleteAddress(DeleteAddressDto deleteAddressDto)
        {
            var parameters = new List<SqlParameter>
    {
        new SqlParameter("@AddressID", SqlDbType.BigInt) { Value = deleteAddressDto.AddressID },
        new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = deleteAddressDto.ChangedBy },
        new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = deleteAddressDto.CallWebApi },
        new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(deleteAddressDto) }
    };
            return ExecuteNonQuery(GetStoredProcedureName(), parameters);
        }
        #endregion

        #region Role Methods
        public string CreateRole(CreateRoleDto createRoleDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@ShortName", SqlDbType.NVarChar, 256) { Value = createRoleDto.ShortName },
                new SqlParameter("@LongName", SqlDbType.NVarChar, 256) { Value = createRoleDto.LongName },
                new SqlParameter("@Description", SqlDbType.NVarChar, -1) { Value = createRoleDto.Description },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = createRoleDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = createRoleDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(createRoleDto) }
            };
            return ExecuteNonQuery(GetStoredProcedureName(), parameters);
        }
        public string AssignUserRole(AssignUserRoleDto assignUserRoleDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@UserID", SqlDbType.BigInt) { Value = assignUserRoleDto.UserId },
                new SqlParameter("@RoleID", SqlDbType.BigInt) { Value = assignUserRoleDto.RoleId },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = assignUserRoleDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = assignUserRoleDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(assignUserRoleDto) }
            };
            return ExecuteNonQuery(GetStoredProcedureName(), parameters);
        }
        public List<RoleDto> GetRole(GetRoleDto getRoleDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@RoleID", SqlDbType.BigInt) { Value = getRoleDto.RoleID },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = getRoleDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = getRoleDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(getRoleDto) }
            };
            return ExecuteQuery<RoleDto>(GetStoredProcedureName(), parameters);
        }
        public string ResetRoleStatus(ResetRoleDto resetRoleDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@RoleID", SqlDbType.BigInt) { Value = resetRoleDto.RoleID },
                new SqlParameter("@Active", SqlDbType.Bit) { Value = resetRoleDto.Active },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = resetRoleDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = resetRoleDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(resetRoleDto) }
            };
            return ExecuteNonQuery(GetStoredProcedureName(), parameters);
        }
        public string DeleteRole(DeleteRoleDto deleteRoleDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@RoleID", SqlDbType.BigInt) { Value = deleteRoleDto.RoleID },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = deleteRoleDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = deleteRoleDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(deleteRoleDto) }
            };
            return ExecuteNonQuery(GetStoredProcedureName(), parameters);
        }
        public string UpdateRole(UpdateRoleDto updateRoleDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@RoleID", SqlDbType.BigInt) { Value = updateRoleDto.RoleID },
                new SqlParameter("@Shortname", SqlDbType.NVarChar, 256) { Value = updateRoleDto.Shortname },
                new SqlParameter("@Longname", SqlDbType.NVarChar, 256) { Value = updateRoleDto.Longname },
                new SqlParameter("@Description", SqlDbType.NVarChar, 256) { Value = updateRoleDto.Description },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = updateRoleDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = updateRoleDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(updateRoleDto) }
            };
            return ExecuteNonQuery("UpdateRole", parameters);
        }
        #endregion

        #region Employee Methods
        public string CreateEmployee(CreateEmployeeDto createEmployeeDto)
        {
                var parameters = new List<SqlParameter>
                {
                    new SqlParameter("@EmployeeNo", SqlDbType.NVarChar, 20) { Value = createEmployeeDto.EmployeeNo},
                    new SqlParameter("@JobPosition", SqlDbType.NVarChar, 50) { Value = createEmployeeDto.JobPosition },
                    new SqlParameter("@CID", SqlDbType.BigInt) { Value = createEmployeeDto.PersonID },
                    new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = createEmployeeDto.ChangedBy },
                    new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = createEmployeeDto.CallWebApi },
                    new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(createEmployeeDto) }
                };
            return ExecuteNonQuery(GetStoredProcedureName(), parameters);
        }
        public List<EmployeeDto> GetEmployee(GetEmployeeDto getEmployeeDto)
        {
                var parameters = new List<SqlParameter>
                {
                    new SqlParameter("@EmployeeID", SqlDbType.BigInt) { Value = getEmployeeDto.EmployeeID },
                    new SqlParameter("@IncludeDetails", SqlDbType.Bit) { Value = getEmployeeDto.IncludeDetails },
                    new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = getEmployeeDto.ChangedBy },
                    new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = getEmployeeDto.CallWebApi },
                    new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(getEmployeeDto) }
                };

            return ExecuteQuery<EmployeeDto>(GetStoredProcedureName(), parameters);
        }
        public string UpdateEmployee(UpdateEmployeeDto updateEmployeeDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@EmployeeNo", SqlDbType.NVarChar, 20) { Value = updateEmployeeDto.EmployeeNo },
                new SqlParameter("@JobPosition", SqlDbType.NVarChar, 50) { Value = updateEmployeeDto.JobPosition },
                new SqlParameter("@PersonID", SqlDbType.BigInt) { Value = updateEmployeeDto.PersonID },
                new SqlParameter("@Active", SqlDbType.Bit) { Value = updateEmployeeDto.Active },
                new SqlParameter("@Deleted", SqlDbType.Bit) { Value = updateEmployeeDto.Deleted },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = updateEmployeeDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = updateEmployeeDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(updateEmployeeDto) }
            };
            return ExecuteNonQuery(GetStoredProcedureName(), parameters);
        }
        public string ResetEmployeeStatus(ResetEmployeeDto resetEmployeeDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@EmployeeID", SqlDbType.BigInt) { Value = resetEmployeeDto.EmployeeID },
                new SqlParameter("@Active", SqlDbType.Bit) { Value = resetEmployeeDto.Active },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = resetEmployeeDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = resetEmployeeDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(resetEmployeeDto) }
            };
            return ExecuteNonQuery(GetStoredProcedureName(), parameters);
        }
        public string DeleteEmployee(DeleteEmployeeDto deleteEmployeeDto)
        {
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@EmployeeID", SqlDbType.BigInt) { Value = deleteEmployeeDto.EmployeeID },
                new SqlParameter("@ChangedBy", SqlDbType.NVarChar, 256) { Value = deleteEmployeeDto.ChangedBy },
                new SqlParameter("@CallWebApi", SqlDbType.NVarChar, 200) { Value = deleteEmployeeDto.CallWebApi },
                new SqlParameter("@DObj", SqlDbType.NVarChar, -1) { Value = JsonConvert.SerializeObject(deleteEmployeeDto) }
            };
            return ExecuteNonQuery(GetStoredProcedureName(), parameters);
        }

        #endregion

        #region Identifier Methods
        // create, update, reset status, delete
        #endregion

        #region Helper Methods

        private string ExecuteNonQuery(string storedProcedureName, List<SqlParameter> parameters)
        {
            DataTable result = new("Result");
            try
            {
                using SqlConnection sqlConnection = new(_connectionString);
                using SqlCommand sqlCmd = new(storedProcedureName, sqlConnection);
                sqlConnection.Open();
                sqlCmd.CommandType = CommandType.StoredProcedure;

                if (parameters != null)
                {
                    sqlCmd.Parameters.AddRange(parameters.ToArray());
                }

                result.Load(sqlCmd.ExecuteReader());

                if (result.Rows.Count > 0)
                {
                    return result.Rows[0][0]?.ToString() ?? string.Empty;
                }
                else
                {
                    return string.Empty;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message); // Replace 
                return string.Empty;
            }
        }

        private List<T> ExecuteQuery<T>(string storedProcedureName, List<SqlParameter> parameters) where T : new()
        {
            DataTable result = new("Result");

            try
            {
                using SqlConnection sqlConnection = new(_connectionString);
                using SqlCommand sqlCmd = new(storedProcedureName, sqlConnection);
                sqlConnection.Open();
                sqlCmd.CommandType = CommandType.StoredProcedure;

                if (parameters != null)
                {
                    sqlCmd.Parameters.AddRange(parameters.ToArray());
                }

                using SqlDataReader reader = sqlCmd.ExecuteReader();
                result.Load(reader);

                return MapDataTableToList<T>(result);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message); // Replace 
                return new List<T>();
            }
        }

        private static string GetStoredProcedureName()
        {
            return $"dbo.{MethodBase.GetCurrentMethod()?.Name ?? "UnknownProcedure"}";

        }

        private List<T> MapDataTableToList<T>(DataTable dataTable) where T : new()
        {
            List<T> resultList = new List<T>();

            foreach (DataRow row in dataTable.Rows)
            {
                T item = new T();
                foreach (DataColumn column in dataTable.Columns)
                {
                    PropertyInfo prop = item.GetType().GetProperty(column.ColumnName, BindingFlags.Public | BindingFlags.Instance);
                    if (prop != null && row[column] != DBNull.Value)
                    {
                        prop.SetValue(item, Convert.ChangeType(row[column], prop.PropertyType), null);
                    }
                }
                resultList.Add(item);
            }
            return resultList;
        }


        //private List<T> MapDataTableToList<T>(DataTable dataTable) where T : new()
        //{
        //    List<T> resultList = new List<T>();

        //    foreach (DataRow row in dataTable.Rows)
        //    {
        //        T item = new T();
        //        foreach (DataColumn column in dataTable.Columns)
        //        {
        //            //ToDo check mapping
        //            PropertyInfo prop = item.GetType().GetProperty(column.ColumnName, BindingFlags.Public | BindingFlags.Instance);
        //            if (prop != null && row[column] != DBNull.Value)
        //            {
        //                ////prop.SetValue(item, Convert.ChangeType(row[column], prop.PropertyType), null);
        //                //var safeValue = Convert.ChangeType(row[column], Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType);
        //                //prop.SetValue(item, safeValue, null);
        //                //get prop type
        //                Type targetType = Nullable.GetUnderlyingType(item.GetType()) ?? prop.PropertyType;
        //                //convert value 
        //                object safeValue = Convert.ChangeType(row[column], targetType);
        //                //set the value to property
        //                if (safeValue != null || Nullable.GetUnderlyingType(prop.PropertyType) != null)
        //                { 
        //                    prop.SetValue(item, safeValue, null);
        //                }
        //            }
        //        }
        //        resultList.Add(item);
        //    }
        //    return resultList;
        //}

        #endregion
    }
}