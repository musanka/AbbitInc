using AbbitInc.Shared.DTOs.Request;
using AbbitInc.Shared.DTOs.Response;

namespace AbbitInc.ComponentService.DataAccess
{
    public interface IUserRepository
    {
        //user methods
        public string CreateUser(CreateUserDto createUserDto);
        public List<UserDto> GetUser(GetUserDto getUserDto);
        string ResetUserStatus(ResetUserDto resetUserDto);
        string DeleteUser(DeleteUserDto deleteUserDto);
        public string UpdateUser(UpdateUserDto updateUserDto);

        // Person methods
        public string CreatePerson(CreatePersonDto createPersonDto);
        public List<PersonDto> GetPerson(GetPersonDto getPersonDto);
        string ResetPersonStatus(ResetPersonDto resetPersonDto);
        string DeletePerson(DeletePersonDto deletePersonDto);
        public string UpdatePerson(UpdatePersonDto updatePersonDto);

        // Company methods
        public string CreateCompany(CreateCompanyDto createCompanyDto);
        public List<CompanyDto> GetCompany(GetCompanyDto getCompanyDto);
        string ResetCompanyStatus(ResetCompanyDto resetCompanyDto);
        string DeleteCompany(DeleteCompanyDto deleteCompanyDto);
        public string UpdateCompany(UpdateCompanyDto updateCompanyDto);

        // Phone methods
        string ResetPhoneStatus(ResetPhoneDto resetPhoneDto);
        string DeletePhone(DeletePhoneDto deletePhoneDto);

        // Email methods
        string ResetEmailStatus(ResetEmailDto resetEmailDto);
        string DeleteEmail(DeleteEmailDto deleteEmailDto);

        // Address methods
        string ResetAddressStatus(ResetAddressDto resetAddressDto);
        string DeleteAddress(DeleteAddressDto deleteAddressDto);

        // Role methods
        public string CreateRole(CreateRoleDto createRoleDto);
        public List<RoleDto> GetRole(GetRoleDto getRoleDto);
        string ResetRoleStatus(ResetRoleDto resetRoleDto);
        string DeleteRole(DeleteRoleDto deleteRoleDto);
        public string UpdateRole(UpdateRoleDto updateRoleDto);
        public string AssignUserRole(AssignUserRoleDto assignUserRoleDto);

        // Employee methods
        public string CreateEmployee(CreateEmployeeDto createEmployeeDto);
        List<EmployeeDto> GetEmployee(GetEmployeeDto getEmployeeDto);
        public string UpdateEmployee(UpdateEmployeeDto updateEmployeeDto);
        string ResetEmployeeStatus(ResetEmployeeDto resetEmployeeDto);
        string DeleteEmployee(DeleteEmployeeDto deleteEmployeeDto);

        // Identifier methods
        //string ResetIdentifierStatus(long identifierId, bool active, string changedBy, string callWebApi);
        //string DeleteIdentifier(long identifierId, string changedBy, string callWebApi);
    }
}
