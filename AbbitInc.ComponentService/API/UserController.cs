using AbbitInc.ComponentService.DataAccess;
using AbbitInc.Shared.Config;
using AbbitInc.Shared.DTOs.Request;
using AbbitInc.Shared.DTOs.Response;
using AbbitInc.Shared.User;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

namespace AbbitInc.ComponentService.API
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly IUserRepository _userRepository;
        private readonly ILogger<UserController> _logger;

        public UserController(IUserRepository userRepository, ILogger<UserController> logger)
        {
            _userRepository = userRepository;
            _logger = logger;
        }

        #region USER   
        [HttpPost("CreateUser")]
        [ProducesResponseType(typeof(string), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public IActionResult CreateUser(CreateUserDto createUserDto)
        {
            try
            {
                var result = _userRepository.CreateUser(createUserDto);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while creating user");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpPatch("ResetUserStatus")]
        [ProducesResponseType(typeof(string), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public IActionResult ResetUserStatus(ResetUserDto resetUserDto)
        {
            try
            {
                var result = _userRepository.ResetUserStatus(resetUserDto);
                if (result != null)
                {
                    return Ok(result);
                }
                else
                {
                    _logger.LogWarning("User with UserID {UserID} not found", resetUserDto.UserID);
                    return NotFound($"User with {resetUserDto.UserID} not found");
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while resetting user status for UserID {UserID}", resetUserDto.UserID);
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpDelete("DeleteUser")]
        [ProducesResponseType(typeof(string), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public IActionResult DeleteUser(DeleteUserDto deleteUserDto)
        {
            try
            {
                var result = _userRepository.DeleteUser(deleteUserDto);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while deleting user");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpGet("GetUser")]
        [ProducesResponseType(typeof(List<UserDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public IActionResult GetUserInfo([FromQuery] GetUserDto getUserDto)
        {
            try
            {
                var result = _userRepository.GetUser(getUserDto);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting user info");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpPost("AssignUserRole")]
        [ProducesResponseType(typeof(string), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public IActionResult AssignUserRole(AssignUserRoleDto assignUserRoleDto)
        {
            try
            {
                var result = _userRepository.AssignUserRole(assignUserRoleDto);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while assigning user role");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
        #endregion

        #region ROLE       
        [HttpPost("CreateRole")]
        [ProducesResponseType(typeof(string), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public IActionResult CreateRole(CreateRoleDto createRoleDto)
        {
            try
            {
                var result = _userRepository.CreateRole(createRoleDto);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while creating role");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpPatch("ResetRoleStatus")]
        [ProducesResponseType(typeof(string), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public IActionResult ResetRoleStatus(ResetRoleDto resetRoleDto)
        {
            try
            {
                var result = _userRepository.ResetRoleStatus(resetRoleDto);
                if (result != null)
                {
                    return Ok(result);
                }
                else
                {
                    _logger.LogWarning("Role with RoleID {RoleID} not found", resetRoleDto.RoleID);
                    return NotFound($"Role with {resetRoleDto.RoleID} not found");
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while resetting role status for RoleID {RoleID}", resetRoleDto.RoleID);
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpDelete("DeleteRole")]
        [ProducesResponseType(typeof(string), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public IActionResult DeleteRole(DeleteRoleDto deleteRoleDto)
        {
            try
            {
                var result = _userRepository.DeleteRole(deleteRoleDto);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while deleting role");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpGet("GetRole")]
        [ProducesResponseType(typeof(List<RoleDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public IActionResult GetRoleInfo([FromQuery] GetRoleDto getRoleDto)
        {
            try
            {
                var result = _userRepository.GetRole(getRoleDto);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting role info");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
        #endregion

        #region PERSON 

        [HttpPatch("ResetPersonStatus")]
        [ProducesResponseType(typeof(string), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public IActionResult ResetPersonStatus(ResetPersonDto resetPersonDto)
        {
            try
            {
                var result = _userRepository.ResetPersonStatus(resetPersonDto);
                if (result != null)
                {

                    return Ok(result);
                }
                else
                {
                    _logger.LogWarning("Person with PersonID {PersonID} not found", resetPersonDto.PersonID);
                    return NotFound($"Preson with {resetPersonDto.PersonID} not found");
                }

                }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while resetting person status for PersonID {PersonID}", resetPersonDto.PersonID);
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }

        }
        [HttpGet("GetPerson")]
        [ProducesResponseType(typeof(List<PersonDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public IActionResult GetPerson([FromQuery] GetPersonDto getPersonDto)
        {
            try
            {
                var result = _userRepository.GetPerson(getPersonDto);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting person info");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
        [HttpPost("CreatePerson")]
        [ProducesResponseType(typeof(string), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public IActionResult CreatePerson(CreatePersonDto createPersonDto)
        {
            try
            {
                var result = _userRepository.CreatePerson(createPersonDto);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while creating person");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpDelete("DeletePerson")]
        [ProducesResponseType(typeof(string), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public IActionResult DeletePerson(DeletePersonDto deletePersonDto)
        {
            try
            {
                var result = _userRepository.DeletePerson(deletePersonDto);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while deleting person");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpPut("UpdatePerson")]
        [ProducesResponseType(typeof(string), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public IActionResult UpdatePerson(UpdatePersonDto updatePersonDto)
        {
            try
            {
                var result = _userRepository.UpdatePerson(updatePersonDto);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while updating person");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        #endregion

        #region COMPANY  

        [HttpPost("CreateCompany")]
        [ProducesResponseType(typeof(string), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public IActionResult CreateCompany(CreateCompanyDto createCompanyDto)
        {
            try
            {
                var result = _userRepository.CreateCompany(createCompanyDto);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while creating company");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpPatch("ResetCompanyStatus")]
        [ProducesResponseType(typeof(string), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public IActionResult ResetCompanyStatus(ResetCompanyDto resetCompanyDto)
        {
            try
            {
                var result = _userRepository.ResetCompanyStatus(resetCompanyDto);
                if (result != null)
                {
                    return Ok(result);
                }
                else
                {
                    _logger.LogWarning("Company with CompanyID {CompanyID} not found", resetCompanyDto.CompanyID);
                    return NotFound($"Company with {resetCompanyDto.CompanyID} not found");
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while resetting company status for CompanyID {CompanyID}", resetCompanyDto.CompanyID);
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpDelete("DeleteCompany")]
        [ProducesResponseType(typeof(string), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public IActionResult DeleteCompany(DeleteCompanyDto deleteCompanyDto)
        {
            try
            {
                var result = _userRepository.DeleteCompany(deleteCompanyDto);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while deleting company");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpGet("GetCompany")]
        [ProducesResponseType(typeof(List<CompanyDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public IActionResult GetCompanyInfo([FromQuery] GetCompanyDto getCompanyDto)
        {
            try
            {
                var result = _userRepository.GetCompany(getCompanyDto);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting company info");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpPut("UpdateCompany")]
        [ProducesResponseType(typeof(string), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public IActionResult UpdateCompany(UpdateCompanyDto updateCompanyDto)
        {
            try
            {
                var result = _userRepository.UpdateCompany(updateCompanyDto);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while updating company");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        #endregion

        #region EMPLOYEE  

        [HttpPost("CreateEmployee")]
        [ProducesResponseType(typeof(string), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public IActionResult CreateEmployee(CreateEmployeeDto createEmployeeDto)
        {
            try
            {
                var result = _userRepository.CreateEmployee(createEmployeeDto);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while creating employee");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpGet("GetEmployee")]
        [ProducesResponseType(typeof(List<EmployeeDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public IActionResult GetEmployee([FromQuery] GetEmployeeDto getEmployeeDto)
        {
            try
            {
                var result = _userRepository.GetEmployee(getEmployeeDto);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting employee info");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpPut("UpdateEmployee")]
        [ProducesResponseType(typeof(string), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public IActionResult UpdateEmployee(UpdateEmployeeDto updateEmployeeDto)
        {
            try
            {
                var result = _userRepository.UpdateEmployee(updateEmployeeDto);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while updating employee");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpPatch("ResetEmployeeStatus")]
        [ProducesResponseType(typeof(string), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public IActionResult ResetEmployeeStatus(ResetEmployeeDto resetEmployeeDto)
        {
            try
            {
                var result = _userRepository.ResetEmployeeStatus(resetEmployeeDto);
                if (result != null)
                {
                    return Ok(result);
                }
                else
                {
                    _logger.LogWarning("Employee with EmployeeID {EmployeeID} not found", resetEmployeeDto.EmployeeID);
                    return NotFound($"Employee with {resetEmployeeDto.EmployeeID} not found");
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while resetting employee status for EmployeeID {EmployeeID}", resetEmployeeDto.EmployeeID);
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpDelete("DeleteEmployee")]
        [ProducesResponseType(typeof(string), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public IActionResult DeleteEmployee(DeleteEmployeeDto deleteEmployeeDto)
        {
            try
            {
                var result = _userRepository.DeleteEmployee(deleteEmployeeDto);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while deleting employee");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        #endregion

        #region ADDRESS   
        #endregion

        #region EMAIL        
        #endregion

        #region PHONE       
        #endregion

        #region IDENTIFIER        
        #endregion
    }
}
